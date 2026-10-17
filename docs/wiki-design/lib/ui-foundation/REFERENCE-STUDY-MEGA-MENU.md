---
schema_version: 1
reference_study: true
output_job: "help users scan and choose among many product, resource, or company destinations without hiding the information architecture in a narrow dropdown"
surface: "desktop SaaS navigation with many destinations and a mobile disclosure or drill-in equivalent"
evidence: ["public Threads thread by uiadrian, DcJCp1SGvA4, reply 5 and its 13.9-second mega-menu video reviewed in the VS Code integrated browser on 2026-08-18", "start, midpoint, and end frames captured from the public video", "author caption describing grouped links for content-heavy sites"]
confidence: medium
axes_covered: ["typography", "color", "spacing", "radius", "borders", "shadows", "layout", "hierarchy", "iconography"]
unresolved_axes: ["imagery", "motion", "interaction"]
allowed_range: "Use when one navigation category contains enough distinct destinations that a single vertical list is slower to scan. Group links by user intent or domain, keep one optional evidence/featured rail, and provide a narrow-screen disclosure or drill-in path."
counterexample: "Do not use for a small navigation set, routine app commands, a site map disguised as a popup, hover-only access, or equal visual emphasis on every destination."
transfer_specimen: "pending"
---

# Reference Study: Mega Menu Navigation

## Source observation

[@uiadrian의 Threads thread](https://www.threads.com/@uiadrian/post/DcJCp1SGvA4) 다섯 번째 작성자 리플은 15개 이상의 페이지를 가진 SaaS·콘텐츠 사이트에서 작은 dropdown 대신 grouped links를 넓은 panel에 배치하는 Mega Menu를 제안한다. 공개 영상은 상단 navigation trigger 아래에 여러 link group과 한 개의 featured/content 영역을 펼치고, 배경의 product proof와 customer card는 그대로 유지한다.

`15+ pages`와 conversion 향상은 작성자의 실무 주장이고 독립 측정 근거가 제시되지 않았다. Foundation에서는 고정 임계값이나 conversion 사실로 채택하지 않고, **한 category의 목적지가 한 열에서 스캔하기 어려운가**를 사용 조건으로 삼는다.

## Decision

Mega Menu는 Foundation component가 아니라 medium-confidence reference composition으로 추가한다. 실제 소비 앱 두 곳에서 같은 navigation state와 mobile behavior가 검증되기 전에는 public API를 만들지 않는다.

| Source signal | Foundation transfer | Deliberate correction |
| --- | --- | --- |
| 넓은 panel 안의 grouped links | group heading + semantic link list | 모든 링크를 card나 pill로 만들지 않음 |
| 메뉴 아래 제품·사람 evidence가 보임 | optional featured/evidence rail 1개 | 광고 carousel이나 자동 전환 금지 |
| 빠른 category 이동 | stable trigger와 concise group labels | hover-only open 금지 |
| 큰 dropdown이 page hierarchy를 한 번에 노출 | desktop scan surface | mobile에서 desktop grid 축소 금지 |

## Information architecture

- link group은 조직 내부 분류가 아니라 사용자 목적, product family, workflow 또는 resource type을 따른다.
- 한 group에는 짧은 heading과 semantic `<ul>`/`<a>` 목록을 사용한다.
- featured rail은 destination 선택에 필요한 실제 정보가 있을 때 한 개만 둔다. 최근 글, 현재 status, 대표 workflow처럼 label이 정확해야 한다.
- primary destinations와 reference destinations의 위계를 font weight, position, concise description으로 구분한다. 모두 같은 크기와 색으로 처리하지 않는다.
- 메뉴 안에 card를 중첩하거나 각 link에 독립 shadow·glass·gradient를 반복하지 않는다.

## Interaction contract

- trigger는 native `button`이며 `aria-expanded`와 `aria-controls`를 즉시 갱신한다.
- pointer click, Enter, Space로 열고 Escape, outside dismissal, route selection으로 닫는다.
- close 뒤에는 trigger로 focus를 복원한다. Foundation의 no-focus-rim 정책을 유지하되 keyboard focus semantics와 현재 위치는 이름·상태·surface 변화로 판별 가능해야 한다.
- ordinary site links에는 `role="menu"`를 강제하지 않는다. semantic navigation과 link list가 기본이다.
- hover는 이미 열린 menu 안에서 optional preview를 바꿀 수 있지만, open·selection·description의 유일한 경로가 될 수 없다.
- route change가 아닌 단순 pointer movement에 panel 전체 transition을 반복하지 않는다.

## Visual contract

- panel boundary와 trigger에는 Clear Glass를 검토할 수 있지만 link body는 opaque surface를 기본으로 한다.
- outer panel radius는 8px, 1px boundary, broad low-alpha shadow를 사용한다.
- desktop은 2~4개 link group과 optional evidence rail을 명확한 grid track으로 고정한다.
- link target은 입력 방식과 메뉴 밀도에 맞게 유지하고 letter spacing은 0이다.
- icon은 category를 빠르게 식별할 때만 사용하며 모든 link에 서로 다른 색 icon을 붙이지 않는다.
- open/close는 200ms 안의 opacity·small translate만 허용한다. reduced motion에서는 즉시 최종 상태로 바꾼다.

## Responsive contract

- narrow viewport에서는 desktop panel을 축소하지 않는다.
- top-level category를 in-flow disclosure 또는 full-width drill-in으로 전환한다.
- group heading과 link DOM/read order를 desktop과 동일하게 유지한다.
- featured rail은 primary navigation 뒤로 이동하거나 제거하되 destination link를 숨기지 않는다.
- sticky app navigation과 겹칠 경우 overlay 높이를 bounded scroll area로 제한하고 `FrostedScrollArea`를 사용한다.

## Foundation mapping

| Need | Foundation or platform owner |
| --- | --- |
| shell toolbar/navigation | `WorkbenchShell` 또는 소비 앱의 site header |
| desktop panel / narrow sheet | app-owned navigation + `ResponsiveOverlay`는 modal/sheet가 필요한 경우만 |
| overflow | `FrostedScrollArea` |
| async featured content | `AsyncState` |
| current status | `StatusBadge` 또는 semantic text |

`ResponsiveOverlay`를 모든 desktop mega menu의 구현으로 강제하지 않는다. Desktop navigation popover의 positioning·dismissal engine은 소비 앱이 선택하되 위 semantic contract를 유지한다.

## Validation before promotion

- desktop click, keyboard, Escape, outside dismissal, route selection, focus restore
- mobile disclosure/drill-in과 DOM/read order
- 200% zoom과 long Korean/English labels의 overflow
- dark theme, forced colors, reduced motion
- current-route indication이 색상에만 의존하지 않는지 확인
- two product consumers에서 같은 state contract를 직접 사용한 뒤 public API 승격 검토

## Evidence boundary

- Threads 영상과 agency 사례의 브랜드·copy·customer imagery·layout 좌표를 복제하지 않는다.
- “highest-converting”, “boosts readability”, “15+ pages”는 작성자 주장이다. 독립 analytics, 실험 설계, baseline이 없어 일반 성과 사실로 기록하지 않는다.
- 공개 리플 중 확인 가능한 외부 반응은 “Looks super clean”이라는 호평 1건뿐이며 usability나 conversion 검증이 아니다.
