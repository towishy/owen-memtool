---
schema_version: 1
reference_study: true
output_job: "explain user-triggered state changes"
surface: "buttons, disclosures, overlays, and pending controls"
evidence: ["public Amicro interaction catalog review", "independent full and reduced-motion UI Lab specimen"]
confidence: high
axes_covered: ["color", "radius", "borders", "shadows", "layout", "hierarchy", "iconography", "motion", "interaction"]
unresolved_axes: ["typography", "spacing", "imagery"]
allowed_range: "Use motion only for copy success, disclosure, occasional overlays, and real pending state."
counterexample: "Do not add decorative entrance sequences, fake progress, or hover-only meaning."
transfer_specimen: "lib/ui-lab/src/micro-interactions-study.tsx"
---

# Reference Study: Micro Interactions

## Source pattern

Amicro의 micro-transition catalog에서 상태 변화가 짧게 보이는 방식과 copy-to-code 탐색 구조를 검토했다. 외부 component code나 motion preset은 복사하지 않았다. Owen UI Foundation에는 이미 140ms press, 200ms 일반 transition, 300ms 미만 overlay, reduced-motion 계약이 있으므로 이 문서는 새 motion system이 아니라 허용 사례의 경계를 정의한다.

## Decision

Micro interaction은 사용자가 방금 일으킨 상태 변화를 설명할 때만 사용한다. 의미가 없는 entrance, 상시 반복 loader, hover-only 장식은 Foundation에 넣지 않는다. 기본 허용 패턴은 아래 4개다.

Rare UI 11개 component를 2026-08-19에 cross-check한 결과 이 경계는 유지한다. 일부 component는 reduced motion과 keyboard/Escape를 제공했지만 hover-only gallery preview, unbounded physics, focus ring, detail-page contrast와 scroll-owner 결함도 확인됐다. 따라서 gooey morph, particle stream, ambient orb, spring navigation을 새 기본 pattern으로 추가하지 않고 아래의 실제 state 변화만 유지한다.

ReactVibe commit `443f6cf`를 2026-09-04에 추가 cross-check했다. Copy-paste catalog와 preview/source 병치 구조는 discovery에는 유용하지만, 무한 scale/path loop, 반복 blur entrance, focus ring, clickable non-button과 Latin-only font 전제는 이 계약과 충돌한다. 각 외부 motion 후보는 code보다 먼저 `purpose`, `trigger`, `duration`, `easing`, `interruptibility`, `static endpoint`, `reduced state`, `dependency cost`를 기록하고 하나라도 빠지면 Foundation 후보로 승격하지 않는다.

| Pattern | State source | Full motion | Reduced motion |
| --- | --- | --- | --- |
| Copy success | Clipboard write가 성공한 결과 | icon과 label을 140ms 안에 한 번 교체 | transform 없이 즉시 교체 |
| Disclosure | native button의 `aria-expanded` 변경 | 본문 높이를 200ms 이내로 전환 | 즉시 열고 닫음 |
| Occasional overlay | 사용자가 연 dialog/sheet | Foundation `ResponsiveOverlay`, 300ms 미만 | positional transform 제거 |
| Pending indicator | 실제 Promise 또는 network request가 미완료인 동안 | 상태 text와 함께 indicator만 반복 | 정적 indicator와 상태 text 유지 |

## Interaction contract

### Copy success

- Clipboard API 또는 동등한 실제 copy 결과가 성공한 뒤에만 `Copied`를 표시한다.
- 실패는 success animation으로 덮지 않고 오류 text로 알린다.
- 성공 상태는 `role="status"` 또는 live region으로 전달한다.
- icon만 바꾸지 않고 text도 함께 바꾼다.

### Disclosure

- trigger는 native `button`, `aria-expanded`, `aria-controls`를 사용한다.
- semantic state는 click 또는 keyboard activation과 동시에 바뀐다. transition 완료를 기다리지 않는다.
- 닫힌 content에는 focusable control을 남기지 않는다.
- 자주 반복하는 table row navigation에는 disclosure motion을 붙이지 않는다.

### Occasional overlay

- dialog/sheet는 `ResponsiveOverlay`를 사용해 Escape, focus trap, trigger focus restore를 유지한다.
- open/close는 사용자가 요청한 때만 실행한다.
- navigation이나 selection을 modal transition으로 지연하지 않는다.

### Pending indicator

- 실제 pending state가 시작될 때 나타나고 Promise가 resolve/reject되면 사라진다.
- `Checking sources`, `Saving review`처럼 작업 이름을 text로 제공한다. Spinner 하나만 두지 않는다.
- determinate progress를 알 수 없을 때 percentage나 진행 bar를 꾸며내지 않는다.
- 장식용 무한 loop와 자동 실행 loader gallery를 만들지 않는다.

## Visual decisions

- motion은 opacity와 작은 transform 또는 disclosure track에만 제한한다.
- button, status, disclosure panel은 8px 이하 radius와 semantic surface를 유지한다.
- success, pending, error는 icon과 text를 함께 사용하고 색상에만 의존하지 않는다.
- glass는 overlay boundary처럼 깊이가 필요한 곳에만 사용한다.
- rounded surface에 왼쪽 accent rail을 붙이지 않는다.

## Accessibility contract

- OS `prefers-reduced-motion`과 제품의 explicit reduced-motion mode를 모두 지원한다.
- keyboard activation, focus 이동, `aria-expanded`, pending/complete state는 motion과 무관하게 즉시 반영한다.
- focus는 control의 native semantics를 유지하며 소비 앱의 focus 정책을 따른다.
- pending button은 중복 실행을 막고 현재 작업을 accessible status로 노출한다.
- full/reduced mode 모두 axe, keyboard, narrow viewport, dark theme에서 검증한다.

## When not to use

- 첫 화면의 모든 card를 순차 등장시키는 장식
- 실제 작업과 연결되지 않은 progress, shimmer, spinner
- keyboard 탐색마다 실행되는 slide/fade
- hover가 없으면 의미나 상태를 알 수 없는 control
- 상태 변화보다 긴 animation 또는 사용자의 다음 입력을 막는 transition

## Foundation mapping

| Pattern | Foundation or platform API |
| --- | --- |
| Copy command | `ActionButton` + Clipboard API + live status |
| Disclosure | native button + `aria-expanded` |
| Overlay | `ResponsiveOverlay` |
| Pending command | `ActionButton`/native disabled state + explicit async status |

실제 조합과 full/reduced-motion 검증은 `../ui-lab/src/micro-interactions-study.tsx`와 `../ui-lab/tests/ui-lab.spec.ts`에서 확인한다.
