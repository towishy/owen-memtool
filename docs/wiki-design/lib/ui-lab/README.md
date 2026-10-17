# Owen UI Lab

Browser validation surface for `@owen-wiki/ui-foundation`. It is an operable workbench rather than a marketing page or static component catalog.

AI 코딩 에이전트는 먼저 [`../ui-foundation/AI-USAGE.md`](../ui-foundation/AI-USAGE.md)의 Task router와 API maturity를 읽고, 이 Lab에서는 선택한 component의 실제 상태와 responsive behavior를 확인한다. Lab source나 mockup 전체를 제품 코드로 import하지 않는다.

```powershell
Set-Location lib/ui-lab
npm install
npm run build
npm run test:e2e:update
npm run test:e2e
npm run dev -- --host 127.0.0.1 --port 4173
```

## UI Portal Service Controls

[`../../UI-Portal/`](../../UI-Portal/)은 UI LAB, UI Foundation과 UI 시스템을 상단 탭으로 묶고, UI Lab과 UI 시스템 runtime의 상태 확인·통합 시작·안전 종료·현재 화면 열기를 제공한다. Foundation Catalog는 더 이상 runtime control을 소유하지 않는다.

## Edge 즐겨찾기

외부 Edge에서는 `file:///.../docs/ui-foundation/index.html`이나 `vscode://command/...`를 즐겨찾기에 넣지 않는다. 브라우저가 로컬 파일에서 VS Code task를 실행하거나 loopback API를 제어하는 경로는 신뢰할 수 없다.

1. VS Code에서 WIKI workspace를 연다. `UI Portal Controller` task는 folder open 시 자동 실행된다.
2. Edge 또는 VS Code 내장 브라우저에서 `http://127.0.0.1:4172/portal/`을 연다.
3. Portal 상단의 `전체 시작` 또는 UI LAB panel의 시작 명령으로 UI Lab을 `http://127.0.0.1:4173/`에서 시작한다.
4. `전체 종료`는 현재 controller가 시작해 소유하는 UI Lab·UI 시스템 process에만 적용된다.

주소가 열리지 않으면 VS Code에서 `Tasks: Run Task` → `UI Portal Controller`를 한 번 실행한다. VS Code가 완전히 종료되면 controller도 종료되므로 브라우저 즐겨찾기만으로 로컬 process를 시작할 수는 없다.

- `scripts/ui-lab-controller.mjs`가 `127.0.0.1:4172`에 localhost-only controller API를 연다.
- `.vscode/tasks.json`의 `UI Portal Controller` task가 workspace open 시 controller를 자동 시작한다. VS Code가 automatic task 허용을 묻는 경우 한 번 승인한다.
- Portal은 UI Lab `4173`과 UI 시스템 `4175`를 별도 process로 관리하고 Foundation Catalog는 same-origin static route로 표시한다.
- Foundation에서 `Lab에서 보기`를 누르면 Portal의 UI LAB 탭과 현재 hash로 이동한다.
- 종료는 controller가 직접 시작해 소유하는 process tree에만 적용한다. 다른 terminal의 외부 service는 상태만 감지한다.
- controller 로그는 ignored 경로 `dev/temp/ui-lab-controller/ui-lab.log`에 기록된다.

수동 controller 실행:

```powershell
node scripts/ui-lab-controller.mjs
```

The Playwright matrix covers desktop/mobile Chromium, axe, visual snapshots, dark theme, reduced motion, narrow viewport overflow, native modal Escape behavior, high-risk keyboard hold confirmation, success acknowledgement, and trigger focus restoration.

## Specimen index

