# Owen UI Foundation

Owen 제품 UI에서 반복되는 접근성 primitive와 업무 화면 pattern을 제공하는 private React 패키지다. Extend Labs의 Extend UI와 shadcn compound-component 구조를 기본 문법으로 삼고, Owen Graphite Liquid Glass는 필요한 surface에만 제한적으로 적용한다.

## AI first route

AI 코딩 에이전트는 구현 전에 [`AI-USAGE.md`](AI-USAGE.md)를 읽는다. 이 가이드는 화면 요구를 현재 component와 composition에 연결하고, preferred/opt-in/experimental 경계, UI Lab specimen, import pattern, 검증 명령을 한 곳에 정리한다.

판단 순서는 `AGENTS.md` → `DESIGN.md` → `AI-USAGE.md` → 이 README → 관련 `REFERENCE-STUDY-*.md` → UI Lab specimen이다. Lab의 mockup과 reference study는 구현 증거이며 제품 copy나 화면 전체를 복제하는 source가 아니다.

UI 이름이나 Lab hash가 기억나지 않으면 [`../../docs/ui-foundation/index.html`](../../docs/ui-foundation/index.html)을 직접 연다. 이 정적 catalog의 `Foundation UI` tab은 검색어와 용도 범주로 30개 specimen을 찾고 관련 API, source와 local Lab anchor를 보여 준다. `UI 설명 프롬프트` tab은 VibePrompt의 공개 title·summary·link 251개를 vocabulary index로 제공하며, local favorite와 Owen 계약이 포함된 독립 설명 초안을 만든다. `이미지·비디오 / Image & Video` tab은 로컬 Prompt Library의 이미지 34개와 비디오 20개를 함께 검색하고 별도 local favorite, 실제 프롬프트 복사, canonical Markdown 열기를 제공한다. Evidence receipt가 있는 prompt는 검증 모델·날짜·known limitation을 함께 표시하고, 나머지는 미검증으로 구분한다. 외부 prompt body와 code는 복제하지 않는다. Preview thumbnail은 원본 이미지 URL과 canonical detail link를 보존한 private reference로만 로컬에 유지하며 독립 재배포하지 않는다. 외부 reference tab은 Priority 1 Foundation inventory가 아니다.

## Maturity

**Operational design system / private package stable candidate.** Foundation 디자인 계약은 `sarang.day`, `day.sarang.day`, `mdbox.sarang.day`, Owen MDBOX의 실제 제품 화면에서 사용되고 있다. UI Lab과 `lib/ui-foundation-consumer`는 공용 React API를 직접 import하는 두 독립 browser consumer다. 다만 두 번째 consumer는 제품형 통합 fixture이므로, 공용 React public API는 같은 API를 두 실제 제품이 직접 소비·검증하기 전까지 private stable candidate로 유지한다. 앱별 근거는 [`CONSUMERS.md`](CONSUMERS.md)를 따른다.

| Layer | Role | Default |
| --- | --- | --- |
| Extend Labs + shadcn | 제품 control 구조와 variant 문법 | Canonical |
| Base UI | select 등 복합 control의 keyboard, focus, positioning engine | Internal dependency |
| Owen UI Foundation | 공통 접근성 primitive와 업무 pattern | Preferred local package |
| Owen Graphite | panel, boundary, active-state surface | Selective |
| Select Codes recipes | 고급 interaction pattern | Experimental |
| OriginKit scenes / Liquid DOM | 드문 visual scene | Capability-gated |

## Components

