---
schema_version: 1
reference_study: true
output_job: "graph-based workflow editing"
surface: "desktop workflow builder workbench"
evidence: ["2 user-provided workflow automation screenshots", "independent xyflow UI Lab specimen"]
confidence: high
axes_covered: ["color", "spacing", "radius", "borders", "shadows", "layout", "hierarchy", "iconography", "imagery", "interaction"]
unresolved_axes: ["typography", "motion"]
allowed_range: "Apply to graph editors that separate navigation, canvas tools, mutation commands, and execution evidence."
counterexample: "Do not use the canvas composition for linear forms or place data tables inside graph nodes."
transfer_specimen: "lib/ui-lab/src/workflow-builder-study.tsx"
---

# Workflow Builder Reference Study

2026-07-26에 사용자가 제공한 workflow automation 앱 이미지 2개에서 반복 가능한 편집기 구조와 상태 계약을 추출한 기록이다. 특정 브랜드, 채용 workflow, 문구, 로고를 복제하지 않고 graph 기반 업무 자동화 도구에 재사용할 수 있는 composition만 Owen UI Foundation에 반영한다.

## Extracted Pattern

| 관찰 | Foundation 해석 | 채택 범위 |
| --- | --- | --- |
| 앱 sidebar와 여러 workflow 문서 tab이 동시에 보임 | 앱 탐색과 편집 문서 전환의 책임을 분리 | `WorkflowBuilderSidebar`, `WorkflowBuilderTabList`, `WorkflowBuilderTab` |
| 점 격자 canvas 중앙에 위→아래 node 흐름이 있음 | graph 엔진과 무관한 시각·의미 node composition 제공 | `WorkflowBuilderCanvas`, `WorkflowBuilderNode` |
| Start, Action, Decision, Condition이 text badge로 구분됨 | 색은 보조 신호이고 node type label이 의미를 보존 | `WorkflowBuilderNodeTone`, `badge` |
| Decision 뒤 두 갈래가 합류함 | branch group이 split/stack 관계를 명시 | `WorkflowBuilderBranch` |
| canvas 왼쪽에는 zoom/fit 도구, 오른쪽에는 편집/실행 명령 | 탐색 도구와 workflow mutation을 별도 toolbar/group으로 제공 | `WorkflowBuilderToolbar`, `WorkflowBuilderActions` |
| 추천 카드가 canvas 위에 떠 있고 단일 Optimize 명령을 가짐 | 현재 graph를 보조하는 contextual overlay로만 glass 허용 | `WorkflowBuilderSuggestion` |
| canvas 아래에 입력/실행 데이터 표가 붙음 | graph와 실행 근거를 같은 workbench에서 가까이 비교 | `WorkflowBuilderDataPreview` + `OperationalDataTable` |

## Composition Contract

- Sidebar, tabs, node, data preview는 불투명 neutral surface를 사용한다.
- Canvas는 dotted grid를 사용할 수 있지만 node text와 connector를 방해할 만큼 진하게 만들지 않는다.
- Node는 header, short description, optional footer의 세 영역만 제공한다. 긴 form이나 중첩 card는 inspector/overlay로 분리한다.
- Start, Action, Decision, Condition, Success tone은 badge에만 적용하고 node 전체를 한 색으로 채우지 않는다.
- Recommendation은 현재 workflow와 공간적으로 연결된 단일 contextual overlay이며 한 viewport에 하나만 둔다.
- Sample data는 `OperationalDataTable`을 재사용하고 별도 table primitive를 만들지 않는다.
- 좁은 폭에서는 sidebar를 축약하거나 숨기고 canvas는 내부 scroll을 소유한다. node를 읽을 수 없게 축소하지 않는다.

## Accessibility Contract

- Canvas와 toolbar, action group, branch, data preview는 모두 필수 accessible label을 갖는다.
- Node와 suggestion은 title로 labeling된 article/aside landmark를 사용한다.
- Document tab은 `aria-selected`를 노출하고 Left/Right/Home/End로 포커스를 이동한다.
- Icon-only canvas tools와 dismiss action은 accessible name을 요구한다.
- Node type과 branch 결과를 색만으로 표현하지 않는다.
- 모든 새 control은 focus 전용 outline, ring, border, shadow, lift를 추가하지 않는다.
- 실제 graph editor는 keyboard node 이동, connector 생성, undo/redo, selection announcement를 별도 구현해야 한다.

## Graph Engine Integration

- `WorkflowBuilderGraphViewport`는 실제 graph 엔진이 마운트되는 크기·overflow·접근성 경계다.
- Foundation은 `.react-flow` 호환 edge, handle, selected node 상태를 제공하지만 node position이나 edge routing state는 소유하지 않는다.
- UI Lab reference specimen은 `@xyflow/react`로 zoom, fit, pan, node selection, drag, edge tracking을 검증한다.
- 선택 상태는 `data-selected="true"`로 전달한다. 이는 focus 상태와 분리되며 focus 전용 ring, border, shadow를 만들지 않는다.

## Deliberate Exclusions

- Foundation package 자체는 drag-and-drop, graph layout, edge routing, execution engine, autosave, collaboration state를 구현하지 않는다. 소비 앱은 검증된 graph engine을 `WorkflowBuilderGraphViewport` 안에 통합한다.
- 특정 채용 데이터, 모델명, 레코드 수, 회사 logo, navigation 문구를 API에 포함하지 않는다.
- node마다 floating shadow를 반복하거나 canvas 전체를 glass로 만들지 않는다.
- screenshot의 작은 글자 크기와 낮은 대비를 재현하지 않는다.
- 데이터 표는 canvas node 안에 넣지 않는다.
