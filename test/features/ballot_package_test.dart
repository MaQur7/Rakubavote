import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:rakubavote/core/crypto/device_keys.dart';
import 'package:rakubavote/core/db/ballot_box_repository.dart';
import 'package:rakubavote/core/db/registry_db.dart';
import 'package:rakubavote/core/domain/templates.dart';
import 'package:rakubavote/features/setup/election_service.dart';
import 'package:rakubavote/station/ballot_package.dart';

import '../support/fixtures.dart';

void main() {
  late RegistryDb db;
  late DeviceKeys station;
  late ElectionService svc;
  late String id;

  setUp(() async {
    db = memoryRegistry();
    station = await DeviceKeys.generate();
    svc = ElectionService(db, station);
    id = await svc.createElection(
        template: ElectionTemplate.partyPrimary, orgName: 'Party', name: 'Primary', year: 2026,
        stationName: 'S', languages: ['en', 'ar'], official: 'PO');
    await svc.updateDetails(id, orgLogo: Uint8List.fromList([7, 7, 7]), official: 'PO');
    final p = (await svc.positions(id)).single;
    await svc.saveCandidate(
        positionId: p.id, number: 1, name: 'A', photo: Uint8List.fromList([1, 2]), symbol: Uint8List.fromList([3]),
        official: 'PO');
    await svc.saveCandidate(positionId: p.id, number: 2, name: 'B', official: 'PO');
  });
  tearDown(() => db.close());

  Future<BallotPackage> package({DeviceKeys? keys}) async => BallotPackage(
        signedBallot: (await svc.signBallot(id, official: 'PO')),
        stationPublicKey: (keys ?? station).signingPublic,
        media: await svc.ballotMedia(id),
      );

  test('round trip keeps the ballot, logo and every image', () async {
    final pkg = await package();
    final back = await BallotPackage.decodeAndVerify(pkg.encode());
    expect(back.signedBallot.fingerprint, pkg.signedBallot.fingerprint);
    expect(back.ballot.orgLogoSha256, isNotNull);
    expect(back.media.keys.toSet(), back.ballot.mediaHashes);
    expect(back.stationDeviceId, station.deviceId);
    expect(pkg.suggestedFileName(), endsWith('.rkvballot'));
  });

  test('a changed ballot, a changed image or a missing image is refused', () async {
    final text = (await package()).encode();
    final m = jsonDecode(text) as Map;

    final changedBallot = jsonDecode(text) as Map;
    ((changedBallot['ballot'] as Map)['payload'] as Map)['electionName'] = 'Other';
    await expectLater(BallotPackage.decodeAndVerify(jsonEncode(changedBallot)),
        throwsA(isA<PackageException>().having((e) => e.failure, 'f', PackageFailure.badSignature)));

    final key = (m['media'] as Map).keys.first;
    final changedImage = jsonDecode(text) as Map;
    (changedImage['media'] as Map)[key] = base64Url.encode([9, 9, 9]).replaceAll('=', '');
    await expectLater(BallotPackage.decodeAndVerify(jsonEncode(changedImage)),
        throwsA(isA<PackageException>().having((e) => e.failure, 'f', PackageFailure.imageChanged)));

    final missing = jsonDecode(text) as Map;
    (missing['media'] as Map).remove(key);
    await expectLater(BallotPackage.decodeAndVerify(jsonEncode(missing)),
        throwsA(isA<PackageException>().having((e) => e.failure, 'f', PackageFailure.missingImage)));

    await expectLater(BallotPackage.decodeAndVerify('{"hello":1}'),
        throwsA(isA<PackageException>().having((e) => e.failure, 'f', PackageFailure.malformed)));
  });

  test('a booth that trusts one laptop refuses a ballot from another', () async {
    final pkg = await package();
    final other = await DeviceKeys.generate();
    await expectLater(BallotPackage.decodeAndVerify(pkg.encode(), pinnedStationKey: other.signingPublic),
        throwsA(isA<PackageException>().having((e) => e.failure, 'f', PackageFailure.wrongStation)));
  });

  group('booth ballot box', () {
    test('first load pins the laptop; images are stored by hash', () async {
      final pkg = await package();
      final repo = BallotBoxRepository(memoryBallotBox(), await DeviceKeys.generate());
      await repo.loadBallot(pkg.signedBallot.encode(), stationPublicKey: pkg.stationPublicKey, media: pkg.media);
      expect(await repo.pinnedStationKey(), station.signingPublic);
      expect((await repo.media(pkg.ballot.mediaHashes)).length, pkg.media.length);

      final otherStation = await DeviceKeys.generate();
      final otherSvc = ElectionService(db, otherStation);
      final foreign = await otherSvc.signBallot(id, official: 'PO');
      await expectLater(repo.loadBallot(foreign.encode(), stationPublicKey: otherStation.signingPublic),
          throwsA(isA<CastBallotException>().having((e) => e.failure, 'f', CastFailure.otherStation)));

      // A restart re-checks the stored ballot.
      final again = await repo.restoreBallot();
      expect(again!.electionId, id);
      await repo.db.close();
    });
  });
}
