---
schema_version: 1
reference_study: true
output_job: "review an expressive component registry and route only defensible interaction patterns into Owen UI Foundation"
surface: "component registry governance and opt-in expressive React interactions"
evidence: ["Toolfolio Rare UI listing reviewed 2026-08-19 as discovery metadata only", "rareui.com components index, llms.txt, and representative component pages reviewed 2026-08-19", "swamimalode07/rare-ui source and documentation at main commit 0dc1e6d3556870ad05d568396b1e6eb44403cd48 reviewed 2026-08-19", "independent six-viewport audit of the components index and four representative component pages in dev/temp/ui-audit/rare-ui-*"]
confidence: medium
axes_covered: ["typography", "color", "spacing", "radius", "borders", "shadows", "layout", "hierarchy", "iconography", "motion", "interaction"]
unresolved_axes: ["imagery"]
allowed_range: "Adopt registry metadata, parity validation, persistent preview fallbacks, and bounded interaction behavior only after Owen semantics, input parity, reduced motion, dependency budget, and mobile behavior are independently verified."
counterexample: "Do not vendor Rare UI code or assets, install its registry into Foundation, reproduce its black-orange or Apple-derived trade dress, use hover-only previews, or treat expressive animation as a default product primitive."
transfer_specimen: "scripts/check-ui-foundation-catalog.py"
---

# Reference Study: Rare UI

## Scope

Rare UI는 Next.js, Tailwind CSS, Motion, shadcn registry로 구성된 11개 표현형 React component 모음이다. 이 검토의 목적은 component를 복제하는 것이 아니라 다음 질문에 답하는 것이다.

1. Foundation의 현재 primitive/composition으로 이미 해결되는가?
2. 제품 의사결정을 더 빠르게 만드는 interaction인가, showcase 장식인가?
3. pointer, keyboard, touch, reduced motion, static fallback이 동등한가?
4. source, dependency, credits, license, generated registry artifact를 추적할 수 있는가?

Toolfolio listing은 discovery source로만 사용했다. component 수, repository 상태, license와 실제 behavior는 Rare UI 공식 site와 GitHub source에서 다시 확인했다.

## Legal And Provenance Boundary

- 검토 시점에 repository root의 표준 `LICENSE` 파일은 확인되지 않았다.
- `lib/components.ts`와 `llms.txt`에는 개인·상업 사용 허용, attribution 권장, kit 재판매 금지라는 custom usage text가 있다.
- 같은 metadata는 많은 component가 다른 제품과 작업을 reverse-engineer하거나 recreate한 것이라고 밝히고 credits를 별도로 둔다.
- README의 “open-source” 표현만으로 OSI license 또는 모든 derivative asset의 재배포 권한을 추정하지 않는다.

따라서 Rare UI source, registry payload, logo, Apple emoji, custom SVG, motion geometry와 고유 외형은 Foundation에 vendor하지 않는다. 이 문서는 추상적인 운영·interaction 원칙만 기록한다.

## Evidence Summary

### Registry Operations

Rare UI의 가장 강한 전이 패턴은 component 외형이 아니라 registry 운영 구조다.

- 한 item이 `description`, npm dependencies, registry dependencies, files, optional CSS, interaction, props, usage, credits를 함께 기록한다.
- source component와 `registry.json`, generated `public/r`, gallery, install command가 같은 item name을 공유한다.
- `shadcn build`와 `next build`를 release 전 실행하고 generated registry output을 source와 함께 commit한다.
- `llms.txt`가 같은 component inventory에서 page, description, install, source, dependency를 제공한다.

Foundation은 shadcn registry로 전환하지 않는다. 대신 같은 drift 방지 원칙을 `scripts/check-ui-foundation-catalog.py`에 적용해 static Catalog, UI Lab navigation, `AI-USAGE.md` specimen index, source path를 비교한다.

### Live Site Audit

`https://www.rareui.com/components` index는 320, 375, 414, 768, 1280, 1440px에서 axe, runtime, resource, broken image, horizontal overflow, reduced-motion executable gate를 통과했다.

그러나 component detail page는 별도 결과를 보였다.

