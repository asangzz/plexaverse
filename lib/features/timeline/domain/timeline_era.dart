/// BCE/CE suffix and era-name helpers for the Global Timeline.
///
/// Ported verbatim from Wonderous's `StringUtils.getYrSuffix` / `getEra`
/// (era boundaries -600 / 476 / 1450 are EXACT — do not alter). Consumed by
/// `dashed_divider_with_year.dart` and `animated_era_text.dart`.
library;

/// `'BCE'` for negative years, `'CE'` otherwise.
String yearSuffix(int yr) => yr < 0 ? 'BCE' : 'CE';

/// The named era a given year falls into, per Wonderous's exact boundaries.
String eraForYear(int yr) {
  if (yr <= -600) return 'Prehistory';
  if (yr <= 476) return 'Classical Era';
  if (yr <= 1450) return 'Early Modern Era';
  return 'Modern Era';
}
