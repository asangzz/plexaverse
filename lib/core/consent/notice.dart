/// The privacy notice version this build displays.
///
/// **This must equal `NOTICE_VERSION` in the web repo's `lib/consent.ts`.**
///
/// Every sign-up echoes it back, and the server refuses one that does not
/// match with `NOTICE_VERSION_STALE`. That is deliberate and is the whole
/// point of sending it: a store binary showing last year's notice must not be
/// able to record consent against this year's, so a drift fails loudly at the
/// one moment it matters instead of quietly producing consent evidence for
/// words the user never read.
///
/// So when the notice changes, this constant and the server's move together,
/// and older installs are told to update rather than allowed to proceed.
/// `test/core/consent/notice_version_test.dart` reads the web's constant from
/// the monorepo and fails when the two differ.
///
/// 2026-10-31 (was 2026-10-22, which left every email sign-up from the app
/// refused for weeks): that notice added Meta (WhatsApp Cloud API) as a
/// recipient and `whatsapp_notifications` as a purpose. Both are asked in
/// context on the Settings connect card, never at sign-up, so this build's
/// sign-up text is still true of that notice, and the link it shows opens
/// the live web notice.
const String kNoticeVersion = '2026-10-31';
