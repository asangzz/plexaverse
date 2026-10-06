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

**B. The base64 in `posts.image_url` is an ONGOING LEAK, not a backfill.**
Recorded as a historical 78 MB; it is not. Three web planner paths still PATCH
a fresh multi-megabyte `data:` URL today. Mobile is the client that gets this
right (`compose_controller.dart:407-421` uploads first and hard-fails rather
than falling back) and inherits the cost through the shared `/posts/[id]`
payload. Because those paths never write `imageThumbUrl`, every web-generated
post also shows a permanent placeholder in the mobile feed.
→ make the three call sites do what `tasks/execute/route.ts:1133-1139` already
does, then reject `data:` in `createUserPost`/`updateUserPost`, then backfill.

### High — missing

**9. Newsletter naming dead-ends.** No mobile route for
`POST /api/planner/newsletter`, and the preferences schema is `.strict()`, so
`newsletterName` cannot be written either. `isFirstArticle` stays true forever,
the warning never clears, and captions keep referring to the article generically
instead of by name (`lib/auto-post-prompts.ts:470`).

**7. Follower capture — narrower than recorded.** The `.xlsx` import is fully
on-device now (`persona_page.dart:492-520` → `/persona/reach/import`), and the
GET half effectively exists: `persona.service.ts:68,102` already folds
`{count, measuredAt}` into the mobile payload. What is open: there is **no POST
route** so a count cannot be typed; Flutter **throws away the number it is
handed** (`persona_repositories.dart:148-188` reads `identity`/`bank`/
`voiceSampleCount`, never `json['reach']`); and `followerTarget` in
`roadmap_planets.dart` is assigned and read nowhere, so no checkpoint UI exists.

### Medium

**1. `completeRoadmapStep` writes the completion row before it knows the step
exists, then silently awards 0 XP.** The trigger recorded was wrong — both UIs
already filter `publish-post`, so no user can tap it; the path that fires it is
`getRoadmapProgress`'s auto-credit calling `getBaseRoadmap(brandType)` **bare**
at `roadmap.service.ts:188` and then `completeRoadmapStep` at `:228`, which
rebuilds the roadmap *with* `roadmapStartedAt` at `:301`. A self-inconsistency
between two call sites 113 lines apart.
**Open Plexa does NOT make it more frequent** — it credits only `comment` and
`connect`, from `buildRoadmap`, which already drops what the server drops.
**But it exposed the same root bug on a step that costs real XP:** the WEB chat
resolves its lane steps from a bare `getBaseRoadmap()`
(`PlexaDayChat.tsx:117`), which keeps `connect` for everyone, while
`roadmap-data.ts:255` drops step 3 for company brand. A company-brand user
clearing the connections lane is told "Requests done. Logged." and loses the
50 XP permanently — the row is marked complete, so the idempotency guard at
`:275` means nothing can award it later. The Flutter port is correct here.

**4. Engagement progress dies on screen pop, not app kill.** Both controllers
are auto-dispose (`engagement_controllers.g.dart:224,351`, no `keepAlive`), so
tapping to the dashboard and back already shows 0 of 3. The two surfaces openly
disagree about work the user did. The fix is small and needs **no new id
scheme** — `tv:` never reaches these screens, so comments need `nw:<i>` and
connections `cn:<i>` only; seed `isSent` from `session.doneIn(lane)` and have
`markSent` fire the POST.

**8. `scheduledFor` is on the wire and dropped.** The Flutter `WeeklyArticle`
factory has no field for it, and the mobile article route has no `schedule`
action, so a reminder set on the web is invisible on the phone and cannot be
set, changed or cleared there.

**A. `PostMetric` has no writer anywhere.** Confirmed — but the read sites
recorded were wrong: the ~10 relation reads via `include: { metrics }` in
`post.service.ts`/`linkedin-publish.service.ts` are what the post UIs consume,
not the three aggregates. The dashboard is not a rendering surface at all
(web removed `useDashboardData`; Flutter declares `ApiPaths.dashboard` and
never calls it), and Flutter's `post_card._Metrics` is doubly dead — the feed
mapper never sets `metrics`. The seam for a fix:
`post-analytics.service.ts:117` already fetches `p.stats.impressionCount` live
and throws it away.

### Low

**13. Nebula, Quasar and Nova all render as Uranus.** 3 of the 12 ported planets
have no art, so past day 601 the three legs of the endgame are visually
identical to each other and to a planet passed on day 366.
→ three `PlanetVisual` entries in `planet_node.dart`, ported from
`GamifiedRoadmap.tsx:82-84, 98-100, 113-115`; make the `?? planetVisuals['uranus']!`
fallbacks at `:269` and `:648` assert in debug.

**10. No follower-history endpoint, and no growth chart on mobile to want one.**
`getFollowerHistory` is web-only. More to the point, there is no chart in the
Flutter repo at all — no charting package, no `*chart*` file — so the
"where 100,000 comes from" argument that justifies posting daily is web-only.
The chart is the larger half of this work.

**11. One string, in Flutter.** The claim had this backwards: the web
notification was already fixed (`notification-templates.ts:252` names the thing,
not the day) and so was the planner card. Exactly one user-facing string in
either repo still names the wrong day —
`cadence_section.dart:123`, "Sunday article". Drop the day word rather than
swapping it, so the next shape change cannot re-break it.

---

## Closed since the first pass

| # | Was | Settled by |
|---|---|---|
| 2 | Generate button on hand-off days always failed | `49ca63d` — the `NOT_A_POST_DAY` branch (`planner_repositories.dart:104-106`), its copy (`planner_page.dart:723`), and the `slot.isPublishable` gate that removes the button entirely (`:654-664`) |
| 3 | The video script had no mobile surface at all — `7ff913e` added the route and nothing called it, so Wednesday and Friday opened a sheet whose only action was rewriting the title of a script the app could not show. Both hand-off rows were also pinned at "to write" for ever, reading a `status` column that a hand-off day never reaches | A `VideoScript` model, three repository methods, `VideoScriptsController`, and the shot list in the slot sheet. `slotSignal` now takes a `HandoffState` resolved from the script row (or the article row for Thursday) instead of `slot.status`. The mock plan carries the real `weekShape` too — it built all seven days as posts, so the flavor this app is manually tested on showed a week the product stopped producing |
| 5 | Top Voices: a phone-only user got **zero** curated posts anywhere (the generator's only caller was a web-session route), and the Comments step asked for ten against a screen that could supply five, so Finish could never enable | `GET`/`PATCH /api/mobile/v1/top-voices`, the `TopVoicesSection` card, `reachableCommentTarget`, a Dart port of the forty category ids and a picker in Settings. The two fakes that seeded category LABELS are fixed too — they would have had every preferences PATCH rejected by the server's refine |
| 6 | *(folded into 4 during the first pass)* | — |
| 12 | Chart kit | Rendering-layer only, no wire impact; mobile has `ZaveSparkline` / `ZaveAreaWedge` / `ZaveMeter`. Superseded by 10, which is the real gap |

