---
schema_version: 1
reference_study: true
output_job: "micro collection board and library shelf"
surface: "small mobile content workspace"
evidence: ["user-provided micro ui screenshots", "independent UI Lab transfer specimen"]
confidence: high
axes_covered: ["color", "spacing", "radius", "borders", "shadows", "layout", "hierarchy", "iconography", "imagery", "motion", "interaction"]
unresolved_axes: ["typography"]
allowed_range: "Use for compact collection surfaces with visual previews, quick paste actions, and dock navigation."
counterexample: "Do not apply dotted board and orb action to dense operational tables or long-form settings rows."
transfer_specimen: "lib/ui-lab/src/micro-ui-study.tsx"
---

# Micro UI Reference Study

2026-07-29에 사용자가 제공한 Micro UI 이미지 2장을 분석했다. 목적은 특정 브랜드 아트워크를 복제하는 것이 아니라, Foundation에서 재사용 가능한 구조와 표면 계약을 추출하는 것이다.

## Extracted Pattern

| 관찰 | Foundation 해석 | 채택 범위 |
| --- | --- | --- |
| 상단에는 작은 원형 utility action 두 개와 중앙 제목이 배치됨 | title과 즉시 action의 시선을 분리 | `MicroUiHeader` |
| 메인 작업 영역은 점 패턴 위에 작은 media card가 얹힘 | board는 맥락, card는 실제 콘텐츠를 담당 | `MicroUiDotBoard`, `MicroUiCard` |
| 하단에 링크 확인 + 붙여넣기 명령이 하나의 바 형태로 존재 | copy와 action을 같은 surface에 유지 | `MicroUiLinkComposer` |
| 라이브러리 화면은 가로 스크롤 가능한 커버 선반으로 구성됨 | 커버 미리보기와 짧은 메타를 반복 패턴화 | `MicroUiShelf`, `MicroUiShelfItem` |
| 하단 내비게이션과 보조 + orb action이 함께 존재 | 주 이동은 dock, 생성은 orb action으로 분리 | `MicroUiDock`, `MicroUiDockItem`, `MicroUiOrbAction` |

## Material Contract

- shell은 밝은 neutral canvas와 얕은 shadow를 사용한다.
- dotted board와 content card는 opaque surface를 유지해 텍스트 대비를 확보한다.
- glass는 composer와 dock처럼 직접 조작 면에만 제한 적용한다.
- orb action은 단일 강조 역할로만 사용하고 반복 row의 기본 버튼 스타일로 확장하지 않는다.
- hover와 pressed state는 1px 이동 또는 `scale(0.97)` 수준에서 끝낸다.

## Accessibility Contract

- header action, paste action, dock item, orb action은 각 입력 방식에 맞는 target과 충분한 간격을 유지한다.
- `MicroUiShelf`는 `role="list"`, item은 `role="listitem"`으로 노출해 스크린리더 탐색 순서를 고정한다.
- 현재 위치는 dock item의 `aria-current="page"`로 전달한다.
- 색상은 상태 보조로만 사용하고 의미는 text 또는 icon+text 조합으로 전달한다.
- `prefers-reduced-motion`에서는 hover/pressed 전환을 즉시 반영한다.

## Deliberate Exclusions

- 원본 이미지의 브랜드 이미지, 표지 텍스트, 날짜 표기는 포함하지 않는다.
- 점 패턴을 텍스트 배경 전체에 과도하게 확장하지 않는다.
- orb action을 destructive action 스타일로 재사용하지 않는다.
- 반복되는 대형 카드, 복잡한 데이터 표, 설정 폼 본문에는 이 패턴을 강제하지 않는다.
