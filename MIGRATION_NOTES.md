# Liquid UI Migration Notes
**Branch:** `liquidui`  
**Design source:** `DESIGN.md` v2 — Sunset Glow  
**Status legend:** ✅ done · 🔄 in progress · ⏳ pending

---

## Phase 1 — Tokens + Theme + Navigation (this session)

### Design Tokens (`lib/app/design_tokens.dart`) ✅
- New file: all color, radius, spacing, motion constants from DESIGN.md §2–5.
- Old `AppTheme.*` constants now alias `SlamTokens.*`.

### Theme (`lib/app/theme.dart`) ✅
| Aspect | Old | New |
|---|---|---|
| Background | `#1a1a1f` | `#0F0A0D` (SlamTokens.bg) |
| Surface | `#27272a` | `#22161C` (SlamTokens.surface) |
| Primary | `#f97316` | `#FF7A3B` (SlamTokens.primary) |
| Text | `#fafafa` | `#FFF4EC` (SlamTokens.text) |
| Border | `white@12%` | `rgba(255,180,150,0.10)` — warm |
| Display font | Inter 700 | Fraunces 700/800 |
| Body font | Inter 400/600 | DM Sans 500/700 |
| Button shape | radius 20 | `StadiumBorder` (pill) |
| Input shape | radius 20 | radius 18 |

### Shared Widgets ✅
| Widget | Old | New |
|---|---|---|
| `GlassPanel` | Glassmorphism + backdrop blur | Card §6.2: surface bg + line border |
| `GradientButton` | Gradient, radius 12–20 | Flat primary, pill (rCircle), primaryShadow |
| `SecondaryButton` | Primary-colored outline | surface bg + line border, radius 18 |
| `CoinBalanceChip` | amber bg | warnSoft bg + warn color, pill |

### Navigation (`lib/features/home/presentation/widgets/main_navigation.dart`) ✅
| Aspect | Old | New |
|---|---|---|
| Tabs | 3: Feed · Apps · Profil | 4: Feed · Plan · Apps · Shop |
| Nav widget | Material `NavigationBar` | Custom `SlamBottomNav` (pill §6.6) |
| Active tab | Material indicator | `AnimatedContainer` flex 2.2 |
| Profile entry | Tab 2 | Avatar tap → Swoosh-Overlay (§6.7) |
| Overlay origin | — | `GlobalKey avatarGlobalKey` measured at runtime via `RenderBox.localToGlobal` |
| Overlay animation | — | `clip-path` circle reveal 680 ms, content fade + scale with 80 ms stagger |

### Routing (`lib/app/routes.dart`) ✅
| Route | Old behaviour | New behaviour |
|---|---|---|
| `/lernplan` | Full-screen `LernplanScreen` | Redirect → `/home` + switch to tab 1 (Plan) |
| `/shop` | Full-screen `ShopScreen` | Redirect → `/home` + switch to tab 3 (Shop) |
| `/profil` | *(did not exist)* | Redirect → `/home` + open profile overlay |
| All other routes | unchanged | unchanged |

**Implementation:** `mainNavNotifierProvider` (`StateNotifierProvider`) carries
tab index + overlay flag. GoRouter redirect calls `Future.microtask` to update
the notifier without mutating state during the routing evaluation phase.

### Nav State (`lib/features/home/presentation/providers/main_nav_notifier.dart`) ✅
- `MainNavState { tabIndex, showProfileOverlay }`
- `MainNavNotifier.switchToTab(int)` — closes overlay, switches tab
- `MainNavNotifier.openProfile()` / `closeProfile()`

---

## Phase 2 — Feed Screen (⏳ pending)

### Feature parity checklist
- [ ] Feed header: Avatar (top-left, `avatarGlobalKey`) + Stat-Pills (XP, Coins, Streak)
- [ ] Avatar tap triggers `mainNavNotifier.openProfile()`
- [ ] Subject-Tag as `SlamSubjectChip` (§6.3, subject hue)
- [ ] Question card: Fraunces 700 30px, radius 22–28
- [ ] Option buttons: radius 18–20, `surfaceHi` bg, success/danger on feedback
- [ ] Option → Feedback morph animation (§5.3)
- [ ] Hint-Button, Skip/Next pill (§6.1 Ghost)
- [ ] Feedback-Card with „Frag die KI" CTA
- [ ] Coins/XP/Streak pills visible in header (removed from AppBar)

---

## Phase 3 — Lernplan (⏳ pending)

- [ ] Leitidee-chips with subject hues (§2.2, §6.3)
- [ ] Topic/Subtopic grid
- [ ] Single CTA: „Plan speichern" pill

---

## Phase 4 — Apps Hub (⏳ pending)

- [ ] Hero-Card for KI-Labor
- [ ] 2×2 tool grid with `SlamIconBadge` Filled (§6.4)
- [ ] No background glows (§9)

---

## Phase 5 — Shop (⏳ pending)

- [ ] Coins-Balance-Pill in own header (not global AppBar)
- [ ] Remove back-button (now a nav tab, not a pushed route)
- [ ] Theme-tiles: aspect ratio 1.4 image tiles
- [ ] Power-Ups as list items
- [ ] KAUFEN / BESITZT status labels

---

## Phase 6 — Profil Overlay (⏳ pending)

Full migration of `ProfilScreen` content to match DESIGN.md §7.5:

- [ ] Level-Ring 220px with multi-stop gradient (replaces `LevelProgressCircle`)
- [ ] 3-stat grid: XP · Münzen · Streak (replace individual chips)
- [ ] Streak-Calendar: 14 × 4 dots (§1.5)
- [ ] Subject progress bars per Leitidee (Algebra, Analysis, Geometrie, Stochastik)
- [ ] Streak-risk banner kept
- [ ] Exam countdown card kept
- [ ] Quick actions (Lernplan, Einstellungen) kept as Ghost buttons (§6.1)

---

## Preserved Routes (all still reachable)

| Route | Still works? | How |
|---|---|---|
| `/home` | ✅ | MainNavigation, tab 0 |
| `/lernplan` | ✅ | Redirect → tab 1 |
| `/shop` | ✅ | Redirect → tab 3 |
| `/profil` | ✅ | Redirect → overlay |
| `/settings` | ✅ | Unchanged pushed route |
| `/progress` | ✅ | Unchanged pushed route |
| `/question-session/:id` | ✅ | Unchanged pushed route |
| `/login`, `/register`, etc. | ✅ | Unchanged |
| `/onboarding` | ✅ | Unchanged |

---

## Do / Don'ts carried forward from DESIGN.md §9

❌ No background blobs / ambient gradients  
❌ No asymmetric corner radii  
❌ No Goo-merge filters on pill clusters  
❌ No drop-shadows except on elevated/floating elements (nav, FAB, CTA)  
❌ No emoji as content  
❌ No dummy stats  
