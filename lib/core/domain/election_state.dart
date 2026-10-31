/// Phases of an election on the station laptop. Moves forward only.
enum ElectionState {
  setup,
  registration,
  review,
  locked,
  polling,
  closed;

  static ElectionState fromWire(String s) => values.byName(s);

  bool canMoveTo(ElectionState next) => next.index == index + 1;
}