| Component | Contract |
| --- | --- |
| `ActionButton` | loading 중 중복 실행 방지, surface별 density, 명시적 variant |
| `FormField` | label, description, error, required, disabled ARIA 연결 |
| `SelectControl` | Base UI 기반 keyboard, typeahead, focus, form value, collision-aware positioning |
| `StatusBadge` | 색상 외 text/icon으로 상태 전달 |
| `AsyncState` | loading, empty, error, partial, offline, success 상태 vocabulary |
| `OperationalDataTable` | caption, sticky header, sorting, selection, loading/empty state |
| `QueryBuilder` | controlled field/operator/typed-value 규칙, explicit AND/OR logic, responsive rule layout |
| `WorkbenchShell` | toolbar, sidebar, main, inspector, status bar의 반응형 compound layout |
| `ConfirmableAction` | native modal confirmation, opt-in hold safety, async error/success, focus restore |
| `ResponsiveOverlay` | desktop modal, narrow viewport bottom sheet, native Escape/focus behavior |
| `ThemeWorkbench` | semantic token 편집, scoped CSS variable preview, foreground/background 대비 검사 |
| `InstrumentPanel` | primary metric 1개, supporting stat, segmented progress, optional target marker와 header action slot을 갖춘 telemetry profile |
| `GlintWidget` | 날씨·일정·배터리처럼 한 개의 compact signal을 contextual olive/neutral glass에 표시하는 소형 위젯 |
| `MobileAssistantShell` | 추천 intent, compact collection row, composer, bottom dock을 묶는 모바일 assistant compound layout |
| `GlassFrameWindow` | gradient back plate와 translucent front pane을 분리한 작은 시각 frame |
| `MobileCommerceShell` | search, category filter, product, quantity, primary action, dock을 묶는 모바일 commerce layout |
| `MicroUiShell` | dotted board, compact media card, link composer, horizontal shelf, dock, orb action을 묶는 micro collection layout |
| `FeatureShowcase` | section heading, semantic item list, inert UI preview, concise supporting copy를 묶는 기능 설명 composition |
| `SettingsPanel` | 설명형 row, switch, preset, command input을 묶는 환경설정 compound composition |
| `FrostedScrollArea` | native scroll semantics와 2px rail, configurable compact local glass grip을 결합한 기본 세로 scrollbar template |
| `TooltipLayer` | experimental Portal/Canvas 통합 계층: 기존 DOM과 open ShadowRoot의 hover/focus 설명, 충돌 회피, native title 복구 |

