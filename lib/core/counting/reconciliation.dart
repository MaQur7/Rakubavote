/// Closing check: every check-in should have produced exactly one used code
/// and one ballot. Any difference is shown to officials and recorded; the app
/// does not change the count.
class Reconciliation {
  const Reconciliation({
    required this.registered,
    required this.checkedIn,
    required this.manualCheckIns,
    required this.tokensIssued,
    required this.tokensUsed,
    required this.ballots,
  });

  final int registered;
  final int checkedIn;
  final int manualCheckIns;
  final int tokensIssued;
  final int tokensUsed;
  final int ballots;

  bool get checkInsMatchVotes => checkedIn == tokensUsed && tokensUsed == ballots;

  List<String> get issues => [
        if (checkedIn > registered) 'More check-ins than registered voters.',
        if (tokensIssued != checkedIn) 'Codes issued ($tokensIssued) differ from check-ins ($checkedIn).',
        if (tokensUsed > tokensIssued) 'More codes used ($tokensUsed) than issued ($tokensIssued).',
        if (tokensUsed < checkedIn)
          '${checkedIn - tokensUsed} checked-in voter(s) did not use their code.',
        if (ballots != tokensUsed) 'Ballots ($ballots) differ from codes used ($tokensUsed).',
      ];

  Map<String, Object?> toJson() => {
        'registered': registered,
        'checkedIn': checkedIn,
        'manualCheckIns': manualCheckIns,
        'tokensIssued': tokensIssued,
        'tokensUsed': tokensUsed,
        'ballots': ballots,
        'match': checkInsMatchVotes,
      };
}
