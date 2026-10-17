# Owen UI Foundation AI Usage Guide

AI 코딩 에이전트가 Owen 제품 UI를 구현할 때 사용하는 실무 라우터다. 이 문서는 새로운 디자인 시스템을 정의하지 않는다. 시각·동작 결정의 단일 진실 출처는 `DESIGN.md`이고, 이 문서는 현재 구현된 API와 UI Lab specimen을 올바르게 선택하는 방법만 정리한다.

제품 화면의 output job 정의부터 Foundation·앱·Lab 소유권, 상태·반응형·CSS 확장·브라우저 검증까지 이어지는 상세 실행 절차는 [`../../wiki/synthesis/ui-foundation-lab-development-guide.md`](../../wiki/synthesis/ui-foundation-lab-development-guide.md)를 함께 사용한다.

## Source priority

충돌이 있으면 다음 순서를 따른다.

1. `AGENTS.md`의 UI Design Foundation-First Workflow
2. `lib/ui-foundation/DESIGN.md`
3. 이 문서의 component 및 composition 선택 규칙
4. `lib/ui-foundation/README.md`의 API 설명과 예제
5. 관련 `REFERENCE-STUDY-*.md`
6. `lib/ui-lab`의 독립 transfer specimen

Reference study와 Lab mockup은 증거와 검증 surface다. 앱별 문구, 데이터, 브랜드, 화면 전체를 그대로 복사하는 source가 아니다.

Lucian 업무형 원본 6개는 [별도 원본 수집 경로](../lucian-uxui/README.md)에서 명시적으로 검색·선택한다. Portal의 적용 프롬프트와 `query-assets.mjs original`은 기존 source-packet 형식으로 고정 코드·해시를 제공하지만, 미등록 원본을 공개 Foundation API나 검증된 구현으로 취급하지 않는다. 일반 제품 선택의 Foundation 우선순위는 바뀌지 않는다.

## Start here

UI 작업 전에 다음 순서로 판단한다.