`WorkflowBuilder*`는 package root export, Foundation 기본 CSS, UI Lab의 React Flow transfer specimen, desktop/mobile 회귀 검증을 갖지만 실제 Owen 앱 두 곳의 직접 소비가 확인되기 전까지 experimental API다. `mobile-task.tsx`는 package root에서 export되지 않는 internal reference implementation이다. 둘 다 새 제품 화면의 기본 선택으로 사용하지 않는다. 자세한 maturity와 대체 경로는 [`AI-USAGE.md`](AI-USAGE.md#api-maturity)를 따른다.

### Portal / Canvas tooltip integration

`TooltipLayer`는 문서당 하나만 연결한다. `rootSelector`는 소유 surface(기본 `body`), `exclude`는 원본·비소유 영역, `className`은 식별용 추가 class다. `data-owen-tooltip` 또는 기존 `title`, ARIA 이름, 버튼 문구를 일반 텍스트로 표시한다. 비대화형 필수 설명이나 form label을 툴팁으로 대체하지 않는다.

흰색 불투명 면, 중성 경계, 6px radius, 12px 글자와 7px/10px 여백을 [tooltip-layer-styles.ts](D:/GITHUB/wiki/lib/ui-foundation/src/tooltip-layer-styles.ts) 한 곳에서 관리한다. Base UI가 positioning을 담당하며, hover 450ms, keyboard focus 즉시 표시, Escape·pointerdown·dragstart·document scroll 닫힘, reduced-motion과 forced-colors 대체 표현을 제공한다. ShadowRoot에서는 같은 트리에 popup과 `aria-describedby`를 연결하고 native dialog의 top layer를 유지한다.

수집 원본 iframe과 `[data-owen-tooltips='off']`는 제외한다. Canvas 소비자는 배치된 node/screen/export도 제외한다. 현재 검증 대상은 Portal 외곽과 Canvas 편집기이며, 닫힌 ShadowRoot나 모든 외부 앱의 범용 tooltip engine으로 검증된 것은 아니다. 원본 컬렉션이나 Registry 승격과 무관한 experimental API다. 실행 근거와 재현 명령은 [Canvas validation](D:/GITHUB/wiki/dev/ui-portal-intakes/m3e-canvas/VALIDATION.md#portal-and-canvas-tooltips)에 있다.

## Reference Compositions

모든 `REFERENCE-STUDY-*.md`는 문서 상단에 evidence metadata를 둔다. `output_job`과 `surface`가 적용 범위를 정하고, `axes_covered`와 `unresolved_axes`는 typography, color, spacing, radius, borders, shadows, layout, hierarchy, iconography, imagery, motion, interaction 12축을 빠짐없이 분류한다. `allowed_range`, `counterexample`, `transfer_specimen`은 관찰을 Foundation 규칙으로 과잉 일반화하지 않게 한다.

```powershell
.venv\Scripts\python.exe scripts\check-ui-reference-studies.py
```

`high` confidence는 source evidence뿐 아니라 실제로 존재하는 독립 transfer specimen을 요구한다. 아직 specimen이 없으면 `transfer_specimen: "pending"`과 `medium` 또는 `low` confidence를 사용한다. 이 메타데이터는 후보 근거의 품질을 검증하며, 승인된 결정의 단일 진실 출처는 계속 `DESIGN.md`다.

외부 `DESIGN.md` 포맷과 first-party 사례는 [`DESIGN-WATCHLIST.md`](DESIGN-WATCHLIST.md)에서 discovery source로만 추적한다. Watchlist 항목은 Foundation 결정이나 코드 의존성이 아니며, 브랜드 token과 구현 recipe를 직접 가져오지 않는다.

`REFERENCE-STUDY-QUIET-GLASS-WORKSPACE.md`와 UI Lab의 `Cloud Desk`는 workspace layout의 기본 composition이다. Stable navigation sidebar, opaque work plane, optional utility rail을 mail, file, review, research, task, knowledge, operations 화면에 폭넓게 사용한다. Contextual glass panel은 배경 맥락이 의미를 가질 때만 제한적으로 두며, 실제 반응형 조합과 브라우저 검증은 `../ui-lab/src/cloud-desk-mockup.tsx`에 있다.

`REFERENCE-STUDY-KNOWLEDGE-ROOMS.md`와 UI Lab의 `Knowledge Rooms`는 로컬 지식 컬렉션의 stable navigation, type filter, preview grid, selected-item reading, offline cache와 compact command를 한 작업면에 묶는다. 원본 Threads 영상의 자산·문구·window chrome·trade dress는 복제하지 않으며 공용 component가 아닌 app-owned transfer specimen으로 유지한다.

`REFERENCE-STUDY-HIERARCHICAL-FLYING-PANELS.md`와 UI Lab의 `Hierarchical flying panels`는 stable navigation anchor에서 1차·2차 패널로 깊은 계층을 탐색하는 reference composition이다. 3단계 이상은 같은 2차 패널 안에서 drill하고, pin은 한 패널만 workplane 위에 남겨 header drag 이동과 bounded resize를 허용한다. 좁은 화면에서는 이동·resize를 제거하고 in-flow disclosure로 전환한다. Owen MDBOX 한 제품에서만 운영 검증되었으므로 public component가 아니라 medium-confidence reference로 사용한다.

`REFERENCE-STUDY-MOBILE-ASSISTANT.md`는 모바일 AI assistant 이미지에서 큰 질문, 짧은 추천 intent, compact collection row, 하단 composer와 dock의 구조를 추출한다. Glass는 composer와 dock에만 쓰고 list row는 불투명하게 유지하며, icon tone은 text 의미를 보조하는 데만 사용한다.

`REFERENCE-STUDY-GLASS-FRAME-WINDOW.md`는 Figma glass effect 튜토리얼에서 back plate, front pane, gradient, inner rim, shadow의 레이어 책임을 추출한다. 작은 calendar/status/media frame이 필요할 때만 `GlassFrameWindow`를 사용한다.

`REFERENCE-STUDY-CSS-EFFECT-GENERATORS.md`는 CSS.glass, Neumorphism.io, retired Shadows by Philipp Brumm, HYPE4 Glassmorphism Generator, CSS-Tricks를 현행성·license·생성 코드·compatibility 관점에서 구분한다. 외부 recipe는 fill, backdrop, rim, inner highlight, contact/ambient shadow로 분해한 뒤 기존 owner에 필요한 값만 옮기며 opaque fallback, reduced transparency, forced colors, backdrop root, contrast와 paint cost를 실제 browser에서 검증한다. 새 effect token이나 dependency를 자동 추가하지 않는다.

`REFERENCE-STUDY-GLINT-WIDGETS.md`와 UI Lab의 `Glint widgets`는 올리브 tint, inner rim, tabular numeral, 단일 signal color를 작은 telemetry/status surface로 제한한다. 큰 목표형 분석은 `InstrumentPanel`, 비상호작용 visual frame은 `GlassFrameWindow`를 사용한다.

`REFERENCE-STUDY-WEATHER-ORB-WIDGET.md`와 UI Lab의 `Weather orb widget`은 `GlintWidget`의 semantic metric과 decorative visual slot을 재사용해 날씨 데이터와 atmospheric orb를 형제 layer로 분리한다. 위치·보기·단위·언어 필터는 widget group 위에 두고 filter-to-grid와 widget gap을 20–24px로 유지한다. 숫자 pop과 orb motion은 reduced-motion에서 완전히 정지하며, blur panel로 copy나 orb를 가리는 원본 위험은 채택하지 않는다.

`REFERENCE-STUDY-CORNER-RATIO.md`는 app-install showcase 이미지에서 추출한 곡률 사다리를 rounded-corner surface의 opt-in 계약으로 제공한다. 기존 운영 panel과 목업은 8px radius를 유지한다. 둥근 panel을 새로 선택한 경우에만 15% 비율을 16~32px로 제한하고, 큰 showcase는 40~104px, 정사각 identity는 21%, command는 pill/circle을 사용한다.

UI Lab의 Clear Glass search/control/workflow specimen은 Foundation의 기본 interaction material이다. Search, toolbar, segmented mode, command, form control, select/menu, overlay, dock, active navigation, widget boundary에 폭넓게 적용하되 dense table, 긴 본문, 반복 row, settings body는 불투명하게 유지한다.

UI Lab의 `Layered stacks`는 위젯형 화면의 기본 composition이다. Round shell 안에 preview layer, persistent label tray, compact metadata, item-local command, selected state를 갖춘 responsive item grid를 구성한다.

`REFERENCE-STUDY-FEATURE-SHOWCASE.md`와 `FeatureShowcase`는 2-6개 기능을 inert UI miniature, 짧은 제목, 한 문단 설명으로 소개하는 reference composition이다. Preview와 copy를 분리하고 3→2→1열로 reflow하며, 실제 interactive demo, settings row, dense operational data에는 사용하지 않는다. UI Lab의 `From signal to shared decision`은 외부 문구와 브랜드를 복제하지 않은 독립 transfer specimen이다.

`REFERENCE-STUDY-PHYSICAL-BOOK-INTERACTION.md`와 UI Lab의 `Physical book interaction`은 소수의 이미지 중심 작품이나 제품 이야기를 고정 순서로 탐색하는 opt-in narrative composition이다. Page turn은 하나의 app-owned state machine에서 drag progress, velocity 기반 commit/cancel, interruptible settle, front/back content, 곡면 geometry와 lighting을 함께 관리한다. 버튼·키보드·index 동등 경로와 reduced-motion 즉시 전환이 필수이며, 운영 UI·긴 문서·dense catalog에는 사용하지 않는다. 검토한 upstream에는 명시적 software license가 없으므로 코드·자산·고유 외형을 vendor하지 않는다.

`REFERENCE-STUDY-MOBILE-COMMERCE.md`는 furniture discovery와 cart 화면에서 warm-neutral shell, black primary action, product row, quantity stepper, bottom dock의 계약을 추출한다. Product와 order content는 불투명 surface를 유지한다.

`REFERENCE-STUDY-MICRO-UI.md`는 micro collection 이미지의 trip board와 library shelf를 분석해 dotted board, compact card, link composer, dock, orb action의 역할을 분리한다. 추천 이미지 자체를 복제하지 않고 token과 구조만 Foundation API로 변환한다.

`REFERENCE-STUDY-FOOD-COMMERCE-DASHBOARD.md`는 desktop food delivery 화면에서 compact icon rail, image-led discovery plane, persistent order rail의 책임 분리를 추출한다. UI Lab의 `Citrus Market`은 원본 브랜드·문구·이미지를 복제하지 않은 독립 transfer specimen이며, Foundation 공용 API가 아니라 commerce dashboard composition 참고면이다.

`REFERENCE-STUDY-SETTINGS-PANELS.md`와 `SettingsPanel`은 설정 메뉴의 기본 composition이다. Tone/icon header 아래에 설명형 setting row, switch, preset, command input을 배치하며 실제 설정 행은 불투명 surface를 유지한다.

`REFERENCE-STUDY-FROSTED-SCROLLBAR.md`와 `FrostedScrollArea`는 모든 웹 기반 페이지의 document-level scroll과 앱 소유 panel/menu/list 세로 scroll에 기본 적용하는 canonical scrollbar다. Native wheel, touch, keyboard scroll은 유지하고 native arrow와 content-ratio thumb 대신 2px rail, density에 맞게 조정 가능한 compact glass grip, 중앙 3-line handle을 사용한다. Horizontal tab/chip scroller, 명시적 OS scrollbar, virtualized scroll owner만 기록된 예외로 둔다.

`REFERENCE-STUDY-CLEAR-OPERATIONAL-UI.md`와 `QueryBuilder`는 field, operator, typed value를 갖는 editable condition list를 제공한다. Rule row는 불투명하게 유지하고 AND/OR와 add command에만 제한적으로 Clear Glass를 사용한다. 실제 앱 2곳에서 검증되기 전까지 experimental API로 취급한다.

`REFERENCE-STUDY-MOBILE-FORM-FLOW.md`는 Revolut account-details 사례에서 persistent label, mobile touch height, bounded radius, input-mode 선택, keyboard 위 field progression을 추출한다. 기존 `FormField`, `SelectControl`, `ActionButton`이 owner이며 placeholder-only label, 모든 input의 pill 처리, custom keyboard 우선 구현은 채택하지 않는다. 독립 transfer specimen이 없으므로 `medium` confidence를 유지한다.

`REFERENCE-STUDY-FONT-SOURCING.md`는 Fontshare, 눈누, Google Fonts, Fontjoy, Velvetyne을 각각 Latin 후보, 한글 탐색, 다국어 배포, pairing 발산, experimental display 역할로 구분한다. 새 family는 exact license와 language coverage, version·hash, CDN 또는 self-hosting 책임, 한국어·영어 실제 specimen을 통과한 뒤에만 도입하며 무료·상업 이용·오픈소스를 같은 상태로 취급하지 않는다. 기존 Aptos/Pretendard/Segoe 운영 stack은 유지한다.

`REFERENCE-STUDY-MICRO-INTERACTIONS.md`는 copy success, disclosure, occasional overlay, 실제 pending indicator만 허용하는 motion 경계를 정의한다. Keyboard state는 즉시 반영하고 reduced-motion에서는 positional transform과 반복 motion을 제거한다.

`REFERENCE-STUDY-DESIGNMOTIONHQ-UI-SYSTEMS.md`는 공개 UI 교육 게시물 95개를 전수 검토하고, 홍보·순수 모션 7개를 제외한 88개 근거를 13개 UI 시스템 원칙으로 합성한다. `lib/ui-foundation-consumer`의 bilingual Workbench와 11개 interactive specimen이 독립 transfer surface이며, source 계정의 visual skin·code·copy·정량 claim은 복제하거나 검증된 사실로 취급하지 않는다.

`REFERENCE-STUDY-RARE-UI.md`는 Rare UI의 11개 표현형 component와 shadcn registry workflow를 검토한다. 표준 LICENSE 부재와 derivative provenance 때문에 code·asset은 vendor하지 않고, registry parity metadata, persistent mobile preview, bounded motion intake gate만 Foundation 운영에 흡수한다. `scripts/check-ui-foundation-catalog.py`가 Catalog, UI Lab nav, AI-USAGE index와 source path drift를 검증한다.

`REFERENCE-STUDY-SMOOTHUI.md`는 MIT-licensed SmoothUI의 130개 component와 34개 block을 전수 catalog metadata로 검토한다. 109개 Motion dependency와 공개 metadata상 55개 reduced-motion gap 때문에 registry를 wholesale 설치하지 않고, machine-readable catalog와 bounded motion 운영 원칙만 보강 근거로 사용한다.

`REFERENCE-STUDY-VIBE-PROMPTS.md`는 VibePrompt의 15 category·251개 layout idea를 UI vocabulary discovery source로 검토한다. 표준 reuse license를 확인하지 못했으므로 title, summary, category, canonical link와 출처가 표시된 preview thumbnail만 private local index에 보존한다. Prompt body와 Tailwind source는 복제하지 않고 thumbnail은 독립 재배포하지 않는다. 독립 transfer specimen은 UI Foundation Catalog의 `UI 설명 프롬프트` tab이다.

`REFERENCE-STUDY-MEGA-MENU.md`는 한 navigation category의 목적지가 단일 목록에서 스캔하기 어려울 때 grouped semantic link list와 optional evidence rail을 제공하는 medium-confidence reference composition이다. Desktop click·keyboard·Escape·focus restore를 유지하고 좁은 화면에서는 in-flow disclosure 또는 drill-in으로 전환한다. Ordinary site links에 ARIA menu role을 강제하거나 hover-only 접근, site map 전체 투입, link마다 card·glass·shadow 반복은 허용하지 않는다.

`REFERENCE-STUDY-MOTION-GRAPHICS.md`와 UI Lab의 `Evidence motion graphics`는 anime.js timeline을 한정된 장면 orchestration에, Motion을 React 기반 pointer feedback에 분리 적용한다. 자동 재생과 반복 loop는 금지하고 OS 또는 제품 reduced-motion이 켜지면 완전한 최종 상태를 즉시 표시한다.

`REFERENCE-STUDY-WORKFLOW-BUILDER.md`는 sidebar, document tabs, graph canvas, contextual recommendation, 실행 데이터 표의 책임을 분리한다. UI Lab의 독립 React Flow specimen과 desktop/mobile·keyboard·axe 회귀를 갖는 high-confidence reference지만, graph state와 실행 engine은 계속 소비 앱이 소유한다.

`REFERENCE-STUDY-MOBILE-TASK-DASHBOARD.md`는 task home/detail 구조를 정리하지만 아직 독립 transfer specimen이 없어 `medium` confidence로 유지한다.

### Mobile assistant composition

```tsx
<MobileAssistantShell>
  <MobileAssistantMain>
    <h1>무엇을 도와드릴까요?</h1>
    <p>추천 작업을 선택하거나 바로 질문하세요.</p>
    <MobileAssistantSuggestion
      description="검토 범위와 순서를 정리합니다."
      icon={<ListTodo aria-hidden="true" />}
      title="검토 계획 만들기"
      tone="mint"
    />
  </MobileAssistantMain>
  <MobileAssistantComposer
    inputProps={{ placeholder: "무엇이든 물어보세요" }}
    label="어시스턴트에게 질문"
    trailingActions={<button aria-label="메시지 보내기" type="submit"><ArrowUp /></button>}
  />
  <MobileAssistantDock label="주요 탐색">
    <MobileAssistantDockItem active icon={<Home />} label="홈" />
    <MobileAssistantDockItem icon={<Bookmark />} label="저장됨" />
  </MobileAssistantDock>
</MobileAssistantShell>
```

### Settings panel composition

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
        checked={useHtmlTables}
        label="HTML 표 우선 사용"
        onCheckedChange={setUseHtmlTables}
      />
    )}
    description="보고서 명령에서 Graphite CSS가 포함된 표를 사용합니다."
    title="HTML 표 우선 사용"
  />
  <SettingsRow
    control={(
      <SettingsPresetGroup
        label="즐겨찾기 프리셋"
        onValueChange={setPreset}
        options={presets}
        value={preset}
      />
    )}
    description="현재 작업에 맞는 명령 묶음을 적용합니다."
    title="즐겨찾기 프리셋"
  />
