import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../core/theme/plexaverse_colors.dart';
import '../../../../core/ui/widgets/glass_card.dart';
import '../posts_context_ext.dart';

/// The AI creator studio — a full-screen route (`RoutePaths.studio`) outside
/// the shell. Ported verbatim from the layer-first
/// `presentation/features/studio/pages/studio_page.dart`; this is a design-only
/// mock chat surface (actions are stubs) and its visuals are preserved.
class StudioPage extends StatefulWidget {
  const StudioPage({super.key});

  @override
  State<StudioPage> createState() => _StudioPageState();
}

class _StudioPageState extends State<StudioPage> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              size: 18.r, color: context.colors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'AI Studio',
              style: GoogleFonts.sora(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: context.colors.onSurface,
              ),
            ),
            SizedBox(width: 6.w),
            Icon(Icons.auto_awesome_rounded,
                color: PlexaversePalette.warning, size: 18.r),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.grid_view_rounded,
                color: context.colors.onSurface, size: 22.r),
            onPressed: () {},
            tooltip: 'Canvas',
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Column(
        children: [
          // ── Canvas preview ──────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _CanvasPreview(),
          ),

          SizedBox(height: 12.h),

          // ── Chat area ───────────────────────────────────────────────────────
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              children: [
                // AI greeting bubble
                const _AiBubble(
                  text:
                      'Hi! I\'m your AI designer. What would you like to create today? '
                      'I can help with LinkedIn carousel posts, infographics, '
                      'cover images, and more.',
                ),

                SizedBox(height: 8.h),

                // Quick-action chips
                _QuickActionChips(),

                SizedBox(height: 16.h),

                // User bubble
                const _UserBubble(
                  text: 'Create a 5-slide carousel about AI productivity tips',
                ),

                SizedBox(height: 16.h),

                // AI response
                const _AiBubble(
                  text: 'Great! Here are 3 layout options for your carousel:',
                ),

                SizedBox(height: 8.h),

                // Layout suggestion thumbnails
                _LayoutSuggestions(),

                SizedBox(height: 16.h),
              ],
            ),
          ),

          // ── Bottom input bar ────────────────────────────────────────────────
          _InputBar(controller: _ctrl),
        ],
      ),
    );
  }
}

// ── Canvas preview ────────────────────────────────────────────────────────────

