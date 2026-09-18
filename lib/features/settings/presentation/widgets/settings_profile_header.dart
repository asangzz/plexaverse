import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/screen_util.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../application/settings_profile_controller.dart';
import '../../domain/settings_profile.dart';

/// The profile header at the top of the Settings screen: avatar + display name
/// + handle. Display-only in v1 (no edit action wired) — the data comes from
/// the local `assets/mock/settings/profile.json` fixture via
/// `settingsProfileControllerProvider`.
///
/// The three async states are kept compact so a header failure never blocks the
/// local-only theme/locale controls below it: loading → a shimmerless
/// placeholder row, error → a one-line retry, data → the real header.
class SettingsProfileHeader extends ConsumerWidget {
  const SettingsProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(settingsProfileControllerProvider);
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: profile.when(
        loading: () => const _HeaderPlaceholder(),
        error: (_, _) => _HeaderError(
          onRetry: () =>
              ref.invalidate(settingsProfileControllerProvider),
        ),
        data: (p) => _HeaderContent(profile: p),
      ),
    );
  }
}

class _HeaderContent extends StatelessWidget {
  const _HeaderContent({required this.profile});

  final SettingsProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        _Avatar(profile: profile),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                profile.displayName,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.h),
              Text(
                profile.handleDisplay,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (profile.memberSince != null) ...[
                SizedBox(height: 2.h),
                Text(
                  // TODO(l10n): add a `memberSince` ARB key with a date arg;
                  // hardcoded EN prefix + ISO date for now.
                  'Member since ${_formatDate(profile.memberSince!)}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  static String _formatDate(DateTime date) {
    const months = <String>[
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.profile});

  final SettingsProfile profile;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = 28.r;
    final url = profile.avatarUrl;
    return CircleAvatar(
      radius: radius,
      backgroundColor: scheme.primaryContainer,
      backgroundImage:
          (url != null && url.isNotEmpty) ? NetworkImage(url) : null,
      child: (url == null || url.isEmpty)
          ? Text(
              profile.initials,
              style: TextStyle(
                color: scheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
                fontSize: 18.sp,
              ),
            )
          : null,
    );
  }
}

class _HeaderPlaceholder extends StatelessWidget {
  const _HeaderPlaceholder();

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08);
    return Row(
      children: [
        CircleAvatar(radius: 28.r, backgroundColor: base),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 14.h, width: 140.w, color: base),
              SizedBox(height: 8.h),
              Container(height: 10.h, width: 90.w, color: base),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderError extends StatelessWidget {
  const _HeaderError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(Icons.person_off_outlined,
            size: 28.r, color: theme.colorScheme.onSurfaceVariant),
        SizedBox(width: 16.w),
        Expanded(
          child: Text(
            l.profileTitle,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
        TextButton(onPressed: onRetry, child: Text(l.retry)),
      ],
    );
  }
}
