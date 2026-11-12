/// The six CEFR bands, as this product uses them.
///
/// A port of the web's `lib/cefr.ts`. The placement test estimates a learner's
/// band, the contest lesson is written at it, and the contest multiplies right
/// answers by it — so the bands and their names must read the same on both
/// platforms.
///
/// A PLACEMENT ESTIMATE, NEVER A CERTIFICATE. A short adaptive quiz cannot
/// establish a CEFR level the way an accredited exam does, and nothing in the
/// product may present it as one — hence [placementDisclaimer] on every
/// screen that shows a band.
library;

enum CefrBand {
  a1('A1', 'Beginner'),
  a2('A2', 'Elementary'),
  b1('B1', 'Intermediate'),
  b2('B2', 'Upper intermediate'),
  c1('C1', 'Advanced'),
  c2('C2', 'Proficient');

  const CefrBand(this.wire, this.plainName);

  /// The code as the server spells it, and as the screen shows it: `B2`.
  final String wire;

  /// The plain-words name under the code (`BAND_NAMES` on the web).
  final String plainName;

  /// A band off the wire, or null for anything that is not one.
  ///
  /// Null rather than a default. A band is a claim about the learner, and a
  /// screen that cannot read one must say nothing rather than print a level
  /// the server never sent — the web's `isCefrBand` guards do the same.
  static CefrBand? parse(Object? raw) {
    for (final CefrBand band in values) {
      if (band.wire == raw) return band;
    }
    return null;
  }
}

/// Everyone's band until they take the placement test (`DEFAULT_BAND`).
///
/// B2 because it is the level every lesson was written at before placement
/// existed — a learner who skips the test keeps exactly the lessons they had.
const CefrBand defaultBand = CefrBand.b2;

/// `PLACEMENT_DISCLAIMER` in the web's `lib/placement/engine.ts`, verbatim.
/// A big "B2" on a dark card looks like a certificate; this says it is not.
const String placementDisclaimer =
    'A placement estimate to set your lesson level — not a CEFR certificate.';
