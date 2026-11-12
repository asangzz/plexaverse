import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/company/application/company_controllers.dart';
import 'package:plexaverse/features/company/data/company_repositories.dart';
import 'package:plexaverse/features/company/domain/company_post.dart';
import 'package:plexaverse/features/company/domain/company_repository.dart';

/// Featuring a post for advocacy is per user since web 857b2b3: only the
/// caller's own page's posts, and not one a second Plexaverse account already
/// features for that page. A refusal used to flick the star back with no
/// word, which reads as a flaky tap; now the server's sentence comes back.
class _Refusing extends FakeCompanyRepository {
  _Refusing(this.refusal);

  final Object? refusal;

  @override
  Future<bool> setAdvocacy({
    required String postId,
    required bool isAdvocated,
    int? expiryDays,
  }) async {
    final Object? r = refusal;
    if (r != null) throw r;
    return isAdvocated;
  }
}

void main() {
  Future<(ProviderContainer, String)> open(Object? refusal) async {
    final ProviderContainer c = ProviderContainer(
      overrides: <Override>[
        companyRepositoryProvider.overrideWithValue(_Refusing(refusal)),
      ],
    );
    addTearDown(c.dispose);
    c.listen(companyPostsControllerProvider, (_, _) {});
    final List<CompanyPostItem> posts = await c.read(
      companyPostsControllerProvider.future,
    );
    return (c, posts.first.id);
  }

  test('a stored flag is a success: no message', () async {
    final (ProviderContainer c, String id) = await open(null);
    final String? said = await c
        .read(companyPostsControllerProvider.notifier)
        .setAdvocacy(id, true);
    expect(said, isNull);
  });

  test(
    '409: another account features this page — its words are shown',
    () async {
      const String conflict =
          'Another Plexaverse account already features posts for this page, so '
          'only that account can feature this one.';
      final (ProviderContainer c, String id) = await open(
        const CompanyUnavailable(CompanyPrecondition.upstreamRefused, conflict),
      );
      final String? said = await c
          .read(companyPostsControllerProvider.notifier)
          .setAdvocacy(id, true);
      expect(said, conflict);
    },
  );

  test('404: not this user\'s post — its words are shown', () async {
    const String notFound =
        'Post not found. You can feature only recent posts from your own '
        'company page.';
    final (ProviderContainer c, String id) = await open(
      const CompanyUnavailable(CompanyPrecondition.upstreamRefused, notFound),
    );
    final String? said = await c
        .read(companyPostsControllerProvider.notifier)
        .setAdvocacy(id, true);
    expect(said, notFound);
  });

  test('anything else still says something', () async {
    final (ProviderContainer c, String id) = await open(StateError('boom'));
    final String? said = await c
        .read(companyPostsControllerProvider.notifier)
        .setAdvocacy(id, false);
    expect(said, "Couldn't change that. Try again.");
  });
}
