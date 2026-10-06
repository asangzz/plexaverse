import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../../preferences/domain/user_preferences.dart';
import '../../../preferences/application/preferences_controller.dart';
import 'settings_section.dart';

/// **Mission Schedule** — when the daily mission arrives, and in which zone.
///
/// ## Why there is no cadence here any more
///
/// This screen used to offer POSTS PER WEEK (3 / 5 / 7) and PUBLISHING DAYS
/// (a Sun–Sat picker). Both wrote real columns. Neither changed anything.
///
/// `preferredDays` is validated by the zod schema, stored on
/// `UserPreferences`, and **read by nothing** — no scheduler, no planner, no
/// publish path. The week's shape comes from `WEEK_SHAPE`, which is fixed.
///
/// `postsPerWeek` is read in exactly one place, `generateWeekPlan`'s
/// maintenance mode, and that is now a no-op: the kept set is
/// `postingDays().slice(0, 3)` and the week has two post days, so a cap of
/// three blanks nothing. The field is NOT dead — `season.service` still sets
/// it to 3 when a user picks the maintenance path at the end of a season, and
/// if the week ever regains a fourth posting day the cap bites again. What was
/// wrong was letting someone set it HERE, where it reads as a promise about
/// how often they will post.
///
/// The web has no cadence UI at all; it captures these at onboarding and never
/// shows them again. So this is not mobile losing something the web has — it
/// is mobile no longer offering a choice the product cannot honour, which is
/// the thing the alignment work exists to fix.
///
/// What is left is live: `preferredTime` feeds the publish time, the chain
/// fire time, the daily mission and the calendar event.
class CadenceSection extends ConsumerStatefulWidget {
  const CadenceSection({required this.preferences, super.key});

  final UserPreferences preferences;

  @override
  ConsumerState<CadenceSection> createState() => _CadenceSectionState();
}

class _CadenceSectionState extends ConsumerState<CadenceSection> {
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
      await ref
          .read(preferencesControllerProvider.notifier)
          .saveMissionTime(_formatTime(_time));
      if (mounted) {
        showSettingsMessage(context, 'Schedule updated.');
      }
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
                  'Plexaverse writes your week’s posts for approval on the days '
                  'your plan posts — not every day. The video scripts and the '
                  'newsletter are prepared for you to post yourself, and the '
                  'weekend rests. Disable to stop generation and stop incurring '
                  'AI costs; you can re-enable anytime.',
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
