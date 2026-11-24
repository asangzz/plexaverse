/// The shoutout's words — the web's `lib/contest-shoutout-copy.ts`,
/// verbatim.
///
/// A consent is only as good as the words it was given to, and the web's
/// card, its Settings consent list (`PURPOSE_LABELS.contest_shoutout`) and its
/// rules page all say these. The app's card says them too, character for
/// character, so a learner agrees to the same thing on either platform.
library;

/// What the learner agrees to. The web's `PURPOSE_LABELS.contest_shoutout`.
///
/// "with my place if I win": the Hall of Fame can show a winner's place —
/// only for one who also agreed to the leaderboard (the server decides).
///
/// "make my profile a level in the next round" (owner, 24 Nov 2026): a
/// winner who agreed becomes the level "Follow last round's top learners",
/// where every learner is asked to follow them on LinkedIn and on Plexaverse
/// and gets XP for it. A new use of the same profile, so the words say it and
/// the purpose's notice version moved (2026-11-24): every earlier yes is
/// asked again. Being in that level also needs a published Plexaverse profile
/// — its own consent, `public_profile`, which the card asks for beside this.
const String kShoutoutConsentText =
    'Show my name, photo, headline and LinkedIn profile link to every '
    'Plexaverse learner if I am one of the week’s learners or a winner, '
    'with my place if I win — and if I win, make my profile a level in the '
    'next round, where learners are asked to follow me on LinkedIn and on '
    'Plexaverse and get XP for doing it';

/// The choice's own name, on the card.
const String kShoutoutToggleLabel = 'Feature me if I make it';

/// How it is undone, said where it is given.
const String kShoutoutWithdrawLine =
    'It stays off unless you switch it on. Switch it off here or in Settings '
    '→ Your data & consent at any time: you are hidden at once and the '
    'profile link you gave us is deleted. Saying no changes nothing about '
    'how you score, rank or win.';

/// Said under every card that shows featured people.
///
/// Exact about what pays (owner, 24 Nov 2026): last round's top learners are
/// a level of their own, "Follow last round's top learners", which DOES pay
/// for following each of them on LinkedIn and on Plexaverse, once a round.
/// Nothing else here pays for a follow. Being featured pays the person
/// featured nothing, and a connection with a featured learner is a
/// connection like any other.
const String kFollowOptionalLine =
    'Following anyone here is up to you. Last round’s top learners are also '
    'a level, “Follow last round’s top learners”, which pays once a round for '
    'following each of them on LinkedIn and on Plexaverse. Following anyone '
    'else here earns nothing, being featured earns the person featured '
    'nothing, and connecting with someone featured earns nothing beyond what '
    'any connection earns in the connect and invites levels. We never follow '
    'anyone for you, and being featured is no promise of followers.';

/// The most learners the week's card shows.
const int kLearnersOfTheWeekMax = 10;

/// The week's card, under its heading.
const String kLearnersOfTheWeekLine = 'Featured to every Plexaverse learner.';

/// The web's `SHOUTOUT_GRANT_ON_CONTEST_LINE`: Settings shows this under the
/// shoutout's row while it is off. It is switched ON only on the levels
/// page's card, where the link and the 18+ tick it needs are given; the
/// consent routes refuse a grant (409 GRANT_IN_CONTEXT). Switching it OFF
/// works everywhere.
const String kShoutoutGrantOnContestLine =
    'Switch this on from your levels page, where you add your LinkedIn '
    'profile link. You can switch it off here at any time.';

/// The consent purpose these words are for.
const String kShoutoutPurpose = 'contest_shoutout';

/// The 18+ tick the card asks for when no declaration is on record — the
/// web's `ADULT_DECLARATION_LABEL` / `ADULT_DECLARATION_REASON` (lib/adult.ts).
const String kAdultDeclarationLabel = 'I am 18 or older.';
const String kAdultDeclarationReason =
    'Plexaverse is only for people aged 18 or older.';

/// Said when "Feature me" is pressed without the 18+ tick.
const String kShoutoutNeedsAdult =
    'Confirm that you are 18 or older to be featured.';

/// Under the public-profile box, when the learner leaves it unticked: being
/// featured never needs a public profile; only the follow level does. The
/// web's `SHOUTOUT_PROFILE_OPTIONAL_LINE` (review of 24 Nov 2026 — it used to
/// be a refusal, `NEEDS_PROFILE`, which made one consent conditional on
/// another it does not need).
const String kShoutoutProfileOptionalLine =
    'Optional. Being featured does not need a public profile. Without one, if '
    'you finish among the top learners you are featured, but you are not in '
    'the level where learners follow last round’s top learners.';

/// The notice date of [kShoutoutConsentText] — the web's
/// `SHOUTOUT_WORDS_VERSION`. Sent with every yes, so the server knows which
/// words this card showed; it refuses a yes without the current one.
const String kShoutoutWordsVersion = '2026-11-24';

/// Above the unticked box when an earlier yes no longer counts because the
/// words changed (the server's `stale`). The web's `SHOUTOUT_STALE_LINE`.
const String kShoutoutStaleLine =
    'We changed what being featured means — last round’s top learners now '
    'become a level other learners follow. Your earlier yes no longer counts: '
    'read the words below and agree again if you still want to be featured.';

/// Beside [kShoutoutStaleLine]: the earlier yes no longer counts, but the link
/// given for it is still on record until it is withdrawn, so the card offers
/// the withdrawal (review, 24 Nov 2026). The web's `SHOUTOUT_STALE_REMOVE_LABEL`.
const String kShoutoutStaleRemoveLabel = 'Remove my earlier yes and my link';

/// A paste the profile rule refuses, said beside the field. The web's
/// `BAD_LINK` in `ShoutoutCard.tsx`.
const String kShoutoutBadLink =
    'That is not a public LinkedIn profile link. It looks like '
    'https://www.linkedin.com/in/your-name.';
