import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../../preferences/domain/user_preferences.dart';
import '../../application/settings_controllers.dart';
import 'settings_section.dart';

/// **Mission Schedule** — when the week publishes, and how often.
///
/// The web's Settings page carries only the time and the timezone here; the
/// cadence itself (`postsPerWeek`, `preferredDays`) is captured during
/// onboarding and never shown again. Both are exposed on this screen, because
/// mobile has no other surface that can reach them and the mobile API's
/// preferences PATCH already accepts them. Flagged as a departure in the
/// hand-off summary.
///
/// **Day numbering is the server's, not Dart's.** The zod schema is
/// `min(0).max(6)` over a Sunday-first week; `DateTime.weekday` is Monday-first
/// and 1-based. The conversion happens here, at the edge, and nowhere else.
class CadenceSection extends ConsumerStatefulWidget {
  const CadenceSection({required this.preferences, super.key});

  final UserPreferences preferences;

  @override
  ConsumerState<CadenceSection> createState() => _CadenceSectionState();
}

class _CadenceSectionState extends ConsumerState<CadenceSection> {
  /// Sunday-first, matching the server's 0–6.
  static const List<String> _dayLabels = <String>[
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];

  /// The cadences the product actually supports. 3 is "maintenance mode" —
  /// the weekday slots shrink to `{Sun, Tue, Thu}` while the Sunday article
  /// still generates, because the article is the week's spine and not one of
  /// its posts (CLAUDE.md §6b).
  static const List<int> _cadences = <int>[3, 5, 7];

  late final Set<int> _days = <int>{...widget.preferences.preferredDays};
  late int _postsPerWeek = widget.preferences.postsPerWeek;
  late TimeOfDay _time = _parseTime(widget.preferences.preferredTime);
  bool _saving = false;

  static TimeOfDay _parseTime(String raw) {
    final List<String> parts = raw.split(':');
    final int? hour = parts.isNotEmpty ? int.tryParse(parts[0]) : null;
    final int? minute = parts.length > 1 ? int.tryParse(parts[1]) : null;
    // A malformed stored value must not crash the screen; 09:00 is the
    // server's own default.
    if (hour == null || minute == null || hour > 23 || minute > 59) {
      return const TimeOfDay(hour: 9, minute: 0);
    }
    return TimeOfDay(hour: hour, minute: minute);
  }

  static String _formatTime(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:'
      '${time.minute.toString().padLeft(2, '0')}';

  Future<void> _pickTime() async {
    // Material's own picker, themed by ZaveTheme. Zave has no time-picker
    // component and building one would be a large surface with no web
    // counterpart to align to.
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null && mounted) setState(() => _time = picked);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final List<int> days = _days.toList()..sort();
      await ref
          .read(preferencesControllerProvider.notifier)
          .saveCadence(
            postsPerWeek: _postsPerWeek,
            preferredDays: days,
            preferredTime: _formatTime(_time),
          );
      if (mounted) showSettingsMessage(context, 'Profile updated successfully!');
    } on Object {
      if (mounted) showSettingsMessage(context, 'Failed to update profile.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'Mission Schedule',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('POSTS PER WEEK', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.sm),
          Wrap(
            spacing: ZaveSpace.sm,
            runSpacing: ZaveSpace.sm,
            children: <Widget>[
              for (final int n in _cadences)
                ZaveChip(
                  label: '$n',
                  selected: _postsPerWeek == n,
                  onTap: () => setState(() => _postsPerWeek = n),
                ),
            ],
          ),
          if (_postsPerWeek <= 3) ...<Widget>[
            SizedBox(height: ZaveSpace.sm),
            Text(
              'Maintenance mode. Your Sunday article still gets written — it '
              'is the week’s spine, not one of its posts.',
              style: ZaveType.caption,
            ),
          ],

          const SettingsDivider(),

          Text('PUBLISHING DAYS', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.sm),
          Wrap(
            spacing: ZaveSpace.sm,
            runSpacing: ZaveSpace.sm,
            children: <Widget>[
              for (int day = 0; day < _dayLabels.length; day++)
                ZaveChip(
                  label: _dayLabels[day],
                  selected: _days.contains(day),
                  onTap: () => setState(() {
                    if (!_days.remove(day)) _days.add(day);
                  }),
                ),
            ],
          ),

          const SettingsDivider(),

          Text('DAILY MISSION TIME', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.sm),
          Align(
            alignment: Alignment.centerLeft,
            child: ZaveButton(
              label: _formatTime(_time),
              icon: const Icon(Icons.schedule_outlined),
              onPressed: _pickTime,
            ),
          ),
          SizedBox(height: ZaveSpace.sm),
          Text(
            'When should your mission directive hit your inbox?',
            style: ZaveType.caption,
          ),

          const SettingsDivider(),

          Text('YOUR TIMEZONE', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.sm),
          Align(
            alignment: Alignment.centerLeft,
            child: ZavePill(
              label: widget.preferences.timezone,
              leading: const Icon(
                Icons.public_outlined,
                size: 16,
                color: ZaveColors.ink45,
              ),
            ),
          ),
          SizedBox(height: ZaveSpace.sm),
          // The web re-detects this with `Intl.DateTimeFormat().resolvedOptions()
          // .timeZone`, which hands back an IANA name. Flutter has no IANA zone
          // without a package — `DateTime.now().timeZoneName` is an abbreviation
          // ("IST"), and writing that into the column would break the scheduler
          // it feeds. So the app shows the stored zone and does not offer
          // re-detection; see the hand-off summary.
          Text(
            'Detected from your device during setup. Change it from the web '
            'app if you have moved.',
            style: ZaveType.caption,
          ),

          SizedBox(height: ZaveSpace.xl),
          Align(
            alignment: Alignment.centerRight,
            // The screen's ONE white button — the web reserves its `.zv-cta`
            // for exactly this control too.
            child: ZaveButton.primary(
              label: _saving ? 'Saving...' : 'Save Schedule',
              busy: _saving,
              onPressed: _saving ? null : _save,
            ),
          ),
        ],
      ),
    );
  }
}

/// **Auto-Post Generation** — the daily-generation kill switch.
///
/// Live, via `PATCH /user/autopost-toggle`.
///
/// It goes through its own endpoint rather than the preferences PATCH because
/// it is not a preference: enabling stamps a resume time so the server's
/// auto-pause engine starts from a clean slate, re-arms the next generation
/// task, and clears stale "Auto-post paused" notifications. That is also why
/// `autoPostEnabled` is deliberately absent from the preferences schema — it
/// was not an oversight there, and adding it would skip all of the above.
class AutoPostSection extends ConsumerWidget {
  const AutoPostSection({required this.preferences, super.key});

  final UserPreferences preferences;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool enabled = preferences.autoPostEnabled;

    return SettingsSection(
      title: 'Auto-Post Generation',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Plexaverse can prepare a fresh LinkedIn post for your '
                  'approval every day. Disable to stop generation and stop '
                  'incurring AI costs. You can re-enable anytime — your post '
                  'for tomorrow will be ready by morning.',
                  style: ZaveType.caption,
                ),
              ),
              SizedBox(width: ZaveSpace.lg),
              ZaveSwitch(
                value: enabled,
                onChanged: (bool next) => ref
                    .read(preferencesControllerProvider.notifier)
                    .setAutoPost(next),
                semanticLabel: 'Auto-post generation',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
