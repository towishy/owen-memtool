---
schema_version: 1
reference_study: true
output_job: "evaluate generated CSS effects and translate only accessible, performant material parameters into existing Owen glass and depth owners"
surface: "Clear and Liquid Glass controls, small visual frames, overlays, and bounded elevation"
evidence: ["css.glass live generator and miketromba/css.glass commit 9b94547 reviewed 2026-08-28", "Neumorphism.io live generator and adamgiebl/neumorphism commit 8ab93a6 reviewed 2026-08-28", "shadows.brumm.af parked domain plus Tobias Ahlin and Josh W. Comeau references to Philipp Brumm's retired generator reviewed 2026-08-28", "HYPE4 Glassmorphism generator, generated CSS, and HYPE4 terms reviewed 2026-08-28", "CSS-Tricks Almanac and license plus current MDN and web.dev references for box-shadow, backdrop-filter, feature queries, and reduced transparency reviewed 2026-08-28"]
confidence: medium
axes_covered: ["color", "radius", "borders", "shadows", "hierarchy", "motion", "interaction"]
unresolved_axes: ["typography", "spacing", "layout", "iconography", "imagery"]
allowed_range: "Use the generators only to explore bounded fill, blur, rim, inset-highlight, and elevation parameters. Normalize a chosen result into the owning Foundation token or component after opaque fallback, contrast, backdrop-root, state, forced-colors, reduced-transparency, browser, and paint-cost checks."
counterexample: "Do not paste generated width, height, overflow, position, radius, pseudo-elements, or shadow-only interaction states into product CSS; do not revive an unavailable tool, vendor unlicensed source, or treat a visual preview as accessibility, compatibility, or performance evidence."
transfer_specimen: "pending"
---

# Reference Study: CSS Effect Generators

## Scope

이 문서는 CSS.glass, Neumorphism.io, Shadows by Philipp Brumm, HYPE4 Glassmorphism Generator, CSS-Tricks를 하나의 추천 목록으로 취급하지 않는다. 각 source가 제공하는 parameter model과 현행성을 확인하고, Owen UI Foundation의 기존 Clear/Liquid Glass와 depth owner에 전이할 수 있는 원칙만 기록한다.

생성된 CSS는 완성 component가 아니다. 시각 preview가 좋아 보여도 semantic state, contrast, fallback, stacking context, clipping, paint cost와 responsive behavior는 별도로 검증해야 한다.

## Current Source Review

| Source | Current value | Generated or documented model | Boundary |
| --- | --- | --- | --- |
| CSS.glass | 작은 glass recipe를 빠르게 탐색 | transparency, blur, color, outline을 조절하고 translucent background, 16px radius, 한 겹 outer shadow, `backdrop-filter`와 `-webkit-backdrop-filter`, 1px border를 출력 | rendered page의 세 slider는 accessible name이 없었다. opaque fallback, text contrast, state, saturation, feature query가 없고 public GitHub repository에는 표준 license와 release가 없다. source를 vendor하지 않는다. |
| Neumorphism.io | Soft UI의 광원 방향과 pressed/elevated 차이를 비교 | base color, size, radius, distance, intensity, blur와 flat, concave, convex, pressed를 제공한다. flat은 양방향 outer shadow, concave/convex는 gradient 방향, pressed는 같은 shadow를 inset으로 바꾼다. | source는 BSD-3-Clause지만 latest visible commit은 `8ab93a6`, release는 없다. 저대비 shadow만으로 affordance와 상태를 전달하므로 operational control에는 부적합하다. embedded Uiverse examples는 별도 source와 license다. |
| Shadows by Philipp Brumm | layered shadow 역사의 참고점 | layer 수, offset, blur와 alpha progression을 조합해 단일 shadow보다 부드러운 falloff를 만들던 도구로 후속 글에서 설명된다. | `shadows.brumm.af`와 `brumm.af/shadows`는 현재 parked domain이다. Josh W. Comeau도 원 도구가 더 이상 online이 아니라고 명시한다. 활성 도구나 재현 가능한 source로 추천하지 않는다. |
| HYPE4 Glassmorphism Generator | rim/refraction/depth layer의 관계를 탐색 | blur 5–50, refraction 0.05–0.4, depth 0–30을 조절한다. 기본 출력은 fixed size/radius, translucent fill, blur, border, outer shadow, 세 inset shadow, 상단·좌측 pseudo-element highlight를 포함한다. | fixed geometry, `position: relative`, `overflow: hidden`과 pseudo-elements가 effect와 함께 출력되어 component ownership을 침범한다. HYPE4 terms는 website source와 교육 자료를 보호하며 open-source license는 확인되지 않았다. source, demo asset과 고유 recipe를 vendor하지 않는다. |
| CSS-Tricks | CSS recipe, Almanac, guide와 최신 front-end 동향 탐색 | property 설명, article, guide, CodePen을 통해 구현 아이디어를 찾을 수 있다. site license는 code, design, demo 사용을 허용하지만 article 전체 재게시·저자 사칭은 피하도록 명시한다. | compatibility의 최종 권위가 아니다. 2019 backdrop-filter Almanac는 여전히 지원이 제한적이라고 서술하지만 현재 MDN은 Baseline 2024로 분류한다. 글의 날짜를 확인하고 MDN, specification, browser test로 다시 검증한다. |

