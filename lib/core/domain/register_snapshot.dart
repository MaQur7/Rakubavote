import '../crypto/hashing.dart';

/// One line of the public register. Fee data is deliberately not part of the
/// signed register.
class RegisterEntry {
  const RegisterEntry({
    required this.voterNo,
    required this.fullName,
    required this.memberId,
    required this.groupName,
    required this.cardIssue,
    this.photoSha256,
  });

  final int voterNo;
  final String fullName;
  final String memberId;
  final String groupName;
  final int cardIssue;
  final String? photoSha256;

  Map<String, Object?> toJson() => {
        'n': voterNo,
        'name': fullName,
        'id': memberId,
        'group': groupName,
        'issue': cardIssue,
        'photo': photoSha256,
      };

  factory RegisterEntry.fromJson(Map m) => RegisterEntry(
        voterNo: m['n'] as int,
        fullName: m['name'] as String,
        memberId: m['id'] as String,
        groupName: m['group'] as String,
        cardIssue: m['issue'] as int,
        photoSha256: m['photo'] as String?,
      );

  static String? photoHash(List<int>? photo) => photo == null ? null : sha256Hex(photo);
}

/// The register payload that is signed when the register is locked.
class RegisterSnapshot {
  RegisterSnapshot({
    required this.electionId,
    required this.ballotHash,
    required List<RegisterEntry> entries,
  }) : entries = [...entries]..sort((a, b) => a.voterNo.compareTo(b.voterNo));

  final String electionId;
  /// Hash of the signed ballot, binding register and ballot together.
  final String ballotHash;
  final List<RegisterEntry> entries;

  RegisterEntry? byVoterNo(int n) {
    for (final e in entries) {
      if (e.voterNo == n) return e;
    }
    return null;
  }

  Map<String, Object?> toJson() => {
        'electionId': electionId,
        'ballotHash': ballotHash,
        'count': entries.length,
        'voters': [for (final e in entries) e.toJson()],
      };

  factory RegisterSnapshot.fromJson(Map m) => RegisterSnapshot(
        electionId: m['electionId'] as String,
        ballotHash: m['ballotHash'] as String,
        entries: [for (final e in m['voters'] as List) RegisterEntry.fromJson(e as Map)],
      );
}
