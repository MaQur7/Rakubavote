import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:rakubavote/core/crypto/bytes.dart';
import 'package:rakubavote/core/crypto/device_keys.dart';
import 'package:rakubavote/core/db/ballot_box_db.dart';
import 'package:rakubavote/core/db/open_encrypted.dart';
import 'package:rakubavote/core/db/registry_db.dart';
import 'package:rakubavote/core/domain/ballot_definition.dart';

RegistryDb memoryRegistry() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return RegistryDb(openEncrypted(key: randomBytes(32)));
}

BallotBoxDb memoryBallotBox() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return BallotBoxDb(openEncrypted(key: randomBytes(32)));
}

/// Community association ballot like mockup A: three positions, two
/// candidates each, plus an optional 13-candidate party position.
BallotDefinition sampleBallot({
  String electionId = 'e1',
  bool withLargePosition = false,
  int chooseNForSecretary = 1,
}) {
  PositionDef pos(String id, int order, String title, int colour, int candidates,
          {int chooseN = 1, bool allowNoChoice = true}) =>
      PositionDef(
        id: id,
        order: order,
        titles: {'en': title},
        colour: colour,
        chooseN: chooseN,
        allowNoChoice: allowNoChoice,
        candidates: [
          for (var i = 1; i <= candidates; i++)
            CandidateDef(id: '$id-c$i', number: i, name: 'Candidate $i'),
        ],
      );
  return BallotDefinition(
    electionId: electionId,
    orgName: 'CIEC Community Independent Electoral Committee',
    electionName: 'Community Association Election',
    year: 2026,
    stationName: 'Station 1',
    languages: const ['en', 'ar', 'din'],
    positions: [
      pos('chair', 1, 'Chairman', 0xFF1D4E89, 2),
      pos('secgen', 2, 'Secretary General', 0xFF2E7D4F, chooseNForSecretary == 1 ? 2 : 4,
          chooseN: chooseNForSecretary),
      pos('fin', 3, 'Finance Secretary', 0xFFA9521A, 2),
      if (withLargePosition) pos('flag', 4, 'Flag bearer', 0xFF5B3A8C, 13),
    ],
  );
}

class Station {
  Station._(this.keys);
  final DeviceKeys keys;
  static Future<Station> create() async => Station._(await DeviceKeys.generate());
}
