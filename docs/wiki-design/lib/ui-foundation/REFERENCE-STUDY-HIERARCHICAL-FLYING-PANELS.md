---
schema_version: 1
reference_study: true
output_job: "navigate deep hierarchy without replacing the primary work context"
surface: "connected primary and secondary flying panels over a quiet workspace"
evidence: ["Owen MDBOX 0.3.17 folder flying panel implementation", "independent interactive UI Lab transfer specimen"]
confidence: medium
axes_covered: ["typography", "color", "spacing", "radius", "borders", "shadows", "layout", "hierarchy", "iconography", "motion", "interaction"]
unresolved_axes: ["imagery"]
allowed_range: "Use for bounded hierarchical navigation where an anchor opens a primary index, one secondary panel owns deeper drill, and only one pinned panel may move over the workplane."
counterexample: "Do not create an unlimited cascade of panels, move an unpinned panel, or use flying panels for linear forms and ordinary navigation."
transfer_specimen: "lib/ui-lab/src/hierarchical-flying-panels-study.tsx"
---

# Hierarchical Flying Panels Reference Study

Owen MDBOX 0.3.17의 폴더 탐색 구현에서 검증한 1차·2차 플라잉 패널, 단일 고정, 헤더 이동, 크기 조절 계약을 앱과 분리해 일반화한 기록이다. 폴더 이름, 문서 수, 앱별 breakpoint와 치수를 복제하지 않고 깊은 계층을 현재 작업 문맥 위에서 탐색하는 composition만 Foundation에 남긴다.

이 패턴은 현재 Owen MDBOX 한 제품에서만 운영 검증되었으므로 공용 React component가 아닌 reference composition이다. 두 번째 제품에서 같은 상태 모델과 responsive 계약이 반복될 때 public API 승격을 검토한다.

## Output Job

사용자는 현재 문서·그래프·검토 화면을 떠나지 않고 다음을 수행한다.

1. 안정된 sidebar 또는 tree anchor에서 최상위 범위를 선택한다.
2. 1차 패널에서 직접 항목과 다음 하위 범위를 확인한다.
3. 2차 패널에서 검색·정렬·페이지 탐색과 3단계 이상 deep drill을 이어간다.
4. drag/drop 또는 비교 작업이 필요하면 한 패널만 고정해 작업면 위에서 옮긴다.
5. 명시적 닫기 또는 선택 완료로 overlay 문맥을 종료한다.

## State Model

| 상태 | 보이는 surface | 핵심 계약 |
| --- | --- | --- |
| Closed | anchor와 workplane | 패널 상태가 본문 layout을 영구 밀어내지 않는다. |
| Primary | 1차 패널 | anchor와 공간적으로 연결되고 최상위 index 또는 직접 항목을 보여 준다. |
| Primary + Secondary | 연결된 1차·2차 패널 | 2차는 약간 아래로 offset되어 깊이를 설명하고 4–8px 시각 간격을 유지한다. |
| Secondary drilled | 같은 2차 패널 | 3단계 이상은 새 패널을 더 만들지 않고 title, breadcrumb/meta, back 명령을 갱신한다. |
| Pinned primary/secondary | 선택한 패널 1개 | 다른 패널을 닫고 선택한 패널만 workplane 위에 남긴다. |
| Moving | pinned panel 1개 | header drag로만 이동하며 workspace boundary 안에 clamp한다. |
| Narrow | in-flow primary/secondary | 이동·resize를 제거하고 disclosure 또는 sheet처럼 읽는 순서에 맞게 쌓는다. |

## Composition Contract

### 1차 패널

- 1차 패널은 stable navigation anchor에서 열리며 anchor 선택 상태와 `aria-expanded`를 동기화한다.
- 최상위 범위의 하위 폴더 또는 다음 drill target을 먼저 보여 준다. 긴 hierarchy 전체를 sidebar에 다시 펼치지 않는다.
- 직접 문서만 있는 범위에서는 같은 패널이 검색 가능한 document browser로 전환될 수 있다.
- header는 icon, title, 짧은 meta, pin, close 순서를 유지한다. 모든 icon command는 입력 방식과 밀도에 맞는 target과 accessible name을 갖는다.

### 2차 패널

- 2차 패널은 1차 선택과 연결된 다음 깊이를 담당한다. 1차와 맞닿게 겹치지 않고 작은 gap과 12–20px 수직 offset으로 계층을 설명한다.
- 3단계 이상 deep drill은 2차 패널 내부에서 수행한다. panel cascade를 세 번째, 네 번째로 늘리지 않는다.
- deep state에는 title/path meta와 명시적 back command가 필요하다.
- 긴 항목은 검색, 정렬, pagination 또는 virtualization을 소비 앱에서 제공한다. Foundation pattern은 데이터 엔진을 소유하지 않는다.

### 고정

- pin은 `aria-pressed`를 가진 명시적 toggle command다. hover만으로 고정하거나 패널을 붙잡지 않는다.
- 한 workspace에는 pinned flying panel을 한 개만 허용한다. 1차를 고정하면 2차를 닫고, 2차를 고정하면 1차를 닫는다.
- 고정 해제는 기본 연결 위치와 기본 크기로 돌아가는 예측 가능한 reset 경로를 제공한다.
- 고정은 drag/drop, 비교, workplane과 패널을 오가는 반복 작업을 위한 opt-in 상태다. 일반 탐색의 기본값이 아니다.

