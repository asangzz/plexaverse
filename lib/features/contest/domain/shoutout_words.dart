/// The contest shoutout's words — the web's `lib/contest-shoutout-copy.ts`,
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
const String kShoutoutConsentText =
    'Show my name, photo, headline and LinkedIn profile link to every '
    'Plexaverse learner if I am one of the week’s learners or a winner, '
    'with my place if I win';

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
/// Exact about XP: being featured earns nothing, but a connection with a
/// featured learner is a connection like any other, and the connect and
/// invites levels pay for connections whoever they are with.
const String kFollowOptionalLine =
    'Following or connecting with anyone here is up to you. Being featured '
    'earns nothing, and connecting with someone featured earns nothing beyond '
    'what any connection earns in the connect and invites levels. We never '
    'follow anyone for you, and being featured is no promise of followers.';

/// The most learners the week's card shows.
const int kLearnersOfTheWeekMax = 10;

/// The week's card, under its heading.
const String kLearnersOfTheWeekLine = 'Featured to every Plexaverse learner.';

/// The web's `SHOUTOUT_GRANT_ON_CONTEST_LINE`: Settings shows this under the
/// shoutout's row while it is off. It is switched ON only on the contest
/// card, where the link and the 18+ tick it needs are given; the consent
/// routes refuse a grant (409 GRANT_IN_CONTEXT). Switching it OFF works
/// everywhere.
const String kShoutoutGrantOnContestLine =
    'Switch this on from the contest page, where you add your LinkedIn '
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

/// A paste the profile rule refuses, said beside the field. The web's
/// `BAD_LINK` in `ShoutoutCard.tsx`.
const String kShoutoutBadLink =
    'That is not a public LinkedIn profile link. It looks like '
    'https://www.linkedin.com/in/your-name.';
