/// Values the mock flavor's fakes must agree on.
///
/// Three separate fakes used to hand the same user three different XP
/// balances — 4350 on the roadmap, 8450 in settings, 4820 in the missions
/// recap — when on the server all three read the identical `GET /user/xp`.
/// The disagreement was permanent and invisible: no screen could ever be
/// caught showing a stale or unrefreshed balance on the one build this app is
/// manually tested on, because disagreeing was the fixture's normal state.
///
/// A fixture that cannot demonstrate the behaviour it stands in for is worse
/// than no fixture: it teaches the wrong thing confidently.
library;

/// The one XP balance. Every fake that reports one reports this.
const int kMockXpBalance = 4350;
