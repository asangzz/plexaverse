import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/platform/link_opening.dart';
import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/learn_controllers.dart';
import '../../domain/learn_unit.dart';
import '../../domain/learner_lines.dart';
import 'exercise_views.dart';
import 'level_node.dart';
import 'quiz_shell.dart';

/// One level, one question at a time.
///
/// ## Two shapes behind the same frame
///
/// A TAUGHT level is a quiz: the teaching point, then its questions one to a
/// screen, each answered, graded by the server and answered back in a bar
/// that turns green or amber before the next one appears. An ACTION level
/// (write the post, make the poster, read it back) is a panel — there is
/// nothing to grade, only something to do.
///
/// ## Why the whole level is not submitted at once
///
/// It was, and it read as a form. The teaching happens in the half second
/// between committing to an answer and finding out, and a page of stacked
/// questions under one Check button has no such moment — it has a submit.
/// Per question also means a wrong answer costs something visible (a heart)
/// at the point the mistake is made, rather than being listed with three
/// others at the end.
///
/// ## Nothing here decides whether an answer is right
///
/// Check enables on a purely mechanical rule — is there an answer, is it long
/// enough — and every verdict comes back from the server. See the note on
/// [Verdict] in `exercise_views.dart` for why that line must not move.
class LessonPlayer extends ConsumerStatefulWidget {
  const LessonPlayer({
    required this.unit,
    required this.week,
    required this.day,
    required this.onClose,
    this.openAt,
    super.key,
  });

  final LearnUnit unit;
  final int week;
  final int day;
  final VoidCallback onClose;

  /// The node the user tapped on the path.
  ///
  /// The path draws its nodes from the TEMPLATE, before any ladder exists,
  /// so a tap can land on a level the learner has not reached. The ladder is
  /// the authority: a locked target is ignored and the run keeps its own
  /// seed, which is the server's `nextLevelIndex`.
  final int? openAt;

  @override
  ConsumerState<LessonPlayer> createState() => _LessonPlayerState();
}

class _LessonPlayerState extends ConsumerState<LessonPlayer> {
  /// Typed answers, by exercise id. Controllers so the text survives a
  /// rebuild — a verdict arriving must not wipe what the user wrote.
  ///
  /// Purely a text buffer: the answer of record is the run's `value`, which
  /// these write into on every keystroke.
  final Map<String, TextEditingController> _controllers =
      <String, TextEditingController>{};

  /// One per free-text question, owned here for the same reason the
  /// controllers are: the question's widget is rebuilt whenever the run
  /// changes, and a node created in that build would be a new node every
  /// frame — so "Say it instead" would focus something that no longer exists.
  final Map<String, FocusNode> _focusNodes = <String, FocusNode>{};

