/// Voter numbers are shown with at least four digits, as on the cards: 0142.
String voterNoLabel(int n) => n.toString().padLeft(4, '0');

/// Candidate numbers: two digits when a position has 10 or more candidates (07).
String candidateNoLabel(int n, {int candidateCount = 0}) =>
    candidateCount >= 10 ? n.toString().padLeft(2, '0') : '$n';

/// Native name of a ballot language, shown on language buttons.
String languageDisplayName(String code) => switch (code) {
      'en' => 'English',
      'ar' => 'العربية',
      'din' => 'Thuɔŋjäŋ',
      _ => code,
    };
