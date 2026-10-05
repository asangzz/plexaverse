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
| Android Google OAuth | Custom Tab survived the redirect and re-showed the account picker | `85807b9` |

---

## Still open

Ordered by damage. Each row is a real finding, verified against both repos.

### High — broken

**1. `completeRoadmapStep` credits XP for a step that no longer exists.**
It writes the `RoadmapProgress` row unconditionally, *then* looks the step up in
`getBaseRoadmap` to decide XP. On a Wed/Thu/Fri/Sat/Sun the `publish-post` step
is now filtered out, so the lookup misses after the write has landed.
→ `lib/services/roadmap.service.ts`

**2. Hand-off days offer a Generate button that always fails.**
`planner-generate.service.ts:141` now throws `NOT_A_POST_DAY`, and
`POST /api/mobile/v1/planner/generate-post` returns 400 with that code. Flutter's
`_generateKind` has no branch for it, so the user gets a generic failure. No XP
is burned — the server guard is correct — so this is a dead end, not data loss.

**3. Hand-off completion is invisible.**
`markVideoScriptPublished` / `markArticlePublished` write their own tables; the
plan slot is untouched. `GET /planner` returns the plan only, so a filmed video
looks identical to an untouched one. The web overlays script and article status
onto the week. Mobile now has the script endpoint (`7ff913e`) and needs the
overlay.

**4. Per-item daily progress is local-only on mobile.**
`plexa-day.service.ts` stores cleared item ids server-side as a third
`DailyAiBatch` kind. Flutter keeps `markSent` in memory, so killing the app
resets the day's count to zero — exactly the bug the web just removed, and the
two clients disagree about the same day.

### High — missing

**5. Top Voices.** `top-voices.service.ts` (415 lines), the admin library, five
curated posts a day, topics from the profession, settings picker. Mobile renders
only the generated half of the comments page. Needs: a mobile route, a
`DailyTopVoice` model, the `actedAt` stamp, and a settings surface for
`postCategories` using the forty-id vocabulary.

**6. Open Plexa.** The day's missions as one conversation —
`PlexaDayChat.tsx` (491 lines) over `plexa-day.service.ts`. No mobile
counterpart and no `app/api/mobile/v1/plexa/`. This is almost certainly what
"integrate plexa ai" meant.

**7. Follower capture.** `FollowerCheckpoint.tsx` asks for the count on the
roadmap. Mobile's only route to a follower number is downloading LinkedIn's
.xlsx on a desktop, so the phase checkpoints can never fill in. Needs
`POST/GET /api/mobile/v1/persona/reach`.

### Medium

**8. Newsletter scheduling.** `weekly_articles.scheduled_for` is a schema change
that *already* alters the mobile response — the summary route spreads the row,
so `scheduledFor` is being sent and silently dropped by the Flutter model.

**9. Newsletter naming dead-ends.** `POST /api/planner/newsletter` has no mobile
route, and `newsletterName` is not whitelisted in user preferences, so the
first-article flow cannot complete on a phone.

**10. Follower readings carry an as-of stamp** now; mobile has no history
endpoint, which the growth chart's user line needs.

### Low

**11. Notification copy** still says the article is Sunday's. It is Thursday's.
Nothing is broken on the wire — the push lands and the app's own settings copy
contradicts it.

**12. Chart kit.** Rendering-layer only; no wire impact. Mobile has its own
(`ZaveSparkline`, `ZaveAreaWedge`, `ZaveMeter`).

**13. Roadmap planets/phases are ported but not drawn.** `3bc02be` brought the
12-planet, 4-phase table across; `planet_node.dart` still draws the nine-planet
visual vocabulary and has no art for `nebula`, `quasar` or `nova`.

---

## Two things worth knowing

**`PostMetric` is empty in production.** 167 published posts, 0 metric rows,
and nothing in the codebase writes the table — only three read-aggregates in
`dashboard.service.ts`. So the post detail's performance section, the posts
list's metrics row, and the dashboard's impressions all render nothing on real
data. This is not an alignment gap; it is a feature that was never finished.

**78 MB of base64 sits in `posts.image_url`.** 152 of 246 image posts hold an
inline `data:` URL rather than a storage link. The mobile feed excludes the
column by construction, so the list is fast — but opening a post detail can pull
1.6 MB for one image. A thumbnail backfill would fix the list, the calendar and
the detail at once.
