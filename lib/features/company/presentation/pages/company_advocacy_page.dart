import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/zave_routes.dart';
import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/company_controllers.dart';
import '../../domain/advocacy_post.dart';
import '../../domain/company_repository.dart';
import '../widgets/advocacy_card.dart';
import '../widgets/company_states.dart';

/// **Advocacy** — the web's `/company-advocacy`, "Employee Amplification".
///
/// A feed of company posts flagged for advocacy; resharing one to your own
/// LinkedIn feed widens the company's reach. It used to earn 50 wallet XP;
/// wallet XP is retired (the plan pays for AI now), so a reshare pays nothing
/// and the copy no longer promises it. The feed holds only the posts THIS
/// user featured (web 857b2b3): it was meant as a team surface, but with no
/// team in the schema a global feed was every company's posts.
///
/// Nav visibility is `admin`, so this is hidden from every end user in v1 and
/// reachable only by deep link. The screen is built anyway: the gate is a nav
/// decision the product can reverse without a release, and a screen that does
/// not exist cannot be un-hidden.
///
/// One thing to hold onto: the connection this screen needs is the PERSONAL
/// one. Everything else under `features/company` runs on the company account;
/// a reshare publishes to the user's own feed and fails with a different
/// precondition, which is why its error says which account is missing.
class CompanyAdvocacyPage extends ConsumerWidget {
  const CompanyAdvocacyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<AdvocacyState> feed = ref.watch(
      advocacyControllerProvider,
    );

    _announceAward(context, ref);

    return ZaveScaffold(
      largeTitle: 'Advocacy',
      actions: <Widget>[
        ZaveIconButton(
          icon: const Icon(AppIcons.refresh),
          tooltip: 'Refresh',
          onPressed: () => ref.invalidate(advocacyControllerProvider),
        ),
      ],
      body: RefreshIndicator(
        color: ZaveColors.white,
        backgroundColor: ZaveColors.deep,
        onRefresh: () async {
          ref.invalidate(advocacyControllerProvider);
          await ref.read(advocacyControllerProvider.future);
        },
        child: ZaveScrollView(
          children: <Widget>[
            Text(
              "Support your company's growth. Reshare featured posts to your "
              'personal LinkedIn network to boost their organic reach.',
              style: ZaveType.lead,
            ),
            SizedBox(height: ZaveSpace.xl),
            ...feed.when(
              loading: () => <Widget>[
                const CompanySkeletonList(count: 3, height: 280),
              ],
              error: (Object e, StackTrace _) => <Widget>[
                if (e is CompanyUnavailable)
                  CompanyUnavailableCard(
                    failure: e,
                    onRetry: () => ref.invalidate(advocacyControllerProvider),
                    onOpenSettings: () => context.push(ZaveRoutes.settings),
                  )
                else
                  CompanyErrorCard(
                    title: "The advocacy feed didn't load.",
                    onRetry: () => ref.invalidate(advocacyControllerProvider),
                  ),
              ],
              data: (AdvocacyState state) => _feed(ref, state),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _feed(WidgetRef ref, AdvocacyState state) {
    final AdvocacyController notifier = ref.read(
      advocacyControllerProvider.notifier,
    );

    return <Widget>[
      if (state.error != null) ...<Widget>[
        ZaveCard(
          child: Row(
            children: <Widget>[
              // Amber, not red: Zave has no red, and a failed reshare is
              // "needs another go", not a destructive state.
              const ZaveDot(ZaveColors.amber),
              SizedBox(width: ZaveSpace.md),
              Expanded(child: Text(state.error!, style: ZaveType.bodyMuted)),
              SizedBox(width: ZaveSpace.md),
              ZaveIconButton(
                icon: const Icon(AppIcons.close),
                tooltip: 'Dismiss',
                onPressed: notifier.clearError,
              ),
            ],
          ),
        ),
        SizedBox(height: ZaveSpace.md),
      ],
      if (state.posts.isEmpty)
        const CompanyEmptyCard(
          title: 'Advocacy Queue Empty',
          body:
              'No company posts have been featured for advocacy yet. Check '
              'back later!',
        )
      else
        ..._cards(state, notifier),
    ];
  }

  List<Widget> _cards(AdvocacyState state, AdvocacyController notifier) {
    final List<Widget> cards = <Widget>[];
    for (int i = 0; i < state.posts.length; i++) {
      final AdvocacyPost post = state.posts[i];
      cards.add(
        AdvocacyCard(
          post: post,
          resharing: state.isResharing(post.id),
          reshared: state.isReshared(post.id),
          onReshare: () => notifier.reshare(post),
        ),
      );
      if (i != state.posts.length - 1) {
        cards.add(SizedBox(height: ZaveSpace.md));
      }
    }
    return cards;
  }

  /// The reshare toast.
  ///
  /// It keys off [AdvocacyState.lastXpAward] only because that is the field the
  /// controller sets on every successful reshare; the number itself is ignored,
  /// since wallet XP is retired and the server now awards nothing. The web
  /// animates a purple gradient panel with a bouncing emoji. Zave has
  /// neither a decorative gradient nor a bounce, so the award is announced in
  /// the app's own snack bar — which the Zave theme already styles — and the
  /// state is cleared so it fires once.
  void _announceAward(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<AdvocacyState>>(advocacyControllerProvider, (
      AsyncValue<AdvocacyState>? previous,
      AsyncValue<AdvocacyState> next,
    ) {
      final int? award = next.value?.lastXpAward;
      if (award == null || award == previous?.value?.lastXpAward) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Amplified — shared to your feed.')),
        );
      ref.read(advocacyControllerProvider.notifier).clearAward();
    });
  }
}