### 이동과 크기 조절

- 이동은 pinned panel의 비어 있는 header 영역에서만 시작한다. header 안의 button, input, link activation은 drag를 시작하지 않는다.
- pointer capture를 사용하고 이동 좌표를 workspace 내부 8px 안전 여백에 clamp한다. viewport 밖으로 title과 close command가 사라지게 두지 않는다.
- resize는 우측 하단에 발견 가능한 handle로 제공하고 최소 폭·높이와 workspace 최대 경계를 지킨다.
- double-click reset 또는 동등한 명시적 reset을 제공한다. narrow layout에서는 move/resize를 숨기고 surface를 in-flow로 되돌린다.

## Visual Contract

- workplane과 반복 row는 opaque surface를 유지한다. 패널 전체를 과도하게 투명하게 만들어 배경 문서가 비치지 않게 한다.
- panel radius는 기본 8px, 내부 row는 divider로 분리하며 row마다 card와 shadow를 반복하지 않는다.
- elevation은 1px border, 넓고 낮은 shadow, 얕은 top reflection 순서로 표현한다. 2차는 1차보다 한 단계만 높다.
- header는 거의 흰 mint/neutral tint를 사용할 수 있지만 title과 meta는 AA 대비를 유지한다.
- pin 활성 상태는 icon, `aria-pressed`, surface 변화로 함께 전달한다. 색만으로 고정을 설명하지 않는다.
- rounded panel에 vertical accent rail을 붙이지 않는다.

## Interaction and Close Rules

- 같은 primary row를 다시 선택하면 연결된 secondary를 닫을 수 있다.
- close command는 1차와 2차 각각 제공한다. 1차 닫기는 연결된 2차와 pin 상태도 종료한다.
- 항목 선택으로 작업이 시작되면 기본적으로 패널을 닫는다. pinned 상태를 유지해야 하는 제품은 그 차이를 visible status로 설명한다.
- `Escape`는 이동·resize session을 먼저 취소하고, 그다음 가장 위의 unpinned panel을 닫는다.
- panel 사이 pointer 이동만으로 닫지 않는다. hover corridor와 timing에 의존한 dismissal은 금지한다.
- keyboard activation과 `aria-expanded`, `aria-pressed`, breadcrumb 변경은 motion 완료를 기다리지 않고 즉시 반영한다.

## Responsive Contract

- desktop은 anchor → 1차 → 2차의 공간 관계를 보존한다. 폭이 부족하면 panel 자체 글자와 target을 줄이지 말고 2차를 workplane 아래 또는 in-flow stack으로 전환한다.
- narrow layout에서는 resize handle과 header drag를 제거한다. pin은 in-flow disclosure 유지 또는 명시적 sheet 전환으로 해석한다.
- panel width를 유지하기 위해 page 전체 horizontal scroll을 만들지 않는다.
- mobile에서도 title, back, pin/close의 touch-appropriate target과 읽는 순서를 유지한다.

## Accessibility Contract

- anchor는 tree 또는 navigation semantics를 유지하고 현재 상태를 `aria-current` 또는 `aria-expanded`로 노출한다.
- 각 panel은 고유한 accessible name을 가진 region 또는 제품 문맥에 맞는 non-modal surface다. 단순 overlay를 modal dialog로 오표현하지 않는다.
- back, pin, close, resize는 icon-only라도 accessible name과 tooltip/title을 제공한다.
- focus-only outline, ring, border, shadow는 만들지 않는다. keyboard focus는 background, icon, text 등 non-rim surface 변화로 식별한다.
- 이동과 resize는 pointer-only 편의 기능이다. 모든 핵심 탐색과 닫기, pin toggle에는 keyboard 경로가 있어야 한다.
- forced colors에서는 translucency와 shadow를 제거하고 Canvas/CanvasText border로 panel boundary를 유지한다.

## Deliberate Exclusions

- Foundation은 폴더 store, filesystem drag/drop, document loading, search index, pagination, virtualization을 구현하지 않는다.
- 세 개 이상의 cascading panel, hover-open cascade menu, 자유 배치 dashboard card에는 이 패턴을 사용하지 않는다.
- panel이 workplane의 primary command나 destructive confirmation을 영구적으로 가리지 않게 한다.
- pinned position과 size를 기기 간 설정으로 자동 동기화하지 않는다. persistence는 소비 앱의 명시적 요구가 있을 때만 추가한다.

## Evidence and Transfer

- 운영 evidence: `owen-mdbox/desktop/wiki-public/wiki.js`, `wiki.css`, `index.html`의 folder flying panel과 `tests/e2e/app.spec.ts`의 desktop/mobile 회귀 계약.
- 독립 transfer specimen: `../ui-lab/src/hierarchical-flying-panels-study.tsx`.
- focused validation: `../ui-lab/tests/ui-lab.spec.ts`의 `hierarchical flying panels connect, drill, pin, move, and collapse`.

UI Lab specimen은 folder product copy를 복제하지 않고 generic evidence workspace를 사용한다. 1차·2차 연결, deep drill, 단일 pin, bounded header drag, narrow in-flow 전환만 검증한다.