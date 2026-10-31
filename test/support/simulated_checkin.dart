import 'package:rakubavote/core/crypto/voting_token.dart';
import 'package:rakubavote/core/db/registry_db.dart';

/// Stand-in for the check-in desk until milestone 4 provides the real service.
/// Writes exactly what the real desk may write: a check-in row (no token, hour
/// only) and an issued-token hash (no voter, no time).
Future<String> simulateCheckIn(RegistryDb db, String electionId, String voterId,
    {String hour = '2026-11-05T09'}) async {
  final token = VotingToken.generate();
  await db.transaction(() async {
    await db.into(db.checkIns).insert(CheckInsCompanion.insert(
        voterId: voterId, electionId: electionId, method: 'qr', official: 'Check-in official',
        hourBucket: hour));
    await db.into(db.issuedTokens).insert(IssuedTokensCompanion.insert(
        tokenHash: VotingToken.tokenHash(electionId, token), electionId: electionId));
  });
  return token;
}

Future<void> seedRegister(RegistryDb db, String electionId, int voters) async {
  await db.into(db.elections).insert(ElectionsCompanion.insert(
      id: electionId, orgName: 'Org', name: 'Election', year: 2026, template: 'association',
      languages: '["en"]', idLabel: 'Member ID', groupLabel: 'Branch', stationName: 'Station 1'));
  await db.batch((b) {
    for (var i = 1; i <= voters; i++) {
      b.insert(db.voters, VotersCompanion.insert(
          id: 'voter-$i', electionId: electionId, voterNo: i, fullName: 'Voter $i',
          registeredOn: '2026-11-01', registeredBy: 'Official'));
    }
  });
}
