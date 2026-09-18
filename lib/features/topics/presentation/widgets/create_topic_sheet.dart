import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';

/// What the user typed into the Create Topic form.
///
/// Returned from the sheet rather than written from inside it: the sheet is a
/// form, the page owns the network call, and keeping the split means the sheet
/// renders in a test without a repository.
class NewTopicDraft {
  const NewTopicDraft({
    required this.name,
    required this.keywords,
    this.description,
  });

  final String name;

  /// Already split on commas, trimmed, and stripped of empties — exactly what
  /// the web does before it POSTs.
  final List<String> keywords;

  /// Null when the box was left empty. The column is nullable and the web
  /// posts `description || null`, so an empty string is never stored.
  final String? description;
}

/// The Create Topic form, as a sheet.
///
/// The web opens a centred modal over a `bg-black/60 backdrop-blur-sm`
/// scrim. A phone's equivalent is a sheet on the app's own ground — a
/// centred dialog on a 390pt screen is a modal that has to fight the
/// keyboard for the same space.
///
/// Returns a [NewTopicDraft] on submit, or null if dismissed.
Future<NewTopicDraft?> showCreateTopicSheet(BuildContext context) {
  return showModalBottomSheet<NewTopicDraft>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext _) => const _CreateTopicSheet(),
  );
}

class _CreateTopicSheet extends StatefulWidget {
  const _CreateTopicSheet();

  @override
  State<_CreateTopicSheet> createState() => _CreateTopicSheetState();
}

class _CreateTopicSheetState extends State<_CreateTopicSheet> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _keywords = TextEditingController();

  /// Null until the user has tried to submit once. Showing "Topic Name is
  /// required" on an untouched form scolds someone who has not done anything
  /// wrong yet.
  String? _nameError;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _keywords.dispose();
    super.dispose();
  }

  void _submit() {
    final String name = _name.text.trim();
    if (name.isEmpty) {
      // Amber, via ZaveField's error state — Zave has no red.
      setState(() => _nameError = 'A topic needs a name.');
      return;
    }

    final String description = _description.text.trim();

    Navigator.of(context).pop(
      NewTopicDraft(
        name: name,
        description: description.isEmpty ? null : description,
        keywords: _keywords.text
            .split(',')
            .map((String k) => k.trim())
            .where((String k) => k.isNotEmpty)
            .toList(growable: false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      ),
      decoration: BoxDecoration(
        gradient: ZaveGround.base,
        border: const Border(
          top: BorderSide(color: ZaveGlass.headerBorder, width: 1),
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ZaveRadius.cardLg),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          // Lift the form clear of the keyboard; the sheet is a form and the
          // keyboard is up for the whole time it is open.
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(ZaveSpace.gutter),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: Container(
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: ZaveColors.rule,
                      borderRadius: ZaveRadius.pillBr,
                    ),
                  ),
                ),
                SizedBox(height: ZaveSpace.xl),
                Text('Create Topic', style: ZaveType.h3),
                SizedBox(height: ZaveSpace.xl),
                ZaveField(
                  controller: _name,
                  label: 'Topic name',
                  hint: 'e.g., Tech Leadership',
                  error: _nameError,
                  textInputAction: TextInputAction.next,
                  onChanged: (String _) {
                    if (_nameError != null) setState(() => _nameError = null);
                  },
                ),
                SizedBox(height: ZaveSpace.lg),
                ZaveField(
                  controller: _description,
                  label: 'Description',
                  hint: 'What should the AI write about?',
                  maxLines: 4,
                  minLines: 3,
                ),
                SizedBox(height: ZaveSpace.lg),
                ZaveField(
                  controller: _keywords,
                  label: 'Keywords',
                  hint: 'e.g., AI, productivity, startups',
                  helper: 'Comma-separated.',
                  textInputAction: TextInputAction.done,
                  onSubmitted: (String _) => _submit(),
                ),
                SizedBox(height: ZaveSpace.xl),
                ZaveButton(
                  label: 'Create Topic',
                  kind: ZaveButtonKind.primarySmall,
                  expand: true,
                  onPressed: _submit,
                ),
                SizedBox(height: ZaveSpace.md),
                ZaveButton(
                  label: 'Cancel',
                  expand: true,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