  @override
  void initState() {
    super.initState();
    final int? target = widget.openAt;
    if (target == null) return;
    // Post-frame: a provider cannot be written to while the tree is
    // building. The run has already seeded itself to the ladder's own open
    // level, so this only ever moves a learner who tapped somewhere else —
    // and only when that somewhere is actually reachable.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final List<LearnLevel> levels = widget.unit.levels;
      if (target < 0 || target >= levels.length) return;
      if (levels[target].isLocked) return;
      _run.goToLevel(target);
    });
  }

  @override
  void dispose() {
    for (final TextEditingController c in _controllers.values) {
      c.dispose();
    }
    for (final FocusNode n in _focusNodes.values) {
      n.dispose();
    }
    super.dispose();
  }

  LearnRun get _run =>
      ref.read(learnRunProvider(widget.week, widget.day).notifier);

  TextEditingController _controllerFor(String id) =>
      _controllers.putIfAbsent(id, TextEditingController.new);

  FocusNode _focusFor(String id) =>
      _focusNodes.putIfAbsent(id, FocusNode.new);

  /// A new run means an empty box, whatever was typed into the last one.
  void _clearTyping() {
    for (final TextEditingController c in _controllers.values) {
      c.clear();
    }
  }

  /// The only local judgement allowed: is there an answer to send.
  bool _canCheck(Exercise exercise, String value) {
    final String v = value.trim();
    if (exercise.isCompose) return v.length >= exercise.minChars;
    return v.isNotEmpty;
  }

  void _leaveLevel(int nextIndex) {
    _clearTyping();
    if (nextIndex >= widget.unit.levels.length) {
      widget.onClose();
      return;
    }
    _run.goToLevel(nextIndex);
  }

  Future<void> _step(Future<LearnStep> Function() action) async {
    final LearnStep step = await action();
    if (!mounted || step != LearnStep.banked) return;
    _leaveLevel(
      ref.read(learnRunProvider(widget.week, widget.day)).levelIndex + 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    final LearnRunState run = ref.watch(
      learnRunProvider(widget.week, widget.day),
    );
    final List<LearnLevel> levels = widget.unit.levels;
    if (levels.isEmpty || run.levelIndex >= levels.length) {
      return _Panel(
        week: widget.week,
        day: widget.day,
        unit: widget.unit,
        level: null,
        onClose: widget.onClose,
        child: const ZaveEmptyState(
          title: 'Nothing to climb here',
          body: 'This day has no levels yet.',
        ),
      );
    }

    final LearnLevel level = levels[run.levelIndex];

    // ── The hearts are gone ─────────────────────────────────────────────
    if (run.outOfHearts && !level.isComplete) {
      return _Panel(
        week: widget.week,
        day: widget.day,
        unit: widget.unit,
        level: level,
        onClose: widget.onClose,
        child: OutOfHeartsView(
          message: run.error,
          onRetry: () {
            _clearTyping();
            _run.restart();
          },
          onQuit: widget.onClose,
        ),
      );
    }

    // ── The server speaks a dialect this build does not ─────────────────
    if (!level.isClimbable) {
      return _Panel(
        week: widget.week,
        day: widget.day,
        unit: widget.unit,
        level: level,
        onClose: widget.onClose,
        // Said plainly, because the alternative — drawing the questions we
        // understand and silently dropping the rest — looks like a complete
        // level and grades as a failed one.
        child: ZaveEmptyState(
          kicker: 'UPDATE NEEDED',
          title: 'This lesson needs a newer app',
          body:
              'It uses a kind of question this version cannot show '
              '(${level.unsupportedTypes.join(", ")}). Update the app, or '
              'climb this day on the web.',
        ),
      );
    }

    // ── Nothing to answer: do the thing instead ─────────────────────────
    if (level.kind.isAction || level.isComplete) {
      return _Panel(
        week: widget.week,
        day: widget.day,
        unit: widget.unit,
        level: level,
        onClose: widget.onClose,
        child: _ActionLevel(
          // Keyed by level, or Flutter reuses one State across them: the
          // poster level's resume observer is added in initState, which does
          // not run again when draft hands over to visual — so the
          // come-back-from-ChatGPT re-check never fired, and on the way out
          // the observer stayed attached to a level that had moved on.
          key: ValueKey<int>(level.index),
          unit: widget.unit,
          level: level,
          week: widget.week,
          day: widget.day,
          onDone: () => _leaveLevel(run.levelIndex + 1),
        ),
      );
    }

    return _Quiz(
      unit: widget.unit,
      level: level,
      run: run,
      controllerFor: _controllerFor,
      focusNodeFor: _focusFor,
      canCheck: _canCheck,
      onTeachRead: _run.teachRead,
      onValue: _run.setValue,
      onCheck: (Exercise e) =>
          _run.check(unit: widget.unit, level: level, exercise: e),
      onContinue: () =>
          _step(() => _run.advance(unit: widget.unit, level: level)),
      onSkip: (Exercise e) => _step(
        () => _run.skip(unit: widget.unit, level: level, exercise: e),
      ),
    );
  }
}

/// The quiz: header, one question, the bar that answers back.
class _Quiz extends StatefulWidget {
  const _Quiz({
    required this.unit,
    required this.level,
    required this.run,
    required this.controllerFor,
    required this.focusNodeFor,
    required this.canCheck,
    required this.onTeachRead,
    required this.onValue,
    required this.onCheck,
    required this.onContinue,
    required this.onSkip,
  });

  final LearnUnit unit;
  final LearnLevel level;
  final LearnRunState run;
  final TextEditingController Function(String id) controllerFor;
  final FocusNode Function(String id) focusNodeFor;
  final bool Function(Exercise exercise, String value) canCheck;
  final VoidCallback onTeachRead;
  final ValueChanged<String> onValue;
  final ValueChanged<Exercise> onCheck;
  final VoidCallback onContinue;
  final ValueChanged<Exercise> onSkip;

  @override
  State<_Quiz> createState() => _QuizState();
}

