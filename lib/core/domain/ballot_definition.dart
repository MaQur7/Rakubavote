/// The ballot as signed by the station laptop and loaded by every booth.
/// Photos and symbols are referenced by SHA-256 so the signature covers them
/// while the image bytes travel separately.
class CandidateDef {
  const CandidateDef({
    required this.id,
    required this.number,
    required this.name,
    this.photoSha256,
    this.symbolSha256,
  });

  final String id;
  final int number;
  final String name;
  final String? photoSha256;
  final String? symbolSha256;

  Map<String, Object?> toJson() => {
        'id': id,
        'number': number,
        'name': name,
        'photo': photoSha256,
        'symbol': symbolSha256,
      };

  factory CandidateDef.fromJson(Map m) => CandidateDef(
        id: m['id'] as String,
        number: m['number'] as int,
        name: m['name'] as String,
        photoSha256: m['photo'] as String?,
        symbolSha256: m['symbol'] as String?,
      );
}

class PositionDef {
  const PositionDef({
    required this.id,
    required this.order,
    required this.titles,
    required this.colour,
    required this.chooseN,
    required this.allowNoChoice,
    required this.candidates,
  });

  final String id;
  final int order;
  /// locale -> title
  final Map<String, String> titles;
  final int colour;
  final int chooseN;
  final bool allowNoChoice;
  final List<CandidateDef> candidates;

  String title(String locale) => titles[locale] ?? titles['en'] ?? titles.values.first;

  CandidateDef? candidateById(String id) {
    for (final c in candidates) {
      if (c.id == id) return c;
    }
    return null;
  }

  CandidateDef? candidateByNumber(int n) {
    for (final c in candidates) {
      if (c.number == n) return c;
    }
    return null;
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'order': order,
        'titles': titles,
        'colour': colour,
        'chooseN': chooseN,
        'allowNoChoice': allowNoChoice,
        'candidates': [for (final c in candidates) c.toJson()],
      };

  factory PositionDef.fromJson(Map m) => PositionDef(
        id: m['id'] as String,
        order: m['order'] as int,
        titles: (m['titles'] as Map).cast<String, String>(),
        colour: m['colour'] as int,
        chooseN: m['chooseN'] as int,
        allowNoChoice: m['allowNoChoice'] as bool,
        candidates: [for (final c in m['candidates'] as List) CandidateDef.fromJson(c as Map)],
      );
}

class BallotDefinition {
  const BallotDefinition({
    required this.electionId,
    required this.orgName,
    required this.electionName,
    required this.year,
    required this.stationName,
    required this.languages,
    required this.positions,
    this.orgLogoSha256,
  });

  final String electionId;
  /// SHA-256 of the organization logo shown on the booth welcome screen.
  final String? orgLogoSha256;
  final String orgName;
  final String electionName;
  final int year;
  final String stationName;
  final List<String> languages;
  /// Sorted by [PositionDef.order].
  final List<PositionDef> positions;

  /// Every image hash the ballot refers to (logo, photos, symbols).
  Set<String> get mediaHashes => {
        ?orgLogoSha256,
        for (final p in positions)
          for (final c in p.candidates) ...[?c.photoSha256, ?c.symbolSha256],
      };

  PositionDef? positionById(String id) {
    for (final p in positions) {
      if (p.id == id) return p;
    }
    return null;
  }

  /// Problems that stop the ballot from being signed. Empty means valid.
  List<String> validate() {
    final problems = <String>[];
    if (positions.isEmpty) problems.add('The ballot has no positions.');
    for (final p in positions) {
      final t = p.title('en');
      if (p.candidates.isEmpty) problems.add('$t has no candidates.');
      if (p.chooseN < 1) problems.add('$t must allow at least one choice.');
      if (p.chooseN > p.candidates.length && p.candidates.isNotEmpty) {
        problems.add('$t asks for more choices than there are candidates.');
      }
      final numbers = p.candidates.map((c) => c.number).toSet();
      if (numbers.length != p.candidates.length) problems.add('$t has two candidates with the same number.');
      if (p.candidates.any((c) => c.number < 1)) problems.add('$t has a candidate number below 1.');
    }
    return problems;
  }

  Map<String, Object?> toJson() => {
        'electionId': electionId,
        'orgName': orgName,
        'electionName': electionName,
        'year': year,
        'stationName': stationName,
        'orgLogo': orgLogoSha256,
        'languages': languages,
        'positions': [for (final p in positions) p.toJson()],
      };

  factory BallotDefinition.fromJson(Map m) {
    final positions = [for (final p in m['positions'] as List) PositionDef.fromJson(p as Map)]
      ..sort((a, b) => a.order.compareTo(b.order));
    return BallotDefinition(
      electionId: m['electionId'] as String,
      orgName: m['orgName'] as String,
      electionName: m['electionName'] as String,
      year: m['year'] as int,
      stationName: m['stationName'] as String,
      orgLogoSha256: m['orgLogo'] as String?,
      languages: (m['languages'] as List).cast<String>(),
      positions: positions,
    );
  }
}
