---
schema_version: 1
reference_study: true
output_job: "prompt initiation and saved-result retrieval"
surface: "mobile assistant home and collection views"
evidence: ["user-provided mobile assistant screenshots", "independent UI Lab assistant specimen"]
confidence: high
axes_covered: ["color", "spacing", "radius", "borders", "shadows", "layout", "hierarchy", "iconography", "imagery", "motion", "interaction"]
unresolved_axes: ["typography"]
allowed_range: "Apply to assistant surfaces with immediate intents, a focused composer, and compact saved-result rows."
counterexample: "Do not turn every row into glass or use animated multicolor glow as the primary state signal."
transfer_specimen: "lib/ui-lab/src/mobile-assistant-study.tsx"
---

# Mobile Assistant Reference Study

2026-07-25에 사용자가 제공한 모바일 AI assistant 이미지의 홈 화면과 저장 목록 화면을 분석한 기록이다. 특정 제품의 문구, 자산, 화면을 복제하지 않고 반복 가능한 구조, 표면, 상태 계약만 Owen UI Foundation에 반영한다.

## Extracted Pattern

| 관찰 | Foundation 해석 | 채택 범위 |
| --- | --- | --- |
| 첫 화면이 큰 질문과 3~4개의 짧은 추천 명령으로 시작함 | 설명보다 즉시 실행 가능한 intent를 먼저 제시 | heading, supporting copy, `MobileAssistantSuggestion` |
| 추천 행마다 작은 아이콘과 한 줄 보조 설명이 있음 | 아이콘은 탐색 속도를 높이고 text가 의미를 보존 | `icon`, `title`, `description`, `tone` |
| 입력 surface가 본문과 분리되어 하단에 떠 있음 | composer는 현재 행동의 초점이므로 제한된 glass와 pastel halo 허용 | `MobileAssistantComposer` |
| 주요 화면 전환이 하단 dock에 고정됨 | icon과 label을 함께 유지하고 현재 위치를 의미론적으로 표시 | `MobileAssistantDock`, `aria-current="page"` |
| 저장 목록은 thumbnail, 제목, 설명, category, 시간 순서로 압축됨 | 반복 항목은 작은 불투명 row로 유지하고 metadata 위계를 고정 | `MobileAssistantCollectionItem` |
| 전체 화면은 거의 무채색이고 아이콘에만 얕은 pastel이 있음 | 색은 기능군을 구분하는 보조 신호이며 text를 대체하지 않음 | mint, warm, violet, sky, neutral tone |

## Material Contract

- Shell, list row, collection item은 밝은 중립 surface와 얇은 경계를 기본으로 한다.
- Glass는 composer, bottom dock, 원형 utility action에만 사용한다.
- Composer의 다색 halo는 얕은 sky/violet 반사로 제한하며 resting surface를 채색하지 않는다.
- 반복 row는 `--owen-radius-panel`을 사용한다. 큰 radius는 device shell, composer, dock처럼 외곽 boundary 또는 command surface에만 허용한다.
- Hover는 1px 상승과 부드러운 하단 shadow만 사용한다. 선택과 navigation은 즉시 반영한다.
- 좁은 container에서는 thumbnail과 여백을 줄이고 부가 metadata를 숨기되 제목, 설명, accessible name은 유지한다.

## Accessibility Contract

- 추천 intent는 `button`이며 제목이 accessible name에 포함된다.
- Composer input은 시각 label 유무와 관계없이 `label` prop으로 accessible name을 요구한다.
- Dock은 필수 navigation label을 받고 현재 item은 `aria-current="page"`를 사용한다.
- Icon은 장식으로 처리하고 의미는 인접 text 또는 action의 accessible name이 담당한다.
- 모든 직접 action은 touch 입력에 맞는 target과 충분한 간격을 유지한다. Keyboard focus는 background, text, icon 변화로만 표현하며 outline, ring, border, inset/outer shadow를 생성하지 않는다.
- `prefers-reduced-motion`에서는 suggestion의 이동과 scale feedback을 제거한다.
- Forced colors에서는 glass와 pastel을 제거해 system border, Canvas, CanvasText로 환원한다.

## Deliberate Exclusions

- 특정 avatar, 사진, 카테고리 문구, navigation 이름은 포함하지 않는다.
- 모든 card를 glass로 만들거나 pastel로 채색하지 않는다.
- 입력 surface의 무지개 glow를 강한 gradient나 지속 animation으로 확대하지 않는다.
- 아이콘만으로 중요한 intent나 navigation 의미를 전달하지 않는다.
- device status bar와 하드웨어 frame은 제품 component가 아니며 Foundation API에 포함하지 않는다.
