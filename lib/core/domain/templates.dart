/// Election templates. They only pre-fill setup; every value stays editable
/// and is stored as election data (nothing is hard-coded in screens).
class PositionTemplate {
  const PositionTemplate(this.title, {this.chooseN = 1, this.allowNoChoice = true});
  final String title;
  final int chooseN;
  final bool allowNoChoice;
}

enum ElectionTemplate {
  school(
    idLabel: 'Student ID',
    groupLabel: 'Class',
    requiresConsent: true,
    positions: [
      PositionTemplate('Head prefect'),
      PositionTemplate('Head boy'),
      PositionTemplate('Head girl'),
      PositionTemplate('Secretary'),
    ],
  ),
  association(
    idLabel: 'Member ID',
    groupLabel: 'Branch',
    requiresConsent: false,
    positions: [
      PositionTemplate('Chairman'),
      PositionTemplate('Secretary General'),
      PositionTemplate('Finance Secretary'),
    ],
  ),
  partyPrimary(
    idLabel: 'Delegate ID',
    groupLabel: 'County',
    requiresConsent: false,
    positions: [PositionTemplate('Flag bearer')],
  ),
  blank(idLabel: 'Member ID', groupLabel: 'Group', requiresConsent: false, positions: []);

  const ElectionTemplate({
    required this.idLabel,
    required this.groupLabel,
    required this.requiresConsent,
    required this.positions,
  });

  final String idLabel;
  final String groupLabel;
  /// School elections involve minors: registration needs the consent checkbox (D2).
  final bool requiresConsent;
  final List<PositionTemplate> positions;

  String get wire => switch (this) {
        school => 'school',
        association => 'association',
        partyPrimary => 'party_primary',
        blank => 'blank',
      };

  static ElectionTemplate fromWire(String s) =>
      values.firstWhere((t) => t.wire == s, orElse: () => blank);
}
