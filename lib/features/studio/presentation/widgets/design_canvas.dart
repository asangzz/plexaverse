import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';
import '../../domain/studio_design.dart';
import 'css_value.dart';

/// Draws a Studio design, read-only.
///
/// ## Why this is straightforward, and why it is not a canvas editor
///
/// The web Studio's live canvas is **not** Fabric.js — `useFabricCanvas` is
/// initialised to false and nothing ever sets it. What actually renders is a
/// recursive function emitting absolutely-positioned `<div>`s inside one
/// scaled wrapper. That is a declarative tree, so it ports to `Stack` +
/// `Positioned` almost line for line, which is why a faithful VIEWER is cheap
/// on a phone even though the EDITOR is not.
///
/// The mapping, element by element:
///
/// | Web | Here |
/// |---|---|
/// | wrapper `transform: scale()` | [FittedBox] over a design-unit [SizedBox] |
/// | `position:absolute; left/top/width/height` | [Positioned] |
/// | `transform: rotate(Ndeg)` (centre origin) | [Transform.rotate] |
/// | rectangle div with `backgroundColor`/`border`/`borderRadius` | [DecoratedBox] |
/// | ellipse div with `rounded-full` | an elliptical [BorderRadius] |
/// | line div `height: strokeWidth`, `marginTop:(h-sw)/2` | a centred bar |
/// | image `object-cover` | [BoxFit.cover] |
/// | frame / group children | a nested [Stack] — child x/y are RELATIVE |
///
/// Sizes are design units (a 1080×1350 poster), not logical pixels; the whole
/// tree is scaled once to fit. Text therefore scales proportionally for free,
/// which is the bug the web's TemplateCustomizer has and this deliberately
/// does not reproduce (it sizes text in `vh`, so a phone mis-scales it).
///
/// Zave note: the surface INSIDE this box is the user's artwork and uses the
/// user's colours. The frame around it is Zave's — [ZaveGlass.rest] fill,
/// [ZaveColors.rule] hairline — so a design never looks like app chrome.
class DesignCanvas extends StatelessWidget {
  const DesignCanvas({required this.data, this.highlightId, super.key});

  final StudioDesignData data;

  /// Draws a hairline around one element, so tapping a layer in the editor
  /// below shows you which one it is. White at the rule opacity, not a brand
  /// ring — the web's violet selection ring is Tailwind leakage, not a token.
  final String? highlightId;

  @override
  Widget build(BuildContext context) {
    final StudioCanvas canvas = data.canvas;

    return ClipRRect(
      borderRadius: ZaveRadius.cardSmBr,
      child: AspectRatio(
        aspectRatio: canvas.aspectRatio,
        child: ColoredBox(
          color: cssColor(canvas.background, fallback: ZaveColors.midnight),
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: canvas.width,
              height: canvas.height,
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  for (final StudioElement element in data.elements)
                    if (element.visible)
                      _ElementBox(element: element, highlightId: highlightId),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// One node, positioned in its parent's coordinate space.
class _ElementBox extends StatelessWidget {
  const _ElementBox({required this.element, required this.highlightId});

  final StudioElement element;
  final String? highlightId;

  @override
  Widget build(BuildContext context) {
    final bool highlighted = highlightId != null && highlightId == element.id;

    Widget body = _ElementBody(element: element);

    if (element.isContainer && element.children.isNotEmpty) {
      final Widget children = Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          for (final StudioElement child in _laidOut(element))
            if (child.visible)
              _ElementBox(element: child, highlightId: highlightId),
        ],
      );
      body = Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: <Widget>[
          body,
          // A frame clips unless it says otherwise; a group never clips.
          if (element.type == 'frame' && element.clipContent)
            ClipRect(child: children)
          else
            children,
        ],
      );
    }

    if (highlighted) {
      body = DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: ZaveColors.white, width: 2),
        ),
        child: body,
      );
    }

    if (element.opacity < 1) {
      body = Opacity(opacity: element.opacity.clamp(0.0, 1.0), child: body);
    }
    if (element.rotation != 0) {
      body = Transform.rotate(
        angle: element.rotation * math.pi / 180,
        child: body,
      );
    }

    return Positioned(
      left: element.x,
      top: element.y,
      width: element.width,
      height: element.height,
      child: body,
    );
  }

  /// Applies a frame's auto-layout, exactly as the web does: children are
  /// stacked along [StudioElement.layoutMode] from the frame's padding, each
  /// offset by the previous children's extents plus the gap.
  ///
  /// Returns the children untouched when there is no auto-layout, which is the
  /// common case — a Figma import carries absolute positions.
  static List<StudioElement> _laidOut(StudioElement frame) {
    final String? mode = frame.layoutMode;
    if (frame.type != 'frame' || mode == null || mode == 'none') {
      return frame.children;
    }
    final double padding = frame.layoutPadding ?? 0;
    final double gap = frame.layoutGap ?? 0;
    final bool horizontal = mode == 'horizontal';

    double offset = padding;
    final List<StudioElement> out = <StudioElement>[];
    for (final StudioElement child in frame.children) {
      out.add(
        child.copyWith(
          x: horizontal ? offset : padding,
          y: horizontal ? padding : offset,
        ),
      );
      offset += (horizontal ? child.width : child.height) + gap;
    }
    return out;
  }
}