class _QuizState extends State<_Quiz> {
  final ScrollController _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  /// When the verdict lands, show the answers it is talking about.
  ///
  /// The bar is a third of a phone screen once it carries the corrected line
  /// and the explanation, and it grows from the foot — so the options the
  /// learner just chose between end up behind it, including the green one
  /// naming the right answer. Scrolling to the end puts them back on screen.
  /// Without this the single most useful thing on the page is reachable only
  /// by a scroll nobody knows to make.
  @override
  void didUpdateWidget(_Quiz old) {
    super.didUpdateWidget(old);
    if (old.run.verdict != null || widget.run.verdict == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: ZaveMotion.quick,
        curve: ZaveMotion.curve,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final LearnUnit unit = widget.unit;
    final LearnLevel level = widget.level;
    final LearnRunState run = widget.run;
    final int total = level.exercises.length;
    final int at = run.questionIndex.clamp(0, total == 0 ? 0 : total - 1);
    final Exercise? exercise = total == 0 ? null : level.exercises[at];
    final bool lastQuestion = at >= total - 1;
    final bool lastLevel = level.index >= unit.levels.length - 1;
    final bool working = run.work != null;

    /// The teaching card is up, so the question and its bar are not.
    ///
    /// Gated on the CARD, not on `run.taught`. Those are only the same thing
    /// when the level actually has a teaching block — and `teach` is
    /// nullable on the wire. A level that arrived without one showed its
    /// first question immediately and no bar underneath it, because nothing
    /// had set `taught`: no Check, no Skip, no way to answer, and the day
    /// could never advance past it.
    final bool showingTeach = !run.taught && level.teach != null;

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(
            ZaveSpace.gutter,
            ZaveScaffold.contentTop(context) + ZaveSpace.md,
            ZaveSpace.gutter,
            ZaveSpace.md,
          ),
          child: QuizHeader(
            // The bar counts questions ANSWERED, not questions reached: it
            // moves when the verdict lands, which is the moment something
            // was actually done. Filling it on arrival at a question would
            // credit the learner for scrolling.
            progress: total == 0
                ? 0
                : (at + (run.verdict != null ? 1 : 0)) / total,
            heartsLeft: run.heartsLeft,
            streak: run.streak,
          ),
        ),
        Expanded(
          child: ListView(
            controller: _scroll,
            padding: EdgeInsets.fromLTRB(
              ZaveSpace.gutter,
              ZaveSpace.lg,
              ZaveSpace.gutter,
              ZaveSpace.section,
            ),
            children: <Widget>[
              if (showingTeach)
                _TeachCard(teach: level.teach!, onStart: widget.onTeachRead)
              else if (total == 0)
                Text(
                  'There is nothing to answer on this one.',
                  style: ZaveType.bodyMuted,
                )
              else if (exercise != null) ...<Widget>[
                _ContextStrip(unit: unit, level: level),
                SizedBox(height: ZaveSpace.lg),
                ExerciseView(
                  // Keyed by question, so Flutter rebuilds rather than
                  // reusing the last one's field state across a change of
                  // shape — a rewrite box left holding the previous
                  // answer is the bug this prevents.
                  key: ValueKey<String>(exercise.id),
                  exercise: exercise,
                  value: run.value,
                  controller: exercise.isFreeText
                      ? widget.controllerFor(exercise.id)
                      : null,
                  focusNode: exercise.isFreeText
                      ? widget.focusNodeFor(exercise.id)
                      : null,
                  verdict: run.verdict,
                  onChanged: widget.onValue,
                ),
              ],
            ],
          ),
        ),
        // The bar also stays for a level with NO questions — see
        // QuizResultBar.nothingToAnswer. Without it such a level is a dead
        // end the day can never advance past.
        if (!showingTeach && (exercise != null || total == 0))
          QuizResultBar(
            verdict: run.verdict,
            checking: working,
            nothingToAnswer: total == 0,
            canCheck: exercise != null && widget.canCheck(exercise, run.value),
            onCheck: () => exercise == null ? null : widget.onCheck(exercise),
            onContinue: widget.onContinue,
            onSkip: () => exercise == null ? null : widget.onSkip(exercise),
            isLast: lastQuestion && lastLevel,
            // A wrong ANSWER is not an error and is never shown here; this
            // is for a request that did not go through.
            error: run.verdict == null ? run.error : null,
          ),
      ],
    );
  }
}

