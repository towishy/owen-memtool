---
name: Owen UI Foundation
status: stable-candidate
foundation: Extend Labs UI + shadcn/new-york
surface: Owen Graphite Liquid Glass
color_source: tokens/tokens.json
css_source: tokens/tokens.css
radius:
  control: 6px
  panel: 8px
  rounded_panel: "clamp(16px, 15%, 32px)"
  showcase: "clamp(40px, 15cqi, 104px)"
  identity: "21%"
  pill: 999px
motion:
  fast: 140ms
  normal: 200ms
---

# Owen UI Foundation

## Overview

Quiet, work-focused product UI for document review, security operations, agent traces, and knowledge tooling. The interface should favor scanning, comparison, and repeated action over marketing composition. Extend Labs/shadcn defines component structure; Owen Graphite adds depth only where it explains hierarchy.

AI 구현 라우팅은 [`AI-USAGE.md`](AI-USAGE.md)를 사용한다. 이 문서는 component inventory를 중복 정의하지 않고 현재 구현된 API의 선택, maturity, Lab specimen, 검증 경로를 제공한다. 시각·동작 결정이 충돌하면 이 `DESIGN.md`가 항상 우선한다.

## Continuous Corner Default

사용자 지정(2026-10-17, Circular/Continuous 비교 첨부 이미지): 앞으로 새로 만들거나 수정하는 일반 제품 UI의 모든 라운드 코너는 **continuous 방식**을 기본 계약으로 적용한다. 버튼, 입력, 카드, 패널, 메뉴, 팝오버, 다이얼로그, 툴팁, 아이콘 타일과 이미지 외곽 모두에 적용하며 별도 재요청을 요구하지 않는다.

- **형태 기준**: Circular는 직선에 일정 곡률의 원호를 바로 연결한다. Continuous는 그 사이에 곡률이 점진적으로 변하는 전환 곡선을 두어 직선과 곡선이 자연스럽게 이어지게 한다. 단순히 `border-radius`를 키우거나 접선만 맞추는 것으로 이 기준을 충족했다고 하지 않는다.
- **크기와 형태 분리**: 기존 control 6px, panel 8px과 Corner Ratio Ladder는 둥글기의 크기·비례 기준으로 유지하고, 접합부의 형태를 continuous로 만든다. 작은 코너에도 적용하며 모든 surface를 큰 squircle이나 장식 카드로 바꾸지 않는다. 첨부 이미지에서 정확한 수식이나 smoothing 수치를 추정해 고정하지 않는다.
- **구현 선택**: 해당 플랫폼의 continuous corner API 또는 검증된 corner-smoothing 구현을 소유 컴포넌트에서 재사용한다. 웹의 `corner-shape: squircle` 등은 대상 브라우저 지원과 실제 형상을 확인해 선택하며, 특정 플랫폼의 continuous 형상과 완전히 같다고 가정하지 않는다. 미지원 환경에는 검증된 SVG/path 등으로 같은 형상을 제공한다. 일반 `border-radius`만 남는 호환성 fallback을 continuous 적용 완료로 보고하지 않으며, 구현할 수 없는 경로는 제한으로 명시한다.
- **일관된 외곽**: 배경, border, 이미지 clipping, 내부 surface, shadow와 focus 표시가 같은 외곽을 따르게 한다. `clip-path`나 mask로 popup·그림자·focus ring을 잘라내지 않으며, 기존 hit target, keyboard/touch 동작과 반응형 크기를 보존한다. 공용 형상 계산이 있으면 재사용하고 요소마다 서로 다른 곡선을 복제하지 않는다.
- **원형과 캡슐**: 완전한 원 자체가 목적인 원형 버튼·avatar·차트의 원은 유지한다. 캡슐은 역할과 전체 비례를 보존하면서 직선과 곡선의 접합부에 continuous를 적용한다. 모든 원형·pill에 큰 radius와 동일한 squircle 값을 일괄 지정하지 않는다.
- **범위와 검증**: 기존 UI의 일괄 재작성이나 수집 원본의 변형 승인은 아니다. 새로 만들거나 해당 외곽을 수정하는 일반 제품 UI부터 적용하며 수집 원본은 원래 형상을 보존한다. 실제 대상 브라우저·크기에서 코너 접합부와 border·shadow·focus의 정합성, desktop/mobile reflow를 확인한다. 문서에 기본값을 저장한 것과 실제 UI 구현·검증 완료를 구분한다.

## Compact UI And Detail Tooltip Default

사용자 지정(2026-09-16, Subly FFmpeg 내보내기 목업 첨부 화면): 이후 일반 제품 UI는 별도 재요청 없이 **최대한 간결하고 컴팩트한 본문 + 디자인된 상세 툴팁**을 기본값으로 구현한다. 이는 이 목업만의 스타일이 아니라 화면 구성·정보 공개의 공통 기준이다.

