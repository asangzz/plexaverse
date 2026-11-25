import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show FilteringTextInputFormatter, TextInputFormatter;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/connections_controller.dart';
import '../../domain/connection_summary.dart';
import 'connection_series_chart.dart';

/// "How many connections do you have now?" — the roadmap's weekly check-in,
/// and since 25 Nov 2026 the ONLY thing the roadmap asks for (the follower
/// card left it, web and app).
///
/// ## Why it stands where the day's missions used to
///
/// The roadmap handed out a day's tasks until the levels' daily path took
/// that job over (web, 12 Nov 2026). What the roadmap keeps is the long view,
/// and for connections the long view is one number a week: connection growth
/// is where the connect and invite levels actually show up.
///
/// ## Why weekly, and no Update button
///
/// Connections move faster than followers ([ConnectionReading.staleAfter] is
/// a week) and the levels run in weeks. It asks while there is no count for
/// the current week; once this week's count is in, the card shows the count,
/// how it moved and the graph ([ConnectionSeriesChart]) — and nothing to
/// press (owner, 25 Nov 2026). The next ask comes when the reading goes stale.
///
/// A strip, never a dialog, and the answer turns into the figure rather than
/// vanishing. "Not now" is a per-device convenience ([ConnectionPromptSnooze]).
/// LinkedIn gives no app a member's connection count, so the number only
/// exists because the user typed it. The copy is the web's
/// `ConnectionCheckpoint`, word for word.
class ConnectionCheckpoint extends ConsumerStatefulWidget {
  const ConnectionCheckpoint({super.key});

  @override
  ConsumerState<ConnectionCheckpoint> createState() =>
      _ConnectionCheckpointState();
}

/// Why the number is asked for. Said in every state, because a figure nobody
/// explains is a figure nobody updates.
const String _why =
    'Connection growth is how your connect and invite levels show up over '
    'time.';

const String _whereToFind =
    'Find it on your LinkedIn profile under your name, or in My Network → '
    'Connections.';

class _ConnectionCheckpointState extends ConsumerState<ConnectionCheckpoint> {
  final TextEditingController _draft = TextEditingController();

  /// The question opened from "Add your connection count" (snoozed before
  /// ever answering). A count already in has no Update, as on the web.
  bool _editing = false;

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  void _openEditor() {
    _draft.clear();
    ref.read(connectionActionsProvider.notifier).clearError();
    setState(() => _editing = true);
  }

  /// "Cancel" closes an opened question; "Not now" puts one away.
  void _dismiss() {
    ref.read(connectionActionsProvider.notifier).clearError();
    if (!_editing) ref.read(connectionPromptSnoozeProvider.notifier).snooze();
    setState(() => _editing = false);
  }

  Future<void> _save() async {
    final bool saved = await ref
        .read(connectionActionsProvider.notifier)
        .record(_draft.text);
    if (!mounted || !saved) return;
    _draft.clear();
    setState(() => _editing = false);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<ConnectionSummary> summary = ref.watch(
      connectionSummaryProvider,
    );
    final AsyncValue<DateTime?> snoozedUntil = ref.watch(
      connectionPromptSnoozeProvider,
    );

    // Nothing while the first read is in flight, as the web. A read that
    // FAILED is not nothing: it is treated as no reading, so the question
    // still stands — the card is half of what this sheet holds, and an
    // empty sheet over the path is worse than a question.
    if (!summary.hasValue && !summary.hasError) return const SizedBox.shrink();
    // Resolves within a frame and never errors (see ConnectionPromptSnooze);
    // waiting for it is what keeps a snoozed question from flashing up first.
    if (!snoozedUntil.hasValue) return const SizedBox.shrink();

    final ConnectionSummary data = summary.value ?? const ConnectionSummary();
    final ConnectionReading? reading = data.reading;
    final bool stale = reading == null || reading.isStale();
    final bool snoozed = isConnectionPromptSnoozed(snoozedUntil.value);
    final bool asking = _editing || (stale && !snoozed);

    final Widget body;
    if (asking) {
      final ConnectionSave save = ref.watch(connectionActionsProvider);
      body = _Ask(
        draft: _draft,
        placeholder: reading == null ? 'e.g. 480' : _grouped(reading.count),
        editing: _editing,
        busy: save.busy,
        error: save.error,
        onChanged: () =>
            ref.read(connectionActionsProvider.notifier).clearError(),
        onSave: _save,
        onDismiss: _dismiss,
      );
    } else if (reading == null) {
      // Snoozed before ever answering: one quiet line rather than nothing.
      body = _AddCount(onAdd: _openEditor);
    } else {
      body = _Progress(
        reading: reading,
        growth: data.growth,
        history: data.history,
      );
    }

    return ZaveCard(child: body);
  }
}

class _Ask extends StatelessWidget {
  const _Ask({
    required this.draft,
    required this.placeholder,
    required this.editing,
    required this.busy,
    required this.error,
    required this.onChanged,
    required this.onSave,
    required this.onDismiss,
  });