</SettingsPanel>
```

`SettingsPanel`은 settings page의 section 단위로 사용한다. Named tone은 gray부터 sky, indigo, violet, rose, coral, amber, olive, mint, teal까지 제공하며 custom settings color variable도 허용한다. Header icon은 가능한 한 outline glyph를 사용하고 tile surface, border, glyph가 현재 header accent를 함께 따라야 한다. 일반 form field, data table, 중첩 card를 row control에 넣지 않고, 폭이 큰 복합 편집은 별도 화면이나 overlay로 분리한다.

## Install

```json
{
  "dependencies": {
    "@owen-wiki/ui-foundation": "file:../wiki/lib/ui-foundation"
  }
}
```

Import the base stylesheet once:

```tsx
import "@owen-wiki/ui-foundation/styles.css"
```

## Example

```tsx
import { ActionButton, FormField } from "@owen-wiki/ui-foundation"

export function ProfileForm() {
  return (
    <form>
      <FormField label="Display name" description="Visible to your team" required>
        {(controlProps) => <input {...controlProps} name="displayName" />}
      </FormField>
      <ActionButton type="submit">Save profile</ActionButton>
    </form>
  )
}
```

### Styles API metadata

복합 control은 안정적인 selector, CSS variable, state modifier를 metadata로 공개한다. 제품별 surface는 내부 DOM을 추측하지 않고 이 계약을 기준으로 확장한다.

```tsx
import {
  responsiveOverlayStylesApi,
  selectControlStylesApi,
  settingsPanelStylesApi,
} from "@owen-wiki/ui-foundation"

