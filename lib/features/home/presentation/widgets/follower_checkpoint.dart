import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show FilteringTextInputFormatter, TextInputFormatter;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../../persona/application/persona_controller.dart';
import '../../../persona/domain/persona_entities.dart';
import '../../domain/roadmap_planets.dart';
import 'follower_series_chart.dart';

/// "How many followers do you have?" — asked on the roadmap, where it matters.
///
/// ## Why the roadmap has to ask at all
///
/// The 1000-day arc is four phases with a follower checkpoint each: 3,000 /
/// 15,000 / 50,000 / 100,000. LinkedIn gives no app the follower count of a
/// personal profile — `r_member_social_actions` is Partner-Program-only — so
/// the number can only come from the person looking at the screen. Without it
/// the checkpoint is decoration: the roadmap can say "next checkpoint: 3,000"
/// and cannot say whether the user is at 40 or at 2,900.
///
/// ## Why it is a strip and not a dialog
///
/// The job a user comes to this screen to do is "tell me what to do today". A
/// dialog in front of that gets dismissed, and a dismissed prompt teaches the
/// habit of dismissing it. One strip above the day's missions is present the
/// moment they land, answerable in one gesture, and never hides the thing they
/// came for. The web makes the same call for the same reason.
///
/// ## Why it does not go away when answered
///
/// The answer turns into the progress bar toward the checkpoint — the same
/// strip, now showing what the number bought. A field that vanishes on submit
/// gives no reason to have filled it in, and no obvious way back when the
/// number changes.
///
/// ## Why it re-asks after a month
///
/// The count goes stale and nothing tells us when. Thirty days is about how
/// long a figure stays useful against a checkpoint a quarter away, and long
/// enough that answering never feels like a chore. See
/// [FollowerReading.staleDays].
class FollowerCheckpoint extends ConsumerStatefulWidget {
  const FollowerCheckpoint({required this.currentDay, super.key});

  /// Decides which phase's target is being worked toward.
  final int currentDay;

  @override
  ConsumerState<FollowerCheckpoint> createState() => _FollowerCheckpointState();
}

class _FollowerCheckpointState extends ConsumerState<FollowerCheckpoint> {
  final TextEditingController _controller = TextEditingController();
  bool _busy = false;

  /// Editing an answer that already exists.
  ///
  /// Separate from "has no reading" so the strip can go back to the field
  /// without the user having to wait a month for it to ask again.
  bool _editing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final int? count = int.tryParse(_controller.text.trim());
    if (count == null) return;

    setState(() => _busy = true);
    final String? failure = await ref
        .read(personaControllerProvider.notifier)
        .recordFollowers(count);
    if (!mounted) return;
    setState(() {
      _busy = false;
      if (failure == null) _editing = false;
    });

    if (failure != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(failure, style: ZaveType.body)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<PersonaSnapshot> persona = ref.watch(
      personaControllerProvider,
    );

    // Nothing at all while it loads, and nothing on failure. This strip is an
    // instrument on somebody else's screen — the roadmap renders perfectly
    // without it, and a skeleton or an error card above the day's missions
    // would cost more attention than the number is worth.
    final PersonaSnapshot? snapshot = persona.value;
    if (snapshot == null) return const SizedBox.shrink();

    final FollowerReading? reading = snapshot.followers;
    final RoadmapPhase phase = phaseForDay(widget.currentDay);
    final bool asking = _editing || reading == null || reading.isStale();

    return ZaveCard(
      child: asking
          ? _Ask(
              phase: phase,
              controller: _controller,
              busy: _busy,
              // Said only when there IS a previous answer. "Last answered 40
              // days ago" to someone who has never answered is nonsense.
              stale: reading != null,
              onSave: _save,
              onCancel: reading == null
                  ? null
                  : () => setState(() => _editing = false),
            )
          : _Progress(
              phase: phase,
              reading: reading,
              // Nothing until the series arrives, and nothing if it fails —
              // the strip's job is the number and the bar; the line is a
              // bonus that must never cost either of them.
              history: ref.watch(followerHistoryProvider).value,
              onEdit: () {
                _controller.text = reading.count.toString();
                setState(() => _editing = true);
              },
            ),
    );
  }
}

class _Ask extends StatelessWidget {
  const _Ask({
    required this.phase,
    required this.controller,
    required this.busy,
    required this.stale,
    required this.onSave,
    required this.onCancel,
  });

