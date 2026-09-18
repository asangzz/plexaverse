import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/theme/plexaverse_colors.dart';
import '../../../../core/ui/widgets/glass_card.dart';
import '../../../../core/ui/widgets/status_badge.dart';
import '../../domain/post_entity.dart';
import '../posts_context_ext.dart';

/// The post composer (create / edit / pre-scheduled). Full-screen route
/// (`RoutePaths.createPost`) parented to the root navigator. Ported verbatim
/// from the layer-first `presentation/features/posts/pages/create_post_page.dart`
/// — this is a design-only stepper today (actions are stubs) and its visuals
/// are Plexaverse product identity, preserved unchanged.
class CreatePostPage extends StatefulWidget {
  /// When coming from the schedule page, pre-fill the scheduled time.
  final DateTime? preScheduledAt;

  /// When editing an existing post, pre-fill content + hook.
  final PostEntity? editPost;

  const CreatePostPage({
    super.key,
    this.preScheduledAt,
    this.editPost,
  });

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  int _currentStep = 0;
  int _selectedVisual = 1; // 0=Photo, 1=AI Art (default), 2=Carousel

  late final TextEditingController _hookCtrl;
  late final TextEditingController _bodyCtrl;

  final double _hookScore = 8.4;

  @override
  void initState() {
    super.initState();
    _hookCtrl = TextEditingController(text: widget.editPost?.hookLine ?? '');
    _bodyCtrl = TextEditingController(text: widget.editPost?.content ?? '');
  }

