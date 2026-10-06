# Web → Mobile alignment

What the Flutter app owes the web app, as of **6 Oct 2026**.

Audited across the 56 web commits in `8051ddf..origin/master` (26 Sep – 6 Oct):
the planner pivot, the 1000-day roadmap, Top Voices, Open Plexa, the chart kit.

## The thing that makes this urgent

**None of those 56 commits touched `app/api/mobile/`.** That reads like "mobile
is merely behind". It is worse than that: the mobile routes delegate to the
*shared* services in `lib/services/`, and those changed heavily —
`week-plan.service.ts` alone by 224 lines.

So the Flutter app is not stale. It is **already being served the new shapes
with the old UI**, which is why most of the high-severity rows below say
`broken` rather than `missing`.

### State vocabulary

| | meaning |
|---|---|
| **broken** | new data is reaching old UI, or a mobile client sends something the server now rejects |
| **missing** | the feature has no mobile surface at all |
| **stale** | mobile shows an older model; nothing is mis-parsed |

---

## Fixed in this pass

| Area | Was | Commit |
|---|---|---|
| Season 1 length | Flutter said 66 days, web says 1000 — **every user past day 66 was shown Season Complete**, 934 days early, while the server still had them mid-season | `3bc02be` |
| Roadmap build | looped the whole arc; at 1000 days that is ~1000 levels × 3–5 steps rebuilt per progress change | `3bc02be` |
| Daily mission | asked for a post on five days of seven that no longer produce one | `39a91bf` |
| Onboarding | sent `postCategories` from an 8-id vocabulary; 5 are rejected by the new validator, so the whole PATCH failed and onboarding could not complete | `39a91bf` |
| Comment target | 5 drafts against a progress bar reading 3, Finish could never enable; target was *scraped from display copy* | `8da96e4` |
| Invite target | `connections ? 10 : 3` — the larger number on the smaller task | `8da96e4` |
| Video scripts | the week has two; mobile had no endpoint | `7ff913e` |
| Rate limiting | mobile has no cookie, so **all ~110 mobile routes bucketed by IP** — carrier NAT shares one AI budget | `c05737a` |
| Session loss | 3h idle timer wiped a 30-day refresh token (a health-app policy; the web has none) | `85807b9` |
| Planner dead ends | Generate offered on days the server refuses; "tomorrow's post" deep-linked to a non-post day | `49ca63d` |
| **Open Plexa** | absent on mobile — now one aggregate call, three lanes, server-side progress | `95f01f9` `3474e1a` |
| **Open Plexa, again** | the port was a scrolling card list with a separate "I did this" button. The web is a **conversation** that deals one item at a time, where one tap is opened AND counted — the web file argues explicitly that asking a second time "would add a turn per item, ten times a day, to collect an answer nothing can verify" | *this pass* |
| Plexa session ids | mobile wrote `comments:0` / a bare `shownId`; the web writes `tv:` / `nw:` / `cn:`. **Both clients write the same `plexa_day` row**, so a user who worked on the browser in the morning and the phone in the evening was shown the same posts twice | `8f11fde` |
| Roadmap credit from Plexa | finishing a lane in the chat credited nothing — the web calls `complete_step` the moment the last comment or request clears. A user who worked the whole day inside the chat found the roadmap still showing the step undone | *this pass* |
| **Every `AppIcons` glyph** | `font_awesome_flutter` was **not in `pubspec.yaml`** — only `cupertino_icons` and the engine's MaterialIcons shipped, so the entire house icon layer rendered the missing-glyph box. Visible on More (Write/Persona/Settings), the offline overlay, and Plexa's close button | *this pass* |
| `AppIcons.linkedin` / `.google` | pointed at `FontAwesomeSolid`; brand marks live in `FontAwesomeBrands` and have **no codepoint in solid at all** | *this pass* |
| Plexa pluralisation | a day with one item read "1 comments. I've written all of them." — fixed on **both** platforms so the first line a new user sees has no grammar mistake | *this pass* |
| Android Google OAuth | Custom Tab survived the redirect and re-showed the account picker | `85807b9` |

---

## Still open

Ordered by damage. Re-verified against both repos after the Open Plexa rebuild;
eight of the thirteen original rows were wrong in their details, so each now
carries the file:line that settles it. Numbering is kept from the first pass so
earlier notes still resolve — 6 and 12 are closed and listed at the bottom.

### High — broken

*(none)*

### High — missing

*(none)*

### Medium

**Mock-flavour fixtures still disagree with the server — 11 left.** An audit of
all 19 fakes found 14 divergences; the three cheapest are fixed (one shared XP
balance instead of three different ones, a composed draft no longer collides
with a published post in the library, and an upload URL on `.invalid` that
could never resolve, so every "successful" upload rendered the error state).
The rest are listed in the session notes and want their own pass — the ones
that matter most: `fetchWeek` ignores its week/season arguments so the
ungenerated-week state is unreachable; the batch fakes hardcode `cached: true`
so the XP-charging first-call-of-the-day branch never runs; `generateSlotPost`
cannot fail, so none of its four documented failures can be walked; and the
season recap is still a 66-day, seven-posts-a-week season.

