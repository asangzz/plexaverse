import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/mission_models.dart';

/// Renders a Studio banner design at whatever size it is given.
///
/// ## Why this draws raw colours and a raw TextStyle
///
/// Everything else in this app is built from Zave tokens, and must be. This
/// widget is the exception, and the reason is that it is not drawing APP
/// CHROME — it is drawing the user's artwork. The fills, sizes and weights are
/// DATA that came from the Studio design, and forcing them onto the Zave scale
/// would render a banner that does not match the one LinkedIn ends up showing.
/// The card AROUND this preview is ordinary Zave glass.
///
/// ## The maths is the web's
///
/// The web positions each element as a percentage of its parent
/// (`left: x / parentWidth * 100%`) and sizes text in `cqh` against the CANVAS
/// height. Reproduced exactly: positions scale to the parent box, font sizes
/// scale to the rendered canvas height. Children are relative to their parent's
/// origin, so recursion passes the parent's own box down rather than the root.
///
/// ## What is not ported
///
/// Rotation, stroke, text shadows, per-range styling and `styleRanges`. The
/// web's own preview renderer ignores all of them too; it is a preview, and the
/// Studio canvas is where a design is edited.
class BannerPreview extends StatelessWidget {
  const BannerPreview({required this.design, super.key});

  final BannerDesign design;

  @override
  Widget build(BuildContext context) {
    final BannerCanvas canvas = design.frame;

    return AspectRatio(
      aspectRatio: canvas.aspectRatio,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double boxWidth = constraints.maxWidth;
          final double boxHeight = constraints.maxHeight;

          return ClipRRect(
            borderRadius: ZaveRadius.cardSmBr,
            child: ColoredBox(
              color: parseCssColor(canvas.background) ?? kBannerFallbackGround,
              child: Stack(
                children: <Widget>[
                  for (final BannerElement element in design.elements)
                    _ElementBox(
                      element: element,
                      parentWidth: canvas.width,
                      parentHeight: canvas.height,
                      boxWidth: boxWidth,
                      boxHeight: boxHeight,
                      // Text scales against the CANVAS, at every depth — that
                      // is what `cqh` means on the web.
                      fontScale: canvas.height <= 0
                          ? 1
                          : boxHeight / canvas.height,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// One element, positioned inside its parent's box.
class _ElementBox extends StatelessWidget {
  const _ElementBox({
    required this.element,
    required this.parentWidth,
    required this.parentHeight,
    required this.boxWidth,
    required this.boxHeight,
    required this.fontScale,
  });

  final BannerElement element;

  /// The element's coordinate space — its parent's width/height in DESIGN
  /// units, not rendered pixels.
  final double parentWidth;
  final double parentHeight;

  /// The parent's RENDERED size.
  final double boxWidth;
  final double boxHeight;

  /// Rendered canvas height ÷ design canvas height. Applies to font sizes at
  /// every nesting depth.
  final double fontScale;

  @override
  Widget build(BuildContext context) {
    if (!element.visible) return const SizedBox.shrink();

    final double sx = parentWidth <= 0 ? 0 : boxWidth / parentWidth;
    final double sy = parentHeight <= 0 ? 0 : boxHeight / parentHeight;

    final double width = element.width * sx;
    final double height = element.height * sy;
    final Color? fill = parseCssColor(element.fill);
    final double radius = (element.borderRadius ?? 0) * sy;

    final bool ellipse = element.type == 'ellipse';

    // A BoxDecoration may carry a borderRadius OR a circular shape, never
    // both — pairing them trips an assertion at paint time.
    final BorderRadius? corner = ellipse || radius <= 0
        ? null
        : BorderRadius.circular(radius);

    final Widget contents = Stack(
      fit: StackFit.expand,
      children: <Widget>[
        if (element.isImage && element.imageUrl != null)
          CachedNetworkImage(
            imageUrl: element.imageUrl!,
            fit: BoxFit.cover,
            // A broken asset must not take the whole preview down;
            // the box simply stays empty, as it does on the web.
            errorWidget: (BuildContext _, String _, Object _) =>
                const SizedBox.shrink(),
          ),
        if (element.isText && (element.text ?? '').isNotEmpty)
          _ElementText(element: element, fontScale: fontScale),
        for (final BannerElement child in element.children)
          _ElementBox(
            element: child,
            parentWidth: element.width,
            parentHeight: element.height,
            boxWidth: width,
            boxHeight: height,
            fontScale: fontScale,
          ),
      ],
    );

    return Positioned(
      left: element.x * sx,
      top: element.y * sy,
      width: width,
      height: height,
      child: Opacity(
        opacity: element.opacity.clamp(0, 1).toDouble(),
        child: DecoratedBox(
          decoration: BoxDecoration(
            // Text and image elements never paint their `fill` as a
            // background — on the web `fill` is the TEXT colour for a text
            // element, and an image covers its own box.
            color: (element.isText || element.isImage) ? null : fill,
            borderRadius: corner,
            shape: ellipse ? BoxShape.circle : BoxShape.rectangle,
          ),
          child: ellipse
              ? ClipOval(child: contents)
              : ClipRRect(
                  borderRadius: corner ?? BorderRadius.zero,
                  child: contents,
                ),
        ),
      ),
    );
  }
}

/// A text element's own type.
///
/// Urbanist, always. The web defaults to `'Urbanist, sans-serif'` and the
/// Studio's other families are CSS names that a Flutter build cannot resolve at
/// runtime without shipping the font — asking `google_fonts` for an arbitrary
/// family string throws. Urbanist is also the app's own reading face, so a
/// template that names nothing renders identically on both platforms.
class _ElementText extends StatelessWidget {
  const _ElementText({required this.element, required this.fontScale});

  final BannerElement element;
  final double fontScale;

  @override
  Widget build(BuildContext context) {
    final double size = (element.fontSize ?? 24) * fontScale;
    final TextAlign align = switch (element.textAlign) {
      'center' => TextAlign.center,
      'right' => TextAlign.right,
      _ => TextAlign.left,
    };

    return Align(
      alignment: switch (align) {
        TextAlign.center => Alignment.center,
        TextAlign.right => Alignment.centerRight,
        _ => Alignment.centerLeft,
      },
      child: Text(
        element.text ?? '',
        textAlign: align,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.urbanist(
          fontSize: size <= 0 ? 1 : size,
          fontWeight: _weight(element.fontWeight),
          height: 1.1,
          color: parseCssColor(element.fill) ?? ZaveColors.white,
        ),
      ),
    );
  }

  /// CSS numeric weights → Flutter's nine steps. A missing weight lands on
  /// 600, the web's own default for a Studio text element.
  static FontWeight _weight(int? css) {
    final int weight = css ?? 600;
    if (weight <= 100) return FontWeight.w100;
    if (weight <= 200) return FontWeight.w200;
    if (weight <= 300) return FontWeight.w300;
    if (weight <= 400) return FontWeight.w400;
    if (weight <= 500) return FontWeight.w500;
    if (weight <= 600) return FontWeight.w600;
    if (weight <= 700) return FontWeight.w700;
    if (weight <= 800) return FontWeight.w800;
    return FontWeight.w900;
  }
}