| Page | Executable result | Main finding |
| --- | --- | --- |
| Duration Picker | 6/6 viewport FAIL | dark surface의 16px text contrast 2.78:1, page heading contrast 3.26:1 |
| Emoji Reaction | 6/6 viewport FAIL | foreground text contrast 4.42:1과 heading contrast 3.26:1 |
| GitHub Activity | 6/6 viewport FAIL | month labels 10px contrast 3.14:1과 heading contrast 3.26:1 |
| Proximity Sidebar | 6/6 viewport FAIL | contrast 3.26:1, internal scrollable `main`이 keyboard-focusable하지 않음 |

수동 interaction 검토에서는 다음을 추가 확인했다.

- Duration Picker의 hour/minute `number` input에는 accessible name, `name`, `inputMode`가 없었다. Edit command가 input에 focus는 이동시켰지만 focus 대상의 의미를 전달하지 않았다.
- OTP Input은 6개 input 각각 `Digit N of 6` label과 sequential keyboard 입력을 제공하지만 focus ring을 사용해 Owen no-focus-visual 계약과 충돌한다.
- Emoji Reaction은 horizontal menu, arrow navigation, outside/Escape handling과 trigger focus return을 구현한다. 다만 close 후 exit layer의 semantic menu가 즉시 제거되지 않는 상태를 관찰했다.
- GitHub Activity detail panel은 explicit show/hide button을 제공하지만 열린 panel은 Escape로 닫히지 않았다.
- Proximity Sidebar는 34개 real target button과 `aria-current="location"`을 제공한다. 마지막 `Mobile` target을 누른 뒤 viewport anchor가 `Usage`에 머무는 end-of-scroll mismatch를 관찰했다.
- components gallery의 preview는 desktop hover에서 유용하지만 320px touch screenshot에서는 여러 video area가 빈 검정 surface로 남았다. Persistent poster 또는 explicit play control이 필요하다.
- components page를 전환할 때 preview MP4 request가 abort되는 기록이 반복됐다. Gallery media lifecycle과 preload budget을 별도 검증해야 한다.

## Component Routing Decisions

| Rare UI component | Owen decision | Foundation mapping and required correction |
| --- | --- | --- |
| Folder component | Reject as new primitive | `Layered stacks`가 preview/tray/selection을 이미 소유한다. Hover fan-out와 3D flap을 복제하지 않고 touch에서 persistent preview를 유지한다. |
| Bounce sidebar | Reject | Routine navigation state는 즉시 반영한다. Spring marker는 output job을 개선하지 않고 source에서 direct reduced-motion evidence가 약하다. |
| Proximity Sidebar | Reference-only candidate | 긴 desktop reader의 real-section minimap으로만 검토한다. `FrostedScrollArea` rail과 같은 edge를 경쟁하지 않게 하고, narrow에서는 숨기거나 explicit index로 이동한다. End-of-scroll active target과 focusable scroll owner를 먼저 해결한다. |
| Duration Picker | App-owned candidate | Native number input, persistent label, clamp message와 explicit confirm을 유지하는 bounded display-to-edit pattern만 학습한다. Squircle/flubber morph와 focus ring은 채택하지 않는다. |
| Fluid Orb | Do not add | 기존 Weather Orb와 experimental Liquid DOM capability gate가 같은 문제를 소유한다. ChatGPT voice-mode 외형을 복제하지 않는다. |
| Scroll Progress | Narrative-only reference | 긴 article에서 하나의 derived progress와 explicit section disclosure로 제한한다. Foundation scrollbar를 대체하지 않고, Escape/focus restore와 static section label을 제공한다. |
| Code Block | Pattern adopted, no API yet | 한 semantic accent에서 token을 파생하고 copy success를 text+live status로 전달하는 원칙을 채택한다. 실제 반복 수요 전에는 Foundation component를 추가하지 않는다. |
| Gravity Letters | Reject | Decorative physics이며 default `maxGlyphs`가 무제한이다. reduced-motion, memory budget, deterministic capture와 semantic value가 불충분하다. |
| OTP Input | Candidate when auth flow exists | `autocomplete="one-time-code"`, paste distribution, grouped accessible label, error/success text, no focus ring, reduced-motion static character를 갖춘 독립 구현만 허용한다. |
| GitHub Activity | Map to existing telemetry | `InstrumentPanel`/`GlintWidget`의 summary와 bounded detail disclosure로 번역한다. GitHub trade dress와 green scale을 복제하지 않고 Escape와 exact text를 추가한다. |
| Emoji Reaction | App-owned social interaction | 제품에 reaction workflow가 있을 때만 사용한다. `ResponsiveOverlay` 수준의 collision, keyboard, Escape, focus restore를 유지하고 Apple asset과 repeated particle stream은 기본 제외한다. |