1. 화면의 `output job`을 한 문장으로 정한다. 예: “보안 분석가가 evidence 상태를 비교하고 검토 대상을 선택한다.” 아래 컴팩트 UI 실행 규칙에 따라 본문에 남길 핵심 정보와 상세 툴팁으로 옮길 부가 정보를 구분한다.
2. UI Lab의 `#glass-search`, `#glass-controls`, `#glass-workflow`, 작업에 맞는 shadcn/ui 구성요소·변형, 분석된 UI 언어 사례를 높은 우선순위로 함께 검토한다. 세 가지를 모두 사용하도록 강제하지 않고 조작 재질·구성요소·화면 구조의 역할에 맞게 선택한다.
3. UI Lab 왼쪽 navigation의 모든 specimen을 1순위 디자인 후보군으로 보고, 아래 Task router에서 output job에 가장 가까운 primitive 또는 composition을 고른다.
4. Foundation API를 먼저 조합하고 앱 전용 데이터와 copy는 소비 앱에 둔다. 새로 만들거나 수정하는 라운드 코너는 [`DESIGN.md`의 Continuous Corner Default](DESIGN.md#continuous-corner-default)를 재요청 없이 적용한다. Radius 크기와 continuous 형상을 구분하고, 소유 구현·브라우저 지원과 fallback을 확인하며 일반 `border-radius`만으로 완료 처리하지 않는다.
5. 관련 Lab specimen을 확인하되, mockup 전체를 component처럼 import하지 않는다.
6. loading, empty, error, partial, offline, success와 narrow container를 구현한다.
7. 내비게이션·overlay·모션·비동기 상태·상호작용 성능을 바꾸면 편집 전에 [흐름·모션·성능 검증 절차](../../.github/skills/ui-quality-audit/references/flow-motion-performance.md)로 대표 흐름, 복귀·실패 대조군과 검증 예산을 정한다. 성능 개선 주장은 변경 전 기준선이 필요하다. 문구·색상만 바꾸는 작업을 무관한 전체 흐름 검사로 확대하지 않는다.
8. Foundation check, Lab E2E, 실제 URL audit 순서로 검증한다. 컴팩트 배치와 열린 상세 툴팁의 desktop/mobile 화면 및 입력 방식별 동작도 확인한다. 선택한 흐름의 실제 동작·녹화 관찰·성능 측정은 URL audit의 자동 통과와 별도로 보고한다.

### 컴팩트 UI 실행 규칙

사용자 지정(2026-09-16): 이후 UI 작업은 [`DESIGN.md`의 Compact UI And Detail Tooltip Default](DESIGN.md#compact-ui-and-detail-tooltip-default)를 재요청 없이 적용한다. 이전의 긴 설명형 row나 full-width 박스 선택기를 관성적으로 복제하지 않는다.

1. **설계 전**: 짧은 라벨·값/상태·필수 조작·오류/경고는 본문, 목적·버전·경로·부가 절차는 상세로 분류한다. 가능한 한 줄의 상태+아이콘 명령과 내용 너비의 중앙 캡슐 선택을 우선하고, 다른 구성이 필요하면 이유를 기록한다. 작업별 Portal query와 실제 reference 확인은 그대로 수행한다.
2. **소유자 선택**: 범위·언어·preset에는 선호 자산 `vibe:features-tabbed-feature-switcher`의 모양과 native radio semantics를 조합한다. 뷰 전환에만 tab semantics를 사용한다. 툴팁은 기존 Foundation/제품 owner와 maturity를 확인하고 재사용한다. Mockup-local 코드를 검증된 공용 API로 간주하지 않는다.
   - Segmented track은 기본 2–5개의 동등한 선택에만 사용한다. wide container에서 짧은 label과 44px target을 실제로 보존할 때만 6–7개를 허용한다.
   - 형제 segment는 같은 폭과 동일한 content anatomy를 사용한다. icon-only, text-only, icon+text를 한 group에서 섞지 않는다.
   - 단일 form 값은 native radio group, panel 전환은 tabs, 단일·복수 toggle은 명시적 policy를 가진 button/ToggleGroup을 선택한다. 긴·동적·번역 가변 목록은 Select, Combobox 또는 menu owner로 보낸다.
   - 같은 폭 때문에 label을 자르거나 target을 줄여야 하면 segmented control을 포기한다. 여러 줄 pill, 숨긴 선택지, device-name 분기보다 실제 container capacity와 지원 locale을 판단 근거로 사용한다. 근거와 반례는 [`REFERENCE-STUDY-SEGMENTED-CONTROLS.md`](REFERENCE-STUDY-SEGMENTED-CONTROLS.md)에 있다.
3. **구현**: 불필요한 본문·카드·여백은 줄이되 글자 가독성과 이 패턴의 44px 조작 영역은 보존한다. 상세는 제목+본문의 디자인 툴팁으로 제공하고 아이콘에는 항상 접근성 이름을 둔다. 필수 정보는 숨기지 않으며 touch용 상세 trigger와 링크·명령·긴 내용용 popover/dialog를 구분한다.
4. **검증**: desktop/narrow의 실제 배치·reflow·선택 상태와 열린 툴팁을 캡처해 직접 확인한다. Hover/focus/tap 접근, 툴팁 hover 유지, Escape·초점 보존, 경계·clipping, reduced motion, 접근성·overflow·console/resource를 실행 검사한다. 문서 선호 기록만 바꾸는 작업에 실제 UI 검증 완료를 주장하지 않는다.

UI Foundation Lab 왼쪽 navigation의 30개 UI는 모두 `Priority 1`이다. Clear가 이 1순위 후보군 안에서도 가장 먼저이며, 나머지 27개 사이에는 기본 우열을 두지 않는다. 이는 모든 content를 glass로 만들라는 뜻이 아니라 functional interaction layer의 기본 재질을 먼저 검토하라는 뜻이다. Clear가 맞지 않거나 content readability를 해치면 opaque body를 유지하고, 다음 Lab specimen에서 맞는 composition을 선택한다.

UI Portal의 `UI 언어` 251개 스크린샷은 단순 용어 사전이 아니라 화면 구조와 디자인을 선택하는 시각 참고 사례다. 일반 UI 작업에서도 아래 절차로 관련 이미지를 실제로 열어 검토한다. 원본 자료는 그대로 보존하며, 제품 구현은 이 문서의 Task router, maturity, `DESIGN.md`와 확인된 shadcn/ui·Clear 소유 API를 따른다. 정적 [UI Foundation Catalog](D:/GITHUB/wiki/docs/ui-foundation/index.html)의 어휘 탐색과 설명 초안 기능도 보조적으로 사용할 수 있다.

같은 catalog의 `이미지·비디오 / Image & Video` tab은 `docs/prompts/image/`와 `docs/video-prompt/`를 한 화면에서 검색하는 로컬 Prompt Library다. 이미지·비디오와 즐겨찾기를 필터링하고 실제 prompt를 복사하거나 canonical Markdown을 연다. 문서를 추가하거나 수정한 뒤 `node scripts/sync-media-prompts-catalog.mjs`로 색인을 갱신하고 `node scripts/sync-media-prompts-catalog.mjs --check`로 drift를 확인한다.

## Design Detail Acceptance Loop

2026-09-19 사용자 피드백을 반영한 일반 제품 UI의 검증 절차입니다. 디자인 기준은 `DESIGN.md`의 User-Corrected Product Details를 따릅니다.

1. **소유자와 범위**: 요청된 화면·실제 렌더러·스타일 소유자부터 확인합니다. 보존할 표·본문·어두운 로컬 표면과 제품별 예외를 먼저 구분합니다. 전역 CSS나 새 primitive를 기본 해법으로 삼지 않습니다.
2. **검사 대상**: 같은 줄의 버튼·선택기·검색·캡슐·테두리가 있는 카운트와 checkbox 라벨을 모두 포함합니다. 입력 glyph와 외곽 래퍼, 닫힌 컨트롤과 팝업 행, 숫자 페이지와 이전·다음 명령을 구분합니다.
3. **숨은 경로**: 실제 메뉴로 데이터를 로드하고, 동적 상세창·접힌 영역·다른 pagination 소유자·열린 picker도 방문합니다. 본문만 캡처하거나 hash만 변경한 빈 화면으로 대체하지 않습니다.
4. **빠른 판별**: 편집 직후 가장 작은 동작 검사를 실행합니다. 높이 문제는 실제 border box·top/bottom·중심선, 상태 강조는 의미 필드·computed color/weight·대비, 입력칸은 상속·native appearance·전체 경계를 확인합니다.
5. **상태 조합**: 한·영, 라이트·다크 및 로컬 표면, 첫·마지막 선택, 인접 selected+hover, focus·checked·disabled/read-only·오류 중 지원하는 상태를 검사합니다. 캡슐 여백과 메뉴 간격은 동시에 활성화된 상태에서 확인합니다.
6. **동작 보존**: 접근성 이름, 키보드, tooltip/popup의 Escape와 초점 복귀, 검색·정렬·복사·CSV 및 데이터 값을 확인합니다. 상태 꾸밈으로 비상태 이름을 변환하지 않습니다.
7. **삭제 회귀**: 제거한 기능의 템플릿뿐 아니라 초기화 삽입·이벤트·노출 경로·기존 검사도 갱신합니다. 저장·새로고침·재진입 후 재등장을 검사하며, 오래된 검사 때문에 삭제된 기능을 복원하지 않습니다.
8. **실제 화면과 실행 환경**: 관련 창 크기의 캡처를 직접 보고 넘침·겹침·접근성·콘솔·리소스 오류를 실행 검사합니다. 디바이스 범위는 요청·제품 계약을 따릅니다. 네이티브 앱은 패키지 창 크기로도 확인하고, 사용자에게는 고정 viewport가 아닌 일반 실행 창을 보여드립니다.
9. **완료와 학습**: 규칙 저장, 정적 검사, 브라우저 검사, 패키지 실행, 다른 OS 검증을 구분합니다. 결함을 놓친 검사 selector·소유 경로를 보완하고 재사용 규칙은 이 디자인 문서, 제품별 예외는 제품 설계 문서, 개인 선호는 사용자 지침·기억에 기록합니다.

기록과 테스트 개수는 실제 UI 품질의 대체 증거가 아닙니다. 검증한 영역·상태·환경과 미검증 범위를 명시하며, 이미 확인한 범위를 무관한 전체 저장소 재검사로 확대하지 않습니다. 문서 반영만 요청된 경우에는 제품 CSS·컴포넌트·수집 원본을 새로 변경하지 않습니다.

## UI 언어 스크린샷 활용

사용자 지정(2026-09-08): Clear 디자인, shadcn/ui, UI 언어는 높은 우선순위의 세 디자인 후보군이다. 15개 분류의 251개 Screenshot은 항목별 기본 시각 분석을 갖춘 사례로 활용한다. 작은 검토 시트의 관찰과 작업별 원본 재확인, 실제 제품 검증을 구분한다.

1. 평소 `query-assets.mjs brief "<작업>" --limit 5`를 실행하면 구현 owner 선택과 별도로 최대 3개의 `visualReferences`가 포함된다. Portal에서 선택한 스크린샷은 기존 `AI 구현 패킷` 복사에 우선 포함된다.
2. 각 참고의 `image.path`를 이미지 도구로 열거나 `image.url`을 브라우저에서 열어 본다. AVIF를 직접 읽지 못하는 도구라면 브라우저 렌더·캡처로 확인한다. 파일명·설명만 읽고 이미지를 봤다고 하지 않는다.
3. 실제로 관찰한 정보 위계, 배치, 여백, 타이포그래피, 색상, 구성요소 묶음을 작업 목적과 연결한다. 설계안에 exact ID와 이미지 SHA-256, 적용할 점, 적용하지 않을 점, 미확인 동작을 짧게 남긴다.
4. 모든 사례를 한 스타일로 통일하지 않는다. 원본 이미지·브랜드·문구를 그대로 복제하거나 이미지를 실행 가능한 구성요소로 취급하지 않는다. 일반 제품의 조작 레이어와 구현 API는 기존 Foundation·shadcn/ui·Clear 기준을 유지한다.
5. 스크린샷은 runtime, 반응형, 접근성, 실제 데이터·수치의 검증 증거가 아니다. 해당 동작은 구현 화면에서 별도로 검증한다. 관련 사례가 없거나 이미지가 열리지 않으면 그 사실을 명시한다.

`designPriorities`는 Clear 후보 최대 2개, 작업에 맞는 shadcn 원본 후보 최대 3개, UI 언어 참고 ID를 역할별로 제시한다. 기존 구현 owner·필수 검증 slot을 대체하지 않는다. shadcn의 `pendingRegistration`·`comparison-pending`은 그대로 유지하며 카탈로그가 없으면 `catalog-not-loaded`로 표시한다. Native Select는 제외한다.

2026-09-15 사용자 지정으로, 질의와 일치하는 Bencho 블록도 높은 선호의 `designPriorities` 후보 최대 3개로 제시한다. 원본 29개는 Portal의 `Bencho` owner에서 개별 Live·소스·스크린샷으로 열 수 있다. 특히 MDBOX 하단 에디터 작업은 `bencho:toolbar`의 선택 기억과 위쪽 관련 메뉴를 먼저 대조한다. [참고 기록](REFERENCE-STUDY-BENCHO-BLOCKS.md)을 읽고 원본 격리, 사진·폰트 차이와 검증 대기를 유지한다. 이는 Registry 기반 구현 owner 선택이나 검증된 공용 API를 대체하지 않는다.

각 `visualReferences[].designAnalysis`에는 다음 구분을 유지한다.

| 필드 | 사용 기준 |
| --- | --- |
| `observed` | 실제 보이는 배치·정보 위계·밀도·색·타이포그래피·그룹화. 폰트명·정확한 색값·숨겨진 동작은 추측하지 않는다 |
| `suitableFor` / `avoidWhen` | 작업 적합성 제안과 제외 조건. 모든 사례의 미적 우열을 점수화하지 않는다 |
| `uncertainty` | 잘림·작은 문구·미노출 상태·동작 및 접근성 미검증 |
| `imageSha256` / `evidence` | 원본 이미지와 검토 시트·타일의 결합. 이미지가 바뀌면 분석을 다시 검토한다 |

분석은 [분류별 JSON](D:/GITHUB/wiki/dev/ui-portal-ai-usage/screen-design-analysis/README.md)에 보존한다. 검색은 제목·요약과 관찰·검색어·적합 용도를 사용하고, `avoidWhen`을 긍정 키워드로 색인하지 않는다. `reviewed`는 기본 시각 관찰 기록이며 승인된 디자인이나 검증된 제품이라는 뜻이 아니다. 후보를 고른 뒤 실제 이미지를 열어 채택할 구조와 제외할 요소를 설명한다.

예: 비용 화면에는 Clear의 기간·필터 조작, shadcn 표·Card의 불투명 본문, UI 언어 비용 사례의 요약→서비스별 비교 구조를 각각 검토한다. 사례의 금액·브랜드·작은 저대비 텍스트는 그대로 채택하지 않는다. 기존 Foundation이 표의 동작을 소유하면 그 API를 재사용한다.

```powershell
node scripts/ui-portal/query-assets.mjs references "서비스별 클라우드 비용 비교 대시보드" --limit 3
node scripts/ui-portal/query-assets.mjs references --id vibe:dashboards-cost-explorer-by-service
node scripts/ui-portal/query-assets.mjs references --list
```

`--list`는 전체 251개 ID·분류·이미지 정보를 확인하는 inventory다. 평소에는 작업에 맞는 1~3개만 선택하며 전체 목록이나 이미지 bytes를 매번 모델 컨텍스트에 넣지 않는다. CLI 조회는 이미지를 자동으로 모델에 첨부하거나 모델을 학습시키지 않는다.

현재 원본은 공개 카드 제목·요약·썸네일의 출처 표시 비공개 참고용 인덱스이며 재배포 라이선스가 확인된 자료가 아니다. 원본 프롬프트·Tailwind 소스를 복제하지 않고 이미지의 재게시·별도 배포·외부 모델 서비스 전송은 별도 권리·승인 확인을 거친다. 패킷의 `rights`와 `visualReferencePolicy`를 유지한다.

## shadcn/ui + Clear 우선 조합

사용자 지정(2026-09-06): 일반 제품 UI 설계에서는 shadcn/ui 구성요소를 Clear 레이어 디자인과 함께 많이 사용한다. 이를 참고 목록에만 두지 않고 화면 목적에 맞는 실제 구성요소와 Clear 적용 위치를 설계안에 명시한다.

- **구성요소 선택**: Button, Input/Field, Select/Combobox, Dropdown Menu, Tabs, Dialog/Popover, Data Table, Calendar/Date Picker 등에서 필요한 동작과 변형을 고른다. Native Select는 사용자 제외 결정을 유지한다.
- **Clear 적용 위치**: 검색·툴바·전환 컨트롤·팝오버·다이얼로그의 조작 레이어에 선택적으로 사용한다. 긴 본문, 표, 반복 행, 설정 본문은 불투명한 면으로 가독성을 유지한다. 모든 shadcn/ui 구성요소를 glass로 일괄 변경하지 않는다.
- **소유권**: 같은 역할의 Foundation API가 있으면 기존 소유 모듈에서 재사용·확장한다. 새 역할에는 확인된 shadcn/ui 소스와 동작을 활용하되, 앱마다 같은 primitive를 복제하거나 late CSS override를 쌓지 않는다.
- **원본과 제품 구분**: [원본 컬렉션](D:/GITHUB/wiki/lib/ui-lab/shadcn-collection.html)은 원본 보존용이다. 제품에 적용하는 shadcn/ui + Clear 조합은 별도 소비 화면이나 파생 자산에 두며 수집 원본을 변경하지 않는다.
- **선택 근거**: UI Portal에서 exact asset과 maturity·validation을 확인한다. 아직 등록되지 않은 원본 후보는 [현재 수집 진행도](D:/GITHUB/wiki/dev/ui-portal-intakes/shadcn-ui-full-review/ORIGINAL-PROGRESS.md)로 범위를 확인하고 미등록·미검증 상태를 명시한다. 이 선호만으로 전체 원본 비교 완료나 제품 채택 승인을 주장하지 않는다.

## Task router

| UI 요구 | 먼저 사용할 API | 함께 고려할 API | 사용하지 말아야 할 대체 |
| --- | --- | --- | --- |
| 저장, 실행, 재시도 같은 명령 | `ActionButton` | `AsyncState`, `StatusBadge` | 새 button primitive, div click handler |
| 드롭다운·더보기·행 작업 명령 메뉴 | 사용자 지정 1순위 `shadcn:dropdown-menu` (`shadcn/ui 명령 메뉴`) | 기존 소유 어댑터, Clear trigger, opaque menu, keyboard/Escape/focus 복귀 | 새 HTML 메뉴·타 메뉴 라이브러리 우선 도입; 값 선택 Select의 일괄 교체 |
| label, help, error가 있는 입력 | `FormField` | native input/textarea, `SelectControl` | label과 ARIA를 앱에서 각각 재구현 |
| 모바일 다중 필드 입력과 키보드 진행 | `FormField` + native input semantics | `SelectControl`, `ActionButton`, `REFERENCE-STUDY-MOBILE-FORM-FLOW.md` | placeholder-only label, 모든 input pill 처리, custom keyboard 우선 구현 |
| option 선택, typeahead, popup positioning | `SelectControl` | `FormField` | 직접 만든 listbox 또는 select popup |
| loading/empty/error/offline/partial/success | `AsyncState` | `ActionButton` | spinner만 표시하거나 빈 영역 유지 |
| compact 상태 표시 | `StatusBadge` | text/icon | 색상만 있는 dot 또는 무의미한 pill |
| 정렬, 선택, empty/loading이 있는 표 | `OperationalDataTable` | `AsyncState` | card grid로 표를 흉내 내기 |
| field/operator/value 조건을 편집하는 복합 필터 | experimental `QueryBuilder` | `SelectControl`, 서버 query translation | 단일 검색이나 static chip에 query builder 사용 |
| toolbar/sidebar/main/inspector/status 업무 shell | `WorkbenchShell` compound API | Cloud Desk composition | 모든 page section을 card로 감싸기 |
| stable anchor에서 깊은 계층을 작업면 위로 탐색 | Hierarchical Flying Panels reference composition | `WorkbenchShell`, `FrostedScrollArea` | 3개 이상 panel cascade, hover-open menu, unpinned free drag |
| 많은 site destination을 category별로 스캔하는 navigation | Mega Menu reference composition | semantic nav/link lists, `FrostedScrollArea`, narrow disclosure/drill-in | small nav에 mega menu 사용, hover-only open, ordinary links에 menu role 강제 |
| 2-6개 기능을 UI miniature와 짧은 copy로 설명 | `FeatureShowcase`, `FeatureShowcaseItem` | inert preview와 정확한 `previewLabel` | interactive demo, 장식용 feature card grid |
| 소수의 이미지 중심 작품·제품 이야기를 고정 순서로 탐색 | Physical Book Interaction reference composition | native button, keyboard, index, app-owned turn state | 운영 UI, 긴 문서 reader, dense catalog, primary navigation |
| modal 또는 좁은 화면 bottom sheet | `ResponsiveOverlay` | `FormField`, `ActionButton` | 앱별 focus trap 또는 Escape 처리 |
| Portal/Canvas 기존 DOM과 open ShadowRoot의 툴팁 통일 | experimental `TooltipLayer` | 기존 접근성 이름, 명시적 원본 제외 selector | 원본 iframe 스타일 변경, 필수 label/오류 설명의 tooltip 이전 |
| 되돌리기 어려운 mutation 확인 | `ConfirmableAction` | `confirmationMode="hold"`는 고위험에만 | 모든 confirm에 hold 사용 |
| 설정 group과 설명형 row | `SettingsPanel` compound API | `SettingsSwitch`, `SettingsPresetGroup`, `SettingsCommandInput` | row마다 중첩 card 또는 일반 form 전체 삽입 |
| semantic token 편집과 대비 확인 | `ThemeWorkbench` | 실제 preview specimen | 앱 전체 runtime theme store |
| 주 metric과 telemetry 상태 | `InstrumentPanel` | `StatusBadge`, header action | generic content card |
| 날씨·일정·배터리 등 compact contextual signal | `GlintWidget` | semantic text, native progress/time | generic glass card, dense analytics panel |
| 날씨 값과 atmospheric orb를 필터로 전환하는 compact group | `GlintWidget` + Weather Orb reference composition | explicit location/view/unit/language filters | orb를 의미 전달의 유일 경로로 사용, copy 위 blur pane |
| 모든 웹 페이지 document scroll과 앱 소유 세로 panel/menu/list | `FrostedScrollArea` | native wheel/touch/keyboard viewport, 2px rail, configurable compact grip | native arrow·ratio thumb 노출, vertical scroller 누락 |
| 작은 calendar/status/media visual frame | `GlassFrameWindow` | 실제 content label | 일반 panel 전체에 glass frame 적용 |
| 모바일 AI assistant | `MobileAssistantShell` compound API | suggestion, composer, dock | generic chat landing page |
| 모바일 상품 탐색과 수량/구매 흐름 | `MobileCommerceShell` compound API | search, filter, product, stepper, dock | operational app의 기본 shell |
| 작은 collection/library surface | `MicroUiShell` compound API | board, card, composer, shelf, dock | dense table 또는 settings 화면 |
| node graph workflow builder | experimental `WorkflowBuilder*` | `@xyflow/react` 등 앱 소유 graph engine | public export를 stable product engine으로 가정 |

## API maturity

Foundation의 디자인 계약은 네 실제 제품에서 운영 적용된다. 이 사실은 package API와 개별 composition이 모두 stable하다는 뜻은 아니다. 제품 채택, 공용 React API 직접 소비, pattern별 운영 검증을 [`CONSUMERS.md`](CONSUMERS.md)처럼 별도 축으로 판단한다.

### Preferred core

새 Owen 제품 화면에서 기본으로 사용할 수 있다.

- `ActionButton`
- `FormField`
- `SelectControl`
- `StatusBadge`
- `AsyncState`
- `OperationalDataTable`
- `FrostedScrollArea` (모든 웹 기반 document/app-owned vertical scroll의 기본)
- `WorkbenchShell`과 slot components
- `ConfirmableAction`
- `ResponsiveOverlay`

### Preferred opt-in patterns

특정 output job이 맞을 때만 사용한다.

- `SettingsPanel`: 설정 section
- `ThemeWorkbench`: theme authoring과 validation
- `InstrumentPanel`: telemetry와 operations
- `GlintWidget`: compact telemetry와 contextual status
- `GlassFrameWindow`: 작은 visual frame

### Reference compositions

공통 primitive보다 정보 구조가 강한 compound API다. 화면 목적이 정확히 일치할 때만 사용하고, 앱별 copy와 data는 소비 앱이 소유한다.

- `MobileAssistant*`
- `MobileCommerce*`
- `MicroUi*`
- `FeatureShowcase`, `FeatureShowcaseItem`

### Experimental or internal

- `TooltipLayer`는 Portal 외곽과 Canvas 편집기의 공통 설명 계층이다. 문서당 하나를 연결하고 `rootSelector`/`exclude`로 소유 범위를 한정한다. 기존 title은 native 중복 표시 없이 관리하고 해제 시 복구하며, 원본 iframe에는 진입하지 않는다. package root export가 있지만 closed ShadowRoot와 임의의 외부 앱은 검증 범위가 아니다. [API와 검증 경계](README.md#portal--canvas-tooltip-integration)를 따른다.
- `QueryBuilder`는 package root에서 export되고 Lab specimen과 회귀 검증을 갖지만 실제 Owen 앱 2곳에서 검증되기 전까지 experimental이다. 현재 text, number, select value만 지원하며 nested group이나 raw query syntax를 소유하지 않는다.
- `WorkflowBuilder*`는 package root export, Foundation 기본 CSS, UI Lab React Flow specimen과 desktop/mobile·keyboard·axe 회귀를 갖는다. 다만 graph state·layout·edge routing·실행 engine은 앱 소유이며 실제 Owen 앱 두 곳의 직접 소비가 확인되기 전까지 experimental이다.
- `mobile-task.tsx`는 reference study를 위한 내부 구현이며 package root에서 export되지 않는다. import 경로를 우회하지 않는다.
- UI Lab의 `CloudDeskMockup`, `HierarchicalFlyingPanelsStudy`, `LayeredStacksMockup`, food dashboard, glass studies는 앱에 import하는 public API가 아니다.

두 개 이상의 실제 앱에서 같은 composition이 반복되고 API, narrow-container behavior, keyboard, axe, visual regression이 검증된 뒤에만 maturity를 올린다.

## Public API inventory

다음 이름은 package root에서 import할 수 있다. 이 표에 없는 `src/*` module은 internal로 취급한다.

### Core controls and state

| Export | 역할 | 핵심 입력/계약 |
| --- | --- | --- |
| `ActionButton` | 표준 command button | `variant`, `size`, `loading`, `loadingText`, `startIcon`, `endIcon` |
| `FormField` | label/help/error와 control ARIA 연결 | render function child에 control props 전달 |
| `SelectControl` | Base UI 기반 select | `options`, `value`, `onValueChange`, form value, class names |
| `StatusBadge` | compact semantic status | `tone`, text/icon, optional live announcement |
| `AsyncState` | async region state | `loading`, `empty`, `error`, `partial`, `offline`, `success` |
| `ResponsiveOverlay` | native modal과 narrow bottom sheet | non-interactive trigger content, title, description, focus restore |
| `ConfirmableAction` | mutation confirmation | press 기본, high-risk에만 hold, async success/error |
| `OperationalDataTable` | operational table | caption, columns, sorting, selection, loading/empty |
| `QueryBuilder` | controlled operational filter builder | field definitions, typed value editors, rules, AND/OR, minimum rule count |
| `FrostedScrollArea` | custom vertical scroll surface | native viewport semantics와 fixed local grip |
| `TooltipLayer`, `TooltipLayerProps` | experimental 기존 DOM 툴팁 통합 | `rootSelector`, `exclude`, `className`; 문서당 하나, 원본 iframe 제외 |

### Workbench and authoring

| Family | Exports | 역할 |
| --- | --- | --- |
| Workbench | `WorkbenchShell`, `WorkbenchToolbar`, `WorkbenchSidebar`, `WorkbenchMain`, `WorkbenchInspector`, `WorkbenchStatusBar` | 업무 화면의 landmark와 responsive responsibility 분리 |
| Settings | `SettingsPanel`, `SettingsRow`, `SettingsSwitch`, `SettingsPresetGroup`, `SettingsCommandInput` | 설정 group, 설명형 row, binary/preset/command control |
| Theme | `ThemeWorkbench`, `calculateContrastRatio`, `getThemeContrastResults` | scoped token authoring과 contrast validation |
| Instrument | `InstrumentPanel` | primary metric, supporting stats, segmented progress, target |
| Glint widget | `GlintWidget` | compact value/time/status, decorative instrument, optional footer |
| Glass frame | `GlassFrameWindow` | 작은 visual frame의 back plate와 front pane |

### Mobile and micro compositions

| Family | Exports | 역할 |
| --- | --- | --- |
| Feature showcase | `FeatureShowcase`, `FeatureShowcaseItem` | section heading, inert UI preview, title, supporting copy를 갖춘 2-6개 기능 설명 |
| Mobile assistant | `MobileAssistantShell`, `MobileAssistantHeader`, `MobileAssistantMain`, `MobileAssistantSuggestion`, `MobileAssistantCollectionItem`, `MobileAssistantComposer`, `MobileAssistantDock`, `MobileAssistantDockItem` | intent, collection, composer, navigation을 갖춘 assistant surface |
| Mobile commerce | `MobileCommerceShell`, `MobileCommerceHeader`, `MobileCommerceMain`, `MobileCommerceSearch`, `MobileCommerceFilterBar`, `MobileCommerceFilterItem`, `MobileCommerceProduct`, `MobileCommerceQuantityStepper`, `MobileCommercePrimaryAction`, `MobileCommerceDock`, `MobileCommerceDockItem` | 상품 탐색, 수량, primary action, navigation 흐름 |
| Micro UI | `MicroUiShell`, `MicroUiHeader`, `MicroUiMain`, `MicroUiDotBoard`, `MicroUiCard`, `MicroUiLinkComposer`, `MicroUiShelf`, `MicroUiShelfItem`, `MicroUiDock`, `MicroUiDockItem`, `MicroUiOrbAction` | 작은 board와 collection/library interaction |

### Experimental workflow exports

`WorkflowBuilderShell`, `WorkflowBuilderSidebar`, `WorkflowBuilderMain`, `WorkflowBuilderTabList`, `WorkflowBuilderTab`, `WorkflowBuilderCanvas`, `WorkflowBuilderGraphViewport`, `WorkflowBuilderToolbar`, `WorkflowBuilderActions`, `WorkflowBuilderNode`, `WorkflowBuilderBranch`, `WorkflowBuilderSuggestion`, `WorkflowBuilderDataPreview`는 experimental이다. Exact export가 존재한다는 사실은 stable visual contract를 의미하지 않는다.

### Styles API metadata

| Export | 대상 |
| --- | --- |
| `selectControlStylesApi` | select root, trigger, popup 등 공개 selector와 variable |
| `responsiveOverlayStylesApi` | trigger, dialog, backdrop, header, body |
| `settingsPanelStylesApi` | settings panel slot과 scoped color variable |
| `queryBuilderStylesApi` | query shell, logic, rule rows, controls, footer |
| `frostedScrollAreaStylesApi` | scroll viewport, rail, grip |
| `glassFrameWindowStylesApi` | glass frame layer와 size/tone state |
| `defineStylesApi` | Foundation owner가 metadata를 선언할 때 사용하는 helper |

소비 앱은 Styles API metadata에 없는 내부 class나 DOM nesting에 의존하지 않는다. Type은 같은 package root에서 `import type`으로 가져온다.

## Composition router

| 화면 유형 | 기본 composition | Surface 원칙 | Lab anchor |
| --- | --- | --- | --- |
| mail, file, review, research, knowledge, task, operations workspace | Cloud Desk + `WorkbenchShell` | stable navigation, opaque work plane, optional utility rail | `/#cloud-desk` |
| room/collection 단위 local note, link, image, evidence browsing | Knowledge Rooms + `WorkbenchShell` | stable collection navigation, opaque grid/detail, offline cache, compact command | `/#knowledge-rooms` |
| stable tree/sidebar에서 1차·2차로 깊은 계층 탐색 | Hierarchical Flying Panels reference | connected primary/secondary, one pinned panel, narrow in-flow collapse | `/#hierarchical-flying-panels` |
| content-heavy site의 grouped navigation | Mega Menu reference composition | grouped semantic links, opaque body, optional evidence rail, mobile disclosure/drill-in | pending |
| 반복 widget, collection, stack browser | Layered stacks | preview layer + persistent label tray + local command | `/#layered-stacks` |
| 소수 기능의 UI 기반 설명 section | `FeatureShowcase` | neutral preview stage + external copy, 3→2→1열 | `/#feature-showcase` |
| 이미지 중심 portfolio, product story, limited lookbook | Physical Book Interaction reference | 직접 조작 + 버튼/키보드/index 동등 경로, reduced-motion 즉시 전환 | `/#physical-book-interaction` |
| settings page | `SettingsPanel` | tinted header, opaque rows, responsive control placement | `/#settings-panels` |
| data-heavy operations | `InstrumentPanel` + `OperationalDataTable` | 한 개의 hero metric, opaque data substrate | `/#instrument-profile`, `/#operational-data` |
| editable field/operator/value filtering | experimental `QueryBuilder` | opaque rows, explicit AND/OR, typed values | `/#query-builder` |
| compact weather, schedule, battery, activity status | `GlintWidget` | 한 개의 signal, contextual olive/neutral glass | `/#glint-widgets` |
| filtered weather metric with contextual orb motion | `GlintWidget` + app-owned filters/orb | semantic data와 decorative scene 분리, 20–24px spacing | `/#weather-orb-widget` |
| mobile assistant | `MobileAssistantShell` | suggestion/list는 opaque, composer와 dock만 glass | `/#mobile-assistant` |
| mobile commerce | `MobileCommerceShell` | product/order content는 opaque, primary action은 명확하게 | `/#mobile-commerce` |
| image-led food commerce dashboard | Lab reference composition | compact nav, discovery plane, persistent order rail | `/#food-commerce-dashboard` |
| micro collection/library | `MicroUiShell` | dotted board와 card는 opaque, command와 dock만 glass | `/#micro-ui` |
| graph workflow builder | experimental `WorkflowBuilder*` + app-owned graph engine | canvas와 data preview 책임 분리 | `/#workflow-builder` |

## Import pattern

기본 stylesheet는 앱 root에서 한 번만 import한다.

```tsx
import "@owen-wiki/ui-foundation/styles.css"

import {
  ActionButton,
  AsyncState,
  FormField,
  SelectControl,
  StatusBadge,
} from "@owen-wiki/ui-foundation"
```

Token data가 필요한 도구만 별도 entry를 사용한다.

```tsx
import "@owen-wiki/ui-foundation/tokens.css"
import tokens from "@owen-wiki/ui-foundation/tokens.json"
```

내부 `src/*` 경로를 직접 import하지 않는다. Styles API가 공개된 component는 내부 DOM selector를 추측하지 말고 metadata를 사용한다.

```tsx
import {
  responsiveOverlayStylesApi,
  selectControlStylesApi,
  settingsPanelStylesApi,
} from "@owen-wiki/ui-foundation"
```

## Common recipes

### Form and async action

```tsx
<form onSubmit={saveReview}>
  <FormField
    description="검토 큐와 감사 기록에 표시됩니다."
    error={nameError}
    label="검토 이름"
    required
  >
    {(controlProps) => <input {...controlProps} name="reviewName" />}
  </FormField>

  <ActionButton loading={saving} loadingText="저장 중" type="submit">
    저장
  </ActionButton>

  {saveError ? (
    <AsyncState
      actions={<ActionButton onClick={retry} variant="outline">다시 시도</ActionButton>}
      description={saveError}
      status="error"
      title="저장하지 못했습니다"
    />
  ) : null}
</form>
```

### Operational shell

```tsx
<WorkbenchShell>
  <WorkbenchToolbar>{toolbar}</WorkbenchToolbar>
  <WorkbenchSidebar aria-label="주요 탐색">{navigation}</WorkbenchSidebar>
  <WorkbenchMain>{workSurface}</WorkbenchMain>
  <WorkbenchInspector aria-label="선택 항목 세부 정보">{inspector}</WorkbenchInspector>
  <WorkbenchStatusBar>{status}</WorkbenchStatusBar>
</WorkbenchShell>
```

### Settings section

```tsx
<SettingsPanel
  description="편집 보조 기능을 설정합니다."
  icon={<Sparkles aria-hidden="true" />}
  title="Graphite 도우미"
  tone="amber"
>
  <SettingsRow
    control={(
      <SettingsSwitch
        checked={enabled}
        label="편집 보조 사용"
        onCheckedChange={setEnabled}
      />
    )}
    description="현재 문서에서 보조 명령을 사용할 수 있습니다."
    title="편집 보조"
  />
</SettingsPanel>
```

## Surface rules

- Clear Glass는 search, toolbar, segmented mode, command, select/menu, overlay, dock, active navigation, widget boundary에 사용한다.
- 긴 본문, dense table, 반복 list row, settings body, data visualization substrate는 opaque surface를 유지한다.
- page section을 floating card로 만들지 않고 card 안에 card를 중첩하지 않는다.
- 일반 운영 panel radius는 8px이다. Corner Ratio Ladder는 opt-in rounded surface의 크기·비례에만 사용하며, 새로 만들거나 수정하는 라운드 코너의 형태는 [`Continuous Corner Default`](DESIGN.md#continuous-corner-default)를 따른다.
- rounded surface에 vertical left accent rail을 붙이지 않는다.
- 상태와 선택은 text, icon, ARIA state를 함께 사용하고 색상만으로 전달하지 않는다.
- pointer press는 짧은 `scale(0.97)`을 사용할 수 있지만 keyboard selection과 navigation은 즉시 반영한다.
- icon-only action에는 accessible name을 제공한다. Lucide를 기본으로 사용한다.

## Project context preflight

외부 component skill이나 design-system CLI를 실행하기 전에 현재 작업이 Foundation 자체인지 소비 앱인지 먼저 판별한다. Agent context는 구현 정확도를 높이는 입력이며 `DESIGN.md`보다 높은 디자인 권한이 아니다.

1. Foundation 자체 작업이면 `package.json`, 이 문서, `src/index.ts`, 관련 Styles API와 Lab specimen으로 현재 버전과 public surface를 확인한다.
2. 소비 앱에 `components.json`이 있을 때만 그 앱 디렉터리에서 `npx shadcn info --json`을 사용해 framework, Tailwind 버전, alias, primitive base, icon library, installed component, global CSS 경로를 확인할 수 있다.
3. `components.json`이 없으면 shadcn 앱으로 추정하거나 WIKI root에 shadcn skill을 설치하지 않는다. Foundation API와 소비 앱의 실제 package metadata를 사용한다.
4. 외부 design system이 생성하는 `AGENTS.md`, `DESIGN.md`, theme, component index는 Owen 문서에 주입하지 않는다. 필요한 정보는 read-only CLI 또는 upstream 문서에서 조회하고 로컬 계약과 대조한다.
5. Agent용 component 문서는 설치된 package 버전과 맞아야 한다. 버전 불일치, 누락된 public export, stale usage example은 구현 전에 확인하고 API를 추측하지 않는다.

shadcn Skills의 project detection과 Astryx의 version-aligned retrieval/doctor 패턴에서 이 preflight를 학습했다. 두 외부 시스템의 component, theme, generated agent block은 Foundation에 채택하지 않는다.

### Expressive external component intake

Rare UI 같은 외부 interaction registry는 install source가 아니라 untrusted research input이다. `npx shadcn add` 또는 source copy 전에 다음 gate를 모두 기록한다.

1. animation을 제거해도 완결되는 output job과 state model
2. pointer, keyboard, touch, paste/autofill, Escape와 focus return의 동등 경로
3. full/reduced/static motion과 interruption behavior
4. hover가 없는 mobile의 persistent preview 또는 explicit command
5. npm, client runtime, canvas/WebGL, portal, sensor permission의 dependency budget
6. name/role/state, contrast, scroll owner와 non-color meaning
7. source URL, reviewed commit/date, credits와 standard license 여부
8. desktop/narrow axe, overflow, runtime, reduced motion과 interaction test

통과하지 못한 후보는 public API, Lab specimen, Foundation Catalog에 추가하지 않는다. 세부 component별 판단은 `REFERENCE-STUDY-RARE-UI.md`를 따른다.

## Current implementation boundaries

AI는 다음 항목을 자동으로 “검증 완료”라고 가정하지 않는다.

- Focus indicator: Foundation은 focus rim을 금지한다. 그러나 keyboard focus는 background, text, icon 또는 surface 변화로 반드시 식별 가능해야 한다. 새 화면에서 focus 전후 시각 차이를 직접 검증한다.
- Nested responsiveness: viewport 폭만 보지 말고 sidebar나 inspector 안에서 줄어든 실제 component container 폭을 검사한다. `overflow: hidden`으로 focusable content를 숨기지 않는다.
- `ResponsiveOverlay.trigger`: 현재 구현은 전달한 content를 내부 button으로 감싼다. `ActionButton` 같은 interactive element를 전달하지 말고 icon과 text를 담은 비-interactive `span`을 전달한다.
- `FrostedScrollArea`: keyboard로 직접 스크롤해야 하는 viewport에는 `viewportProps={{ tabIndex: 0, "aria-label": "..." }}`를 제공한다.
- Hold confirmation: routine archive, publish, retry에는 press mode를 사용한다. hold mode는 즉시 비용이 큰 영구 삭제나 key 폐기에만 사용한다.
- Lab copy와 metrics는 specimen data다. 제품 claim, customer proof, 실제 test result로 재사용하지 않는다.

## Lab specimen index

이 표의 30개 항목은 모두 앱 전용 디자인보다 먼저 검토하는 `Priority 1` 후보군이다. Clear 3종을 먼저 보고, 이후 output job과 가까운 나머지 왼쪽 navigation specimen을 선택한다. Experimental 또는 Lab-only 표시는 import maturity를 제한하지만 디자인 후보 검토 순위는 낮추지 않는다.

| Hash | Source | 검증할 내용 | Foundation 사용 여부 |
| --- | --- | --- | --- |
| `#glass-search` | `glass-search-mockup.tsx` | functional glass search와 clear focus return | Lab recipe · Clear first |
| `#glass-controls` | `glass-control-study.tsx` | segmented/filter/action glass controls | Lab recipe · Clear first |
| `#glass-workflow` | `glass-workflow-study.tsx` | form, keyboard menu, action state | Lab recipe · Clear first |
| `#layered-stacks` | `layered-stacks-mockup.tsx` | widget anatomy, selection, responsive grid | composition reference |
| `#feature-showcase` | `feature-showcase-study.tsx` | inert preview, external copy, container reflow | `FeatureShowcase*` |
| `#micro-ui` | `micro-ui-study.tsx` | board, shelf, composer, dock, orb action | `MicroUi*` |
| `#theme-workbench` | `app.tsx` | scoped token editing, contrast, preview | `ThemeWorkbench` |
| `#instrument-profile` | `white-instrument-study.tsx` | telemetry hierarchy, target, dark profile | `InstrumentPanel` |
| `#mono-telemetry` | `mono-telemetry-study.tsx` | 30개 chart family, exact data, tooltip, filter, reduced motion | Lab-only reference |
| `#weather-orb-widget` | `weather-orb-widget-study.tsx` | explicit filters, semantic weather, sibling orb layer, number pop, spacing | `GlintWidget` composition |
| `#glint-widgets` | `glint-widget-study.tsx` | compact signal hierarchy, contextual glass, responsive grid | `GlintWidget` |
| `#cloud-desk` | `cloud-desk-mockup.tsx` | quiet workspace, sidebar, work plane, rail | `WorkbenchShell` reference |
| `#knowledge-rooms` | `knowledge-rooms-mockup.tsx` | collection navigation, filter, grid/detail, offline cache, KO/EN | `WorkbenchShell` + `FrostedScrollArea` reference |
| `#hierarchical-flying-panels` | `hierarchical-flying-panels-study.tsx` | connected primary/secondary drill, single pin, bounded move/resize, narrow in-flow fallback | reference composition |
| `#food-commerce-dashboard` | `food-commerce-dashboard.tsx` | image-led discovery와 order rail | Lab-only reference |
| `#mobile-assistant` | `mobile-assistant-study.tsx` | suggestion, collection, composer, dock | `MobileAssistant*` |
| `#glass-frame` | `glass-frame-study.tsx` | back plate와 front pane 분리 | `GlassFrameWindow` |
| `#corner-ratio` | `corner-ratio-study.tsx` | showcase/identity/pill radius | geometry reference |
| `#settings-panels` | `settings-panel-study.tsx` | tone header, row, switch, preset, command | `SettingsPanel*` |
| `#frosted-scrollbar` | `frosted-scrollbar-study.tsx` | native scroll + fixed local grip | `FrostedScrollArea` |
| `#physical-book-interaction` | `physical-book-interaction-study.tsx` | drag/command/keyboard/index 단일 turn state와 curved leaf | Lab-only reference |
| `#mobile-commerce` | `mobile-commerce-study.tsx` | search, filter, product, quantity, dock | `MobileCommerce*` |
| `#micro-interactions` | `micro-interactions-study.tsx` | real pending, copy success, disclosure, overlay | interaction reference |
| `#motion-graphics` | `motion-graphics-study.tsx` | bounded anime.js orchestration, Motion pointer feedback, reduced-motion final state | Lab-only reference |
| `#liquid-dom` | `liquid-dom-integration.tsx` | capability-gated renderer와 CSS fallback | experimental integration |
| `#query-builder` | `query-builder-study.tsx` | explicit logic, typed values, add/remove, narrow reflow | experimental `QueryBuilder` |
| `#workflow-builder` | `workflow-builder-study.tsx` | graph interaction, keyboard tabs, recommendation, execution evidence, narrow reflow | experimental `WorkflowBuilder*` |
| `#operational-data` | `app.tsx` | sorting, selection, loading/empty ownership | `OperationalDataTable` |
| `#state-language` | `app.tsx` | loading/empty/offline vocabulary | `AsyncState` |
| `#form-actions` | `app.tsx` | FormField, Select, confirmation, save state | core components |

`workflow-builder-study.tsx`는 Lab page와 E2E matrix에 연결된 experimental specimen이다. Foundation anatomy와 responsive contract를 검증하지만 graph engine, node position, edge routing, execution state를 Foundation이 소유한다는 뜻은 아니다.

## Validation

가장 가까운 검증부터 실행한다.

```powershell
npm run check --prefix lib/ui-foundation
npm run check --prefix lib/ui-lab
.\.venv\Scripts\python.exe scripts\check-ui-reference-studies.py
python scripts/check-ui-foundation-catalog.py
```

실제 앱 또는 Lab URL을 6개 viewport에서 감사한다.

```powershell
npm run audit:url --prefix lib/ui-lab -- http://127.0.0.1:4173 --output ../../dev/temp/ui-audit
```

완료 전 최소 확인 항목:

- keyboard로 primary workflow 완료
- focus가 rim 없이도 시각적으로 식별됨
- overlay Escape와 trigger focus restore
- loading, empty, error, partial, offline, success 중 해당 상태 존재
- 320px viewport와 좁은 nested container에서 focusable content가 잘리지 않음
- dark theme, reduced motion, forced colors 확인
- axe violation, runtime error, failed resource, broken image 없음
- screenshot에서 text overlap, nested card, 과도한 glass 없음

## Documentation update rule

새 component 또는 composition을 추가할 때는 코드만 export하지 않는다.

1. `src/index.ts` public export와 type export를 갱신한다.
2. 이 문서의 Task router와 API maturity를 갱신한다.
3. `README.md` Components 표에 contract를 추가한다.
4. 두 화면 이상에 적용할 reference-derived rule이면 `REFERENCE-STUDY-*.md`를 추가하거나 갱신한다.
5. UI Lab에 독립 specimen과 hash navigation을 추가한다.
6. unit, axe, keyboard, narrow-container, dark/reduced-motion, visual regression을 추가한다.
7. 구현과 검증이 모두 끝난 뒤에만 `experimental`에서 `preferred`로 올린다.