## Transferable Material Model

Generator의 slider 이름을 그대로 token으로 옮기지 않는다. 효과를 다음 책임으로 분해한다.

| Layer | Responsibility | Owen rule |
| --- | --- | --- |
| Base surface | filter가 없거나 실패해도 text와 control을 읽을 수 있는 면 | 먼저 충분히 불투명한 neutral fallback을 둔다. |
| Translucent fill | 뒤 맥락을 제한적으로 전달 | semantic surface 위에서만 사용하고 dense content에는 쓰지 않는다. |
| Backdrop treatment | blur, saturation, brightness | `@supports` 안의 progressive enhancement로 취급한다. |
| Boundary | 1px border 또는 directional rim | surface 경계를 고정하되 상태의 유일한 단서로 쓰지 않는다. |
| Inner highlight | 상단/광원 방향의 얕은 반사 | one-light-source 방향을 따르고 content를 가리지 않는다. |
| Outer elevation | surface와 배경의 깊이 분리 | 가까운 contact layer와 넓은 ambient layer처럼 서로 다른 역할만 남긴다. |
| Interaction state | selected, pressed, active, disabled | text, icon, fill과 native semantics를 우선하며 shadow 방향만으로 표현하지 않는다. |

HYPE4의 `refraction`은 실제 광학 굴절 계산이 아니라 inset highlight 강도를 조절하는 authoring label이다. Owen에서는 `rim`, `inner highlight`, `backdrop treatment`로 분해해 기록하고 물리적으로 정확한 refraction이라고 부르지 않는다.

## Shadow System Rules

Layered shadow에서 흡수할 핵심은 layer 수가 아니라 일관된 환경이다.

1. 한 화면의 outer shadow는 같은 광원 방향과 X:Y offset 비를 공유한다.
2. elevation이 높아질수록 offset과 blur 범위는 커지고 각 ambient layer의 alpha는 낮아진다.
3. 가까운 contact shadow와 넓은 ambient shadow는 서로 다른 역할을 가진다.
4. 배경 hue에 맞춘 shadow는 검정 overlay의 탁함을 줄일 수 있지만 glow처럼 보이지 않게 saturation과 lightness를 제한한다.
5. 각 layer에 removal test를 적용한다. 제거해도 경계나 elevation 판단이 같으면 삭제한다.
6. 많은 layered shadow를 반복 list, table row, settings body에 적용하지 않고 animation하지 않는다.

`box-shadow`는 multiple shadow와 inset을 포함해 광범위하게 지원된다. 다만 shadow는 box model 크기에 포함되지 않으므로 인접 content 또는 container 밖으로 번지는지 별도로 확인한다. 서로 다른 shadow list를 transition하면 순서대로 보간되고 짧은 list에는 transparent shadow가 채워지므로, state 간 layer 수와 inset 여부를 맞추거나 transition 자체를 제거한다.

## Glass Fallback And Runtime Rules

`backdrop-filter`는 2024 Baseline이지만 지원 여부만으로 결과가 보장되지는 않는다. 효과가 보이려면 surface가 부분적으로 투명해야 하고, filter, opacity, mask, clip-path, 다른 backdrop-filter, mix-blend-mode, 일부 `will-change` ancestor는 backdrop root를 만들어 blur 범위를 바꿀 수 있다.

- 기본 declaration은 filter 없이도 읽히는 opaque or near-opaque surface다.
- `@supports (backdrop-filter: blur(1px))` 또는 prefixed 조건 안에서만 translucent fill과 backdrop filter를 강화한다.
- `-webkit-backdrop-filter`는 구형 WebKit fallback이 필요한 target에서만 unprefixed declaration과 함께 유지한다.
- `prefers-reduced-transparency`가 감지되면 blur와 transparency를 줄이고 opaque surface로 전환한다.
- 이 media feature는 현재 Firefox와 Safari를 포함한 일부 주요 browser에서 지원되지 않으므로 유일한 fallback으로 사용하지 않는다.
- forced-colors에서는 background, border, text와 state를 system color로 복구하고 decorative shadow와 filter를 제거한다.
- transparent surface의 text와 icon contrast는 token 색상끼리만 계산하지 않고 실제 worst-case backdrop과 fallback state에서 측정한다.

