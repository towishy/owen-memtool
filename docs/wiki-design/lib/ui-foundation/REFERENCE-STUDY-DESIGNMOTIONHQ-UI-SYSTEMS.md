---
schema_version: 1
reference_study: true
output_job: "turn short-form UI advice into evidence-linked, operable UI systems without copying source trade dress"
surface: "operational workbench, interactive UI specimen board, state lab, and evidence ledger"
evidence: ["95 public DesignMotionHQ Instagram posts reviewed 2026-08-30", "91 reels sampled every 3 seconds with OCR", "4 carousels captured in canonical hydration order across 32 slides", "88-item evidence ledger and 13 synthesized principles", "independent bilingual UI Foundation consumer specimen and Playwright coverage"]
confidence: medium
axes_covered: ["typography", "color", "spacing", "radius", "borders", "shadows", "layout", "hierarchy", "iconography", "motion", "interaction"]
unresolved_axes: ["imagery"]
allowed_range: "Use the reviewed rules for explicit state, recovery, input timing, navigation, selection, responsive capability, hierarchy, material restraint, bounded motion, native CSS, and ethical user control."
counterexample: "Do not copy the source account's black/teal reel skin, graphics, copy, code, conversion claims, generic glass recipe, focus-ring prescription, artificial delay, forced retention, or dark-pattern implementation."
transfer_specimen: "lib/ui-foundation-consumer/src/designmotionhq-specimens.tsx"
---

# Reference Study: DesignMotionHQ UI Systems

## Source boundary

2026-08-30에 `@designmotionhq` 공개 프로필의 게시물 95개를 전수 확인했다. 91개 릴스는 공개 media를 임시 research 경로에 내려받아 3초 간격 720px 프레임으로 OCR했고, 4개 캐러셀은 Instagram hydration data의 실제 `carousel_media` 순서로 32장을 확인했다.

사용자 요청에 따라 제품 홍보 3개와 순수 알고리즘·모션 4개는 최종 UI 원장에서 제외했다. 남은 88개는 84개 릴스와 4개 캐러셀이며, 한 항목에 하나의 primary category와 `adopt`, `adapt`, `context`, `caution` 판단을 부여했다.

외부 source code, reel graphics, music, brand, dark/teal trade dress와 문구는 복제하지 않았다. 게시물의 행동 통계·전환율·기억률은 creator claim이며 독립 검증 결과로 취급하지 않는다.

## Evidence ledger

| Decision | Count | Meaning |
| --- | ---: | --- |
| Adopt | 30 | 현재 Foundation 계약과 직접 일치 |
| Adapt | 38 | 원칙은 유효하지만 Owen 접근성·재질·모션 경계로 조정 |
| Context | 14 | 특정 제품, 기능 또는 매체에서만 사용 |
| Caution | 6 | 취약점과 dark pattern을 구현 금지 사례로 내재화 |

Primary category 분포는 forms 13, async state 11, psychology/ethics 10, governance 8, safety 7, navigation 7, visual layout 7, material 6, responsive 5, data 4, motion 4, CSS 3, selection 2, collaboration 1이다.

Canonical ledger와 bilingual copy는 `../ui-foundation-consumer/src/designmotionhq-data.ts`에 있다. Persistent review와 구현 screenshot은 `../../dev/designmotionhq-review/`에 있다.

## Synthesized system

### 1. Intent before tokens

- 사용자, output job, primary object와 primary action을 먼저 정한다.
- 기존 token, CSS variable, component와 가장 많이 재사용된 implementation을 읽은 뒤 gap만 확장한다.
- Type, color, space와 finish 축마다 명시적인 결정을 남긴다.
- 외부 plugin command 이름과 pricing은 design evidence가 아니다.

### 2. Risk through reversal

- Routine mutation은 confirm보다 undo와 soft delete를 우선한다.
- High-cost irreversible mutation만 strong confirmation과 optional hold를 사용한다.
- UI duplicate prevention과 server idempotency는 서로 대체하지 않는다.
- Danger는 happy path와 떨어뜨리고 consequence를 문장으로 쓴다.

### 3. Truthful async state

- Loading, empty, error, partial, offline와 success는 서로 다른 원인과 recovery를 가진다.
- 200ms 미만 작업은 loader를 보이지 않는다.
- Skeleton은 known layout, progress는 known completion, spinner는 unknown duration에만 사용한다.
- Optimistic UI는 reversible action에 한정하고 rollback 또는 draft recovery를 제공한다.
- Artificial typing delay, fake percentage와 spinner-only state는 금지한다.

### 4. Conversational form behavior

- Persistent label과 associated help/error를 유지한다.
- 첫 error 전에는 blur validation, error 이후에는 live validation으로 강화한다.
- Paste, autocomplete, input mode와 keyboard progression을 보존한다.
- OTP, payment card와 rating은 domain-specific composition이며 generic primitive가 아니다.

### 5. Navigation exposes scale

- Search placeholder는 searchable scope를 설명한다.
- Zero result는 recent item, scope change와 filter reset을 제공한다.
- Menu는 collision, Escape, arrows와 typeahead를 지원한다.
- Primary action을 hover-only 또는 mobile-hidden 상태로 만들지 않는다.

### 6. Honest data and recoverable selection

- Numeric data는 tabular figures와 consistent alignment를 사용한다.
- OR within category, AND across categories를 명시하고 result count를 즉시 갱신한다.
- Bulk selection은 empty, partial, full, range, cross-page persistence와 undo를 고려한다.
- Chart axis, form과 color는 data question을 보존해야 한다.