const selectSlots = selectControlStylesApi.selectors
const overlayStates = responsiveOverlayStylesApi.modifiers
const settingsSlots = settingsPanelStylesApi.selectors
```

현재 `SelectControl`은 `--owen-select-radius`, `--owen-select-shadow`를, `ResponsiveOverlay`는 `--owen-overlay-radius`, `--owen-overlay-shadow`, `--owen-overlay-backdrop`을 지원한다. `SettingsPanel`은 accent, header, icon surface, icon border, body surface, panel border 변수를 공개한다. 기본값은 Owen token과 기존 surface를 유지하며, 변수는 해당 component root 범위에서만 재정의한다.

### High-risk destructive action

`confirmationMode="hold"`는 계정·workspace 삭제, key 폐기처럼 실수 비용이 큰 작업에만 사용한다. 일반 archive, publish, retry에는 기본 `press` confirmation을 유지한다.

```tsx
<ConfirmableAction
  confirmationMode="hold"
  confirmLabel="Delete workspace"
  description="Members lose access immediately. Audit records are retained."
  holdDuration={1000}
  onConfirm={deleteWorkspace}
  successDescription="The workspace was deleted."
  successTitle="Workspace deleted"
  title="Delete this workspace?"
  triggerLabel="Delete workspace"
  variant="danger"