/// The day this level is building, pinned above the question.
///
/// The levels exist to produce a specific post, and a learner who has lost
/// track of which one is answering trivia.
class _ContextStrip extends StatelessWidget {
  const _ContextStrip({required this.unit, required this.level});

  final LearnUnit unit;
  final LearnLevel level;

  static const List<String> _days = <String>[
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
    'SUNDAY',
  ];

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      Text(
        unit.dayIndex >= 0 && unit.dayIndex < _days.length
            ? _days[unit.dayIndex]
            : 'THIS DAY',
        style: ZaveType.kicker,
      ),
      SizedBox(width: ZaveSpace.sm),
      Text('·', style: ZaveType.kicker.copyWith(color: ZaveColors.ink35)),
      SizedBox(width: ZaveSpace.sm),
      Expanded(
        child: Text(
          level.title.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: ZaveType.kicker.copyWith(color: ZaveColors.scheduled),
        ),
      ),
    ],
  );
}

/// Everything that is not a question: the action levels, the refusal, the
/// out-of-hearts screen. One frame so they do not each invent their own.
class _Panel extends StatelessWidget {
  const _Panel({
    required this.week,
    required this.day,
    required this.unit,
    required this.level,
    required this.onClose,
    required this.child,
  });

  final int week;
  final int day;
  final LearnUnit unit;
  final LearnLevel? level;
  final VoidCallback onClose;
  final Widget child;

  @override
  Widget build(BuildContext context) => ZaveScrollView(
    children: <Widget>[
      if (level case final LearnLevel l) ...<Widget>[
        Row(
          children: <Widget>[
            Icon(iconForLevel(l.kind), size: 18, color: ZaveColors.violet),
            SizedBox(width: ZaveSpace.sm),
            Expanded(child: Text(l.title, style: ZaveType.h3)),
            Text(
              '${l.index + 1} of ${unit.levels.length}',
              style: ZaveType.caption,
            ),
          ],
        ),
        SizedBox(height: ZaveSpace.xl),
      ],
      child,
      SizedBox(height: ZaveSpace.section),
    ],
  );
}

/// The rule, before any question is asked.
class _TeachCard extends StatelessWidget {
  const _TeachCard({required this.teach, required this.onStart});

  final TeachBlock teach;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      if (teach.kind case final String kind when kind.isNotEmpty) ...<Widget>[
        Text(kind.replaceAll('_', ' ').toUpperCase(), style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.md),
      ],
      Text(teach.rule, style: ZaveType.h2),
      SizedBox(height: ZaveSpace.sm),
      Text(teach.why, style: ZaveType.bodyMuted),
      SizedBox(height: ZaveSpace.xl),
      _BeforeAfter(label: 'WEAK', body: teach.before, tint: ZaveColors.ink45),
      SizedBox(height: ZaveSpace.sm),
      _BeforeAfter(label: 'STRONG', body: teach.after, tint: ZaveColors.green),
      SizedBox(height: ZaveSpace.xl),
      ZaveButton.primary(label: 'Got it', expand: true, onPressed: onStart),
    ],
  );
}

class _BeforeAfter extends StatelessWidget {
  const _BeforeAfter({
    required this.label,
    required this.body,
    required this.tint,
  });

  final String label;
  final String body;
  final Color tint;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: ZaveSpace.rowPad,
    decoration: ZaveSurface.row,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: ZaveType.kicker.copyWith(color: tint)),
        SizedBox(height: ZaveSpace.xs),
        Text(body, style: ZaveType.body),
      ],
    ),
  );
}

/// The three levels finished by doing rather than answering.
///
/// They share a shape — an explanation, one control, and a done state — but
/// almost nothing else, so each is its own branch rather than a parameterised
/// card that would have to apologise for all three.
class _ActionLevel extends ConsumerStatefulWidget {
  const _ActionLevel({
    required super.key,
    required this.unit,
    required this.level,
    required this.week,
    required this.day,
    required this.onDone,
  });

  final LearnUnit unit;
  final LearnLevel level;
  final int week;
  final int day;
  final VoidCallback onDone;

  @override
  ConsumerState<_ActionLevel> createState() => _ActionLevelState();
}

