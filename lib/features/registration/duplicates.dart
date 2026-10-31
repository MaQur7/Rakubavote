// Finding possible duplicate registrations. The app only warns; an official
// decides, and any objection is handled in review (milestone 3).

/// Lower-case, strip punctuation, collapse spaces, sort name parts, so
/// "Deng, Mary  Achol" and "mary achol deng" compare equal.
String normaliseName(String name) {
  final parts = name
      .toLowerCase()
      .replaceAll(RegExp(r"[^\p{L}\p{N}\s]", unicode: true), ' ')
      .split(RegExp(r'\s+'))
      .where((p) => p.isNotEmpty)
      .toList()
    ..sort();
  return parts.join(' ');
}

int levenshtein(String a, String b) {
  if (a == b) return 0;
  if (a.isEmpty) return b.length;
  if (b.isEmpty) return a.length;
  var prev = List<int>.generate(b.length + 1, (i) => i);
  for (var i = 1; i <= a.length; i++) {
    final cur = List<int>.filled(b.length + 1, 0);
    cur[0] = i;
    for (var j = 1; j <= b.length; j++) {
      final cost = a.codeUnitAt(i - 1) == b.codeUnitAt(j - 1) ? 0 : 1;
      cur[j] = [prev[j] + 1, cur[j - 1] + 1, prev[j - 1] + cost].reduce((x, y) => x < y ? x : y);
    }
    prev = cur;
  }
  return prev[b.length];
}

/// Names are "similar" when normalised forms match, or differ by at most one
/// edit per 8 characters (spelling variants such as Achol / Akol).
bool similarNames(String a, String b) {
  final na = normaliseName(a);
  final nb = normaliseName(b);
  if (na.isEmpty || nb.isEmpty) return false;
  if (na == nb) return true;
  final allowed = (na.length < nb.length ? na.length : nb.length) ~/ 8 + 1;
  return levenshtein(na, nb) <= allowed;
}

enum DuplicateReason { sameMemberId, similarNameSameGroup }

class DuplicateMatch {
  const DuplicateMatch(this.voterId, this.voterNo, this.reason);
  final String voterId;
  final int voterNo;
  final DuplicateReason reason;
}