/>
```

Hold mode accepts pointer and Space/Enter input, cancels on early release, pointer boundary exit, blur, or page visibility loss, and preserves a synthetic-click path for assistive technology. Async failures stay in the dialog and move focus to the announced error; success requires an explicit acknowledgement before trigger focus is restored.

The behavior was adapted from the MIT-licensed snapshot in `../dialog-web-component`. The upstream Web Component remains available as a reference, but its Shadow DOM visuals, fixed copy, demo auto-completion, and generic use are not part of the canonical React foundation.

### Theme workbench

`ThemeWorkbench`는 tweakcn에서 학습한 token → specimen → contrast 검증 흐름만 내재화한다. CSS 변수는 workbench root에만 적용되므로 앱의 `:root`나 sibling 화면을 바꾸지 않는다.

```tsx
const tokens = [
  { id: "background", label: "Background", group: "Colors", kind: "color", value: "#ffffff", cssVariable: "--preview-background" },
  { id: "foreground", label: "Foreground", group: "Colors", kind: "color", value: "#18181b", cssVariable: "--preview-foreground" },
  { id: "radius", label: "Radius", group: "Shape", kind: "range", value: "8", min: 0, max: 16 },
] satisfies ThemeTokenDefinition[]

<ThemeWorkbench
  tokens={tokens}
  contrastPairs={[
    { id: "content", label: "Content", foregroundToken: "foreground", backgroundToken: "background" },
  ]}
  preview={(values) => <PreviewCard radius={Number(values.radius)} />}
