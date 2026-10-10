import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/screen_util.dart';
import '../../../core/ui/app_icons.dart';
import '../../../core/ui/widgets/open_link.dart';
import '../../../core/ui/zave/zave_kit.dart';
import '../../home/application/home_controllers.dart';
import '../../home/domain/roadmap_level.dart';
import '../../home/domain/roadmap_progress.dart';
import '../application/plexa_chat_controller.dart';
import '../domain/chat_bubble.dart';
import '../domain/plexa_day.dart';
import 'widgets/chat_bubbles.dart';
import 'widgets/chat_dock.dart';

/// Opens Open Plexa.
///
/// A modal sheet, not a page. The web mounts `<PlexaDayChat>` as a fixed
/// overlay on the roadmap and on the Season 2 dashboard — at phone widths
/// `items-end` with `h-[86vh]`, which is a bottom sheet — and it has no URL of
/// its own on either platform. Routing to it would put the day's work behind a
/// back button and take the roadmap off screen; this way the user is still
/// standing on their roadmap when the sheet closes.
Future<void> showPlexaDay(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  // The ROOT navigator, not the shell's. Presented on the shell's own
  // navigator the sheet is a sibling of the tab body, so the bottom bar
  // stays painted over the dock — the web's `z-[100] fixed inset-0` covers
  // its nav for the same reason. The day's work is modal: nothing else on
  // screen should be tappable behind it.
  useRootNavigator: true,
  backgroundColor: Colors.transparent,
  // `bg-black/70 backdrop-blur-sm`.
  barrierColor: const Color(0xB3000000),
  builder: (BuildContext context) => const _PlexaDaySheet(),
);

class _PlexaDaySheet extends ConsumerStatefulWidget {
  const _PlexaDaySheet();

  @override
  ConsumerState<_PlexaDaySheet> createState() => _PlexaDaySheetState();
}

class _PlexaDaySheetState extends ConsumerState<_PlexaDaySheet> {
  // Built by `plexaChatProvider` in application/, not here. The sheet used to
  // construct it, which meant importing the repository provider from data/ —
  // the dependency arrow backwards, and the last such import in the app.
  late final PlexaChatController _chat = ref.read(plexaChatProvider);

  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _chat.addListener(_onChat);

