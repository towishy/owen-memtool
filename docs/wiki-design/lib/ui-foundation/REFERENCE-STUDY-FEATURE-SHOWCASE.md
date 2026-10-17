---
schema_version: 1
reference_study: true
output_job: "explain a small set of product capabilities with self-contained UI previews and concise supporting copy"
surface: "editorial product feature section, onboarding explanation, or pattern documentation"
evidence: ["user-provided 1024x768 feature-showcase screenshot", "NameThatUI public site and methodology reviewed 2026-07-31", "stored source and transfer captures", "independent UI Lab transfer specimen"]
confidence: high
axes_covered: ["typography", "color", "spacing", "radius", "borders", "shadows", "layout", "hierarchy", "iconography", "imagery", "motion", "interaction"]
unresolved_axes: []
allowed_range: "Use for 2-6 capabilities whose value can be understood through an inert UI miniature, a short title, and one concise description. Wide containers may use three columns; narrow containers must reflow to two or one."
counterexample: "Do not use this composition for dense operational data, settings rows, long-form documentation, interactive demos, or claims that cannot be shown honestly in the preview."
transfer_specimen: "lib/ui-lab/src/feature-showcase-study.tsx"
---

# Feature Showcase and UI Vocabulary Reference Study

2026-07-31에 사용자가 제공한 1024x768 이미지와 [NameThatUI](https://namethatui.com/)를 함께 분석했다. 목적은 원본 브랜드나 화면을 복제하는 것이 아니라, 기능을 짧은 UI miniature로 먼저 보여주고 정확한 UI 용어로 설명하는 재사용 가능한 Foundation 계약을 만드는 것이다.

## Visual Evidence

### NameThatUI home

![NameThatUI 홈 화면의 질문형 제목, 검색, 플랫폼 필터, UI 용어 specimen grid](D:/GITHUB/wiki/lib/ui-foundation/reference-assets/name-that-ui-home-desktop.png)

외부 사이트 캡처는 정보 구조와 용어 연구를 위한 비제품 자산이다. 원본 문구, 브랜드, specimen, 구현 코드는 Foundation이나 소비 앱에 복제하지 않는다.

### Independent transfer specimen

![검토 큐, 저장 확인, 맥락 첨부를 보여주는 Owen UI Foundation Feature Showcase](D:/GITHUB/wiki/lib/ui-foundation/reference-assets/feature-showcase-transfer-desktop.png)

이 이미지는 첨부 레퍼런스의 구조만 옮긴 독립 구현이다. 원본의 Quick save, Stack, Maya, Library 문구와 시각 자산은 사용하지 않았다.

## Attached Image Analysis

첨부 이미지는 하나의 중앙 제목 아래에 같은 폭의 preview stage 세 개를 배치하고, 각 stage 바깥에 제목과 2-3줄 설명을 둔다.

| 관찰 | 해석 | Foundation 전이 |
| --- | --- | --- |
| 약 292x263px의 밝은 중립 stage 3개가 한 줄에 놓임 | 설명보다 실제 UI 형태를 먼저 인식시킴 | `FeatureShowcaseItem.preview`와 약 `1.1:1` 비율 |
| 메뉴, 상태 확인, 댓글 composer가 stage 중앙에 작게 떠 있음 | 한 stage는 한 기능과 한 상태만 설명 | 소비 앱이 소유하는 inert miniature 1개 |
| 제목과 설명이 stage 밖에 있음 | visual evidence와 해석 copy를 분리 | item의 `title`과 `description` slot |
| stage 자체 shadow는 거의 없고 내부 UI만 떠 있음 | 외곽보다 기능에 depth를 집중 | stage는 1px border, 내부 miniature만 필요한 shadow 사용 |
| 큰 여백과 짧은 문장이 반복됨 | marketing hero보다 스캔 가능한 설명 section | 최대 6개 item, 설명 한 문단 |

원본의 약 16px stage radius는 Foundation의 일반 panel 계약과 충돌하므로 그대로 복제하지 않았다. `FeatureShowcase`는 `--owen-radius-panel` 8px을 사용하고, 별도의 rounded-showcase opt-in이 있을 때만 Corner Ratio 계약을 적용한다.

## NameThatUI Learned Model

NameThatUI는 UI를 단순한 이미지 모음으로 다루지 않는다. 홈은 자연어 검색에서 실제 명칭, 플랫폼, API symbol, 구현 prompt로 이동시키고, 각 상세 항목은 가까운 look-alike와의 차이를 먼저 설명한다.

### Entry anatomy

| 필드 | 역할 | Foundation 문서에 적용할 방식 |
| --- | --- | --- |
| Real name + aliases | 사용자가 모르던 이름과 익숙한 표현을 연결 | component 이름과 검색 가능한 alternate term 기록 |
| Platform marker | 같은 모양의 플랫폼별 명칭 차이를 보존 | Web, macOS, AppKit, SwiftUI 범위를 명시 |
| Plain-language distinction | 가장 가까운 패턴과 역할 차이를 설명 | `allowed_range`와 `counterexample`에 기록 |
| Named anatomy | trigger, panel, item, arrow 같은 부분 이름 제공 | public slot과 Styles API selector 이름에 반영 |
| In code | HTML, ARIA, framework symbol 연결 | Foundation API와 native semantic engine 명시 |
| Prompt + debug prompt | 구현 계약과 대표 실패 모드를 실행 가능한 문장으로 제공 | usage recipe와 검증 체크리스트로 변환 |
| See also | 인접 패턴으로 탐색 연결 | 관련 reference study와 Lab hash 연결 |

### Methodology

1. 화면에서 실제로 식별 가능한 픽셀과 동작에서 시작한다.
2. 플랫폼 가이드, framework 문서, HTML/ARIA 표준에서 명칭과 semantics를 확인한다.
3. 가장 가까운 look-alike와 차이를 specimen과 평문으로 드러낸다.
4. 사용자의 비공식 검색어는 findability에 활용하되 표준 명칭을 대체하지 않는다.
5. 플랫폼마다 이름이 다르면 하나로 뭉개지 않고 각 이름과 범위를 유지한다.

사이트의 Translation Table은 63개 macOS 요소를 plain English, AppKit, SwiftUI 열로 연결한다. Styles atlas는 style을 무제한 수집하지 않고 출처, 용어 상태, 3-5개 식별 신호, 가까운 look-alike가 있는 항목만 등록한다. 이 두 구조는 Foundation 문서에도 “이름 목록”보다 provenance와 차이 설명이 중요하다는 근거가 된다.

## Foundation Contract

- `FeatureShowcase`는 section heading, optional description, semantic list를 소유한다.
- `FeatureShowcaseItem`은 inert preview, title, description을 소유한다.
- preview는 `role="img"`와 필수 `previewLabel`로 한 문장 요약을 제공한다. 실제 interactive demo는 이 component 안에 넣지 않는다.
- 640px 초과 container는 3열, 448-640px container는 2열, 448px 이하는 1열로 전환한다.
- stage는 약 `1.1:1` aspect ratio와 240px 최소 높이, 8px radius, 1px border, opaque neutral surface를 사용한다.
- text와 miniature는 container 밖으로 넘치지 않아야 하며 title과 description은 stage 바깥에 유지한다.
- 반복 노출되는 설명 section이므로 entrance, parallax, hover lift를 기본 제공하지 않는다.
- dark mode와 forced colors에서도 preview 경계와 copy hierarchy가 유지되어야 한다.

```tsx
<FeatureShowcase
  description="검토 흐름의 핵심 상태를 짧은 미리보기로 설명합니다."
  title="신호에서 공동 판단까지"
>
  <FeatureShowcaseItem
    description="목적별 검토 큐로 증거를 정리합니다."
    preview={<ReviewQueuePreview />}
    previewLabel="Endpoint posture가 선택된 검토 큐"
    title="증거 정리"
  />
  <FeatureShowcaseItem
    description="작업을 막지 않는 확인 상태를 보여줍니다."
    preview={<SavedStatusPreview />}
    previewLabel="검토에 추가되었다는 상태 확인"
    title="진행 확인"
  />
</FeatureShowcase>
```

## Deliberate Exclusions

- NameThatUI의 검색 UI, dark palette, specimen card, 고유 문구를 Foundation component로 복제하지 않는다.
- 외부 사이트의 paste-ready prompt를 검증 없이 제품 구현 지시로 사용하지 않는다. WAI-ARIA, WHATWG, MDN, 플랫폼 owner 문서를 다시 확인한다.
- miniature 안에 실제 button, input, menu를 넣어 동작하는 것처럼 보이게 하지 않는다. 상호작용이 필요하면 별도 demo surface를 사용한다.
- 기능 수가 많거나 설명이 길면 3열 card를 계속 늘리지 않고 table, documentation section, guided workflow로 전환한다.
- visual preview가 실제 제품 상태를 보여주지 못하면 장식 이미지를 채우지 않고 text-first 설명을 사용한다.

## Validation Record

- Foundation typecheck와 22개 unit/axe test 통과.
- UI Lab Playwright의 desktop/mobile feature-showcase test 통과.
- 670px nested component container에서 3열, 390px viewport에서 1열 확인.
- 각 miniature bounding box의 top/right/bottom/left가 preview stage 안에 들어오는지 확인.
- 새 specimen 범위의 axe violation 0개 확인.
- 외부 캡처와 독립 transfer 캡처를 `reference-assets/`에 분리 저장.

## Sources

- [NameThatUI home](https://namethatui.com/)
- [NameThatUI methodology](https://namethatui.com/methodology)
- [NameThatUI translation table](https://namethatui.com/translate)
- [NameThatUI styles atlas](https://namethatui.com/styles)
- [Popover vs. Dropdown Menu vs. Tooltip](https://namethatui.com/web/popover-dropdown-tooltip)