/>
```

색 외에 radius, spacing, typography, shadow를 token으로 표현할 수 있지만 실제 specimen과 responsive/state 검증 없이 값만 저장하지 않는다. `calculateContrastRatio`와 `getThemeContrastResults`는 외부 validation flow에서도 재사용할 수 있다.

### Instrument profile

`InstrumentPanel`은 계기판 언어를 Owen Graphite에 맞게 제한 적용한다. White/cool-neutral light surface와 선택적 dark profile을 제공하며, Glass+Shadow shell은 유지하고 좌측 accent line과 강제 OLED black은 사용하지 않는다. 목표값은 색상만으로 전달하지 않고 marker와 `aria-valuetext`에 함께 노출한다.

```tsx
<InstrumentPanel
  title="Endpoint posture"
  eyebrow="Primary / coverage"
  metric="87"
  unit="%"
  progress={87}
  progressLabel="Endpoint coverage"
  progressTarget={80}
  progressTargetLabel="Target 80%"
  progressTone="warning"
  status="Attention · 02"
  statusTone="warning"
  stats={[
    { label: "Healthy", value: "1,284", tone: "success" },
    { label: "Degraded", value: "18", tone: "warning" },
  ]}
/>
```

`progress`는 0–100으로 clamp되고, segmented bar는 항상 정확한 `progressbar` ARIA 값을 함께 제공한다. 한국어 본문은 Foundation sans stack을 유지하며 monospace는 숫자와 짧은 metadata에만 적용한다.

## Validation

```powershell
Set-Location lib/ui-foundation
npm install
npm run check
```

The package test suite covers TypeScript contracts, press and hold confirmation paths, pointer/keyboard/assistive input, async errors, focus restoration, theme token editing, WCAG contrast calculation, instrument progress semantics, representative interaction, and axe structural checks. Browser rendering, contrast, keyboard traversal, mobile layout, dark theme, and reduced motion are covered by `lib/ui-lab`.

## Guardrails

- Do not add a component that exists in the consuming app's Extend UI/shadcn layer without a cross-app need.
- Never combine rounded corners with a vertical left accent line (`border-left` or `border-inline-start`) on cards, panels, widgets, popups, notices, or overlays. There are no exceptions. Rounded corners remain allowed when no accent rail is attached to the rounded edge.
- Glass is reserved for shell boundaries, overlays, or a meaningful active state. Forms and dense tables remain opaque.
- Icon-only actions require an accessible name. Prefer Lucide; use Reicon only when it adds a needed filled/outline glyph.
- Loading, errors, offline state, and partial results must be explicit. A spinner alone is not a state model.
- Keyboard actions render immediately. Motion must not delay selection, navigation, or focus.
- Hold confirmation is a high-risk safety control, not a replacement for clear copy, authorization, undo, or server-side validation.
- ThemeWorkbench is an authoring and validation surface, not an application-wide runtime theme store.
- InstrumentPanel is for telemetry, status, and data-dense operations. Do not use it as a generic card style.
