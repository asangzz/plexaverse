import 'package:flutter/material.dart';

import '../../../../../core/responsive/screen_util.dart';
import '../../../../../core/ui/zave/zave_kit.dart';

/// The words waiting to fill the blanks: the answers and three that fit
/// nowhere, in the server's order — shuffled once for the day, so a re-read
/// shows the same bank. A port of the web's word bank.
///
/// A word in a blank stays in its place here, dimmed, so the bank never
/// reflows under the learner's thumb.
class WordBank extends StatelessWidget {
  const WordBank({
    required this.bank,
    required this.used,
    required this.onPick,
    super.key,
  });

  final List<String> bank;

  /// The indexes already in a blank.
  final Set<int> used;

  /// Null while nothing may move — a verdict is up or a submission is out.
  final ValueChanged<int>? onPick;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Word bank',
      container: true,
      child: Wrap(
        spacing: 10.w,
        runSpacing: 10.h,
        children: <Widget>[
          for (int i = 0; i < bank.length; i++)
            _Chip(
              word: bank[i],
              used: used.contains(i),
              onTap: onPick == null || used.contains(i)
                  ? null
                  : () => onPick!(i),
            ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.word, required this.used, required this.onTap});

  final String word;
  final bool used;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: word,
      excludeSemantics: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            // 12 rather than the web's 8: a thumb, not a pointer, picks
            // these, and 12 brings the chip to about 44 high.
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: used ? const Color(0x0AFFFFFF) : const Color(0x0FFFFFFF),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: used ? const Color(0x0FFFFFFF) : const Color(0x24FFFFFF),
                width: 2,
              ),
            ),
            child: Text(
              word,
              style: ZaveType.body.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: used ? const Color(0x33FFFFFF) : ZaveColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
