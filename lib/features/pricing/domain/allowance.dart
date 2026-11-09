/// What a plan includes of one AI feature — a row of
/// `GET /user/allowances`.
///
/// ## Why this exists
///
/// Until 10 Nov 2026 a plan bought 11,000 wallet XP and every AI feature spent
/// it. Wallet XP was retired: the plan itself pays for the features, and each
/// one has a limit a day or a month, counted on India time for everyone. This
/// row is that limit plus how much of it is used — the same table the server's
/// gates count against, so the Pricing screen cannot promise more than the
/// product allows.
///
/// Hand-written rather than freezed: it is a read-only value with one wire
/// shape, and the static [Allowance.defaults] below has to be `const`.
library;

/// `'day'` or `'month'` on the wire.
enum AllowancePeriod {
  day,
  month;

  static AllowancePeriod parse(Object? raw) =>
      raw == 'month' ? AllowancePeriod.month : AllowancePeriod.day;

  /// "left today" / "left this month".
  String get leftSuffix =>
      this == AllowancePeriod.month ? 'left this month' : 'left today';
}

class Allowance {
  const Allowance({
    required this.key,
    required this.label,
    required this.limit,
    required this.period,
    this.enabled = true,
    this.used,
    this.remaining,
    this.resetsAt,
  });

  /// The server's feature key (`ai_generate_post`, …). Stable; the label is
  /// what the user reads.
  final String key;

  /// "Posts", "Posters and images", … — written by the server to be shown.
  final String label;
  final int limit;
  final AllowancePeriod period;

  /// False when an admin switched counting off for this feature: it runs
  /// unmetered. Shown as "Unlimited", never hidden — hiding it would make a
  /// signed-in user see less included than the static list promises.
  final bool enabled;

  /// Null on the static fallback, where nothing is known about this user.
  final int? used;
  final int? remaining;

  /// When this period's count starts over, as an instant.
  final DateTime? resetsAt;

  /// Parses one wire row. Returns null for a row without a key or a label —
  /// a row the screen cannot name is not worth a blank line.
  static Allowance? fromJson(Map<String, dynamic> json) {
    final Object? key = json['key'];
    final Object? label = json['label'];
    if (key is! String || key.isEmpty || label is! String || label.isEmpty) {
      return null;
    }
    final Object? resets = json['resetsAt'];
    return Allowance(
      key: key,
      label: label,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
      period: AllowancePeriod.parse(json['period']),
      enabled: json['enabled'] != false,
      used: (json['used'] as num?)?.toInt(),
      remaining: (json['remaining'] as num?)?.toInt(),
      resetsAt: resets is String ? DateTime.tryParse(resets) : null,
    );
  }

  /// Parses the `data` object of `GET /user/allowances`.
  static List<Allowance> listFromJson(Map<String, dynamic> data) {
    final Object? raw = data['allowances'];
    if (raw is! List) return const <Allowance>[];
    return <Allowance>[
      for (final Object? row in raw)
        if (row is Map<String, dynamic>) ?Allowance.fromJson(row),
    ];
  }

  /// "3 a day" / "4 a month" / "Unlimited".
  String get amountLabel {
    if (!enabled) return 'Unlimited';
    return '$limit a ${period.name}';
  }

  /// "2 left today" — null when the count is unknown or the row is unmetered.
  String? get remainingLabel {
    final int? left = remaining;
    if (!enabled || left == null) return null;
    return '$left ${period.leftSuffix}';
  }

  /// What every plan includes, when the live table cannot be read.
  ///
  /// Mirrors `DEFAULT_USAGE_LIMITS` in the web repo's `lib/usage-limits.ts`,
  /// in the same order. The live read wins whenever it answers — an admin can
  /// change any limit at `/admin/limits` without a deploy, and this list
  /// cannot know — so this is only what the screen says instead of nothing.
  static const List<Allowance> defaults = <Allowance>[
    Allowance(
      key: 'ai_generate_post',
      label: 'Posts',
      limit: 3,
      period: AllowancePeriod.day,
    ),
    Allowance(
      key: 'ai_generate_image',
      label: 'Posters and images',
      limit: 3,
      period: AllowancePeriod.day,
    ),
    Allowance(
      key: 'ai_generate_comment',
      label: 'Comments',
      limit: 15,
      period: AllowancePeriod.day,
    ),
    Allowance(
      key: 'ai_connection_message',
      label: 'Connection messages',
      limit: 20,
      period: AllowancePeriod.day,
    ),
    Allowance(
      key: 'ai_generate_poll',
      label: 'Polls',
      limit: 3,
      period: AllowancePeriod.day,
    ),
    Allowance(
      key: 'ai_generate_about',
      label: 'About sections',
      limit: 3,
      period: AllowancePeriod.day,
    ),
    Allowance(
      key: 'ai_parse_cv',
      label: 'CV reads',
      limit: 3,
      period: AllowancePeriod.day,
    ),
    Allowance(
      key: 'ai_strategy_generate',
      label: 'Strategies',
      limit: 3,
      period: AllowancePeriod.day,
    ),
    Allowance(
      key: 'ai_suggest_title',
      label: 'Headline suggestions',
      limit: 10,
      period: AllowancePeriod.day,
    ),
    Allowance(
      key: 'ai_analyze_post',
      label: 'Post analyses',
      limit: 10,
      period: AllowancePeriod.day,
    ),
    Allowance(
      key: 'ai_suggest_topics',
      label: 'Topic suggestions',
      limit: 10,
      period: AllowancePeriod.day,
    ),
    Allowance(
      key: 'ai_design_generate',
      label: 'Studio designs',
      limit: 10,
      period: AllowancePeriod.day,
    ),
    Allowance(
      key: 'ai_fetch_connections',
      label: 'Connection searches',
      limit: 10,
      period: AllowancePeriod.day,
    ),
    Allowance(
      key: 'ai_suggest_groups',
      label: 'Group suggestions',
      limit: 5,
      period: AllowancePeriod.day,
    ),
    Allowance(
      key: 'ai_suggest_skills',
      label: 'Skill suggestions',
      limit: 5,
      period: AllowancePeriod.day,
    ),
    Allowance(
      key: 'ai_recommendation_request',
      label: 'Recommendation requests',
      limit: 5,
      period: AllowancePeriod.day,
    ),
    Allowance(
      key: 'ai_generate_headshot',
      label: 'Headshots',
      limit: 3,
      period: AllowancePeriod.month,
    ),
    Allowance(
      key: 'ai_generate_carousel',
      label: 'Carousels',
      limit: 4,
      period: AllowancePeriod.month,
    ),
    Allowance(
      key: 'ai_generate_festive_poster',
      label: 'Festive posters',
      limit: 5,
      period: AllowancePeriod.month,
    ),
  ];
}

/// The allowances the Pricing screen shows, and whether they are live.
///
/// [live] is false on the static fallback, so the screen can avoid claiming
/// "left today" figures it does not have.
class AllowanceTable {
  const AllowanceTable({required this.rows, required this.live});

  final List<Allowance> rows;
  final bool live;

  static const AllowanceTable fallback = AllowanceTable(
    rows: Allowance.defaults,
    live: false,
  );
}
