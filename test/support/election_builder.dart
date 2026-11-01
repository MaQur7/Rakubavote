import 'package:rakubavote/core/crypto/device_keys.dart';
import 'package:rakubavote/core/db/registry_db.dart';
import 'package:rakubavote/core/domain/templates.dart';
import 'package:rakubavote/features/checkin/checkin_service.dart';
import 'package:rakubavote/features/register_lock/review_service.dart';
import 'package:rakubavote/features/registration/registration_service.dart';
import 'package:rakubavote/features/setup/election_service.dart';

/// Builds an association election through the real services: two
/// candidates per position, [voters] registered, ballot signed, register
/// locked and (optionally) polls open.
Future<String> buildLockedElection(RegistryDb db, DeviceKeys station,
    {int voters = 5, bool openPolls = true, String official = 'Presiding officer'}) async {
  final setup = ElectionService(db, station);
  final id = await setup.createElection(
      template: ElectionTemplate.association, orgName: 'CIEC', name: 'CIEC Election', year: 2026,
      stationName: 'Station 1', languages: ['en', 'ar'], official: official);
  for (final p in await setup.positions(id)) {
    await setup.saveCandidate(positionId: p.id, number: 1, name: 'Candidate one', official: official);
    await setup.saveCandidate(positionId: p.id, number: 2, name: 'Candidate two', official: official);
  }
  final reg = RegistrationService(db);
  for (var i = 1; i <= voters; i++) {
    await reg.register(id, VoterInput(fullName: 'Voter $i', memberId: 'M-$i', groupName: 'Group ${i % 3}'),
        official: official);
  }
  await setup.signBallot(id, official: official);
  await ReviewService(db, station).lockRegister(id, official: official);
  if (openPolls) await CheckInService(db, station).openPolls(official: official);
  return id;
}
