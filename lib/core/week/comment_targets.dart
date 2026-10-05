/// How many comments a day asks for, and how that total is split.
///
/// A port of the web's `lib/comment-targets.ts`, and a leaf module here for
/// the same reason it is one there: several unrelated places need these
/// numbers — the roadmap step, the comments screen's progress bar, the AI
/// batch size — and hanging them off any one of those makes the others depend
/// on it.
///
/// ## Why this exists at all, rather than reading the copy
///
/// The target used to be scraped out of the step's own description: the first
/// integer anywhere in the sentence, falling back to 3. That made a display
/// string load-bearing — rewording a description changed what "done" meant —
/// and it is how mobile ended up handing the user five comment drafts against
/// a progress bar that said 3 and a Finish button that would not enable.
///
/// The web stopped scraping for the same reason and now declares it. This is
/// the declaration, and `EngagementMission` reads it instead of a RegExp.
library;

/// Both halves of the comments page count toward this.
///
/// Ten a day is five curated Top Voices posts plus five from the user's own
/// niche. Mirrors `DAILY_COMMENT_TARGET`.
const int dailyCommentTarget = 10;

/// The lower half of the comments page — the generated, niche-specific half.
///
/// Five and not six: the server bills `baseCost * ceil(count / 5)`, so three
/// and five both cost one unit and six costs two. Raising this past five
/// doubles the XP price of every user's day.
///
/// Mirrors `NETWORK_COMMENT_BATCH_SIZE`.
const int networkCommentBatchSize = 5;

/// Connection requests asked for on a day the week posts on.
///
/// Ported from the web's `lib/invite-targets.ts`, which is a leaf module there
/// for the same reason this is one here.
///
/// ## Why 80 a week and not the 140 that was asked for
///
/// The strategy this came from asked for 20 a day, every day. LinkedIn
/// restricts accounts that send too many invitations, does not publish the
/// threshold, and its own help pages say support will not disclose the reason
/// for a restriction either — so nobody outside LinkedIn knows where the line
/// is. A product that tells people to do something every day for a thousand
/// days cannot aim at a line it cannot see, because the penalty is not a
/// rejected request, it is a restricted account.
///
/// The copy may say a limit exists and is unpublished, which LinkedIn itself
/// confirms, and that this pace is deliberately conservative. It may NOT quote
/// a number as LinkedIn's.
const int invitesPerPostingDay = 12;

/// Requests asked for on a weekend day.
///
/// Not zero. The week's posting stops at the weekend; reaching out does not
/// have to, and spreading the same weekly total across seven days is gentler
/// on an account than concentrating it into five.
const int invitesPerRestDay = 10;

/// 12 x 5 + 10 x 2. Stated as the product of the two, so it cannot drift.
const int invitesPerWeek = invitesPerPostingDay * 5 + invitesPerRestDay * 2;

/// The target for a given day. Takes the day's kind rather than importing the
/// week shape, so this module stays a leaf — callers have the shape in hand.
int invitesForDay({required bool isPostingDay}) =>
    isPostingDay ? invitesPerPostingDay : invitesPerRestDay;