class _ActionLevelState extends ConsumerState<_ActionLevel>
    with WidgetsBindingObserver {
  /// When the app went to the background, so a resume can tell a trip to
  /// ChatGPT apart from a notification shade being pulled down.
  DateTime? _leftAt;

  @override
  void initState() {
    super.initState();
    if (widget.level.kind == LevelKind.visual) {
      WidgetsBinding.instance.addObserver(this);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// The mobile answer to the web's window-focus re-check.
  ///
  /// Scoped hard on purpose. Android and iOS deliver `resumed` for the
  /// notification shade, an app-switcher peek and every permission dialog —
  /// re-checking on all of them would turn an idle screen into a poller
  /// against a 60/min bucket. So: only on the visual level, only after a real
  /// absence, and never while something is already in flight.
  ///
  /// The manual button below stays the primary path. If this proves noisy it
  /// can be deleted and the level is still perfectly usable.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _leftAt = DateTime.now();
      return;
    }
    if (state != AppLifecycleState.resumed) return;
    final DateTime? left = _leftAt;
    _leftAt = null;
    if (left == null) return;
    if (DateTime.now().difference(left) < const Duration(seconds: 3)) return;
    if (widget.level.isComplete) return;
    if (ref.read(learnActionsProvider(widget.week, widget.day)).isBusy) return;
    _checkVisual();
  }

  LearnActions get _actions =>
      ref.read(learnActionsProvider(widget.week, widget.day).notifier);

  Future<void> _checkVisual() => _actions.checkVisual(widget.unit.id);

  Future<void> _openChatGpt() async {
    // externalApplication, so the OS hands this to the installed ChatGPT app
    // or the system browser where the session already lives. An in-app
    // WebView would land the user in a signed-out chat with no connector and
    // no way to tell why the level will not complete.
    final LinkOpenResult result = await ref
        .read(linkOpeningProvider)
        .open(_posterPrompt());
    if (!mounted) return;
    if (result is LinkOpenFailed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open ChatGPT on this device.')),
      );
    }
  }

  /// The hand-off carries an INSTRUCTION, not the post.
  ///
  /// The web's `lib/chatgpt-handoff.ts` spells out why the detail must not
  /// ride in the URL: the real prompt is several thousand characters and gets
  /// truncated, it is all the user's own material and a URL lands in history,
  /// and it goes stale the moment it is built. ChatGPT reads the day itself
  /// through the connector.
  String _posterPrompt() {
    final String ask = Uri.encodeComponent(
      'Make the poster image for my Plexaverse post for '
      '${widget.unit.title} (week ${widget.unit.weekNumber}, '
      'day ${widget.unit.dayIndex + 1}). The post is already written — '
      'read it from the planner and design the image for it. '
      'Do not rewrite the post.',
    );
    return 'https://chatgpt.com/?q=$ask';
  }

  @override
  Widget build(BuildContext context) {
    final LearnBusy busy = ref.watch(
      learnActionsProvider(widget.week, widget.day),
    );
    final bool done = widget.level.isComplete;

    return switch (widget.level.kind) {
      LevelKind.draft => _draft(busy, done),
      LevelKind.visual => _visual(busy, done),
      LevelKind.review => _review(busy, done),
      // A taught level that is already complete: nothing to answer again,
      // just the way on.
      _ => _finished(),
    };
  }

  Widget _finished() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text('You have already finished this level.', style: ZaveType.bodyMuted),
      SizedBox(height: ZaveSpace.xl),
      _continue(),
    ],
  );

  Widget _draft(LearnBusy busy, bool done) {
    // What this day actually produces. Wednesday and Friday write a script and
    // Thursday a newsletter; calling all three a "post" on screen was wrong
    // before it was confusing, because only two of the five climbable days
    // become a Post at all.
    final String made = widget.unit.kind.madeThing;

    if (done && (widget.unit.postContent?.isNotEmpty ?? false)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Written(
            label: 'YOUR ${made.toUpperCase()}',
            body: widget.unit.postContent!,
          ),
          SizedBox(height: ZaveSpace.lg),
          _LearnerLines(unit: widget.unit),
          SizedBox(height: ZaveSpace.xl),
          _continue(),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Your opening, your account of what happened and your closing ask '
          'are all written. This puts them together into the $made — in your '
          'voice, using your words.',
          style: ZaveType.bodyMuted,
        ),
        SizedBox(height: ZaveSpace.lg),
        if (busy.error case final String message) ...<Widget>[
          Text(
            message,
            style: ZaveType.caption.copyWith(color: ZaveColors.amber),
          ),
          SizedBox(height: ZaveSpace.md),
        ],
        ZaveButton.primary(
          label: busy.isDrafting ? 'Writing your $made…' : 'Write my $made',
          expand: true,
          busy: busy.isDrafting,
          // Enablement comes from the LEVEL, not from a local flag. A 120s
          // call on a phone will routinely time out while the server
          // finishes and bills; a local flag would re-offer the button and
          // sell the user a second post.
          onPressed: busy.isBusy || done
              ? null
              : () => _actions.draft(widget.unit.id),
        ),
        if (busy.isDrafting) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          Text(
            'This takes about half a minute. Keep this screen open.',
            textAlign: TextAlign.center,
            style: ZaveType.caption.copyWith(color: ZaveColors.ink35),
          ),
        ],
      ],
    );
  }

  Widget _visual(LearnBusy busy, bool done) {
    if (done) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (widget.unit.imageUrl case final String url when url.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(ZaveRadius.cardSm),
              child: AspectRatio(aspectRatio: 1, child: ZaveImage(source: url)),
            ),
          SizedBox(height: ZaveSpace.xl),
          _continue(),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'The poster is made in ChatGPT, on your own quota, and written back '
          'through the Plexaverse connector. Open ChatGPT, ask for it, then '
          'come back and check.',
          style: ZaveType.bodyMuted,
        ),
        SizedBox(height: ZaveSpace.md),
        // Said plainly rather than discovered. Without the connector this
        // level cannot complete, and because a day is locked until the one
        // before it is finished, that stalls the whole week. A user who
        // cannot connect it needs to know now, not on Thursday.
        Container(
          width: double.infinity,
          padding: ZaveSpace.rowPad,
          decoration: ZaveSurface.row,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(AppIcons.info, size: 16, color: ZaveColors.amber),
              SizedBox(width: ZaveSpace.sm),
              Expanded(
                child: Text(
                  'The connector is set up in Plexaverse on the web. Without '
                  'it ChatGPT cannot write the poster back, and this level '
                  'will not complete.',
                  style: ZaveType.caption.copyWith(color: ZaveColors.ink62),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: ZaveSpace.lg),
        if (busy.error case final String message) ...<Widget>[
          Text(
            message,
            style: ZaveType.caption.copyWith(color: ZaveColors.amber),
          ),
          SizedBox(height: ZaveSpace.md),
        ],
        ZaveButton.primary(
          label: 'Open ChatGPT',
          icon: const Icon(AppIcons.openExternal),
          expand: true,
          onPressed: busy.isBusy ? null : _openChatGpt,
        ),
        SizedBox(height: ZaveSpace.md),
        ZaveButton(
          label: "I've made it — check now",
          expand: true,
          busy: busy.work == LearnWork.checkingVisual,
          onPressed: busy.isBusy ? null : _checkVisual,
        ),
      ],
    );
  }

  Widget _review(LearnBusy busy, bool done) {
    if (done) return _continue();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.unit.postContent case final String body
            when body.isNotEmpty) ...<Widget>[
          _Written(label: 'WHAT YOU MADE', body: body),
          SizedBox(height: ZaveSpace.lg),
          _LearnerLines(unit: widget.unit),
          SizedBox(height: ZaveSpace.xl),
        ],
        _Taught(unit: widget.unit),
        SizedBox(height: ZaveSpace.xl),
        Text(
          'Read it once more. The words are yours — you wrote them climbing '
          'this day.',
          style: ZaveType.bodyMuted,
        ),
        SizedBox(height: ZaveSpace.lg),
        if (busy.error case final String message) ...<Widget>[
          Text(
            message,
            style: ZaveType.caption.copyWith(color: ZaveColors.amber),
          ),
          SizedBox(height: ZaveSpace.md),
        ],
        ZaveButton.primary(
          label: "I've read it",
          expand: true,
          busy: busy.work == LearnWork.reviewing,
          onPressed: busy.isBusy ? null : () => _actions.review(widget.unit.id),
        ),
      ],
    );
  }

  Widget _continue() => ZaveButton.primary(
    label: 'Continue',
    expand: true,
    trailing: const Icon(AppIcons.forward),
    onPressed: widget.onDone,
  );
}