class _CanvasPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: GlassCard(
        padding: EdgeInsets.all(12.r),
        borderOverride: PlexaversePalette.primary.withValues(alpha: 0.3),
        child: Stack(
          children: [
            // Dashed border overlay
            CustomPaint(
              painter: _DashedBorderPainter(),
              child: Container(),
            ),

            // Content: slide thumbnails
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const _SlideThumbnail(
                      colors: [
                        PlexaversePalette.primary,
                        PlexaversePalette.primaryDark
                      ],
                    ),
                    SizedBox(width: 8.w),
                    const _SlideThumbnail(
                      colors: [Color(0xFF03DAC6), Color(0xFF0095A8)],
                    ),
                    SizedBox(width: 8.w),
                    const _SlideThumbnail(
                      colors: [Color(0xFFFF6B6B), Color(0xFFEE5A24)],
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  'Preview Canvas',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: context.colors.onSurface.withValues(alpha: 0.4),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),

            // Expand icon
            Positioned(
              bottom: 4.h,
              right: 4.w,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: 28.r,
                  height: 28.r,
                  decoration: BoxDecoration(
                    color: PlexaversePalette.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.open_in_full_rounded,
                      color: PlexaversePalette.primary, size: 14.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlideThumbnail extends StatelessWidget {
  final List<Color> colors;

  const _SlideThumbnail({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      height: 60.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = PlexaversePalette.primary.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const dashWidth = 6.0;
    const dashSpace = 4.0;
    const radius = 16.0;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(radius),
        ),
      );

    final dashPath = _dashPath(path, dashWidth: dashWidth, dashSpace: dashSpace);
    canvas.drawPath(dashPath, paint);
  }

  Path _dashPath(Path source,
      {required double dashWidth, required double dashSpace}) {
    final dest = Path();
    for (final metric in source.computeMetrics()) {
      var distance = 0.0;
      var draw = true;
      while (distance < metric.length) {
        final len = draw ? dashWidth : dashSpace;
        if (draw) {
          dest.addPath(
            metric.extractPath(distance, distance + len),
            Offset.zero,
          );
        }
        distance += len;
        draw = !draw;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) => false;
}

// ── Chat bubbles ──────────────────────────────────────────────────────────────

class _AiBubble extends StatelessWidget {
  final String text;

  const _AiBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // AI avatar
        Container(
          width: 28.r,
          height: 28.r,
          margin: EdgeInsets.only(right: 8.w),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                PlexaversePalette.primary,
                PlexaversePalette.primaryDark
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(Icons.auto_awesome_rounded,
              color: Colors.white, size: 14.r),
        ),

        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: GlassCard(
              padding: EdgeInsets.all(12.r),
              child: Text(
                text,
                style: GoogleFonts.urbanist(
                  fontSize: 14.sp,
                  color: context.colors.onSurface.withValues(alpha: 0.85),
                  height: 1.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _UserBubble extends StatelessWidget {
  final String text;

  const _UserBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    PlexaversePalette.primary,
                    PlexaversePalette.primaryDark
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                  bottomLeft: Radius.circular(16.r),
                  bottomRight: Radius.circular(4.r),
                ),
              ),
              child: Text(
                text,
                style: GoogleFonts.urbanist(
                  fontSize: 14.sp,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Quick-action chips ────────────────────────────────────────────────────────

class _QuickActionChips extends StatelessWidget {
  static const _chips = [
    ('🎨', 'Carousel'),
    ('📊', 'Infographic'),
    ('🖼', 'Cover Image'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _chips.map((chip) {
        return Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: GestureDetector(
            onTap: () {},
            child: GlassCard(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              borderOverride: PlexaversePalette.primary.withValues(alpha: 0.35),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(chip.$1, style: TextStyle(fontSize: 14.sp)),
                  SizedBox(width: 4.w),
                  Text(
                    chip.$2,
                    style: GoogleFonts.urbanist(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: PlexaversePalette.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Layout suggestion thumbnails ──────────────────────────────────────────────

class _LayoutSuggestions extends StatelessWidget {
  static const _layouts = [
    ('Layout A', [PlexaversePalette.primary, PlexaversePalette.primaryDark]),
    ('Layout B', [PlexaversePalette.secondary, Color(0xFF0095A8)]),
    ('Layout C', [Color(0xFFFF8C00), Color(0xFFFF6B6B)]),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _layouts.map((layout) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: layout.$1 == 'Layout C' ? 0 : 8.w),
            child: GestureDetector(
              onTap: () {},
              child: Column(
                children: [
                  GlassCard(
                    child: Container(
                      height: 70.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: layout.$2,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    layout.$1,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: context.colors.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Bottom input bar ──────────────────────────────────────────────────────────

class _InputBar extends StatelessWidget {
  final TextEditingController controller;

  const _InputBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 12.h,
        bottom: 12.h + bottomPad,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: context.colors.onSurface.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GlassCard(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 2.h),
              child: TextField(
                controller: controller,
                style: GoogleFonts.urbanist(
                  fontSize: 14.sp,
                  color: context.colors.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'Describe what you want to create...',
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: context.colors.onSurface.withValues(alpha: 0.4),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
              ),
            ),
          ),

          SizedBox(width: 10.w),

          GestureDetector(
            onTap: () {},
            child: Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    PlexaversePalette.primary,
                    PlexaversePalette.primaryDark
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: PlexaversePalette.primary.withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.send_rounded, color: Colors.white, size: 20.r),
            ),
          ),
        ],
      ),
    );
  }
}
