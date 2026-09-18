import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_feature.dart';
import 'tenant_controller.dart';

/// Wrap any feature-specific button, section, or list item:
///
/// ```dart
/// FeatureGate(
///   feature: AppFeature.odyssey,
///   child: OdysseyTab(),
/// )
/// ```
///
/// The single UI feature-gate checkpoint (RULINGS §11). Reads the one
/// `isFeatureEnabledProvider` answer so gating stays consistent everywhere.
class FeatureGate extends ConsumerWidget {
  const FeatureGate({
    required this.feature,
    required this.child,
    this.fallback,
    super.key,
  });

  final AppFeature feature;
  final Widget child;

  /// Rendered when the feature is off for the current tenant.
  /// Defaults to an empty [SizedBox].
  final Widget? fallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(isFeatureEnabledProvider(feature));
    if (enabled) return child;
    return fallback ?? const SizedBox.shrink();
  }
}