/// What happened to the lines the learner wrote.
///
/// The point of this whole feature is that the post comes out of what they
/// wrote. When it does not — and sometimes it legitimately will not, because
/// a hook that reads well on its own does not always carry a post — saying so
/// is the difference between a product that respects the work and one that
/// quietly drops it. A learner whose line disappears without a word stops
/// writing lines.
///
/// `edited` is reported as a success, not a departure: the prompt explicitly
/// asks for light tidying, so a recognisably-theirs opening is the intended
/// outcome, and flagging it would train people to distrust a correct result.
class _LearnerLines extends StatelessWidget {
  const _LearnerLines({required this.unit});

  final LearnUnit unit;

  @override
  Widget build(BuildContext context) {
    final LearnerLineReport? report = reportLearnerLines(
      unit.levels,
      unit.postContent,
    );
    if (report == null || report.isEmpty) return const SizedBox.shrink();

    final Color tint = report.anyReplaced
        ? ZaveColors.amber
        : ZaveColors.green;

    return Container(
      width: double.infinity,
      padding: ZaveSpace.cardPad,
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.05),
        border: Border.all(color: tint.withValues(alpha: 0.22)),
        borderRadius: ZaveRadius.cardBr,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('YOUR LINES', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.md),
          _LineRow(label: 'Your opening', verdict: report.hook),
          if (report.hook.outcome != LineOutcome.missing &&
              report.close.outcome != LineOutcome.missing)
            SizedBox(height: ZaveSpace.md),
          _LineRow(label: 'Your ask', verdict: report.close),
          if (report.anyReplaced) ...<Widget>[
            SizedBox(height: ZaveSpace.md),
            Text(
              'You can put your own line back in the post editor — nothing '
              'here is final until you approve it.',
              style: ZaveType.caption.copyWith(color: ZaveColors.ink45),
            ),
          ],
        ],
      ),
    );
  }
}