`backdrop-filter`는 새 stacking context와 containing behavior를 만들 수 있다. Overlay, sticky toolbar, tooltip, pseudo-element의 z-order와 clipping을 실제 DOM에서 확인한다.

## Performance Gate

- full-screen 또는 큰 scrolling surface의 blur는 기본 허용하지 않는다. 작은 control, navigation, overlay, widget boundary처럼 bounded surface에 제한한다.
- blur, backdrop-filter와 여러 shadow layer를 continuous animation하지 않는다. 이동이 필요하면 material 자체보다 transform을 우선하고 정지 frame의 paint cost도 측정한다.
- 반복 row마다 filter나 다층 shadow를 복제하지 않는다. dense body는 opaque surface를 유지한다.
- Chrome, Edge, Firefox, Safari/WebKit target과 Windows/macOS에서 scroll, resize, overlay open, text input을 확인한다.
- DevTools paint flashing, performance trace 또는 equivalent evidence 없이 “GPU accelerated”나 “가볍다”고 승인하지 않는다.

## Generated CSS Normalization

외부 generator의 `Copy CSS` 결과는 scratch input이다. 제품 코드에는 다음 순서로 옮긴다.

1. `background`, `backdrop-filter`, rim, inner highlight, outer elevation만 분리한다.
2. `width`, `height`, `position`, `overflow`, radius와 pseudo-element는 owning component가 이미 갖고 있으면 버린다.
3. raw value를 app override에 붙이지 않고 Foundation owner의 semantic token 또는 원본 selector에 연결한다.
4. unsupported/no-filter fallback, reduced transparency, forced colors와 dark/light surface를 추가한다.
5. pointer, keyboard, touch, selected, pressed, disabled, loading state에서 non-color meaning과 no-focus-rim 계약을 확인한다.
6. worst-case backdrop contrast, clipping, stacking, scroll paint와 narrow/mobile overflow를 실제 browser에서 검증한다.
7. source URL, reviewed date, generated parameters, normalized token, 제거한 declaration과 이유를 기록한다.

## Owen Decisions

- 기존 `--owen-clear-glass-*` token은 translucent fill, directional inset rim, two-level outer elevation과 backdrop filter를 이미 하나의 material contract로 제공하므로 새 token이나 generator dependency를 추가하지 않는다.
- CSS.glass의 transparency/blur/color/outline 분리는 빠른 authoring vocabulary로만 사용한다. 출력 CSS를 직접 붙이지 않는다.
- Neumorphism의 global light-source consistency와 outer/inset distinction만 흡수한다. neumorphic button, input, switch, selected state는 Foundation에 추가하지 않는다.
- retired Shadows generator에서는 progressive layer falloff 개념만 보존한다. 활성 bookmark나 build dependency로 유지하지 않는다.
- HYPE4의 rim 방향과 inner/outer layer 분리는 참고하되 fixed geometry, clipping, opaque white inset, pseudo-element recipe는 채택하지 않는다.
- CSS-Tricks는 discovery와 설명 source로 사용하고 compatibility 결정은 current MDN, specification, target browser evidence로 갱신한다.
- 이번 검토로 Foundation CSS 값, public API, UI Lab inventory 또는 product surface를 변경하지 않는다.

## Do Not Adopt

- 모든 card와 panel에 glass, blur 또는 layered shadow 적용
- low-contrast neumorphic control과 shadow-only pressed/selected state
- generator가 출력한 fixed size, radius, overflow, position과 pseudo-elements의 일괄 복사
- backdrop filter가 실패하면 거의 투명해지는 surface
- background에 따라 contrast가 흔들리는 text 또는 icon
- 동일 역할을 반복하는 5개 이상의 shadow를 검증 없이 token으로 등록
- blur, refraction, shadow depth의 continuous animation
- parked Shadows domain을 활성 추천 링크로 유지
- 표준 license가 없는 CSS.glass/HYPE4 source 또는 demo asset vendoring
- 오래된 CSS-Tricks browser support 표를 현재 compatibility 근거로 단독 사용

## Review Triggers

- Clear Glass token 또는 `GlassFrameWindow` material을 실제로 조정하려는 경우
- 두 개 이상의 Owen product에서 같은 elevation ladder가 반복되어 public shadow token이 필요한 경우
- `prefers-reduced-transparency`가 Baseline이 되거나 target browser 지원 범위가 바뀌는 경우
- large-area blur, animated glass 또는 high-density repeated surface가 실제 요구로 등장하는 경우
- CSS.glass나 HYPE4가 명시적인 source license와 reproducible release를 제공하는 경우
- retired Shadows generator의 canonical source와 license가 확인되는 경우