## Adopted Foundation Rules

### Expressive Component Intake

외부 interaction component를 Foundation 후보로 검토할 때 다음 필드를 기록한다.

| Field | Required evidence |
| --- | --- |
| Output job | 사용자가 animation 없이 끝낼 수 있는 한 문장 task |
| State model | idle, hover, active, open, pending, success, error, disabled |
| Input parity | pointer, keyboard, touch, paste/autofill, Escape와 focus return |
| Motion contract | full motion, reduced motion, static end state, interruption behavior |
| Responsive fallback | hover가 없는 좁은 화면의 persistent preview와 explicit command |
| Dependency budget | package, client-only runtime, canvas/WebGL, portal, sensor permission |
| Accessibility | name, role, state, contrast, scroll owner, non-color meaning |
| Provenance | source URL, reviewed commit/date, credits, standard license 여부 |
| Validation | narrow/desktop axe, overflow, runtime, reduced motion, interaction test |

이 gate를 통과하지 않은 component는 Foundation public API나 UI Lab `Priority 1` inventory에 추가하지 않는다.

### Gallery Preview Contract

- Hover preview에는 persistent poster 또는 meaningful static state를 기본으로 둔다.
- Touch device에는 explicit play/open command가 있어야 하며 빈 video surface를 표시하지 않는다.
- Preview media abort는 runtime error로 과장하지 않되, request churn과 blank fallback을 performance finding으로 기록한다.
- Gallery screenshot과 product runtime이 같은 engine이라는 주장은 source relation으로 입증한다.

### Registry Parity Contract

- Catalog item, Lab hash, documentation index와 source path는 stable item ID를 공유한다.
- generated inventory count를 손으로 독립 관리하지 않는다. 현재 static catalog는 `check-ui-foundation-catalog.py`가 count와 hash drift를 차단한다.
- dependency, interaction, boundary, evidence, maturity를 metadata에 보존한다.
- external registry install command는 조사 evidence일 뿐 Foundation root에서 자동 실행하지 않는다.

## Do Not Adopt

- black/orange one-note palette와 oversized editorial footer
- blanket squircle, pill, spring 또는 gooey morph
- Apple emoji·ChatGPT orb 등 식별 가능한 third-party trade dress
- hover-only meaning, hover-only preview, pointer-only drag
- focus-visible ring과 glow
- unbounded particle, physics glyph, ambient WebGL loop
- 10px 저대비 label과 translucent text
- component detail page의 nested scroll owner를 keyboard에서 제외하는 구현
- “single file”이라는 이유만으로 dependency, global CSS, sensor permission과 runtime cost를 숨기는 packaging

## Foundation Mapping

| Rare UI learning | Existing Owen owner |
| --- | --- |
| Registry item parity | `scripts/check-ui-foundation-catalog.py` |
| Bounded user-triggered motion | `REFERENCE-STUDY-MICRO-INTERACTIONS.md` |
| File/folder preview composition | `Layered stacks` |
| Long document position | `FrostedScrollArea`; optional future reader minimap reference |
| Duration/OTP field semantics | `FormField`, native input, `ActionButton` |
| Expanding compact metric | `InstrumentPanel`, `GlintWidget`, disclosure semantics |
| Reaction overlay | `ResponsiveOverlay` behavior contract; app-owned data and assets |
| Orb/rendering capability | Weather Orb and Liquid DOM references |

## Review Triggers

다음 조건이 생길 때만 component-level implementation을 재검토한다.

- Foundation 소비 앱 두 곳에서 OTP, duration editor, reaction, reader minimap 중 같은 state model이 반복된다.
- Rare UI가 standard license를 추가하고 component provenance를 명확히 한다.
- component page axe failures, scroll owner와 keyboard/Escape gaps가 수정된다.
- gallery가 touch/mobile persistent preview와 media error fallback을 제공한다.
- Foundation Catalog가 static item data에서 versioned manifest source로 이동한다.
