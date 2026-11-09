import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/zave_routes.dart';
import '../ui/zave/zave_kit.dart';
import 'plan_refusal.dart';

/// The one sheet every AI feature opens when the plan says no.
///
/// Two states, because the two refusals want opposite remedies:
///
///   • needs a plan → the server's message and a way to the pricing page.
///   • limit reached → the server's message and when it comes back. No
///     pricing button: the user already has a plan, and selling them one
///     for a limit that resets tonight would be wrong.
///
/// Neither offers "Try again" — the same request would be refused the same
/// way until something changes outside this screen.
class PlanLimitSheet extends StatelessWidget {
  const PlanLimitSheet({required this.refusal, this.now, super.key});

  final PlanRefusal refusal;

  /// Injectable clock for the "Back at" line, for tests.
  final DateTime? now;

  static Future<void> show(BuildContext context, PlanRefusal refusal) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext _) => PlanLimitSheet(refusal: refusal),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? back = refusal.isLimit ? refusal.backAtLabel(now: now) : null;
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.9,
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
              Text(
                refusal.needsPlan ? 'Needs a plan' : 'Limit reached',
                style: ZaveType.h3,
              ),
              SizedBox(height: ZaveSpace.sm),
              Text(refusal.message, style: ZaveType.body),
              if (back != null) ...<Widget>[
                SizedBox(height: ZaveSpace.md),
                Text(
                  back,
                  style: ZaveType.label.copyWith(color: ZaveColors.amber),
                ),
              ],
              SizedBox(height: ZaveSpace.xl),
              if (refusal.needsPlan) ...<Widget>[
                // Brand blue: the one colour Zave reserves for the upgrade
                // path, which this is.
                ZaveButton.brand(
                  label: 'See plans',
                  expand: true,
                  onPressed: () {
                    // Read the router before popping: the sheet's context is
                    // gone once it closes.
                    final GoRouter router = GoRouter.of(context);
                    Navigator.of(context).pop();
                    router.push(ZaveRoutes.pricing);
                  },
                ),
                SizedBox(height: ZaveSpace.sm),
              ],
              ZaveButton(
                label: refusal.needsPlan ? 'Not now' : 'OK',
                expand: true,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