    // Today's day and today's two step ids, from the same roadmap table the
    // dashboard renders. `.value` rather than an await: progress is already in
    // cache behind the screen that opened this, and a sheet that waited on a
    // second read would open blank. Absent, the chat still works — it just has
    // nothing to credit, which is also true for a company-brand user.
    final RoadmapProgress? progress = ref
        .read(roadmapProgressControllerProvider)
        .value;
    _chat.open(
      roadmapDay: progress?.currentDay ?? 1,
      laneSteps: _laneSteps(progress),
    );
  }

  /// Today's `comment` and `connect` step ids.
  ///
  /// Keyed on [RoadmapStep.key], exactly as the web's `stepFor` is. The title
  /// is display copy that `buildRoadmap` rewrites at runtime; keying on it
  /// would break the moment the wording changed.
  static Map<PlexaLane, int> _laneSteps(RoadmapProgress? progress) {
    if (progress == null) return const <PlexaLane, int>{};
    final List<RoadmapLevel> levels = buildRoadmap(progress);
    if (levels.isEmpty) return const <PlexaLane, int>{};

    final int raw = progress.currentDay;
    final int day = raw < 1 ? 1 : (raw > levels.length ? levels.length : raw);

    RoadmapLevel? level;
    for (final RoadmapLevel candidate in levels) {
      if (candidate.id == day) {
        level = candidate;
        break;
      }
    }
    if (level == null) return const <PlexaLane, int>{};

    const Map<String, PlexaLane> wanted = <String, PlexaLane>{
      'comment': PlexaLane.comments,
      'connect': PlexaLane.connections,
    };
    final Map<PlexaLane, int> out = <PlexaLane, int>{};
    for (final RoadmapStep step in level.steps) {
      final PlexaLane? lane = wanted[step.key];
      if (lane != null) out[lane] = step.id;
    }
    return out;
  }

  void _onChat() {
    if (mounted) setState(() {});
    _scrollToEnd();
  }

  /// Keeps the newest line in view.
  ///
  /// Deferred a frame: the bubble that triggered this has not been laid out
  /// yet, so `maxScrollExtent` read now is the extent BEFORE it — which
  /// scrolls to just above the line the user is waiting for.
  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: ZaveMotion.fast,
        curve: ZaveMotion.curve,
      );
    });
  }

  @override
  void dispose() {
    _chat.removeListener(_onChat);
    // NOT disposed here: `plexaChatProvider` is autoDispose and disposes it
    // when this sheet stops listening. Disposing it twice would throw.
    _scroll.dispose();
    super.dispose();
  }

  void _close() => Navigator.of(context).maybePop();

  Future<void> _openAndCount() => _chat.openAndCount(
    // No clipboard fallback. The draft is already on the clipboard by the time
    // this runs, and `openLinkOrCopy` would overwrite it with the URL — the
    // user would arrive at LinkedIn holding a link to LinkedIn.
    openUrl: (String url) => openLinkKeepingClipboard(ref, url),
    copy: (String text) => Clipboard.setData(ClipboardData(text: text)),
  );

  @override
  Widget build(BuildContext context) {
    final PlexaDay day = _chat.day;

    return Padding(
      // The sheet sits above the keyboard if anything ever summons one.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => SizedBox(
          // `h-[86vh]`, against what the sheet was actually given rather than
          // against the raw window — `useSafeArea` has already taken the
          // status bar out, and 86% of the window would then overflow it.
          //
          // Not FractionallySizedBox: that sizes ITSELF to the incoming
          // constraints and only its child to the fraction, which in a bottom
          // sheet means a full-height sheet with the chat floating in the
          // middle of it.
          height: constraints.maxHeight.isFinite
              ? constraints.maxHeight * 0.86
              : null,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: const Color(0xFF080810),
              border: Border.all(color: const Color(0x1AFFFFFF)),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(ZaveRadius.cardMd),
              ),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Color(0xCC000000),
                  blurRadius: 90,
                  spreadRadius: -20,
                  offset: Offset(0, -30),
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                _Header(
                  day: day,
                  currentDay: _chat.currentDay,
                  onClose: _close,
                ),
                Expanded(child: _thread()),
                _dock(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _thread() {
    final List<ChatBubble> bubbles = _chat.bubbles;
    final bool collapse =
        bubbles.isNotEmpty && bubbles.last.role == ChatRole.bot;

    return Semantics(
      liveRegion: true,
      child: ListView.separated(
        controller: _scroll,
        // `px-4 sm:px-5 pt-5 pb-3`.
        padding: EdgeInsets.fromLTRB(ZaveSpace.lg, 20.h, ZaveSpace.lg, 12.h),
        itemCount: bubbles.length + (_chat.isBotTyping ? 1 : 0),
        separatorBuilder: (_, _) => SizedBox(height: chatBubbleGap),
        itemBuilder: (BuildContext context, int i) {
          if (i == bubbles.length) {
            return TypingBubble(collapseAvatar: collapse);
          }
          return ChatBubbleView(
            bubble: bubbles[i],
            isGroupStart: i == 0 || bubbles[i - 1].role != bubbles[i].role,
          );
        },
      ),
    );
  }

  /// What the user can say next. The branches, and their order, are the web's
  /// `renderDock`.
  Widget _dock() {
    final Widget body;
    if (_chat.isBotTyping) {
      body = const DockHint(text: 'Plexa is typing…');
    } else if (_chat.phase == PlexaPhase.loading) {
      body = const DockHint(text: 'Pulling today together…');
    } else if (_chat.phase == PlexaPhase.empty) {
      body = ChipRow(
        children: <Widget>[SecondaryChip(label: 'Close', onPressed: _close)],
      );
    } else if (_chat.phase == PlexaPhase.done) {
      body = ChipRow(
        children: <Widget>[
          PrimaryChip(
            icon: Icon(AppIcons.check, size: 14.sp, color: ZaveColors.white),
            label: 'Done for today',
            onPressed: _close,
          ),
        ],
      );
    } else {
      final DayItem? item = _chat.currentItem;
      if (item == null) {
        body = const DockHint(text: '…');
      } else {
        body = ChipRow(
          children: <Widget>[
            PrimaryChip(
              reply: true,
              icon: Icon(
                AppIcons.linkedin,
                size: 15.sp,
                color: ZaveColors.white,
              ),
              label: item.lane == PlexaLane.comments
                  ? 'Open and comment'
                  : 'Open and connect',
              onPressed: _openAndCount,
            ),
            SecondaryChip(
              icon: Icon(AppIcons.skip, size: 12.sp, color: ZaveColors.white),
              label: 'Skip',
              onPressed: _chat.skip,
            ),
          ],
        );
      }
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: ZaveSpace.lg,
        vertical: ZaveSpace.lg,
      ),
      decoration: const BoxDecoration(
        color: Color(0xE0080810),
        border: Border(top: BorderSide(color: Color(0x0FFFFFFF))),
      ),
      child: SafeArea(top: false, child: body),
    );
  }
}

/// Who is talking, and how much of today is left.
class _Header extends StatelessWidget {
  const _Header({
    required this.day,
    required this.currentDay,
    required this.onClose,
  });

  final PlexaDay day;
  final int currentDay;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: ZaveSpace.lg, vertical: 14.h),
    decoration: const BoxDecoration(
      color: Color(0xBF080810),
      border: Border(bottom: BorderSide(color: Color(0x0FFFFFFF))),
    ),
    child: Row(
      children: <Widget>[
        const BotAvatar(),
        SizedBox(width: ZaveSpace.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Today with Plexa',
                style: GoogleFonts.urbanist(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                  color: ZaveColors.white,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                // A count, not a percentage, and the day only while there is
                // no count to give: "3 of 11 cleared" answers the question the
                // user opened this to ask, and "Day 7" is all there is to say
                // when the day has nothing in it.
                (day.items.isEmpty
                        ? 'Day $currentDay'
                        : '${day.clearedCount} of ${day.items.length} cleared')
                    .toUpperCase(),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10.sp,
                  letterSpacing: 0.16 * 10.sp,
                  color: ZaveColors.ink35,
                ),
              ),
            ],
          ),
        ),
        ZavePress(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onClose,
            child: SizedBox(
              height: ZaveSpace.minTapTarget,
              width: ZaveSpace.minTapTarget,
              child: Icon(AppIcons.close, size: 16.sp, color: ZaveColors.ink45),
            ),
          ),
        ),
      ],
    ),
  );
}
