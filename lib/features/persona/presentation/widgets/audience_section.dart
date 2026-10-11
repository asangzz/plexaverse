import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/persona_write_controller.dart';
import '../../domain/persona_repository.dart';
import 'persona_chrome.dart';

/// **Who you're writing for** — the audience block.
///
/// This is the only editable thing on the persona screen, and the copy is the
/// web's, verbatim, including the line that explains the cost of leaving it
/// blank. That sentence is the section's whole argument and paraphrasing it
/// would lose it.
///
/// The web additionally offers "Suggest from my profile", which reads the
/// user's LinkedIn profile and proposes two or three real buyers to tap. There
/// is no mobile route for it (`/ai/suggest-audience` does not exist under
/// `api/mobile/v1`), so the manual form — which the web also has — is the whole
/// of this block here, and the missing suggestion is stated rather than hidden.
class AudienceSection extends ConsumerStatefulWidget {
  const AudienceSection({required this.audience, super.key});

  final PersonaAudience audience;

  @override
  ConsumerState<AudienceSection> createState() => _AudienceSectionState();
}

class _AudienceSectionState extends ConsumerState<AudienceSection> {
  late final TextEditingController _role = TextEditingController(
    text: widget.audience.role ?? '',
  );
  late final TextEditingController _industry = TextEditingController(
    text: widget.audience.industry ?? '',
  );
  late final TextEditingController _problem = TextEditingController(
    text: widget.audience.problem ?? '',
  );

  /// A set audience shows as a summary until the user asks to change it — the
  /// web does the same, because the value of this block once filled is that you
  /// can read it at a glance.
  late bool _editing = !widget.audience.isSet;

  @override
  void dispose() {
    _role.dispose();
    _industry.dispose();
    _problem.dispose();
    super.dispose();
  }

  /// The PATCH is [PersonaWriteController]'s — it outlives this card, which is
  /// torn down and rebuilt every time the snapshot above it changes. Only the
  /// two things that have no meaning off this card are left here: the snackbar,
  /// which needs a [BuildContext] application/ cannot hold, and the collapse
  /// back to the summary.
  Future<void> _save() async {
    final String? failure = await ref
        .read(personaWriteControllerProvider.notifier)
        .saveAudience(
          role: _role.text.trim(),
          industry: _industry.text.trim(),
          problem: _problem.text.trim(),
        );
    if (!mounted) return;

    if (failure == null) {
      setState(() => _editing = false);
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(failure, style: ZaveType.body)));
  }

  @override
  Widget build(BuildContext context) {
    final PersonaAudience audience = widget.audience;
    // `.select` so this card rebuilds for its own save and not for the reach
    // import running three sections below it.
    final bool saving = ref.watch(
      personaWriteControllerProvider.select(
        (Set<String> open) => open.contains(PersonaWrite.audience),
      ),
    );

    return PersonaSection(
      title: "Who you're writing for",
      status: audience.isSet
          ? null
          // Amber: waiting on the user, not broken. Zave has no red.
          : const ZavePill(label: 'Not set', color: ZaveColors.amber),
      lead: audience.isSet
          ? 'Every post is written for this person. Change it whenever the '
                'work changes.'
          : 'Until this is set, posts are written for people in your own job — '
                'who enjoy them and cannot hire you.',
      child: _editing ? _form(saving) : _summary(audience),
    );
  }

  Widget _summary(PersonaAudience audience) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(audience.headline, style: ZaveType.h3),
        if (audience.problem != null && audience.problem!.isNotEmpty) ...[
          SizedBox(height: ZaveSpace.sm),
          Text(
            'You help them with: ${audience.problem}',
            style: ZaveType.bodyMuted,
          ),
        ],
        SizedBox(height: ZaveSpace.lg),
        Align(
          alignment: Alignment.centerLeft,
          child: ZaveButton(
            label: 'Edit',
            onPressed: () => setState(() => _editing = true),
          ),
        ),
      ],
    );
  }

  Widget _form(bool saving) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ZaveField(
          controller: _role,
          label: 'Who they are',
          hint: 'Heads of Operations',
          maxLength: 120,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: ZaveSpace.lg),
        ZaveField(
          controller: _industry,
          label: 'Their industry',
          hint: 'logistics',
          maxLength: 120,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: ZaveSpace.lg),
        ZaveField(
          controller: _problem,
          label: 'What you help them with',
          hint: 'Delivery costs rising without service levels dropping',
          maxLength: 120,
          minLines: 2,
          maxLines: 4,
        ),
        SizedBox(height: ZaveSpace.lg),
        Wrap(
          spacing: ZaveSpace.sm,
          runSpacing: ZaveSpace.sm,
          children: <Widget>[
            // The one white button on this screen: the audience is the field
            // the whole page is arguing for.
            ZaveButton.primary(
              label: saving ? 'Saving…' : 'Save',
              busy: saving,
              onPressed: saving ? null : _save,
            ),
            if (widget.audience.isSet)
              ZaveButton(
                label: 'Cancel',
                onPressed: saving
                    ? null
                    : () => setState(() => _editing = false),
              ),
          ],
        ),
        SizedBox(height: ZaveSpace.lg),
        const PersonaUnavailableNote(
          title: 'Suggestions are web-only for now',
          message:
              'On the web, Plexa reads your profile and proposes a few real '
              'buyers to pick from. That call has no mobile route yet, so this '
              'is the typed-in version of the same three fields.',
        ),
      ],
    );
  }
}
