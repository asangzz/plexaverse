import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/engagement/top_voice_categories.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../../preferences/application/preferences_controller.dart';
import '../../../preferences/domain/user_preferences.dart';
import 'settings_section.dart';

/// **Subjects** — what the day's curated posts are drawn from.
///
/// The one thing joining an imported post to a user. A post carries one of the
/// forty ids; a user carries the handful that match their work; the morning's
/// five are the intersection. Choosing none is not a setting with a sensible
/// default — it means the upper half of the comments screen is empty every
/// day, which looks exactly like a quiet day and says nothing.
///
/// ## Why it writes on dismiss rather than on every tap
///
/// Each tap would be a PATCH, and a user adjusting four subjects would fire
/// four writes against a rate-limited route to land one state. Worse, the
/// middle ones are states they never meant to be in — including, on the way
/// from one subject to another, the empty set, which is the value that turns
/// their curated feed off. The sheet holds a draft and commits once.
class SubjectsSection extends ConsumerWidget {
  const SubjectsSection({required this.preferences, super.key});

  final UserPreferences preferences;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> chosen = preferences.postCategories
        .where(isTopVoiceCategoryId)
        .toList(growable: false);

    return SettingsSection(
      title: 'Subjects',
      lead:
          'Five curated posts land on the comments screen every morning, each '
          'with a comment already written. These are the subjects they are '
          'picked from.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (chosen.isEmpty)
            Text(
              'No subjects yet — so no curated posts. Pick the ones you work in '
              'and they start tomorrow morning.',
              style: ZaveType.bodyMuted,
            )
          else
            Wrap(
              spacing: ZaveSpace.sm,
              runSpacing: ZaveSpace.sm,
              children: <Widget>[
                for (final String id in chosen)
                  ZaveChip(
                    label: topVoiceCategoryLabel(id),
                    selected: true,
                    // Not individually removable here. The sheet is the one
                    // place this is edited, so there is exactly one path that
                    // can write an empty set and exactly one that can undo it.
                    onTap: () => _edit(context, ref, chosen),
                  ),
              ],
            ),
          SizedBox(height: ZaveSpace.lg),
          Align(
            alignment: Alignment.centerLeft,
            child: ZaveButton(
              label: chosen.isEmpty ? 'Choose subjects' : 'Edit subjects',
              onPressed: () => _edit(context, ref, chosen),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref,
    List<String> chosen,
  ) async {
    final List<String>? picked = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0xB3000000),
      builder: (BuildContext context) => _SubjectPicker(initial: chosen),
    );

    // Null is a dismissal, which is not the same as choosing nothing — and the
    // difference matters here, because choosing nothing turns the feed off.
    if (picked == null) return;
    await ref
        .read(preferencesControllerProvider.notifier)
        .setPostCategories(picked);
  }
}

class _SubjectPicker extends StatefulWidget {
  const _SubjectPicker({required this.initial});

  final List<String> initial;

  @override
  State<_SubjectPicker> createState() => _SubjectPickerState();
}

class _SubjectPickerState extends State<_SubjectPicker> {
  late final Set<String> _draft = widget.initial.toSet();

  @override
  Widget build(BuildContext context) {
    final List<MapEntry<String, String>> all = topVoiceCategories.entries
        .toList(growable: false);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) => SizedBox(
        height: constraints.maxHeight.isFinite
            ? constraints.maxHeight * 0.86
            : null,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: ZaveGround.base,
            border: Border.all(color: ZaveGlass.headerBorder),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(ZaveRadius.cardMd),
            ),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(
                  ZaveSpace.gutter,
                  ZaveSpace.lg,
                  ZaveSpace.gutter,
                  ZaveSpace.md,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text('Subjects', style: ZaveType.h3),
                          SizedBox(height: 2),
                          Text(
                            _draft.isEmpty
                                // Said plainly, because an empty set is a real
                                // choice with a consequence the user cannot
                                // see from here.
                                ? 'None selected — no curated posts'
                                : '${_draft.length} selected',
                            style: ZaveType.caption,
                          ),
                        ],
                      ),
                    ),
                    ZaveIconButton(
                      icon: const Icon(Icons.close),
                      tooltip: 'Close without saving',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: ZaveSpace.gutter),
                  child: Wrap(
                    spacing: ZaveSpace.sm,
                    runSpacing: ZaveSpace.sm,
                    children: <Widget>[
                      for (final MapEntry<String, String> c in all)
                        ZaveChip(
                          label: c.value,
                          selected: _draft.contains(c.key),
                          onTap: () => setState(() {
                            if (!_draft.remove(c.key)) _draft.add(c.key);
                          }),
                        ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(ZaveSpace.gutter),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: ZaveGlass.headerBorder),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: ZaveButton.primary(
                    label: 'Save subjects',
                    expand: true,
                    onPressed: () => Navigator.of(
                      context,
                    ).pop(_draft.toList(growable: false)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
