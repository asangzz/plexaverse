import 'package:flutter/material.dart';

import '../../responsive/screen_util.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/plexaverse_colors.dart';
import '../app_icons.dart';
import '../widgets/app_button.dart';
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';
import '../widgets/glass_card.dart';
import '../widgets/loading_view.dart';
import '../widgets/network_error_view.dart';
import '../widgets/primary_action_button.dart';
import '../widgets/secondary_action_button.dart';
import '../widgets/skeleton_box.dart';
import '../widgets/status_badge.dart';

/// The living style guide — public route `/styleguide`. Renders every token
/// (colour swatches straight off [PlexaversePalette], the type scale, the
/// spacing/radius bars), the full [AppIcons] gallery, and one instance of
/// each shared widget. It doubles as the regression surface (every new token
/// / icon / component must appear here) and the canonical usage example.
///
/// Modelled on the ProHealth reference (`core/ui/pages/style_guide_page.dart`),
/// re-skinned to the Plexaverse brand layer. Rebuilt fresh rather than
/// line-ported from the legacy 1893-line guide, which read raw hexes off the
/// old `theme/app_colors.dart`.
class StyleguidePage extends StatelessWidget {
  const StyleguidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Style Guide')),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg.w,
          vertical: AppSpacing.md.h,
        ),
        children: const <Widget>[
          _BrandSwatches(),
          _StatusSwatches(),
          _TypeScale(),
          _SpacingScale(),
          _RadiusScale(),
          _IconGallery(),
          _ButtonsSection(),
          _CardsSection(),
          _BadgesSection(),
          _StateViewsSection(),
          SizedBox(height: AppSpacing.xxxl),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.xl.h, bottom: AppSpacing.sm.h),
      child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch(this.name, this.color);

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 64.r,
          height: 48.r,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppRadius.md.r),
            border: Border.all(color: scheme.outlineVariant),
          ),
        ),
        SizedBox(height: AppSpacing.xs.h),
        SizedBox(
          width: 64.r,
          child: Text(name, style: Theme.of(context).textTheme.labelSmall),
        ),
      ],
    );
  }
}

class _BrandSwatches extends StatelessWidget {
  const _BrandSwatches();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _SectionHeader('Brand'),
        Wrap(
          spacing: AppSpacing.md.w,
          runSpacing: AppSpacing.md.h,
          children: const <Widget>[
            _Swatch('primary', PlexaversePalette.primary),
            _Swatch('primaryDark', PlexaversePalette.primaryDark),
            _Swatch('secondary', PlexaversePalette.secondary),
            _Swatch('surfaceDark', PlexaversePalette.surfaceDark),
            _Swatch('backgroundDark', PlexaversePalette.backgroundDark),
          ],
        ),
      ],
    );
  }
}

class _StatusSwatches extends StatelessWidget {
  const _StatusSwatches();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _SectionHeader('Status'),
        Wrap(
          spacing: AppSpacing.md.w,
          runSpacing: AppSpacing.md.h,
          children: const <Widget>[
            _Swatch('success', PlexaversePalette.success),
            _Swatch('warning', PlexaversePalette.warning),
            _Swatch('error', PlexaversePalette.error),
            _Swatch('info', PlexaversePalette.info),
          ],
        ),
      ],
    );
  }
}

class _TypeScale extends StatelessWidget {
  const _TypeScale();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _SectionHeader('Type (Sora / Urbanist)'),
        Text('Display L', style: t.displayLarge),
        Text('Headline L', style: t.headlineLarge),
        Text('Headline M', style: t.headlineMedium),
        Text('Title L', style: t.titleLarge),
        Text('Title M', style: t.titleMedium),
        Text('Body L — the quick brown fox', style: t.bodyLarge),
        Text('Body M — the quick brown fox', style: t.bodyMedium),
        Text('LABEL LARGE', style: t.labelLarge),
      ],
    );
  }
}

class _SpacingScale extends StatelessWidget {
  const _SpacingScale();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    const values = <(String, double)>[
      ('xs', AppSpacing.xs),
      ('sm', AppSpacing.sm),
      ('md', AppSpacing.md),
      ('lg', AppSpacing.lg),
      ('xl', AppSpacing.xl),
      ('xxl', AppSpacing.xxl),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _SectionHeader('Spacing'),
        for (final (name, value) in values)
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xs.h),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 48.w,
                  child: Text(
                    name,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
                Container(width: value.w, height: 12.h, color: scheme.primary),
              ],
            ),
          ),
      ],
    );
  }
}

