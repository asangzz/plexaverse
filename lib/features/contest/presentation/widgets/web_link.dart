import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/links/plexaverse.dart';
import '../../../../core/platform/link_opening.dart';
import '../../../../core/responsive/screen_util.dart';
import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import 'contest_kit.dart';

/// A line that opens one of our own WEB pages — the contest's rules, or its
/// removed claims and their appeals — in the browser.
///
/// The link words are periwinkle with the open-outside glyph; [rest] carries
/// on the sentence in the meta tone, so the line reads exactly as the web's
/// does ("Contest rules — how XP works, …"). The whole line is the tap
/// target, at least 48 tall, and says it is a link. A page that cannot be
/// opened is copied instead, and the learner is told so — in words about a
/// page, not about LinkedIn, which `openLinkAndReport` would say.
class ContestWebLink extends ConsumerWidget {
  const ContestWebLink({
    required this.label,
    required this.url,
    this.before = '',
    this.rest = '',
    super.key,
  });

  final String label;
  final String url;

  /// What the line says before the link words, with its own trailing space.
  final String before;

  /// The rest of the sentence after the link words, with its own leading
  /// space or dash.
  final String rest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextStyle meta = ContestType.meta.copyWith(height: 1.6);
    return Semantics(
      link: true,
      label: '$before$label$rest',
      excludeSemantics: true,
      child: InkWell(
        onTap: () => _open(context, ref),
        borderRadius: ZaveRadius.pillBr,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: ZaveSpace.minTapTarget),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                children: <InlineSpan>[
                  if (before.isNotEmpty) TextSpan(text: before, style: meta),
                  TextSpan(
                    text: label,
                    style: meta.copyWith(
                      color: ContestColors.peri,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Padding(
                      padding: EdgeInsets.only(left: 4.w),
                      child: Icon(
                        AppIcons.openExternal,
                        size: 13.sp,
                        color: ContestColors.peri,
                      ),
                    ),
                  ),
                  if (rest.isNotEmpty) TextSpan(text: rest, style: meta),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _open(BuildContext context, WidgetRef ref) async {
    final LinkOpenResult result = await ref.read(linkOpeningProvider).open(url);
    if (result is LinkOpened) return;
    await Clipboard.setData(ClipboardData(text: url));
    if (!context.mounted) return;
    ScaffoldMessenger.maybeOf(context)
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: ZaveColors.deep,
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Could not open the page — link copied instead.',
            style: ZaveType.body,
          ),
        ),
      );
  }
}

/// The way to the published rules, from every state of the contest page
/// that shows a contest. The web's `RulesLine`.
class ContestRulesLine extends StatelessWidget {
  const ContestRulesLine({super.key});

  @override
  Widget build(BuildContext context) => const ContestWebLink(
    label: 'Contest rules',
    rest: ' — how XP works, what the prize is, and how claims are checked.',
    url: plexaverseContestRulesUrl,
  );
}

/// "Think we got it wrong? Appeal the decision" — under a removed claim, as
/// the web's revoked feed-comments and screenshot levels say it. Opens the
/// web's removed claims and appeals page: each revoke can be appealed there
/// once, within its window, and the app has no appeal form of its own.
class ContestAppealLine extends StatelessWidget {
  const ContestAppealLine({this.before = '', super.key});

  /// What the panel says first, on the same line before the question.
  final String before;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('${before}Think we got it wrong?', style: ContestType.meta),
        const ContestWebLink(
          label: 'Appeal the decision',
          url: plexaverseContestAppealsUrl,
        ),
      ],
    );
  }
}