| Hash | Source | Primary contract |
| --- | --- | --- |
| `#layered-stacks` | `src/layered-stacks-mockup.tsx` | responsive widget stack와 selection |
| `#feature-showcase` | `src/feature-showcase-study.tsx` | inert preview, external copy, 3→2→1열 reflow |
| `#micro-ui` | `src/micro-ui-study.tsx` | micro board, shelf, composer, dock |
| `#theme-workbench` | `src/app.tsx` | scoped token editing과 contrast |
| `#instrument-profile` | `src/white-instrument-study.tsx` | telemetry hierarchy와 target |
| `#mono-telemetry` | `src/mono-telemetry-study.tsx` | 30개 chart family, exact tooltip, filter, reduced motion |
| `#weather-orb-widget` | `src/weather-orb-widget-study.tsx` | location/view/unit/language filters, sibling orb layer, number pop |
| `#cloud-desk` | `src/cloud-desk-mockup.tsx` | quiet workspace layout |
| `#hierarchical-flying-panels` | `src/hierarchical-flying-panels-study.tsx` | connected primary/secondary drill, single pin, bounded move |
| `#food-commerce-dashboard` | `src/food-commerce-dashboard.tsx` | image-led discovery와 order rail |
| `#mobile-assistant` | `src/mobile-assistant-study.tsx` | intent, collection, composer, dock |
| `#glass-frame` | `src/glass-frame-study.tsx` | gradient back plate와 glass pane |
| `#corner-ratio` | `src/corner-ratio-study.tsx` | opt-in corner ratio ladder |
| `#settings-panels` | `src/settings-panel-study.tsx` | settings header와 row controls |
| `#frosted-scrollbar` | `src/frosted-scrollbar-study.tsx` | native scroll와 local grip |
| `#physical-book-interaction` | `src/physical-book-interaction-study.tsx` | direct drag와 curved-page state |
| `#mobile-commerce` | `src/mobile-commerce-study.tsx` | mobile discovery와 quantity flow |
| `#glass-search` | `src/glass-search-mockup.tsx` | functional clear-glass search |
| `#glass-controls` | `src/glass-control-study.tsx` | segmented/filter/action controls |
| `#glass-workflow` | `src/glass-workflow-study.tsx` | form, menu, command state |
| `#micro-interactions` | `src/micro-interactions-study.tsx` | copy, disclosure, overlay, real pending |
| `#liquid-dom` | `src/liquid-dom-integration.tsx` | capability gate와 CSS fallback |
| `#query-builder` | `src/query-builder-study.tsx` | field/operator/value 규칙과 AND/OR logic |
| `#workflow-builder` | `src/workflow-builder-study.tsx` | graph interaction, keyboard tabs, recommendation, execution evidence |
| `#operational-data` | `src/app.tsx` | sortable/selectable operational table |
| `#state-language` | `src/app.tsx` | async state vocabulary |
| `#form-actions` | `src/app.tsx` | field, select, confirmation, save |

`src/workflow-builder-study.tsx`는 page navigation과 desktop/mobile E2E matrix에 연결된 experimental specimen이다. Public anatomy와 Lab 회귀는 완성됐지만 실제 제품 채택과 graph engine ownership은 별도 maturity gate로 유지한다.

## Weather Orb Widget

`#weather-orb-widget`는 `GlintWidget`을 재사용해 semantic weather data와 CSS atmospheric orb를 형제 layer로 분리한다. 위치·현재/전망·섭씨/화씨·한국어/영어 filter가 실제 데이터를 바꾸고, 숫자는 한 번의 bounded pop으로 전환된다. Filter bar와 widget grid, sibling widget 사이에는 desktop 24px, narrow container 20px 간격을 유지한다. Reduced motion에서는 orb drift, cloud, rain, number pop이 모두 정지한다.

원본 Threads 사례의 영상, orb asset, PP Formula, copy, geometry는 복제하지 않았다. Blur panel이 focal content를 가릴 수 있다는 공개 피드백을 반영해 orb와 metric 사이에 blur layer를 두지 않는다.

## Workflow Builder

`#workflow-builder`는 Foundation의 sidebar, document tabs, canvas boundary, toolbar/action groups, typed nodes, recommendation, execution data anatomy를 실제 `@xyflow/react` graph와 결합한다. Lab은 tab keyboard, graph selection, 실행 상태, recommendation toggle, axe, narrow overflow를 검증한다. Node 위치, edge routing, graph persistence와 실행 engine은 소비 앱이 소유한다.

## How AI should use the Lab

1. 제품 요구에 맞는 Foundation API를 먼저 고른다.
2. 위 hash로 이동해 anatomy, state, narrow layout을 확인한다.
3. specimen의 sample copy, metrics, brand, 전체 composition을 복사하지 않는다.
4. 앱에서 같은 primitive를 실제 data와 state로 조합한다.
5. 앱 URL에 Generic URL Audit을 실행하고 screenshot을 직접 확인한다.

Lab의 badge나 고정 문구는 제품 capability 또는 현재 test count의 canonical source가 아니다. 정확한 상태는 실행한 `npm run check`와 audit report를 기준으로 판단한다.

## Cloud Desk Reference Mockup

`src/cloud-desk-mockup.tsx`는 Foundation의 기본 quiet workspace layout을 검증한다. Stable sidebar, opaque work plane, optional utility rail 구조는 메일뿐 아니라 파일, 리뷰, 리서치, 지식, 작업, 운영 화면에 폭넓게 사용한다. 검색 필터, mailbox 선택, task completion이 동작하며 container query로 sidebar·rail·mobile navigation을 재배치한다. 풍경을 맥락으로 사용하는 날씨 위젯만 contextual glass panel로 처리한다.

```powershell
npm run test:e2e -- --grep "Cloud Desk"
```

## Hierarchical Flying Panels

`src/hierarchical-flying-panels-study.tsx`는 stable anchor에서 1차와 2차 패널로 깊은 계층을 탐색하는 reference composition을 검증한다. 3단계 이상은 같은 2차 패널 안에서 drill하고, pin은 한 패널만 남겨 workplane 위에서 header drag 이동을 허용한다. Resize는 workspace boundary와 최소 크기를 지키며 narrow layout에서는 이동·resize를 제거하고 in-flow로 쌓는다. 이 specimen은 Owen MDBOX 구현에서 추출했지만 앱의 폴더명, 치수, 데이터 engine을 복제하지 않는다.

