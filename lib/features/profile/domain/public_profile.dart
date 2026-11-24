import 'dart:typed_data';

/// The public profile's wire shapes and seam — the bodies of the web's
/// `GET/PUT /api/mobile/v1/profile`, `/profile/follow`, `/profile/cv` and
/// `/profile/<handle>` (owner, 24 Nov 2026).
///
/// Plain classes rather than freezed: four small read-only shapes, parsed by
/// hand so a field the server leaves out reads as its safe default.

/// `GET /profile` → the caller's handle and the `public_profile` consent.
class PublicProfileSettings {
  const PublicProfileSettings({
    this.handle,
    this.published = false,
    this.url,
    this.suggestedHandle,
    this.adultDeclared = false,
    this.cvReady = false,
  });

  factory PublicProfileSettings.fromJson(Map<String, dynamic> json) =>
      PublicProfileSettings(
        handle: _string(json['handle']),
        published: json['published'] == true,
        url: _string(json['url']),
        suggestedHandle: _string(json['suggestedHandle']),
        adultDeclared: json['adultDeclared'] == true,
        cvReady: json['cvReady'] == true,
      );

  /// The handle on record — only ever set while the profile is published.
  final String? handle;

  /// The consent is current AND a handle is on record. The box is drawn from
  /// this, so it is never pre-ticked.
  final bool published;

  /// The page's address, when published.
  final String? url;

  /// A free handle made from the user's name, offered while none is on
  /// record. Never published without the user's tick.
  final String? suggestedHandle;

  /// False: the section asks for the 18+ tick before publishing.
  final bool adultDeclared;

  /// Whether a CV can be made from what is on record.
  final bool cvReady;
}

/// `GET /profile?handle=` → `availability`: one handle, checked by the server.
class HandleAvailability {
  const HandleAvailability({
    required this.handle,
    required this.available,
    this.message,
  });

  factory HandleAvailability.fromJson(Map<String, dynamic> json) =>
      HandleAvailability(
        handle: _string(json['handle']) ?? '',
        available: json['available'] == true,
        message: _string(json['message']),
      );

  /// The normalised handle that was checked.
  final String handle;
  final bool available;

  /// Why not, in the server's words (reserved, taken, the shape). Null when
  /// available.
  final String? message;
}

/// `POST/DELETE /profile/follow` → the caller's follow, and the count.
class FollowState {
  const FollowState({required this.following, this.followers = 0});

  factory FollowState.fromJson(Map<String, dynamic> json) => FollowState(
    following: json['following'] == true,
    followers: (json['followers'] as num?)?.toInt() ?? 0,
  );

  final bool following;

  /// A count. Who follows is never sent.
  final int followers;
}

/// The caller's CV, as the share sheet takes it.
class CvFile {
  const CvFile({required this.bytes, required this.fileName});

  final Uint8List bytes;

  /// `<Name>-CV.pdf`, from the server's `Content-Disposition`.
  final String fileName;
}

/// A refused write, with the server's sentence.
sealed class ProfileFailure implements Exception {
  const ProfileFailure(this.message);
  final String message;

  @override
  String toString() => message;
}

/// HANDLE_INVALID / HANDLE_REQUIRED / VALIDATION_FAILED — said beside the
/// field.
final class ProfileHandleRefused extends ProfileFailure {
  const ProfileHandleRefused([super.message = 'Choose another handle.']);
}

/// HANDLE_TAKEN: someone else holds it (or won the race for it).
final class ProfileHandleTaken extends ProfileFailure {
  const ProfileHandleTaken([
    super.message = 'That handle is taken. Try another.',
  ]);
}

/// ADULT_REQUIRED: tick "I am 18 or older" and send it again.
final class ProfileAdultRequired extends ProfileFailure {
  const ProfileAdultRequired([
    super.message = 'Confirm that you are 18 or older to publish your page.',
  ]);
}

/// NOT_FOUND: no PUBLIC profile has that handle (unpublished, erased, none).
final class ProfileNotFound extends ProfileFailure {
  const ProfileNotFound([super.message = 'That profile is not public.']);
}

/// SELF_FOLLOW: it is the caller's own profile.
final class ProfileSelfFollow extends ProfileFailure {
  const ProfileSelfFollow([super.message = 'That is your own profile.']);
}

/// CV_EMPTY: nothing to put in a CV yet.
final class ProfileCvEmpty extends ProfileFailure {
  const ProfileCvEmpty(super.message);
}

/// Anything else: the network, the server.
final class ProfileUnavailable extends ProfileFailure {
  const ProfileUnavailable([
    super.message = 'That did not come through. Try again.',
  ]);
}

/// Seam between the public profile's screens and the backend. Each method is
/// one mobile route, the twin of the web's of the same name.
abstract class ProfileRepository {
  /// `GET /profile` — the handle and the consent.
  Future<PublicProfileSettings> fetchSettings();

  /// `GET /profile?handle=` — is [handle] free for this user? Their own
  /// handle is.
  Future<HandleAvailability> checkHandle(String handle);

  /// `PUT /profile` `{published: true, handle, adult?}` — publish at
  /// [handle]: the `public_profile` consent, recorded `in_context`. Only on
  /// the person's own tick. [ProfileHandleRefused], [ProfileHandleTaken],
  /// [ProfileAdultRequired].
  Future<PublicProfileSettings> publish({
    required String handle,
    bool adult = false,
  });

  /// `PUT /profile` `{published: false}` — the whole withdrawal: the page
  /// goes offline, the handle is freed and its follows deleted. Never fails
  /// on a handle.
  Future<PublicProfileSettings> unpublish();

  /// `POST /profile/follow` `{handle}` — idempotent. [ProfileNotFound],
  /// [ProfileSelfFollow].
  Future<FollowState> follow(String handle);

  /// `DELETE /profile/follow?handle=` — idempotent.
  Future<FollowState> unfollow(String handle);

  /// `GET /profile/cv` — the caller's own ATS CV as a PDF. Made on request,
  /// never stored. [ProfileCvEmpty] when there is nothing to put in it.
  Future<CvFile> downloadCv();
}

String? _string(Object? v) => v is String && v.trim().isNotEmpty ? v : null;