  final TextEditingController draft;
  final String placeholder;
  final bool editing;
  final bool busy;
  final String? error;
  final VoidCallback onChanged;
  final VoidCallback onSave;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      // The dismiss sits on the title line, like a close control.
      Row(
        children: <Widget>[
          Expanded(
            child: Text(
              'How many connections do you have now?',
              style: ZaveType.h3,
            ),
          ),
          SizedBox(width: ZaveSpace.md),
          ZaveButton(
            label: editing ? 'Cancel' : 'Not now',
            onPressed: onDismiss,
          ),
        ],
      ),
      SizedBox(height: ZaveSpace.sm),
      Text('$_why One number a week is enough.', style: ZaveType.bodyMuted),
      SizedBox(height: ZaveSpace.lg),
      Row(
        children: <Widget>[
          Expanded(
            child: ZaveField(
              controller: draft,
              hint: placeholder,
              enabled: !busy,
              keyboardType: TextInputType.number,
              // Digits only, so "1,240" pasted from LinkedIn lands as 1240
              // instead of a number the Save cannot read.
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              textInputAction: TextInputAction.done,
              onChanged: (_) => onChanged(),
              onSubmitted: (_) => onSave(),
            ),
          ),
          SizedBox(width: ZaveSpace.md),
          // Disabled while the field is empty, as the web's is; the keyboard's
          // Done still submits, and an empty answer is told why it was refused.
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: draft,
            builder:
                (BuildContext context, TextEditingValue value, Widget? _) =>
                    ZaveButton.primary(
                      label: 'Save',
                      busy: busy,
                      onPressed: value.text.trim().isEmpty ? null : onSave,
                    ),
          ),
        ],
      ),
      if (error case final String sentence) ...<Widget>[
        SizedBox(height: ZaveSpace.sm),
        Semantics(
          liveRegion: true,
          // Amber, not red — Zave has no red, and a mistyped number is a
          // thing to fix, not an alarm.
          child: Text(
            sentence,
            style: ZaveType.caption.copyWith(color: ZaveColors.amber),
          ),
        ),
      ],
      SizedBox(height: ZaveSpace.sm),
      Text(_whereToFind, style: ZaveType.caption),
    ],
  );
}

class _AddCount extends StatelessWidget {
  const _AddCount({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      ZaveButton(label: 'Add your connection count', onPressed: onAdd),
      SizedBox(height: ZaveSpace.sm),
      Text(_why, style: ZaveType.caption),
    ],
  );
}

/// What the number bought: the count, the graph and how it moved — and no
/// Update button (owner, 25 Nov 2026).
class _Progress extends StatelessWidget {
  const _Progress({
    required this.reading,
    required this.growth,
    required this.history,
  });

  final ConnectionReading reading;
  final ConnectionGrowth? growth;
  final List<ConnectionReading> history;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text.rich(
          TextSpan(
            children: <InlineSpan>[
              TextSpan(text: _grouped(reading.count), style: ZaveType.h2),
              TextSpan(text: ' connections', style: ZaveType.bodyMuted),
            ],
          ),
        ),
        // Spaced by time; draws nothing with fewer than two readings.
        if (history.length >= 2) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          ConnectionSeriesChart(readings: history),
        ],
        SizedBox(height: ZaveSpace.sm),
        Text.rich(_movement(), style: ZaveType.caption),
        SizedBox(height: ZaveSpace.sm),
        Text(_why, style: ZaveType.caption),
      ],
    );
  }

  /// "+12 this week · +40 since 1 Oct", or why there is no such line yet.
  TextSpan _movement() {
    final ConnectionGrowth? g = growth;
    if (g == null || g.readings <= 1) {
      return const TextSpan(
        text: 'First reading — growth shows from next week.',
      );
    }

    // Null when the latest reading is a week old or more: nothing was
    // measured this week, so say when it was, not "no change".
    final int? week = g.week;
    final TextSpan lead = week == null
        ? TextSpan(text: 'Last updated ${_shortDate(reading.measuredAt)}')
        : TextSpan(
            text: week == 0
                ? 'No change this week'
                : '${_signed(week)} this week',
            // A rise is worth a glance; a drop is said plainly, not in alarm
            // colour.
            style: week > 0
                ? const TextStyle(
                    color: ZaveColors.mint,
                    fontWeight: FontWeight.w700,
                  )
                : null,
          );

    return TextSpan(
      children: <InlineSpan>[
        lead,
        const TextSpan(text: ' · '),
        TextSpan(
          text:
              '${g.sinceFirst == 0 ? 'no change' : _signed(g.sinceFirst)} '
              'since ${_shortDate(g.firstMeasuredAt)}',
        ),
      ],
    );
  }
}

/// `1,240` — grouped as the web's `toLocaleString('en-US')` groups it.
String _grouped(int n) => NumberFormat.decimalPattern('en_US').format(n);

/// `+12` / `−3`, with a real minus sign, as the web writes it.
String _signed(int n) {
  if (n > 0) return '+${_grouped(n)}';
  if (n < 0) return '−${_grouped(n.abs())}';
  return '0';
}

/// `12 Nov`, in the device's time zone — the web's `en-GB` day and short
/// month. An unreadable date says nothing rather than something wrong.
String _shortDate(String iso) {
  final DateTime? at = DateTime.tryParse(iso);
  if (at == null) return '';
  return DateFormat('d MMM', 'en_US').format(at.toLocal());
}