**Two settings controls do nothing — a product decision, not a bug fix.**
`POSTS PER WEEK` and `PUBLISHING DAYS` in the mobile cadence section write
`postsPerWeek` and `preferredDays`. Server-side, `preferredDays` is validated,
stored and **read by nothing**; `postsPerWeek <= 3` is maintenance mode, which
`postingDays().slice(0, 3)` now makes a **no-op** — a week that publishes two
posts already satisfies "at most three". The web has no cadence UI at all, so
mobile is offering choices the product cannot honour and the web never
promised. The stale copy is corrected; whether to remove the controls is
yours to call.

**The 78.6 MB inline-image backfill has still not been run.**
`scripts/backfill-inline-post-images.ts` is committed and dry-run by default.
It rewrites 154 rows of live user data, so it stays your call.

---

## Closed since the first pass

| # | Was | Settled by |
|---|---|---|
| 2 | Generate button on hand-off days always failed | `49ca63d` — the `NOT_A_POST_DAY` branch (`planner_repositories.dart:104-106`), its copy (`planner_page.dart:723`), and the `slot.isPublishable` gate that removes the button entirely (`:654-664`) |
| 3 | The video script had no mobile surface at all — `7ff913e` added the route and nothing called it, so Wednesday and Friday opened a sheet whose only action was rewriting the title of a script the app could not show. Both hand-off rows were also pinned at "to write" for ever, reading a `status` column that a hand-off day never reaches | A `VideoScript` model, three repository methods, `VideoScriptsController`, and the shot list in the slot sheet. `slotSignal` now takes a `HandoffState` resolved from the script row (or the article row for Thursday) instead of `slot.status`. The mock plan carries the real `weekShape` too — it built all seven days as posts, so the flavor this app is manually tested on showed a week the product stopped producing |
| 7 | Follower capture. The `.xlsx` import was already on-device and the count was already on the wire as `reach.followers` — but there was no POST route, so a phone-only user could not TYPE the number; the Flutter mapper dropped the one it was handed; and `followerTarget` was declared and read by nobody, so the roadmap named checkpoints it could not measure anyone against | `POST`/`GET /api/mobile/v1/persona/reach`, `FollowerReading` on the snapshot, and the checkpoint strip above the day's missions — ask, then the bar showing what the number bought, re-asking after 30 days. **The Flutter phase targets were 1,000/10,000 against the web's 3,000/15,000** — harmless while nothing read them, four wrong numbers on screen the moment something did |
| 4 | Engagement progress was in-memory and the controllers are auto-dispose, so it died on screen POP, not app kill — tapping to the dashboard and back showed `0 of 10` over work that was done, while Open Plexa, reading the shared row, showed the real count | Both controllers now seed from the shared `plexa_day` row and write to it; `plexaItemId` holds the `nw:`/`cn:` scheme in one documented place. The two fakes held a session EACH, so the mock could never show the two surfaces agreeing — they share one row now, which is what made the cross-surface check possible at all |
| 1 | `completeRoadmapStep` upserted the completion row BEFORE resolving the step, so a miss wrote a phantom completed row — and the already-completed guard then made it permanent. Six resolvers called `getBaseRoadmap()` bare or half-bare, describing a different roadmap from the one the award path rebuilt | The step is resolved first and a miss throws NOT_FOUND writing nothing; all six resolvers now pass `brandType` AND `roadmapStartedAt` (the chat, the auto-credit, and the four dashboard pages that POST a step id); the web route maps NOT_FOUND to 404 instead of 500. **Correction to the original note:** for the company/`connect` case no XP was ever *owed* — step 3 is not on a company roadmap — so the damage was a phantom row, not a refundable 50 XP. The Flutter port was already correct |
| B | Inline base64 in `posts.image_url` was an ONGOING leak, not a historical 78 MB — measured at **154 posts / 78.6 MB**, up from the 152 first recorded. `/api/ai/poster` returns a `data:` URL; the auto-post chain converted it, five client call sites did not, and none of them wrote a thumb, so every such post is also a permanent placeholder in the mobile feed | The guard went into `createUserPost`/`updateUserPost` rather than the five call sites — they are the only two paths that write the column, so nothing can reintroduce it. It REPAIRS rather than rejects: the auto-post chain deliberately falls back to an inline URL when Storage is down, and a hard rejection would turn a Storage blip into a missing image on an unattended publish. Plus `scripts/backfill-inline-post-images.ts` for what is already there |
| 8 | `scheduledFor` was on the wire and dropped. The field has been on the mobile article GET since the column existed — the route spreads the service's row — but `WeeklyArticle` had no field for it and the route had no `schedule` action. So a reminder set on the WEB was sent to the phone and discarded: the nudge arrived for a time the app had never shown, and could not be moved or cleared from it | The `schedule` action on `POST /api/mobile/v1/planner/article` (null `scheduledFor` CLEARS; `ArticleScheduleError` → 400 carrying the service's own sentence, 404 for NOT_FOUND), `reminderAt({now})` on the model, and the reminder row on the article card — date then time, both platform pickers, with the clear path on a sheet that states plainly that **nothing is being scheduled to publish**. There is no articles endpoint on LinkedIn's API; a time only books a nudge. Two things found on the way: both POST actions returned the service row **including the 6.4 KB body** the GET goes to lengths to strip, for a client model that has no body field — one `summarize()` now covers all three responses; and the route was absent from `lib/mobile/registry.ts` entirely, which is the contract file the Flutter team reads |
| A | `PostMetric` had no writer — not one, in either repo — while ten read sites in `post.service` and three aggregates in `dashboard.service` read it. Every one returned null for every user since the table existed, so the post library and the dashboard reported no reach at all | **The premise was inverted.** The obvious fix was to persist the LinkedIn stats `getWeekPerformance` already fetches and throws away — but that function returns before any LinkedIn call for a personal user (`r_member_social_actions` is Partner-Program-only), so a writer there serves COMPANY users only. `ReachSnapshot` is the shipped successor: a strict superset of the columns, with two live writers that both serve personal profiles. So the readers moved instead — `reachMetricsFor()` in post.service, one query per page rather than one per post, and the three aggregates repointed. `PostMetric` is now dead with nothing reading it; **dropping the table is a migration and deliberately left for a separate decision** |
| 10 | No growth chart on mobile. The phone could WRITE follower counts and never read back more than the latest one, so `GET /persona/reach` could say where the user is and nothing could say whether they are moving — which is the question a checkpoint raises | `GET /api/mobile/v1/persona/reach/history` + `FollowerSeriesChart` on the checkpoint strip. Two bugs found in the existing service on the way: `getFollowerHistory` applied its 400-row cap at the **wrong end** (`asc` + `take` keeps the OLDEST 400, so anyone past the cap had a chart frozen on their first 400 readings), and it read only `ReachSnapshot` while the headline figure merges in `AudienceSnapshot` — so a user who only uploads the .xlsx export saw a follower count with an empty chart beneath it. The chart spaces points by TIME, not index, and never resamples or splines: this is the one number that can only come from the person looking at the screen |
| 11 | "One stale Sunday-article string." It was **41**, across both repos — and five of them were PROMPT text reaching the model: "anchors all 7 posts", "produce 7 unique angles", "at most 1–2 of the 7 posts", and a bullet instructing a Sunday "light" company reflection for a day that now rests | All 41 applied. Also rewrote CLAUDE.md §6b, which still described the pre-pivot week in full (Sunday article, a Sunday teaser that auto-publishes, `ACTIVE_MAINTENANCE_SLOTS = {0,2,4}`) — it is the file that tells the next person how the week works. Added `week-shape.ts` to the critical-files table and `VideoScript` to §3, which had never documented a model central to the current week. The `cloudTasks` scheduling comments justified Saturday by "the Sunday post is generated on Saturday"; **Saturday is still right, the reason changed** |
| 13 | Nebula, Quasar and Nova rendered as Uranus past day 601 | **Already fixed during this pass, by a subagent that committed and pushed on its own** (`7c831b6`) — flagged, not sanctioned. The work itself checks out: `planetVisuals` was ported when the arc ended at Neptune, both lookups fell through `?? planetVisuals['uranus']!`, and the timeline's separate `?? 100` ring default mis-centred those rows on top of it. Twelve entries, an assert, and a test that pins every roadmap key to a drawing spec |
| 9 | Newsletter naming dead-ended. The web route is session-authenticated so a bearer could not reach it, and the preferences PATCH could not carry the name either — that schema is `.strict()` with no `newsletterName` field, so a client that tried had the WHOLE patch rejected. `isFirstArticle` is `!newsletterName`, so it stayed true for ever: the planner asked the user to create a newsletter they already had, every week, and captions kept naming the article generically | `POST /api/mobile/v1/planner/newsletter`, plus the naming sheet on the article card. The model's five candidate names were already on the wire and dropped on the floor. The fake held the name as a literal, so `isFirstArticle` was false for ever under the mock and this whole flow was unreachable on the build the app is tested on |
| 5 | Top Voices: a phone-only user got **zero** curated posts anywhere (the generator's only caller was a web-session route), and the Comments step asked for ten against a screen that could supply five, so Finish could never enable | `GET`/`PATCH /api/mobile/v1/top-voices`, the `TopVoicesSection` card, `reachableCommentTarget`, a Dart port of the forty category ids and a picker in Settings. The two fakes that seeded category LABELS are fixed too — they would have had every preferences PATCH rejected by the server's refine |
| 6 | *(folded into 4 during the first pass)* | — |
| 12 | Chart kit | Rendering-layer only, no wire impact; mobile has `ZaveSparkline` / `ZaveAreaWedge` / `ZaveMeter`. Superseded by 10, which is the real gap |