  @override
  void dispose() {
    _hookCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  bool get _canPublish => _currentStep >= 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded,
              size: 22.r, color: context.colors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Create Post',
          style: GoogleFonts.sora(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: context.colors.onSurface,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: TextButton(
              onPressed: _canPublish ? () {} : null,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                backgroundColor: _canPublish
                    ? PlexaversePalette.primary
                    : PlexaversePalette.primary.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              child: Text(
                'Publish',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),

            // ── Step indicator ────────────────────────────────────────────────
            _StepIndicator(
              currentStep: _currentStep,
              totalSteps: 4,
              onStepTap: (i) => setState(() => _currentStep = i),
            ),

            SizedBox(height: 24.h),

            // ── Step 1: Hook ──────────────────────────────────────────────────
            _StepSection(
              stepNumber: 1,
              label: 'Write your hook',
              isActive: _currentStep == 0,
              child: _HookStep(
                controller: _hookCtrl,
                hookScore: _hookScore,
              ),
            ),

            SizedBox(height: 12.h),

            // ── Step 2: Body ──────────────────────────────────────────────────
            _StepSection(
              stepNumber: 2,
              label: 'Expand your idea',
              isActive: _currentStep == 1,
              child: _BodyStep(controller: _bodyCtrl),
            ),

            SizedBox(height: 12.h),

            // ── Step 3: Visual ────────────────────────────────────────────────
            _StepSection(
              stepNumber: 3,
              label: 'Add visual',
              isActive: _currentStep == 2,
              child: _VisualStep(
                selected: _selectedVisual,
                onSelect: (i) => setState(() => _selectedVisual = i),
              ),
            ),

            SizedBox(height: 12.h),

            // ── Step 4: Publish ───────────────────────────────────────────────
            _StepSection(
              stepNumber: 4,
              label: 'Schedule or publish',
              isActive: _currentStep == 3,
              child: const _PublishStep(),
            ),

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}

// ── Step indicator ────────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final ValueChanged<int> onStepTap;

  const _StepIndicator({
    required this.currentStep,
    required this.totalSteps,
    required this.onStepTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (i) {
        final isActive = i == currentStep;
        final isDone = i < currentStep;

        return Expanded(
          child: GestureDetector(
            onTap: () => onStepTap(i),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: isActive ? 6.h : 4.h,
                decoration: BoxDecoration(
                  color: isDone
                      ? PlexaversePalette.success
                      : isActive
                          ? PlexaversePalette.primary
                          : PlexaversePalette.grey600.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ── Step section wrapper ──────────────────────────────────────────────────────

class _StepSection extends StatelessWidget {
  final int stepNumber;
  final String label;
  final bool isActive;
  final Widget child;

  const _StepSection({
    required this.stepNumber,
    required this.label,
    required this.isActive,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: isActive
            ? context.colors.onSurface.withValues(alpha: 0.04)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isActive
              ? PlexaversePalette.primary.withValues(alpha: 0.3)
              : context.colors.onSurface.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 22.r,
                  height: 22.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? PlexaversePalette.primary
                        : context.colors.onSurface.withValues(alpha: 0.15),
                  ),
                  child: Center(
                    child: Text(
                      '$stepNumber',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: isActive
                            ? Colors.white
                            : context.colors.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  label,
                  style: GoogleFonts.urbanist(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: isActive
                        ? context.colors.onSurface
                        : context.colors.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
            if (isActive) ...[
              SizedBox(height: 16.h),
              child,
            ],
          ],
        ),
      ),
    );
  }
}

// ── Step 1: Hook ──────────────────────────────────────────────────────────────

class _HookStep extends StatelessWidget {
  final TextEditingController controller;
  final double hookScore;

  const _HookStep({required this.controller, required this.hookScore});

  Color get _scoreColor {
    if (hookScore >= 8.0) return PlexaversePalette.success;
    if (hookScore >= 6.0) return PlexaversePalette.warning;
    return PlexaversePalette.error;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hook text area
        GlassCard(
          padding: EdgeInsets.all(14.r),
          child: SizedBox(
            height: 120.h,
            child: TextField(
              controller: controller,
              style: GoogleFonts.urbanist(
                fontSize: 16.sp,
                color: context.colors.onSurface,
                height: 1.5,
              ),
              decoration: InputDecoration(
                hintText: 'What\'s your big idea? Start with a hook...',
                hintStyle: TextStyle(
                  fontSize: 16.sp,
                  color: context.colors.onSurface.withValues(alpha: 0.35),
                  height: 1.5,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
            ),
          ),
        ),

        SizedBox(height: 10.h),

        // Hook score
        Row(
          children: [
            Text(
              'Hook Score:',
              style: TextStyle(
                fontSize: 12.sp,
                color: context.colors.onSurface.withValues(alpha: 0.55),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: _scoreColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: _scoreColor.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: Text(
                '${hookScore.toStringAsFixed(1)} / 10',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: _scoreColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        // AI suggestion chips
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: const [
            _AiChip(emoji: '✨', label: 'Make bolder'),
            _AiChip(emoji: '🎯', label: 'Add numbers'),
            _AiChip(emoji: '🔥', label: 'More emotion'),
          ],
        ),
      ],
    );
  }
}

class _AiChip extends StatelessWidget {
  final String emoji;
  final String label;

  const _AiChip({required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: GlassCard(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
        borderOverride: PlexaversePalette.primary.withValues(alpha: 0.3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: TextStyle(fontSize: 13.sp)),
            SizedBox(width: 4.w),
            Text(
              label,
              style: GoogleFonts.urbanist(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: PlexaversePalette.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Step 2: Body ──────────────────────────────────────────────────────────────

class _BodyStep extends StatelessWidget {
  final TextEditingController controller;

  const _BodyStep({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlassCard(
          padding: EdgeInsets.all(14.r),
          child: SizedBox(
            height: 160.h,
            child: TextField(
              controller: controller,
              style: GoogleFonts.urbanist(
                fontSize: 14.sp,
                color: context.colors.onSurface,
                height: 1.55,
              ),
              decoration: InputDecoration(
                hintText: 'AI-generated draft appears here...',
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: context.colors.onSurface.withValues(alpha: 0.35),
                  height: 1.55,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
            ),
          ),
        ),

        SizedBox(height: 6.h),

        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '284 / 3,000',
            style: TextStyle(
              fontSize: 11.sp,
              color: context.colors.onSurface.withValues(alpha: 0.4),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Step 3: Visual ────────────────────────────────────────────────────────────

class _VisualStep extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelect;

  static const _options = [
    ('📷', 'Photo'),
    ('🎨', 'AI Art'),
    ('📊', 'Carousel'),
  ];

  const _VisualStep({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_options.length, (i) {
        final isSelected = i == selected;
        final option = _options[i];

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < _options.length - 1 ? 8.w : 0),
            child: GestureDetector(
              onTap: () => onSelect(i),
              child: GlassCard(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                borderOverride: isSelected
                    ? PlexaversePalette.primary
                    : context.colors.onSurface.withValues(alpha: 0.1),
                bgOverride: isSelected
                    ? PlexaversePalette.primary.withValues(alpha: 0.12)
                    : null,
                child: SizedBox(
                  height: 72.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(option.$1, style: TextStyle(fontSize: 22.sp)),
                      SizedBox(height: 4.h),
                      Text(
                        option.$2,
                        style: GoogleFonts.urbanist(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? PlexaversePalette.primary
                              : context.colors.onSurface
                                  .withValues(alpha: 0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ── Step 4: Publish ───────────────────────────────────────────────────────────

class _PublishStep extends StatelessWidget {
  const _PublishStep();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LinkedIn account row
        GlassCard(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              // Avatar circle
              Container(
                width: 36.r,
                height: 36.r,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      PlexaversePalette.primary,
                      PlexaversePalette.primaryDark
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    'A',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 10.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alex Chen',
                      style: GoogleFonts.urbanist(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: context.colors.onSurface,
                      ),
                    ),
                    Text(
                      '· Personal',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: context.colors.onSurface.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Connected badge
              const StatusBadge(
                label: 'Connected ✓',
                variant: StatusBadgeVariant.success,
              ),
            ],
          ),
        ),

        SizedBox(height: 12.h),

        // Schedule button
        GlassCard(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          borderOverride: PlexaversePalette.primary.withValues(alpha: 0.4),
          onTap: () {},
          child: Center(
            child: Text(
              'Schedule Post →',
              style: GoogleFonts.urbanist(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: PlexaversePalette.primary,
              ),
            ),
          ),
        ),

        SizedBox(height: 10.h),

        // Publish now button
        GradientCard(
          colors: const [
            PlexaversePalette.primary,
            PlexaversePalette.primaryDark
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          radius: 16,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          onTap: () {},
          shadows: [
            BoxShadow(
              color: PlexaversePalette.primary.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          child: Center(
            child: Text(
              'Publish Now',
              style: GoogleFonts.urbanist(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
