---
schema_version: 1
reference_study: true
output_job: "daily task scanning and completion"
surface: "mobile task home and detail views"
evidence: ["2 user-provided mobile task screenshots"]
confidence: medium
axes_covered: ["typography", "color", "spacing", "radius", "borders", "shadows", "layout", "hierarchy", "iconography", "imagery", "interaction"]
unresolved_axes: ["motion"]
allowed_range: "Apply to personal task dashboards with compact metrics, native completion controls, and one create command."
counterexample: "Do not infer collaboration, persistence, upload, reminder, or drag-reorder behavior from the static references."
transfer_specimen: "pending"
---

# Mobile Task Dashboard Reference Study

2026-07-26에 사용자가 제공한 모바일 작업 관리 홈·상세 이미지 2개에서 반복 가능한 정보 구조와 상호작용 계약을 추출한 기록이다. 특정 브랜드, 문구, 로고, 기기 프레임을 복제하지 않고 개인 작업 대시보드에 재사용할 수 있는 패턴만 Owen UI Foundation에 반영한다.

## Extracted Pattern

| 관찰 | Foundation 해석 | 채택 범위 |
| --- | --- | --- |
| 홈 첫 화면이 2×2 지표와 짧은 작업 목록으로 구성됨 | 하루 상태를 스캔한 뒤 바로 완료 처리하는 흐름 | `MobileTaskMetricGrid`, `MobileTaskMetric`, `MobileTaskItem` |
| 작업 행은 완료 원, 우선순위, 시간, 제목, 설명 순서 | 상태와 일정은 제목보다 작게 두되 text로 의미 보존 | native checkbox, priority tone, metadata, description |
| 상세 화면은 핵심 속성 뒤에 segmented section을 배치 | 정보 구조를 한 화면에 쌓지 않고 하위 작업·상세·댓글로 전환 | `MobileTaskTabs`, `MobileTaskTab` |
| 하위 작업은 한 줄 checkbox row이고 우측에 보조 메뉴가 있음 | checkbox label과 menu action의 DOM 책임을 분리 | `MobileTaskChecklistItem` |
| 첨부는 파일 형식 색상, 제목, 용량으로 압축됨 | 색상은 형식 식별의 보조 신호이며 제목이 accessible name 담당 | `MobileTaskAttachment` |
| 하단 dock 옆에 단일 원형 생성 action이 있음 | navigation과 create command를 시각·의미적으로 분리 | `MobileTaskDock`, `MobileTaskPrimaryAction` |
| 상세 하단에 avatar, 입력, 전송이 한 줄로 고정됨 | 댓글 작성은 독립 command surface이며 glass 허용 | `MobileTaskComposer` |

## Material Contract

- Shell은 차가운 중립 canvas와 얕은 sky/mint 반사를 사용하되 실제 content surface는 불투명하게 유지한다.
- 지표, 작업 행, 하위 작업, 첨부는 `--owen-radius-panel`과 얇은 border를 사용한다.
- Glass는 shell 경계, 원형 utility action, bottom dock, comment composer에만 제한한다.
- 우선순위는 urgent coral, normal blue, neutral gray로 구분하고 항상 text label을 함께 표시한다.
- Primary create action은 한 화면에 하나만 사용하고 dock과 분리된 원형 command로 유지한다.
- Metric value는 tabular numeral을 사용하며 label과 metadata보다 분명한 위계를 갖는다.

## Accessibility Contract

- 완료 상태와 하위 작업은 native checkbox로 제공하고 명확한 label을 요구한다.
- Metric과 attachment는 제목으로 labeling된 article이며 숫자나 색상만으로 의미를 전달하지 않는다.
- Segmented tab은 `aria-selected`를 노출하고 Left/Right/Home/End로 포커스를 이동한다.
- Dock은 navigation label과 `aria-current="page"`를 사용한다.
- 원형 create, utility, trailing action은 accessible name을 요구한다.
- 새 control은 focus 전용 outline, ring, shadow, border, lift를 추가하지 않는다.
- Forced colors에서는 tint와 glass를 제거하고 system border와 Highlight 상태로 환원한다.

## Deliberate Exclusions

- 특정 로고, task count, 사람 이름, 날짜, 첨부 파일명은 Foundation API에 포함하지 않는다.
- device status bar, hardware frame, 손이 보이는 제품 사진은 product component가 아니다.
- drag reordering, reminders, assignment picker, file upload, comment persistence는 presentation composition에 넣지 않는다.
- 모든 surface를 glass로 만들거나 metric card 안에 또 다른 card를 중첩하지 않는다.
- 긴급도를 priority 색상만으로 전달하지 않는다.