  final RoadmapPhase phase;
  final TextEditingController controller;
  final bool busy;
  final bool stale;
  final VoidCallback onSave;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text('CHECKPOINT · ${phase.name.toUpperCase()}', style: ZaveType.kicker),
      SizedBox(height: ZaveSpace.sm),
      Text('How many followers do you have?', style: ZaveType.h3),
      SizedBox(height: ZaveSpace.sm),
      Text(
        stale
            // Says WHY it is asking again, so a user who answered last month
            // does not read it as the app having lost their answer.
            ? 'Your last count is over a month old. '
                  '${_formatted(phase.followerTarget)} is this phase’s mark.'
            : 'LinkedIn does not share this with apps, so this is the one '
                  'number we cannot read for you. '
                  '${_formatted(phase.followerTarget)} is this phase’s mark.',
        style: ZaveType.bodyMuted,
      ),
      SizedBox(height: ZaveSpace.lg),
      Row(
        children: <Widget>[
          Expanded(
            child: ZaveField(
              controller: controller,
              hint: '1,240',
              keyboardType: TextInputType.number,
              // Digits only. A pasted "1,240" or "1.2k" would parse to null
              // and the Save would look broken for a reason nothing stated.
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => onSave(),
            ),
          ),
          SizedBox(width: ZaveSpace.md),
          ZaveButton.primary(label: 'Save', busy: busy, onPressed: onSave),
        ],
      ),
      if (onCancel != null) ...<Widget>[
        SizedBox(height: ZaveSpace.sm),
        Align(
          alignment: Alignment.centerLeft,
          child: ZaveButton(label: 'Cancel', onPressed: onCancel),
        ),
      ],
    ],
  );
}

/// What the number bought.
class _Progress extends StatelessWidget {
  const _Progress({
    required this.phase,
    required this.reading,
    required this.history,
    required this.onEdit,
  });

  final RoadmapPhase phase;
  final FollowerReading reading;

  /// Null while loading, and null on failure. Both mean "draw no line".
  final FollowerHistory? history;

  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final int target = phase.followerTarget;
    // Clamped, because a user past this phase's mark is ahead of the plan, not
    // broken — and a bar over 100% reads as a bug.
    final double fraction = target <= 0
        ? 0
        : (reading.count / target).clamp(0.0, 1.0);
    final int remaining = target - reading.count;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'CHECKPOINT · ${phase.name.toUpperCase()}',
                style: ZaveType.kicker,
              ),
            ),
            ZaveButton(label: 'Update', onPressed: onEdit),
          ],
        ),
        SizedBox(height: ZaveSpace.md),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: <Widget>[
            Text(_formatted(reading.count), style: ZaveType.h2),
            SizedBox(width: ZaveSpace.sm),
            Text(
              'of ${_formatted(target)} followers',
              style: ZaveType.bodyMuted,
            ),
          ],
        ),
        SizedBox(height: ZaveSpace.md),
        ClipRRect(
          borderRadius: ZaveRadius.pillBr,
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 6,
            backgroundColor: ZaveColors.rule,
            valueColor: AlwaysStoppedAnimation<Color>(
              remaining <= 0 ? ZaveColors.green : ZaveColors.lavenderLo,
            ),
          ),
        ),
        SizedBox(height: ZaveSpace.sm),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                remaining <= 0
                    ? 'Checkpoint passed.'
                    : '${_formatted(remaining)} to go.',
                style: ZaveType.caption,
              ),
            ),
            if (_rate case final String rate)
              Text(rate, style: ZaveType.caption),
          ],
        ),
        if (history?.isPlottable ?? false) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          FollowerSeriesChart(points: history!.points, target: target),
        ],
      ],
    );
  }

  /// The rate, in the user's terms, or nothing.
  ///
  /// Said as a month because that is the unit people think about growth in,
  /// and because a per-day figure for most users here is a decimal that reads
  /// as precision nobody has. Silent below a fortnight: the server answers
  /// `tooSoon` rather than quoting a slope two readings a day apart would put
  /// in the thousands.
  String? get _rate {
    final FollowerGrowth? g = history?.growth;
    if (g == null || g.asKind != FollowerGrowthKind.rate) return null;
    if (g.perMonth == 0) return 'Holding steady';
    final String n = _formatted(g.perMonth.abs());
    return g.perMonth > 0 ? '+$n a month' : '-$n a month';
  }
}

/// `1,240`. Grouped because these are read as magnitudes, not as figures —
/// 15000 and 150000 are one glance apart without the separators.
String _formatted(int n) {
  final String digits = n.abs().toString();
  final StringBuffer out = StringBuffer(n < 0 ? '-' : '');
  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) out.write(',');
    out.write(digits[i]);
  }
  return out.toString();
}
