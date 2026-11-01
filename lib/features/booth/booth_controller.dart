import 'package:flutter/foundation.dart';

import '../../core/crypto/voting_token.dart';
import '../../core/db/ballot_box_repository.dart';
import '../../core/domain/ballot_definition.dart';
import '../../core/domain/vote.dart';

enum BoothStage { welcome, position, review, end }

/// Why a typed code was not accepted. Messages never blame the voter.
enum CodeProblem { notFound, alreadyUsed, tooManyTries }

/// The voter's journey at the booth (mockups 2–5). Choices live only in
/// memory and are wiped by [reset]; nothing about this voter is stored
/// except the anonymous vote written by [confirm].
class BoothController extends ChangeNotifier {
  BoothController(this.repo, {DateTime Function()? clock, this.maxTries = 5})
      : _clock = clock ?? DateTime.now;

  final BallotBoxRepository repo;
  final DateTime Function() _clock;
  final int maxTries;

  BallotDefinition get ballot => repo.ballot!;

  BoothStage stage = BoothStage.welcome;
  late String locale = ballot.languages.first;
  String? _tokenHash;
  int index = 0;
  bool _returnToReview = false;
  final Map<String, List<String>> _selections = {};
  int _wrongTries = 0;
  DateTime? _pausedUntil;

  PositionDef get position => ballot.positions[index];
  int get positionCount => ballot.positions.length;
  bool get isLastPosition => index == positionCount - 1;
  bool get returningToReview => _returnToReview;

  List<String> selectionFor(String positionId) => List.unmodifiable(_selections[positionId] ?? const []);
  bool isSelected(String positionId, String candidateId) =>
      _selections[positionId]?.contains(candidateId) ?? false;
  bool isNoChoice(String positionId) => _selections[positionId]?.contains(noChoice) ?? false;

  /// The next position's title for the "Next: …" button, or null on the last.
  PositionDef? get nextPosition => isLastPosition || _returnToReview ? null : ballot.positions[index + 1];

  bool get canContinue => (_selections[position.id] ?? const []).isNotEmpty;

  void setLanguage(String code) {
    if (!ballot.languages.contains(code)) return;
    locale = code;
    notifyListeners();
  }

  /// Checks a typed code. On success the voter moves to the first position.
  Future<CodeProblem?> submitCode(String typed) async {
    final now = _clock();
    if (_pausedUntil != null && now.isBefore(_pausedUntil!)) return CodeProblem.tooManyTries;
    final normalised = VotingToken.normalise(typed);
    CodeProblem? problem;
    String? hash;
    if (normalised == null) {
      problem = CodeProblem.notFound;
    } else {
      hash = VotingToken.tokenHash(ballot.electionId, normalised);
      problem = switch (await repo.checkToken(hash)) {
        null => null,
        CastFailure.codeAlreadyUsed => CodeProblem.alreadyUsed,
        _ => CodeProblem.notFound,
      };
    }
    if (problem != null) {
      _wrongTries++;
      if (_wrongTries >= maxTries) {
        _wrongTries = 0;
        _pausedUntil = now.add(const Duration(minutes: 1));
        return CodeProblem.tooManyTries;
      }
      return problem;
    }
    _wrongTries = 0;
    _tokenHash = hash;
    _selections.clear();
    index = 0;
    stage = BoothStage.position;
    notifyListeners();
    return null;
  }

  /// Tapping a candidate. With "choose 1" another tap replaces the choice;
  /// with "choose N" taps add up to N and a second tap removes.
  void tapCandidate(String candidateId) {
    final p = position;
    final current = [...?_selections[p.id]]..remove(noChoice);
    if (p.chooseN == 1) {
      _selections[p.id] = [candidateId];
    } else if (current.contains(candidateId)) {
      current.remove(candidateId);
      _selections[p.id] = current;
    } else if (current.length < p.chooseN) {
      _selections[p.id] = [...current, candidateId];
    } else {
      return; // already N chosen: the voter must remove one first
    }
    notifyListeners();
  }

  /// Typing a candidate number (long lists). Returns false if no such number.
  bool chooseByNumber(int number) {
    final c = position.candidateByNumber(number);
    if (c == null) return false;
    if (!isSelected(position.id, c.id)) tapCandidate(c.id);
    return true;
  }

  void tapNoChoice() {
    if (!position.allowNoChoice) return;
    _selections[position.id] = [noChoice];
    notifyListeners();
  }

  void next() {
    if (!canContinue) return;
    if (_returnToReview || isLastPosition) {
      _returnToReview = false;
      stage = BoothStage.review;
    } else {
      index++;
    }
    notifyListeners();
  }

  void back() {
    if (_returnToReview) {
      _returnToReview = false;
      stage = BoothStage.review;
    } else if (index > 0) {
      index--;
    } else {
      // Back from the first position: return to the welcome screen. The code
      // has not been used, so the voter can type it again.
      _tokenHash = null;
      _selections.clear();
      stage = BoothStage.welcome;
    }
    notifyListeners();
  }

  void change(int positionIndex) {
    index = positionIndex;
    _returnToReview = true;
    stage = BoothStage.position;
    notifyListeners();
  }

  /// Saves the vote. Throws [CastBallotException] if the code was used at
  /// another booth in the meantime.
  Future<void> confirm() async {
    final hash = _tokenHash;
    if (hash == null) return;
    await repo.castBallot(tokenHash: hash, selections: {
      for (final p in ballot.positions) p.id: [...?_selections[p.id]],
    });
    _tokenHash = null;
    _selections.clear();
    stage = BoothStage.end;
    notifyListeners();
  }

  /// Clears everything for the next voter.
  void reset() {
    _tokenHash = null;
    _selections.clear();
    index = 0;
    _returnToReview = false;
    stage = BoothStage.welcome;
    locale = ballot.languages.first;
    notifyListeners();
  }
}
