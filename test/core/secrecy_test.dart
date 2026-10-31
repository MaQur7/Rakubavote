import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:rakubavote/core/crypto/device_keys.dart';
import 'package:rakubavote/core/crypto/signed_artifact.dart';
import 'package:rakubavote/core/crypto/voting_token.dart';
import 'package:rakubavote/core/db/ballot_box_db.dart';
import 'package:rakubavote/core/db/ballot_box_repository.dart';
import 'package:rakubavote/core/db/registry_db.dart';
import 'package:rakubavote/core/domain/vote.dart';

import '../support/fixtures.dart';
import '../support/simulated_checkin.dart';

/// Secrecy: nothing in the data lets anyone link a check-in (who) to a vote (how).
Future<Map<String, List<String>>> columns(dynamic db) async {
  final tables = await db
      .customSelect("SELECT name FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'sqlite_%'")
      .get();
  final out = <String, List<String>>{};
  for (final t in tables) {
    final name = t.read<String>('name');
    final cols = await db.customSelect('PRAGMA table_info($name)').get();
    out[name] = [for (final c in cols) c.read<String>('name')];
  }
  return out;
}

void main() {
  late DeviceKeys station;
  late DeviceKeys booth;
  late RegistryDb registry;
  late BallotBoxDb box;
  late BallotBoxRepository repo;
  const electionId = 'e1';

  setUp(() async {
    station = await DeviceKeys.generate();
    booth = await DeviceKeys.generate();
    registry = memoryRegistry();
    box = memoryBallotBox();
    repo = BallotBoxRepository(box, booth);
    final signed = await SignedArtifact.sign(ArtifactKind.ballot, sampleBallot().toJson(), station);
    await repo.loadBallot(signed.encode(), stationPublicKey: station.signingPublic);
    await seedRegister(registry, electionId, 300);
  });
  tearDown(() async {
    await registry.close();
    await box.close();
  });

  /// Checks in [n] voters in register order and lets each vote at once.
  Future<List<String>> runVoters(int n) async {
    final castOrder = <String>[];
    for (var i = 1; i <= n; i++) {
      final token = await simulateCheckIn(registry, electionId, 'voter-$i');
      final hash = VotingToken.tokenHash(electionId, token);
      await repo.activateToken(hash);
      castOrder.add(await repo.castBallot(tokenHash: hash, selections: {
        'chair': ['chair-c${i % 2 + 1}'],
        'secgen': ['secgen-c1'],
        'fin': [noChoice],
      }));
    }
    return castOrder;
  }

  group('schema', () {
    test('a vote row holds only ballot id, position, choice and signature', () async {
      final c = await columns(box);
      expect(c['votes'], unorderedEquals(['ballot_id', 'position_id', 'choice', 'signature']));
      expect(c['used_tokens'], ['token_hash']);
      expect(c['active_tokens'], ['token_hash']);
    });

    test('the ballot box has no personal, time or order column', () async {
      final c = await columns(box);
      final forbidden = RegExp(r'voter|member|name|photo|fee|receipt|official|hour|date|time|created|rowid');
      for (final t in ['votes', 'used_tokens', 'active_tokens', 'ballot_definitions']) {
        for (final col in c[t]!) {
          expect(forbidden.hasMatch(col), isFalse, reason: '$t.$col');
        }
      }
    });

    test('vote and token tables have no hidden rowid', () async {
      for (final t in ['votes', 'used_tokens', 'active_tokens']) {
        expect(() => box.customSelect('SELECT rowid FROM $t').get(), throwsA(anything), reason: t);
      }
      expect(() => registry.customSelect('SELECT rowid FROM issued_tokens').get(), throwsA(anything));
    });

    test('check-ins hold no code and issued codes hold no voter or time', () async {
      final c = await columns(registry);
      expect(c['check_ins']!.where((x) => x.contains('token')), isEmpty);
      expect(c['issued_tokens'], unorderedEquals(['token_hash', 'election_id', 'state']));
    });

    test('the registry has nothing about choices or ballots', () async {
      final c = await columns(registry);
      for (final entry in c.entries) {
        for (final col in entry.value) {
          // Vote columns must not exist on the registry side (position_id in
          // candidates is ballot setup, not a vote).
          final isVoteColumn = {'ballot_id', 'choice', 'choices', 'signature'}.contains(col) ||
              (col == 'position_id' && entry.key != 'candidates');
          expect(isVoteColumn, isFalse, reason: '${entry.key}.$col');
        }
      }
    });
  });

  group('order and time', () {
    test('votes are stored in random-id order, not voting order', () async {
      final castOrder = await runVoters(120);
      final stored = await box.customSelect('SELECT DISTINCT ballot_id FROM votes').get();
      final storedOrder = [for (final r in stored) r.read<String>('ballot_id')];
      expect(storedOrder, [...castOrder]..sort());
      expect(storedOrder, isNot(castOrder));
      // Hardly any ballot sits at its voting position (expected about 1 of 120).
      var samePlace = 0;
      for (var i = 0; i < castOrder.length; i++) {
        if (storedOrder[i] == castOrder[i]) samePlace++;
      }
      expect(samePlace, lessThan(10));
    });

    test('the exported batch is ordered by random id and holds no time', () async {
      final castOrder = await runVoters(40);
      final batch = await repo.exportBatch();
      final votes = (batch.payload['votes'] as List).cast<Map>();
      expect({for (final v in votes) v['b']}.toList(), [...castOrder]..sort());
      for (final v in votes) {
        expect(v.keys.toSet(), VoteRow.allowedJsonKeys);
      }
      final text = batch.encode();
      expect(RegExp(r'20\d\d-\d\d-\d\d').hasMatch(text), isFalse, reason: 'no dates in a batch');
    });
  });

  group('no shared values', () {
    test('nothing in the ballot box appears in the registry', () async {
      await runVoters(60);
      final boxValues = <String>{};
      for (final r in await box.customSelect('SELECT * FROM votes').get()) {
        boxValues.addAll(r.data.values.map((v) => '$v'));
      }
      final registryValues = <String>{};
      for (final t in ['voters', 'check_ins', 'fee_payments']) {
        for (final r in await registry.customSelect('SELECT * FROM $t').get()) {
          registryValues.addAll(r.data.values.whereType<String>());
        }
      }
      expect(boxValues.intersection(registryValues), isEmpty);
    });

    test('used codes and votes share nothing', () async {
      await runVoters(30);
      final used = {for (final r in await box.select(box.usedTokens).get()) r.tokenHash};
      final voteText = jsonEncode([for (final r in await box.select(box.votes).get()) r.toJson()]);
      for (final h in used) {
        expect(voteText.contains(h), isFalse);
      }
    });

    test('the booth audit log records counts only', () async {
      final castOrder = await runVoters(10);
      await repo.exportBatch();
      final log = jsonEncode([for (final e in await repo.audit.entries()) e.payload]);
      for (final id in castOrder) {
        expect(log.contains(id), isFalse);
      }
      final used = {for (final r in await box.select(box.usedTokens).get()) r.tokenHash};
      for (final h in used) {
        expect(log.contains(h), isFalse);
      }
    });
  });

  group('codes', () {
    test('a code works once', () async {
      final token = await simulateCheckIn(registry, electionId, 'voter-1');
      final hash = VotingToken.tokenHash(electionId, token);
      await repo.activateToken(hash);
      final sel = {'chair': ['chair-c1'], 'secgen': ['secgen-c2'], 'fin': ['fin-c1']};
      await repo.castBallot(tokenHash: hash, selections: sel);
      await expectLater(repo.castBallot(tokenHash: hash, selections: sel),
          throwsA(isA<CastBallotException>().having((e) => e.failure, 'f', CastFailure.codeAlreadyUsed)));
      // Re-activating a used code does nothing.
      await repo.activateToken(hash);
      expect(await repo.checkToken(hash), CastFailure.codeAlreadyUsed);
    });

    test('a code that was never activated is refused', () async {
      await expectLater(
          repo.castBallot(tokenHash: VotingToken.tokenHash(electionId, 'ABCDEF'), selections: {}),
          throwsA(isA<CastBallotException>()));
      expect(await repo.checkToken(VotingToken.tokenHash(electionId, 'ABCDEF')), CastFailure.codeNotActive);
    });

    test('a code used at another booth is refused here', () async {
      final hash = VotingToken.tokenHash(electionId, 'ABCDEF');
      await repo.activateToken(hash);
      await repo.markUsedElsewhere(hash);
      expect(await repo.checkToken(hash), CastFailure.codeNotActive);
    });

    test('an invalid selection is refused and the code stays usable', () async {
      final hash = VotingToken.tokenHash(electionId, 'ABCDEF');
      await repo.activateToken(hash);
      await expectLater(
          repo.castBallot(tokenHash: hash, selections: {'chair': ['chair-c1', 'chair-c2'], 'secgen': ['secgen-c1'], 'fin': ['fin-c1']}),
          throwsA(isA<CastBallotException>().having((e) => e.failure, 'f', CastFailure.invalidSelection)));
      expect(await repo.checkToken(hash), isNull);
      expect(await repo.ballotCount(), 0);
    });
  });

  test('votes cannot be changed or deleted', () async {
    await runVoters(1);
    expect(() => box.customStatement("UPDATE votes SET choice = '[\"x\"]'"), throwsA(anything));
    expect(() => box.customStatement('DELETE FROM votes'), throwsA(anything));
  });
}
