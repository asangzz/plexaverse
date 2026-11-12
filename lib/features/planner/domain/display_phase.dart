/// The phase name a planner chip may show, or null to hide the chip.
///
/// A port of the web's `components/planner/display-phase.ts`.
///
/// Users who were in the old "Season 2" are now on journey 2, but the rows
/// written back then (a week plan's `phase`, and the phase entries of their
/// topic roadmap) still carry the retired loop's phase names. Stored rows are
/// never rewritten, so without this guard those names would keep showing
/// until the rows happen to be regenerated. Hiding the chip is the honest
/// choice: the row does not say which 1000-day phase it belongs to, and
/// guessing one would label the week with a phase it was not written for.
String? displayPhase(String? phase) {
  final String trimmed = phase?.trim() ?? '';
  if (trimmed.isEmpty) return null;
  return _retiredPhases.contains(trimmed.toLowerCase()) ? null : trimmed;
}

const Set<String> _retiredPhases = <String>{
  'event horizon',
  'singularity',
  'multiverse',
  'time dilation',
};