- **본문 구성**: 짧은 라벨, 현재 값/상태, 필요한 조작만 보인다. 관련 상태와 명령은 가능한 한 줄에 배치하고 안정된 크기의 아이콘 버튼을 묶는다. 얇은 구분선과 필요한 여백으로 그룹을 나누며 중복 설명 문단, 큰 제목, 장식 카드, 불필요하게 쌓인 행을 추가하지 않는다.
- **선택 메뉴**: `vibe:features-tabbed-feature-switcher` (`Tabbed feature switcher`, 비교 목업 16)의 중앙 content-width 캡슐 트랙, 텍스트 라벨, 밝은 선택 캡슐과 작은 그림자를 우선한다. 범위·언어·preset 선택에도 적용하되 폼 값은 native radio/group, 뷰 전환은 tab semantics를 유지한다. 전체 너비 박스형이나 sliding underline(목업 15)로 임의 대체하지 않는다.
- **Segmented selection**: 같은 객체·모드·보기에 속한 동등한 선택 2–5개를 기본 범위로 한다. 충분히 넓은 surface에서 짧은 label과 44px target을 보존할 때만 6–7개를 허용한다. 형제 segment는 같은 폭과 동일한 content anatomy(text, icon-only, icon+text 중 하나)를 사용한다. 긴 번역이나 선택지 수 때문에 같은 폭·가독성·target을 함께 지킬 수 없으면 글자 축소, 잘림, 숨김, 불균형 폭, 여러 줄 pill로 버티지 않고 Select·Combobox·menu 등 작업에 맞는 owner로 전환한다.
- **상세 안내**: 기능 목적, 버전, 경로, 부가 전제조건과 절차는 짧은 제목+본문의 디자인 툴팁으로 안내한다. 기존 Foundation/제품 소유 컴포넌트와 token을 재사용하고 브라우저 native `title`만으로 대체하지 않는다. 닫힌 상태에서도 아이콘의 접근성 이름을 제공한다.
- **툴팁 동작**: hover와 keyboard focus로 열리고, 포인터를 툴팁으로 옮겨도 유지되며 Escape로 닫아도 trigger 초점을 잃지 않는다. 화면 경계·scroll·overlay clipping·reduced motion을 처리한다. 터치에서는 기본 명령을 가로채지 않는 탭 가능한 상세 trigger를 제공한다. 링크·명령·선택 가능한 내용·긴 본문은 `role="tooltip"` 안에 넣지 않고 접근 가능한 popover/dialog로 분리한다.
- **가독성과 필수 정보**: 좁은 화면은 재배치로 해결하고 폰트나 hit target을 줄여 억지로 한 줄을 유지하지 않는다. 이 compact command 패턴은 44px 조작 영역을 보존한다. 라벨, 현재/선택 상태, 오류, 필수 입력 안내, 중요한 경고와 동의는 본문에 남긴다. 간결함을 이유로 의사결정에 필요한 정보를 숨기지 않는다.

설계 전에 본문에 남길 정보와 상세로 옮길 정보를 구분하고, 더 넓은 구성이 필요한 경우 이유를 짧게 기록한다. 구현 후 desktop/mobile에서 실제 화면과 열린 툴팁, keyboard/touch, 접근성·overflow·console/resource를 검증한다. 수집 원본의 스타일·동작은 이 기본값으로 덮어쓰지 않으며, 목업의 채택은 공용 컴포넌트의 maturity·Registry 승격이나 다른 제품의 일괄 수정 승인이 아니다.

Segmented track은 하나의 보편 component 이름이 아니라 시각적 관계다. 단일 form 값은 native radio group, view panel 전환은 tabs, 단일·복수 상태 전환은 명시적 selection policy를 가진 button 또는 ToggleGroup semantics를 유지한다. 자세한 적용 범위와 반례는 [`REFERENCE-STUDY-SEGMENTED-CONTROLS.md`](REFERENCE-STUDY-SEGMENTED-CONTROLS.md)를 따른다.

## User-Corrected Product Details

2026-09-19 GSA Dashboard 작업에서 확인된 사용자 기준입니다. 일반 제품의 디자인 계약으로 적용하며, 수집 원본의 외형·동작이나 다른 제품의 기존 검증 상태를 소급 변경하지 않습니다.