class _RadiusScale extends StatelessWidget {
  const _RadiusScale();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    const values = <(String, double)>[
      ('sm', AppRadius.sm),
      ('md', AppRadius.md),
      ('lg', AppRadius.lg),
      ('xl', AppRadius.xl),
      ('xxl', AppRadius.xxl),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _SectionHeader('Radius'),
        Wrap(
          spacing: AppSpacing.md.w,
          runSpacing: AppSpacing.md.h,
          children: <Widget>[
            for (final (name, value) in values)
              Column(
                children: <Widget>[
                  Container(
                    width: 56.r,
                    height: 56.r,
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      borderRadius: BorderRadius.circular(value.r),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                  Text(name, style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

class _IconGallery extends StatelessWidget {
  const _IconGallery();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _SectionHeader('Icons (Font Awesome solid)'),
        Wrap(
          spacing: AppSpacing.lg.w,
          runSpacing: AppSpacing.lg.h,
          children: <Widget>[
            for (final entry in AppIcons.all.entries)
              SizedBox(
                width: 64.r,
                child: Column(
                  children: <Widget>[
                    Icon(entry.value, size: 22.r, color: scheme.onSurface),
                    SizedBox(height: AppSpacing.xs.h),
                    Text(
                      entry.key,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _ButtonsSection extends StatelessWidget {
  const _ButtonsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _SectionHeader('Buttons'),
        PrimaryActionButton(label: 'Primary action', onPressed: () {}),
        SizedBox(height: AppSpacing.sm.h),
        SecondaryActionButton(
          label: 'Secondary',
          leadingIcon: AppIcons.share,
          onPressed: () {},
        ),
        SizedBox(height: AppSpacing.sm.h),
        Wrap(
          spacing: AppSpacing.sm.w,
          runSpacing: AppSpacing.sm.h,
          children: <Widget>[
            AppButton(label: 'Filled', onPressed: () {}),
            AppButton(
              label: 'Tonal',
              variant: AppButtonVariant.secondary,
              onPressed: () {},
            ),
            AppButton(
              label: 'Outline',
              variant: AppButtonVariant.outline,
              onPressed: () {},
            ),
            AppButton(
              label: 'Text',
              variant: AppButtonVariant.text,
              onPressed: () {},
            ),
            const AppButton(label: 'Loading', isLoading: true),
          ],
        ),
      ],
    );
  }
}

class _CardsSection extends StatelessWidget {
  const _CardsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _SectionHeader('Cards'),
        GlassCard(
          padding: EdgeInsets.all(AppSpacing.lg.w),
          child: Text(
            'GlassCard — glassmorphic surface',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        SizedBox(height: AppSpacing.md.h),
        Builder(
          builder: (context) => GradientCard(
            colors: <Color>[
              context.brand.fabGradientStart,
              context.brand.fabGradientEnd,
            ],
            padding: EdgeInsets.all(AppSpacing.lg.w),
            child: const Text(
              'GradientCard — brand hero',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: AppSpacing.md.h),
        SkeletonBox(height: 48, radius: AppRadius.md),
      ],
    );
  }
}

class _BadgesSection extends StatelessWidget {
  const _BadgesSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _SectionHeader('Status badges'),
        Wrap(
          spacing: AppSpacing.sm.w,
          runSpacing: AppSpacing.sm.h,
          children: const <Widget>[
            StatusBadge(
              label: 'Info',
              icon: AppIcons.info,
              variant: StatusBadgeVariant.info,
            ),
            StatusBadge(
              label: 'Success',
              icon: AppIcons.checkCircle,
              variant: StatusBadgeVariant.success,
            ),
            StatusBadge(
              label: 'Warning',
              icon: AppIcons.warning,
              variant: StatusBadgeVariant.warning,
            ),
            StatusBadge(label: 'Neutral'),
            StatusBadge(label: 'Solid', variant: StatusBadgeVariant.solid),
          ],
        ),
      ],
    );
  }
}

class _StateViewsSection extends StatelessWidget {
  const _StateViewsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _SectionHeader('State views'),
        SizedBox(height: 120.h, child: const LoadingView()),
        SizedBox(
          height: 200.h,
          child: EmptyView(
            title: 'Nothing here yet',
            subtitle: 'Content you add will appear here.',
            actionLabel: 'Create',
            onAction: () {},
          ),
        ),
        SizedBox(
          height: 200.h,
          child: ErrorView(message: 'Something went wrong.', onRetry: () {}),
        ),
        SizedBox(
          height: 240.h,
          child: NetworkErrorView(onRetry: () {}),
        ),
      ],
    );
  }
}