### 7. Capability over device names

- `hover`, pointer precision와 actual container width에 반응한다.
- 입력 방식에 맞는 target과 visible icon보다 넓은 hit area를 유지한다.
- Gesture와 resizable panel은 min, max, snap와 commit threshold를 가진다.
- Pull-to-refresh와 swipe는 genuine touch context에만 사용한다.

### 8. Collaboration begins with conflicts

- Offline queue는 local work를 보존하고 deterministic order로 drain한다.
- Same-field editing은 lock, merge 또는 explicit conflict state를 제공한다.
- Presence는 실제 realtime collaboration이 있을 때만 나타낸다.

### 9. Hierarchy survives real data

- Long filename, URL, mixed-script label와 numeric stress copy로 검증한다.
- Related content는 proximity로 묶고 operational boundary가 필요한 곳의 border는 유지한다.
- Geometric center뿐 아니라 optical center와 perceived area를 확인한다.
- Golden ratio와 fixed type-weight ladder를 universal formula로 사용하지 않는다.

### 10. Material needs a role

- Strong color는 primary action, selection과 semantic status에 제한한다.
- Glass는 opaque fallback에서 읽힌 뒤 fill, rim, backdrop와 shadow를 함께 강화한다.
- Contact shadow와 ambient elevation을 분리하고 repeated row에 복제하지 않는다.
- Generic glass number, 60/30/10 ratio와 decorative angle gradient를 Foundation token으로 자동 승격하지 않는다.

### 11. Motion explains state change

- Pointer press, occasional overlay, disclosure와 real pending state에만 bounded motion을 사용한다.
- Keyboard selection과 navigation은 즉시 반영한다.
- Reduced motion은 position/repeat를 제거하고 completed state를 즉시 표시한다.
- Ripple, bounce, spring와 stagger를 하나의 control에 누적하지 않는다.

### 12. Native CSS stays scoped

- Container query, `:has()`, subgrid, view transition, nesting, `text-wrap`와 anchor positioning을 progressive enhancement로 사용한다.
- `gap`, `clamp`, `isolation`, `place-items`와 `@layer` 같은 browser-owned layout을 먼저 검토한다.
- CSS가 JavaScript, Floating UI 또는 motion library를 완전히 대체한다는 마케팅 주장을 채택하지 않는다.

### 13. User control over persuasion

- Peak-end와 serial position은 workflow clarity에 사용할 수 있다.
- Manufactured incompleteness, decoy pricing, confirm shaming, hidden cost, fake typing, endless scroll와 forced autoplay는 prohibited pattern이다.
- Social proof와 metric은 source, scope와 date를 검증할 수 있을 때만 표시한다.

## Owen-specific resolution

### Focus

검토 source는 2px `:focus-visible` ring을 권장하지만 Owen은 focus-only outline, ring, border, shadow와 lift를 금지한다. Native keyboard semantics는 유지하며 background, text, icon 또는 persistent state 변화로 focus를 식별하고 실제 computed style에서 focus 전후 border, shadow와 outline이 변하지 않는지 확인한다.

### Confirmation

Source의 hold-to-delete를 universal default로 채택하지 않는다. Foundation `ConfirmableAction`의 hold mode는 immediate high-cost permanent mutation에만 사용한다. Pointer, Space/Enter, assistive click, early release, boundary exit, blur, visibility loss, async failure와 explicit success acknowledgement를 모두 보존한다.

### Material

Source의 generic glassmorphism recipe는 scratch input이다. Owen의 `--owen-clear-glass-*` contract와 opaque content rule을 그대로 유지한다.

### Motion

Source의 250–280ms, bounce와 ripple 조합보다 Foundation의 140ms press와 200ms normal timing을 먼저 사용한다. Meaningful overlay만 300ms 이내에서 허용한다.

### Psychology

Persuasion mechanics는 detection과 prohibition 교육에 사용한다. Product conversion optimization recipe로 승격하지 않는다.

## Independent transfer surface

`../ui-foundation-consumer/src/designmotionhq-review.tsx`는 Workbench, 88-item ledger, 13 principles, state lab와 evidence inspector를 구현한다. `../ui-foundation-consumer/src/designmotionhq-specimens.tsx`는 다음 11개 independent specimen을 제공한다.

1. Risk and reversal
2. Upload queue and progress
3. Validation timing and password state
4. Toggle, select and slider
5. Search, tabs and recovery
6. Filter and bulk selection
7. Number, badge and avatar
8. Container reflow and reorder
9. Token, spacing and material
10. Native CSS capability
11. Honest choice and caution case

Source posts의 composition, copy와 visual skin은 transfer surface에 사용하지 않았다.

## Validation

- `npm run typecheck --prefix lib/ui-foundation-consumer`
- `npm run test:e2e --prefix lib/ui-foundation-consumer -- --grep DesignMotionHQ`
- `npm run audit:url --prefix lib/ui-lab -- http://127.0.0.1:4175/?surface=designmotionhq --output ../../dev/temp/ui-audit-designmotionhq`
- Browser desktop/mobile screenshot review
- Three `FrostedScrollArea` owners
- Korean/English copy and accessible names
- Dark, reduced-motion and forced-colors states
- Focus without rim, horizontal overflow and axe checks

The audit proves implemented behavior only. It does not prove creator conversion claims, factual completeness of every three-second interval, or reuse rights for external media.