| 항목 | 공통 디자인 계약 |
| --- | --- |
| 수정 범위 | 요청한 컴포넌트의 소유 스타일에서 수정합니다. 로그인·특정 패널 변경을 다른 페이지의 표·카드·본문 전역 스킨으로 확대하지 않습니다. |
| 로컬 표면 | 컨트롤·열린 메뉴·아이콘·상태 글자는 가장 가까운 표면의 톤을 따릅니다. 밝은 페이지 안의 어두운 터미널·유리 오버레이는 자체 배경과 글자 계약을 함께 보존합니다. |
| 가로 컨트롤 높이 | 버튼·선택기·검색·모드 그룹·테두리가 있는 상태·개수·체크박스 라벨의 border box 높이와 세로 중심을 일치시킵니다. 같은 소유자 토큰과 border-box 계산을 사용하고, 체크 표시가 아닌 외곽 래퍼를 측정합니다. |
| 크기와 재배치 | compact 명령은 44px 이상을 유지합니다. 그룹 내부 여백이 필요하면 형제 컨트롤의 공통 높이도 함께 조정하며, 이중 외곽선·글자 축소·옵션 숨김으로 해결하지 않습니다. |
| 아이콘 명령 | 원형 명령 버튼과 중앙 정렬된 일관된 선형 아이콘을 우선합니다. 접근성 이름과 설계된 tooltip, hover/focus/pressed/disabled를 보존하며 텍스트 명령·입력·숫자 페이지 선택은 구분합니다. |
| 캡슐 트랙 | 선택된 첫·마지막 pill의 바깥과 위아래에 트랙이 보이는 여백을 남깁니다. 끝 곡면을 겹치거나 잘라내지 않으며 모든 선택지를 보이게 재배치합니다. |
| 메뉴 간격과 아이콘 | 선택·hover/focus된 인접 행의 테두리와 배경을 붙이지 않습니다. 그룹 내부 간격, 체크·펼침 아이콘 열, 라벨 시작점·크기·획을 일관되게 유지합니다. |
| 상태 강조 | 실패·오류·차단·고위험은 danger, 성공·정상·허용은 success, 검토·경고는 warning, 정보·보고 전용은 info, 미적용·미상은 neutral입니다. 라벨·굵기·숫자 위계와 함께 쓰고 색만으로 의미를 전달하지 않습니다. |
| 의미 경계 | 실제 상태 필드와 명시적 판정에만 상태 토큰을 적용합니다. 이름·자유 텍스트의 키워드로 색칠하거나 차단 결과를 서비스 장애로 재해석하지 않습니다. 0건을 자동 경고로 꾸미지 않으며 원본 데이터·정렬·복사·내보내기를 보존합니다. |
| 입력칸 | 텍스트·숫자 스피너·검색·선택기·표 편집칸의 밑줄 글자 및 하단 선만 남기는 border/shadow/gradient/가상 요소를 금지합니다. 전체 테두리·배경, 키보드 포커스와 오류 안내는 유지합니다. |
| 링크 | 링크 뒤 장식용 외부 이동 화살표를 넣지 않으며 SVG로 우회하지도 않습니다. 요청한 기능성 방향·확대·축소 명령은 별도입니다. |
| 삭제와 미리보기 | 기능 삭제 시 템플릿·자동 삽입·이벤트·회귀 검사까지 처리합니다. 실제 앱 미리보기는 최신 실행 파일의 일반 창을 보여주며 테스트용 고정 viewport를 대신 제시하지 않습니다. |

상태 요약은 본문과 동적 상세창에서 같은 렌더러를 재사용합니다. 제품별 수치(예: GSA의 56px 컨트롤 줄, 10px/6px 캡슐 내부 여백, 4px 메뉴 간격)는 해당 제품의 검증된 로컬 결정이며 Foundation 전체의 고정 상수나 새 API로 승격하지 않습니다. 필요한 디바이스 범위는 제품 지침을 따르고, 명시적 데스크톱 전용 작업에 모바일 구현을 추가하지 않습니다.

이 절은 디자인·검증 규칙의 채택입니다. Foundation 컴포넌트 코드·토큰·수집 원본을 일괄 변경하거나 모든 제품의 UI 검증을 완료했다는 뜻은 아닙니다. 실행 절차는 `AI-USAGE.md`의 Design Detail Acceptance Loop를 따릅니다.

## Canonical Visual Baseline

`lib/ui-lab`에 현재 구현된 specimen과 mockup을 Owen 제품 UI의 기본 시각 기준으로 사용한다. 새 화면은 이 baseline에서 시작하고, 다른 표현이 필요한 경우 output job과 surface 제약을 `DESIGN.md` 또는 해당 `REFERENCE-STUDY-*.md`에 기록한다.

### First-priority design review order

**Bencho 선호 추가 (2026-09-15 사용자 지정):** 작업에 맞는 Bencho UI·모션 블록도 Clear·shadcn과 함께 높은 선호의 비교 후보로 검토한다. 특히 Canvas toolbar의 선택 유지와 위쪽 관련 하위 메뉴는 향후 MDBOX 하단 에디터 갱신의 참고다. [Bencho 참고 기록](REFERENCE-STUDY-BENCHO-BLOCKS.md)의 원본 격리·MIT 범위·사진 대체·검증 대기 상태를 지키며, 이 선호로 공용 API나 Registry 성숙도를 자동 승격하지 않는다.

새 UI를 설계할 때 앱 전용 시각안을 먼저 만들지 않는다. 다음 두 단계는 모두 **1순위 필수 후보 검토**이며, 그 안에서 Clear가 가장 먼저다.

**순위 정의:** UI Foundation Lab 왼쪽 navigation의 30개 UI는 예외 없이 모두 `Priority 1`이다. 사용자 지정(2026-09-08)에 따라 Clear 디자인, shadcn/ui, 분석된 UI 언어 251개를 높은 우선순위로 함께 검토한다. Clear는 조작 재질, shadcn은 구성요소 구조·변형, UI 언어는 화면 구조·정보 위계의 후보이며 기존 API maturity를 바꾸지 않는다. 작업과 관련된 소수 사례만 고르고 세 디자인군의 동시 사용이나 원본 재해석을 강제하지 않는다. 앱 전용 신규 디자인과 그 밖의 외부 reference는 이 후보를 먼저 대조한 뒤 고려한다.