```powershell
npm run test:e2e -- --grep "hierarchical flying panels"
```

## Food Commerce Dashboard

`src/food-commerce-dashboard.tsx`는 food delivery reference에서 추출한 visual-first commerce composition을 독립 specimen으로 검증한다. Compact icon rail, image-led discovery plane, persistent order rail을 책임별로 나누고, category filter, search, quantity, honest checkout preview가 실제로 동작한다. 중간 폭에서는 order rail을 본문 아래로 이동하고, mobile에서는 navigation을 가로 dock으로 전환한다.

```powershell
npm run test:e2e -- --grep "food commerce dashboard"
```

## Generic URL Audit

Run the reusable audit against a local or explicitly approved remote page after its server is ready:

```powershell
Set-Location lib/ui-lab
npm run audit:url -- http://127.0.0.1:4173 --output ../../dev/temp/ui-audit
```

The command checks six viewports from 320 px through 1440 px with reduced motion enabled. It fails on WCAG A/AA axe violations, navigation and critical resource failures, console or page errors, broken images, horizontal overflow, and infinite animation under reduced motion. It records possibly wrapped or covered clickable controls as warnings because those checks need screenshot confirmation. The JSON report and optional full-page screenshots are written only to the selected output directory.

Use `--no-screenshots` for a report-only run. A nonzero exit code means at least one executable gate failed; it is not a subjective design score.

The Liquid DOM sample lazy-loads the WebGPU renderer only when WebGPU and the experimental HTML-in-Canvas `copyElementImageToTexture` API are available. Other browsers render the same notification content and action with the Owen Graphite CSS glass fallback.

## Clear Glass Search Mockup

Clear Glass search/control/workflow는 실험용 showcase가 아니라 Foundation의 기본 interaction material 검증 surface다. Functional control, navigation, overlay, menu, dock, active state, widget boundary에 이 재질을 우선 적용하고, dense content body는 opaque surface로 보호한다.

The search mockup reproduces a bright, low-contrast glass pill with four CSS layers: translucent fill, backdrop blur and luminosity, a directional specular rim, and a broad ambient shadow. It remains a native search form with a labeled input, non-rim keyboard focus treatment limited to background, text, or icon changes, and a clear action that returns focus to the input.

The implementation follows Apple’s guidance to reserve Liquid Glass for a focal functional layer and retain strong foreground legibility. It also avoids placing `opacity`, `filter`, or `will-change` on ancestors that would create an unexpected backdrop root. References: [Apple HIG Materials](https://developer.apple.com/design/human-interface-guidelines/materials) and [MDN backdrop-filter](https://developer.mozilla.org/en-US/docs/Web/CSS/backdrop-filter).

The companion control study reuses the same fill, border, and backdrop-filter tokens for a segmented mode switch, compact filter command, and circular action dock. Dense tables and forms remain opaque; the material is limited to focal navigation and command surfaces.

## Default Compositions

`Layered stacks`는 위젯형 UI의 기본 composition이다. Responsive grid의 각 item은 preview layer, persistent label tray, compact metadata, local command, selected state를 제공한다. `Settings panel composition`은 설정 메뉴의 기본 구조이며 tone/icon header 아래에 설명형 row와 switch, preset, command input을 배치한다.

The workflow study extends the material to a labeled form control, keyboard menu, and action group. The form uses a more opaque regular-glass fill for text legibility, the menu retains roving focus and Escape restoration, and primary actions use a high-contrast neutral fill. This validates selective use around workflows without turning dense form bodies into glass panels.

The page-level `Form and actions` section uses a scoped `lab-form--glass` variant on the existing foundation components. Its text input and Owner listbox keep FormField help and invalid-state semantics, while Save, Archive, and Delete preserve primary and danger meaning. Archive demonstrates ordinary press confirmation; Delete demonstrates the high-risk hold contract with keyboard completion, success acknowledgement, and focus return. The foundation `SelectControl` owns the Base UI behavior for keyboard navigation, typeahead, focus, form submission, and collision-aware positioning. The Lab's thin `GlassSelect` adapter supplies only Lucide icons and the workflow study's `glass-action` trigger and `glass-menu` popup classes, so the experiment does not change shared foundation defaults.

## Theme Workbench and Instrument Profile

The `Theme workbench` section validates scoped semantic token editing, a live operational specimen, controlled radius changes, and foreground/background contrast results. The `Instrument profile` section validates a single primary metric, segmented progress with exact ARIA values, supporting stats, light/dark rendering, and narrow viewport stacking.

These profiles selectively absorb public ideas from tweakcn and `nothing-design-skill`. They do not reproduce either product's trade dress: Owen Graphite Glass+Shadow remains the surface language, left accent stripes remain prohibited, and monospace/dot-grid treatment is limited to telemetry data.