/// The node's own paint, without its children.
class _ElementBody extends StatelessWidget {
  const _ElementBody({required this.element});

  final StudioElement element;

  @override
  Widget build(BuildContext context) => switch (element.type) {
    'text' => _text(),
    'image' => _image(),
    'line' => _line(),
    'ellipse' => _shape(elliptical: true),
    'frame' => _shape(dashedStroke: true),
    'group' => const SizedBox.shrink(),
    _ => _shape(),
  };

  /// Rectangle, ellipse and frame are one recipe with different corners.
  ///
  /// A frame's border is dashed on the web. Flutter has no dashed [Border] and
  /// a custom painter for a decoration the user never sees in the exported
  /// artwork would be effort spent on the editor's scaffolding rather than on
  /// their design — so it renders solid, and only when the frame actually has
  /// a stroke.
  Widget _shape({bool elliptical = false, bool dashedStroke = false}) {
    final Color stroke = cssColor(element.stroke);
    final double radius = element.borderRadius ?? 0;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: cssColor(element.fill),
        border: (element.strokeWidth > 0 && stroke.a > 0)
            ? Border.all(color: stroke, width: element.strokeWidth)
            : null,
        borderRadius: elliptical
            ? BorderRadius.all(
                Radius.elliptical(element.width / 2, element.height / 2),
              )
            : (radius > 0 ? BorderRadius.circular(radius) : null),
      ),
    );
  }

  /// A line is a full-width bar of `strokeWidth`, vertically centred in the
  /// element's box — the same geometry the web builds with a top margin.
  Widget _line() {
    final double thickness = element.strokeWidth > 0 ? element.strokeWidth : 2;
    final Color stroke = cssColor(element.stroke);
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: thickness,
        width: double.infinity,
        child: ColoredBox(
          color: stroke.a > 0 ? stroke : cssColor(element.fill),
        ),
      ),
    );
  }

  Widget _text() {
    final String raw = cssTextTransform(
      element.textValue,
      element.textTransform,
    );
    final double size = element.fontSize ?? 16;

    return Align(
      alignment: cssTextAlignment(element.textAlign),
      child: Text(
        raw,
        textAlign: cssTextAlign(element.textAlign),
        style: TextStyle(
          // The design names a web font family we may not have. Passing the
          // name through lets the platform match it when it can and fall back
          // silently when it cannot, which is better than forcing one face on
          // every design.
          fontFamily: element.fontFamily,
          fontSize: size,
          fontWeight: cssFontWeight(element.fontWeight),
          fontStyle: element.fontStyle == 'italic'
              ? FontStyle.italic
              : FontStyle.normal,
          // For a text node `fill` is the TEXT colour, not a background.
          color: cssColor(element.fill, fallback: ZaveColors.white),
          letterSpacing: element.letterSpacing,
          // The web stores lineHeight in PIXELS; Flutter's `height` is a
          // multiple of the font size.
          height: (element.lineHeight != null && size > 0)
              ? element.lineHeight! / size
              : null,
          decoration: TextDecoration.combine(<TextDecoration>[
            if (element.underline) TextDecoration.underline,
            if (element.linethrough) TextDecoration.lineThrough,
          ]),
          decorationColor: cssColor(element.fill, fallback: ZaveColors.white),
        ),
      ),
    );
  }

  Widget _image() {
    final ImageProvider<Object>? provider = studioImageProvider(
      element.imageUrl,
    );
    final double radius = element.maskBorderRadius ?? element.borderRadius ?? 0;

    if (provider == null) {
      // An image layer with nothing in it. The user can fill it from the
      // editor below, so this reads as a slot rather than as a failure.
      return DecoratedBox(
        decoration: BoxDecoration(
          color: ZaveGlass.rest,
          border: Border.all(color: ZaveColors.rule, width: 1),
          borderRadius: BorderRadius.circular(radius),
        ),
      );
    }

    final Widget image = Image(
      image: provider,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, _, _) => const ColoredBox(color: ZaveGlass.rest),
    );

    if (element.maskShape == 'ellipse') return ClipOval(child: image);
    if (radius > 0) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: image,
      );
    }
    return image;
  }
}