1. **Priority 1A — Clear first**: 모든 UI 작업에서 UI Lab의 `Clear glass search`, `Clear glass controls`, `Clear glass workflow`를 먼저 열어 interaction material을 검토한다. Search, mode, command, form control, select/menu, overlay, dock, active navigation, widget boundary에 적용 가능한지 먼저 판단한다.
2. **Priority 1B — Component and screen structure**: 작업에 맞는 shadcn/ui 구성요소·변형과 UI 언어의 이미지 결합 분석을 대조한다. UI Lab의 나머지 27개 specimen도 동일한 1순위 후보군으로 유지하고 Layered Stacks, workspace, settings, data, mobile, micro, motion, state specimen을 앱 전용 새 composition보다 먼저 고려한다. 분석의 관찰·추천·불확실성을 분리하며 실제 이미지를 재확인한다.

“1순위”는 모든 specimen이나 Clear Glass를 한 화면에 동시에 넣는다는 뜻이 아니다. 먼저 열어보고 output job, surface, API maturity에 맞는 후보를 선택한다는 뜻이다. 선택한 content body가 dense table, 긴 본문, 반복 row, settings body라면 opaque content rule은 계속 우선한다.

- **Composition**: `WorkbenchShell`처럼 navigation, main work plane, inspector, status의 책임을 분리한다. Page section을 card로 감싸거나 card 안에 card를 중첩하지 않는다.
- **Clear Glass material**: Clear Glass를 Foundation의 기본 interaction material로 폭넓게 사용한다. Search, segmented mode, toolbar, command, form control, select/menu, overlay, dock, active navigation, widget boundary가 우선 적용 대상이다. `--owen-clear-glass-*` token의 translucent fill, directional rim, backdrop filter, broad shadow를 한 묶음으로 사용한다.
- **Opaque content rule**: clear glass 위의 text와 icon은 충분한 대비를 유지한다. 긴 본문, dense table, 반복 list row, settings body, data visualization substrate는 opaque surface를 사용해 가독성과 렌더링 비용을 보호한다.
- **Widget composition**: 위젯형 UI는 UI Lab의 `Layered stacks`를 기본 원칙으로 한다. 하나의 round browser/shell 안에 responsive item grid를 두고, 각 item은 preview layer, persistent label tray, compact metadata, item-local command, selected state를 갖는다. Preview는 실제 상태를 보여주며 장식용 nested card를 만들지 않는다.
- **Glint telemetry**: 날씨, 일정, 배터리, 활동량처럼 한 개의 짧은 상태를 표시할 때만 `GlintWidget`의 olive/neutral contextual glass를 사용한다. 한 widget에 primary value 또는 time signal 하나만 두고, dot·segment·radial visual은 semantic text나 progress state를 보조해야 한다.
- **Weather orb composition**: atmospheric scene이 날씨 맥락을 보강할 때 `GlintWidget`의 semantic metric과 decorative visual slot을 분리해 사용한다. 위치·보기·단위·언어 필터는 widget group 위에 두고 filter-to-grid와 widget gap을 20–24px로 유지한다. Blur pane이 copy나 focal orb를 가리게 하지 않으며 reduced-motion에서는 orb, cloud, rain, number pop을 모두 정지한다.
- **Feature explanation composition**: 2-6개 기능의 가치를 실제 UI 형태로 설명해야 할 때만 `FeatureShowcase`를 사용한다. Inert preview stage와 title/description을 분리하고 3→2→1열로 재배치한다. Preview는 기능당 하나의 상태만 보여주며 interactive demo나 장식용 feature-card grid로 확장하지 않는다.
- **Micro collection composition**: micro UI는 dotted board, compact card, link composer, horizontal shelf, bottom dock, orb action을 역할별로 분리한다. board와 card는 밝은 중립 surface, command와 dock은 제한된 glass layer를 사용하고 color는 상태 보조에만 쓴다.
- **Settings composition**: 설정 메뉴는 `SettingsPanel` composition을 기본 원칙으로 한다. Tone과 icon이 있는 section header 아래에 `title + current state + control` row를 배치한다. 부가 description은 위 Compact UI And Detail Tooltip Default에 따라 상세로 제공하되 필수 안내·오류는 본문에 남긴다. Switch/preset/command input은 역할에 맞는 native semantics를 유지한다. Row는 border로 분리하고 좁은 화면에서는 control을 본문 아래로 재배치한다.
- **Query composition**: editable operational filtering은 experimental `QueryBuilder`로 field, operator, typed value, explicit AND/OR를 구성한다. Rule row는 불투명하게 유지하고 glass는 logic selector와 add command에만 제한한다. 단일 검색, static chip, raw query language, nested boolean group에는 사용하지 않는다.
- **Dropdown command preference (2026-09-14 사용자 지정)**: 드롭다운·더보기·행 작업 등 명령 메뉴의 구현 1순위는 Portal의 `shadcn/ui 명령 메뉴` (`shadcn:dropdown-menu`)다. 해당 원본 예제와 소유 어댑터를 먼저 확인하고 grouping, separator, disabled/destructive state, keyboard navigation, Escape·초점 복귀를 재사용한다. 임의 HTML 메뉴나 다른 메뉴 라이브러리를 먼저 만들지 않는다. 값 선택은 `SelectControl`의 역할로 구분하며 명령 메뉴로 일괄 대체하지 않는다. Clear는 조작 재질, 이 선호는 명령 메뉴의 구현 선택이며 원본 수집·검증 상태를 자동 승격하지 않는다.
- **Cloud Desk layout**: 일반 workspace layout은 UI Lab의 `Cloud Desk` composition을 폭넓게 사용한다. Stable navigation sidebar, flexible opaque work plane, optional utility rail로 책임을 나누고 toolbar search와 command를 work plane 상단에 둔다. Container가 좁아지면 rail을 본문 아래로 옮기고 sidebar를 compact navigation으로 전환한다.
- **Knowledge collection layout**: local note, link, image, evidence card를 room 또는 collection 단위로 탐색할 때 UI Lab의 `Knowledge Rooms`를 검토한다. `WorkbenchShell`과 Cloud Desk의 stable navigation, Layered Stacks의 preview/selection, app-owned filter/detail/offline state를 조합하며 source screenshot이나 mockup의 visual skin을 복제하지 않는다.
- **Corner ratio**: 기존 운영 panel은 `--owen-radius-panel: 8px`을 유지한다. 둥근 외곽을 의도적으로 선택한 surface에만 `--owen-radius-rounded-panel: clamp(16px, 15%, 32px)`을 적용한다. 큰 visual showcase는 `--owen-radius-showcase: clamp(40px, 15cqi, 104px)`, 정사각 identity visual은 `--owen-radius-identity: 21%`, pill command와 원형 utility는 50% 곡률을 사용한다.
- **Hierarchy**: compact heading, 짧은 supporting copy, tabular numeral, surface와 입력 방식에 맞는 interaction target을 유지한다. 큰 display type은 실제 focal specimen이나 hero metric 하나에만 사용한다.
- **Color and depth**: neutral surface를 중심으로 semantic color를 상태와 핵심 action에 제한한다. 형태는 1px border로 먼저 정의하고 넓고 낮은 alpha shadow를 elevation에 사용한다.
- **Interaction**: pointer press는 140ms `scale(0.97)`을 허용하지만 keyboard state는 즉시 반영한다. Overlay와 disclosure 외의 반복 동작에는 entrance animation을 붙이지 않는다.
- **Expressive component intake**: 외부 animation component는 output job, state model, pointer/keyboard/touch parity, reduced/static state, mobile fallback, dependency budget, accessibility, provenance와 executable validation을 먼저 기록한다. Hover-only preview, unbounded physics/particles, standard license가 불명확한 source는 Foundation API나 Priority 1 inventory에 넣지 않는다. 상세 gate는 `REFERENCE-STUDY-RARE-UI.md`를 따른다.
- **Responsive behavior**: 좁은 화면에서는 sidebar와 inspector를 접고 composition을 한 열로 바꾼다. Radius token과 text hierarchy를 유지하고, target은 입력 방식과 주변 간격을 함께 검증한다.
- **Scrollbar template**: 모든 웹 기반 Owen 페이지·앱·preview·catalog·목업의 document-level 세로 scroll과 앱이 소유한 panel/menu/list 세로 scroll에는 `FrostedScrollArea`를 기본 적용한다. Native wheel, touch, keyboard scroll semantics는 viewport에 유지하고, 2px 반투명 rail 위에 configurable compact local glass grip만 표시한다. Grip은 기본 6px, hover와 drag에서 10px이며 중앙의 낮은 대비 3-line handle로 조작 가능성을 보조한다. Native arrow button과 viewport 비율만큼 길어지는 thumb는 표시하지 않는다. Horizontal tab/chip scroller, OS scrollbar를 명시적으로 요구하는 화면, virtualized engine이 scroll을 직접 소유하는 영역만 이유를 기록한 예외다.