class _LineRow extends StatelessWidget {
  const _LineRow({required this.label, required this.verdict});

  final String label;
  final LineVerdict verdict;

  @override
  Widget build(BuildContext context) {
    if (verdict.outcome == LineOutcome.missing) {
      return const SizedBox.shrink();
    }
    final bool survived = verdict.outcome.survived;
    final Color tint = survived ? ZaveColors.green : ZaveColors.amber;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: ZaveDot(tint),
        ),
        SizedBox(width: ZaveSpace.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                switch (verdict.outcome) {
                  LineOutcome.kept => '$label — used word for word.',
                  LineOutcome.edited => '$label — used, lightly tidied.',
                  _ => '$label — Plexa went another way.',
                },
                style: ZaveType.label.copyWith(color: tint),
              ),
              if (!survived) ...<Widget>[
                SizedBox(height: ZaveSpace.xs),
                _Quote(label: 'You wrote', body: verdict.written ?? ''),
                SizedBox(height: ZaveSpace.xs),
                _Quote(label: 'The post has', body: verdict.shipped),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Quote extends StatelessWidget {
  const _Quote({required this.label, required this.body});

  final String label;
  final String body;

  @override
  Widget build(BuildContext context) => Text.rich(
    TextSpan(
      children: <InlineSpan>[
        TextSpan(text: '$label: '),
        TextSpan(
          text: '“$body”',
          style: ZaveType.caption.copyWith(color: ZaveColors.ink85),
        ),
      ],
    ),
    style: ZaveType.caption.copyWith(color: ZaveColors.ink45),
  );
}

/// Every teaching point in the unit, for the read-back.
class _Taught extends StatelessWidget {
  const _Taught({required this.unit});

  final LearnUnit unit;

  @override
  Widget build(BuildContext context) {
    final List<TeachBlock> taught = <TeachBlock>[
      for (final LearnLevel l in unit.levels)
        if (l.teach case final TeachBlock t) t,
    ];
    if (taught.isEmpty) return const SizedBox.shrink();

    return ZaveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('WHAT YOU PRACTISED', style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.md),
          for (final TeachBlock t in taught) ...<Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: ZaveDot(ZaveColors.green),
                ),
                SizedBox(width: ZaveSpace.sm),
                Expanded(
                  child: Text(
                    t.rule,
                    style: ZaveType.body.copyWith(color: ZaveColors.ink85),
                  ),
                ),
              ],
            ),
            SizedBox(height: ZaveSpace.sm),
          ],
        ],
      ),
    );
  }
}

/// A finished piece of writing, read-only.
class _Written extends StatelessWidget {
  const _Written({required this.label, required this.body});

  final String label;
  final String body;

  @override
  Widget build(BuildContext context) => ZaveCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.md),
        Text(body, style: ZaveType.body),
      ],
    ),
  );
}