Corner Ratio Ladder는 rounded-corner 표현을 선택한 surface의 크기·비례만 정한다. 코너 접합부의 형태는 [Continuous Corner Default](#continuous-corner-default)를 따른다. 기존 mockup과 일반 운영 panel의 radius를 소급 변경하지 않는다. Table cell, list row 경계, form control에는 rounded panel ratio를 반복하지 않으며 control은 `--owen-radius-control` 또는 명시적인 pill/circle 계약을 사용한다. Clear Glass는 재질, Layered Stacks와 SettingsPanel은 composition, Corner Ratio Ladder는 opt-in geometry 계약이며 서로 대체하지 않는다.

## Settings Header Visual Contract

설정 그룹 header는 사용자가 제공한 `계정` reference와 Sarang.day 전이 구현에서 검증한 재질 문법을 따른다. 이 계약은 `SettingsPanel`의 group header에 적용하며 앱 shell toolbar, table header, 일반 form label에는 확장하지 않는다.

- Header anatomy는 `옅은 tinted band + accent outline icon tile + 진한 중립 제목 + 낮은 대비 설명 + 1px 하단 divider`다. 실제 설정 row는 흰색 또는 동등한 opaque surface를 유지한다.
- 밝은 header band는 `linear-gradient(180deg, var(--settings-header-tint) 0%, color-mix(in srgb, var(--settings-header-tint), #fff 64%) 100%)`를 기준으로 한다. 위쪽 tint가 아래쪽의 거의 흰 surface로 밝아지고 좌우 색상차는 거의 없어야 한다. `105deg` 대각선 gradient로 해석하지 않는다.
- Panel radius는 8px, header icon tile은 48px 정사각형과 8px radius를 기본으로 한다. Compact 반복 widget에서는 icon tile을 32px까지 줄일 수 있으며 interaction target은 실제 입력 방식과 조작 간격으로 검증한다.
- 설정 header title은 약 `0.92rem`, weight 700 이상, line-height 1.35를 사용한다. Description은 약 `0.7rem`, weight 500, line-height 1.4로 두고 제목보다 낮은 대비를 유지한다. Letter spacing은 0이다.
- Icon tile은 tone accent를 outline glyph, border, surface의 공통 source로 사용한다. Glyph는 가능한 한 `fill: none`, `stroke: currentColor`, 약 1.75px stroke와 20px visual size의 line icon을 쓰고 header tone이 바뀌면 같은 accent를 상속한다. Surface는 단색 흰색이 아니라 위쪽 `accent + white 96%`에서 아래쪽 `accent + white 88%`로 tone이 조금 더 드러나는 180deg gradient를 사용하고, border는 `accent + white 60%`를 기준으로 한다. Shadow는 `0 4px 10px rgb(15 23 42 / 0.05)` 수준의 약한 elevation만 허용한다.
- 다크 모드에서는 장식적인 밝은 gradient보다 읽기 쉬운 불투명 surface를 우선한다. App-specific settings header는 tone별 dark tint를 사용할 수 있고, 반복 widget header는 accent 14%와 `#24262b`를 섞은 상단 tint에서 `#24262b`로 내려가는 180deg gradient를 사용할 수 있다.
- 헤더별 tone은 그룹 구분만 보조한다. 상태, 성공, 오류, 선택을 색상만으로 전달하지 않으며 모든 설정 그룹을 단일 파랑으로 통일하지 않는다.

Foundation은 다음 named 설정 tone을 제공한다. Gray/neutral부터 cool, warm, botanical 계열까지 확보하되 이 목록은 색상 한계가 아니다. 제품은 `--owen-settings-accent`, `--owen-settings-header`, `--owen-settings-icon-surface`, `--owen-settings-icon-border`를 component root에서 함께 재정의해 별도 header tone을 만들 수 있다. 어떤 경우에도 glyph만 독립된 고정색으로 분리하지 않는다.

| Tone | Accent | Header tint | Icon border |
| --- | --- | --- | --- |
| neutral | `#64748b` | `#f7f8fa` | accent-derived |
| gray | `#4b5563` | `#f3f4f6` | accent-derived |
| sky | `#007dba` | `#eef7fa` | accent-derived |
| mint | `#287563` | `#eef7f4` | `#c9e3da` |
| rose | `#aa4568` | `#fbf1f4` | `#ebd0da` |
| amber | `#95651f` | `#fbf6ec` | `#eadbbf` |
| violet | `#6856a4` | `#f4f2fb` | `#d9d3ec` |
| teal | `#147975` | `#edf7f6` | `#c5e2e0` |
| coral | `#a65143` | `#fbf1ef` | `#ebd1cb` |
| indigo | `#4d62a6` | `#f1f3fa` | `#d0d7ec` |
| olive | `#62762e` | `#f4f7ed` | `#d8e1c4` |

## Colors

Use semantic CSS variables from `tokens/tokens.css`. Primary indigo is reserved for the main action, selection, and focus-adjacent emphasis. Success, warning, and danger always include text or an icon. Dense screens use neutral canvas, opaque content surfaces, and visible borders rather than a single-hue wash.

## Material And Depth Intake

외부 glass, neumorphism, shadow generator의 출력은 scratch input이며 완성 component나 token이 아니다. [`REFERENCE-STUDY-CSS-EFFECT-GENERATORS.md`](REFERENCE-STUDY-CSS-EFFECT-GENERATORS.md)에 따라 fill, backdrop treatment, boundary/rim, inner highlight, contact shadow, ambient elevation으로 분해하고 기존 Foundation owner에 필요한 값만 옮긴다. Generator가 함께 출력한 width, height, position, overflow, radius, pseudo-element와 shadow-only interaction state는 owning component가 별도로 요구하지 않으면 버린다. App-local late override에 raw recipe를 붙이지 않는다.

Glass surface는 `backdrop-filter` 없이도 읽히는 opaque or near-opaque base와 visible border를 먼저 제공하고 feature query 안에서 transparency와 blur를 강화한다. Reduced-transparency 감지 시 opaque surface로 돌아가되 해당 media feature가 모든 target browser에 지원되지 않으므로 이것만 fallback으로 삼지 않는다. Forced colors에서는 decorative filter와 shadow를 제거한다. 실제 worst-case backdrop의 text/icon contrast, ancestor backdrop root, stacking, clipping, scroll paint와 Windows/macOS target browser를 검증한다.

Outer shadow는 화면 전체에서 한 광원 방향을 공유하고 contact와 ambient layer처럼 역할이 다른 layer만 유지한다. Elevation이 커지면 offset과 blur 범위는 커지고 ambient alpha는 낮아져야 한다. Layer removal test를 통과하지 못한 shadow는 제거하며 layered shadow와 backdrop blur를 continuous animation하거나 repeated row, table, settings body에 복제하지 않는다. Neumorphic pressed/selected 상태는 Foundation control에 사용하지 않는다.

## Typography

Use Aptos or Pretendard Variable where available, then Segoe UI Variable. Letter spacing is always `0`. Panel headings stay compact; large display type is reserved for a true landing hero. Use tabular numerals in metric and numeric table columns.

새 family를 도입할 때는 [`REFERENCE-STUDY-FONT-SOURCING.md`](REFERENCE-STUDY-FONT-SOURCING.md)의 font sourcing gate를 적용한다. 먼저 operational body, editorial/display, brand, code/telemetry 중 역할과 한국어·영어 coverage를 정하고, exact version, source URL, designer/foundry, 원문 license, 허용 surface, embedding·self-hosting·subsetting·format conversion·modification·redistribution 조건, attribution 또는 Reserved Font Name, file hash를 기록한다. `무료`, `상업 이용 가능`, `오픈소스`를 같은 상태로 간주하지 않는다.

운영 UI는 한 family의 weight·width·size hierarchy로 먼저 해결하고, 별도 display family는 실제 정보 역할이 분리되는 hero, cover, poster, editorial surface에만 사용한다. Fontjoy는 발산적 pairing shortlist에만, Fontshare는 family별 license와 language를 통과한 Latin 중심 후보에, 눈누와 Google Fonts는 한글 discovery에, Velvetyne은 명시적인 experimental display output에만 사용한다. 제품 build는 license가 허용할 때 version-pinned WOFF2 self-hosting을 우선 검토한다. 외부 font API/CDN은 privacy, CSP, offline, availability와 fallback 승인을 요구하며, 한국어·영어 mixed-script specimen, compact body, narrow viewport, zoom, Windows/macOS, PDF/image export에서 실제 glyph와 line metrics를 검증한다.

## Spacing

The base spacing unit is 4px. Controls use 8px or 12px internal gaps, panels use 16px or 24px padding, and major layout boundaries use 24px or 32px. Interactive target size follows surface density, input modality, command importance, and adjacent spacing instead of one universal height.

## Components

Prefer compound components and explicit state props. Inputs always use `FormField`. Async regions represent loading, empty, error, partial, offline, and success separately. Tables require captions and own horizontal overflow. Important mutations use `ConfirmableAction` when reversal is difficult. Use its default press mode for ordinary confirmation and opt-in hold mode only when accidental activation has a high, immediate cost.

`FrostedScrollArea`는 모든 웹 기반 surface의 canonical vertical scrollbar다. Scroll viewport와 overlay rail을 분리하고 native wheel, touch, keyboard behavior를 그대로 유지한다. Configurable compact local grip은 content ratio와 무관하게 일정하며 실제 scroll position만 rail 위 위치로 표현한다. React component를 직접 쓰지 못하는 document/window scroll과 정적 surface도 같은 anatomy와 동작을 구현한다. Horizontal chip/tab scroller, operating-system scrollbar를 명시적으로 존중해야 하는 화면, virtualized list engine이 자체 scrollbar를 소유하는 화면에만 강제하지 않으며 예외 이유를 기록한다.

**경계 우선 배치 (2026-09-06 사용자 지정):** 스크롤바는 가능한 한 자신이 제어하는 페이지·패널·목록의 바깥 경계에 붙인다. Scroll root/rail은 경계까지 확장하고 본문 여백은 viewport 내부 콘텐츠에 둔다. 손잡이와 pointer hit area가 텍스트·컨트롤을 덮지 않도록 내부 gutter를 확보하되, 콘텐츠 padding 때문에 rail 자체가 안쪽으로 밀리지 않게 한다. 모서리 clipping과 인접 조작 영역 충돌을 피하는 최소 inset만 허용한다. 이 기본값은 일반 Owen UI와 Portal 외곽에 적용하며, 수집 원본의 scrollbar는 Original Fidelity Contract에 따라 보존한다.

`ThemeWorkbench` is the opt-in theme authoring surface. It edits semantic tokens inside its own CSS-variable scope, renders a real specimen, and reports foreground/background contrast pairs. It does not mutate `:root`, generate AI themes, or replace product information architecture.

`InstrumentPanel` is the opt-in data-display profile. It reserves one primary metric, keeps supporting values quieter, pairs segmented progress with an exact numeric value, and can expose one explicit target marker through both visible text and `aria-valuetext`. Header action slots preserve input-appropriate command targets while period filters and command contents remain consumer-owned. Its white cool-neutral light surface, optional dark profile, dot grid, and monospace labels are appropriate for telemetry and security operations, not every content panel.

`GlintWidget` is the compact contextual telemetry profile. It owns one value, time, or status signal inside a square or wide translucent shell. Its decorative visual slot is intentionally hidden from assistive technology, so consumers must expose the same information through metric text, descriptions, native progress semantics, or time elements. It does not replace `InstrumentPanel`, generic content cards, settings panels, or dense dashboard substrates.

`FeatureShowcase` is a reference composition for explaining a small capability set. The section owns one heading and a semantic list; each item owns an inert, labeled preview plus one title and one short description. Keep miniature implementation and product claims consumer-owned, and use a separate demo surface when the preview must be interactive.

## Layout

Operational screens use `WorkbenchShell`: stable toolbar, optional navigation sidebar, flexible main region, optional inspector, and terse status bar. Inspector and sidebar collapse by responsibility rather than squeezing content. Cards are for repeated items or framed tools, never for every page section.

For general workspace layouts, use the Cloud Desk / Quiet Glass Workspace composition: a stable navigation sidebar, opaque flexible work plane, optional utility rail, and bounded contextual glass panels. This layout applies broadly to mail, files, reviews, research, knowledge, task, and operations workspaces. Move the rail below the work plane and compact navigation before reducing text or targets. The extracted rationale and accessibility contract are recorded in `REFERENCE-STUDY-QUIET-GLASS-WORKSPACE.md`.

When a stable navigation anchor must expose a deep hierarchy without replacing the work plane, use the medium-confidence Hierarchical Flying Panels reference composition in `REFERENCE-STUDY-HIERARCHICAL-FLYING-PANELS.md`. The anchor opens one primary index and at most one connected secondary panel; deeper levels replace the secondary content instead of extending a cascade. Pinning is opt-in, keeps only one panel, and enables bounded header drag and resize. Narrow layouts remove move/resize and return both panels to document flow. Do not treat this app-proven reference as a public Foundation component until a second product validates the same state model.

When one site-navigation category has too many distinct destinations for a compact dropdown, use the medium-confidence Mega Menu reference composition in `REFERENCE-STUDY-MEGA-MENU.md`. Group semantic link lists by user intent or domain, keep at most one optional evidence rail, and use click·keyboard·Escape·focus restore rather than hover-only access. Narrow layouts become in-flow disclosure or full-width drill-in. Keep the link body opaque, avoid nested cards, and do not create a public Foundation component until two products validate the same state model.

Image-led food and delivery dashboards may use the opt-in commerce composition documented in `REFERENCE-STUDY-FOOD-COMMERCE-DASHBOARD.md`: compact icon navigation, a flexible discovery plane, and one persistent order rail. Keep menu and order content opaque, move the rail below the discovery plane at medium widths, and convert navigation to a compact dock before shrinking targets. This composition does not replace Cloud Desk for operational products.

## Motion

Button press feedback uses `scale(0.97)` for 140ms. Entry/exit motion is reserved for occasional overlays and should stay under 300ms. Keyboard-driven navigation and selection are instant. Reduced-motion mode removes transforms and slows non-positional loading indicators.

## Do

- Put evidence and status near the action they affect.
- Preserve native keyboard behavior and focus restoration without creating a focus rim.
- For high-risk destructive actions, support pointer, Space/Enter, assistive click, interruption cancellation, async error recovery, and explicit success acknowledgement.
- Use icons for familiar tool actions and add tooltips or accessible names.
- Apply Clear Glass broadly to functional controls, navigation, overlays, docks, menus, and widget boundaries.
- Keep dense tables, long-form content, repeated rows, and settings bodies opaque.
- Use Layered Stacks as the default widget composition and SettingsPanel as the default settings-menu composition.
- Use Cloud Desk as the default quiet workspace layout when a screen needs navigation, a primary work plane, and supporting utilities.
- Use the Corner Ratio Ladder only when a surface explicitly adopts rounded corners.
- Use `FrostedScrollArea` for document-level and every app-owned vertical scrollbar by default; do not expose native arrow buttons or ratio-length thumbs.
- Validate theme tokens against forms, data, overlays, navigation, Korean text, and narrow viewports.
- Keep instrument displays to one hero metric and no more than one signature motif per screen.
- Use glass for contextual meaning, such as weather carrying a landscape through the surface, rather than as a blanket decoration.
- Test desktop, narrow mobile, dark theme, reduced motion, forced colors, and zoom.

## Don't

- Never create a focus rim. Focus-only outlines, rings, borders, and inset or outer shadows are prohibited regardless of color.
- Never combine rounded corners with a vertical left accent line (`border-left` or `border-inline-start`) on cards, panels, widgets, popups, notices, or overlays. This prohibition is unconditional. Rounded corners without an attached accent rail remain allowed.
- Do not nest cards or wrap page sections in floating cards.
- Do not retrofit existing mockups or ordinary operational panels with the rounded-panel ratio.
- Do not use decorative gradient orbs, bokeh, or a one-note purple palette.
- Do not animate frequent keyboard actions or loop fake progress.
- Do not add visual effect libraries to solve a component structure problem.
- Do not use hold confirmation for routine actions or as a substitute for authorization, reversible design, and precise consequence copy.
- Do not use a theme editor as a substitute for hierarchy, state, or workflow design.
- Do not copy Nothing's no-shadow rule, rounded-edge accent rail, forced OLED black, or display typography into general Owen UI.
