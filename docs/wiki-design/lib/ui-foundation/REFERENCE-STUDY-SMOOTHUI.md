---
schema_version: 1
reference_study: true
output_job: "review an animated shadcn registry and absorb only motion and catalog practices that strengthen Owen product work"
surface: "animated React component registry, AI catalog, and expressive interaction governance"
evidence: ["smoothui.dev home, 130-component catalog, accessibility, animation, installation, and AI integration pages reviewed 2026-08-20", "educlopez/smoothui main source, package metadata, registry generation, and MIT license reviewed 2026-08-20", "public llms-components.json metadata inspected for all 130 components and 34 blocks", "desktop homepage rendered in the VS Code internal browser"]
confidence: medium
axes_covered: ["typography", "color", "spacing", "radius", "borders", "shadows", "layout", "hierarchy", "iconography", "imagery", "motion", "interaction"]
unresolved_axes: []
allowed_range: "Reuse abstract catalog metadata, reduced/static motion discipline, bounded transform/opacity guidance, and selected state-continuity ideas after mapping them to existing Foundation owners and validating them independently."
counterexample: "Do not install the registry wholesale, add Motion or GSAP to Foundation core, copy Apple/Siri trade dress, introduce focus rings, or treat 130 expressive variants as 130 distinct product needs."
transfer_specimen: "lib/ui-lab/src/micro-interactions-study.tsx"
---

# Reference Study: SmoothUI

## Scope

[SmoothUI](https://smoothui.dev/)는 React 19, Tailwind CSS 4, shadcn registry, Motion 중심의 animated component collection이다. 2026-08-20 공개 catalog 기준 130개 component와 34개 block을 제공하며 MIT license로 배포된다.

이번 검토의 목적은 코드를 대량 복사하는 것이 아니라 다음을 판별하는 것이다.

1. 기존 Foundation primitive나 Lab composition과 중복되는가?
2. animation을 제거해도 제품 task와 state model이 남는가?
3. dependency와 reduced-motion evidence가 Foundation core 기준을 충족하는가?
4. catalog 운영 방식 중 Owen에 전이할 가치가 있는 것은 무엇인가?

## Evidence Summary

### Catalog And Dependencies

공개 `llms-components.json`을 기준으로 130개를 전수 분류했다.

| Signal | Count | Interpretation |
| --- | ---: | --- |
| Component | 130 | 표현형 variant가 많은 catalog이며 product primitive 수로 해석하지 않는다 |
| Block | 34 | hero, pricing, testimonial 등 marketing composition 비중이 높다 |
| `motion` dependency | 109 | Foundation core에 그대로 넣으면 runtime budget이 크게 바뀐다 |
| `lucide-react` dependency | 40 | Owen의 icon 선택과 양립 가능하지만 install 근거는 아니다 |
| `hasReducedMotion: false` | 55 | 문서의 “모든 component 지원” 주장과 공개 metadata가 일치하지 않는다 |

사이트 accessibility 문서는 모든 animated component가 `useReducedMotion`을 사용한다고 설명한다. 그러나 같은 사이트의 machine-readable catalog에서는 55개가 reduced-motion 미지원으로 표시된다. `number-flow`, `smooth-button`, 다수 text/shader transition도 이 목록에 포함된다. 따라서 개별 source와 실제 동작 확인 없이 catalog-level accessibility claim을 채택하지 않는다.

### Motion Guidance

다음 원칙은 Foundation의 기존 motion contract와 일치해 보강 근거로 채택한다.

- 일반 interaction은 300ms 아래에 둔다.
- 가능한 경우 transform과 opacity만 animate한다.
- spring bounce는 낮게 유지한다.
- reduced motion에서는 state change를 즉시 완료하고 content를 잃지 않는다.
- ambient loop와 동시에 움직이는 요소 수를 제한한다.

SmoothUI의 권장 200-300ms는 Owen의 fast 140ms, normal 200ms보다 느린 상한이므로 Foundation token을 변경하지 않는다. Owen keyboard state는 계속 즉시 반영한다.

## Component Routing

| SmoothUI family | Owen decision | Existing owner |
| --- | --- | --- |
| Button, form, dialog, select, toast | 중복, 도입하지 않음 | `ActionButton`, `FormField`, `SelectControl`, `ResponsiveOverlay`, `AsyncState` |
| Animated tabs and selector | state-continuity 참고만 | app-owned tabs, native semantics, instant keyboard state |
| Button Copy | behavior만 이미 흡수됨 | Micro interactions의 copy success와 live feedback |
| Number Flow and Price Flow | opt-in 후보, 현재 보류 | `InstrumentPanel` exact value; reduced/static evidence 보강 필요 |
| AI message, reasoning, sources, tool call, approval | 정보 구조 vocabulary 후보 | `MobileAssistant*`, `AsyncState`, `StatusBadge`; 두 제품 반복 전 public API 추가 금지 |
| Dynamic Island, Siri Orb, AI Orb Face | 도입하지 않음 | `GlintWidget`, Weather Orb, Liquid DOM capability gate가 인접 문제를 소유 |
| Shader and chroma transitions | production Foundation에서 제외 | bounded motion graphics 또는 video composition에서만 검토 |
| Expandable and scrollable cards | 일반 primitive로 도입하지 않음 | Layered Stacks, disclosure, OperationalDataTable을 output job에 맞게 선택 |
| Marketing blocks | Foundation core에서 제외 | `FeatureShowcase` 또는 소비 site composition |

## Adopted Operational Patterns

### Machine-readable catalog

SmoothUI는 같은 component metadata에서 site catalog, `llms.txt`, JSON, REST API, registry payload를 만든다. Owen은 외부 MCP나 registry를 설치하지 않지만 다음 drift 방지 원칙을 유지한다.

- stable item ID를 documentation, Lab hash, source와 공유한다.
- count와 source path를 executable checker로 검증한다.
- category, maturity, dependency, interaction, boundary, evidence를 사람이 찾을 수 있는 형태로 공개한다.
- AI가 catalog를 검색하더라도 최종 선택은 Foundation maturity와 output job으로 제한한다.

### Expressive intake

SmoothUI item을 향후 다시 검토할 때는 source snapshot, MIT notice, full/reduced/static state, keyboard/touch parity, interruption, dependency budget, Korean/English overflow와 real-browser evidence를 함께 남긴다. MIT가 허용하더라도 substantial source를 복사하면 copyright와 permission notice를 포함해야 한다.

## Do Not Adopt

- Apple Dynamic Island, Siri orb, Apple Invites처럼 식별 가능한 제품 외형
- 모든 control에 spring, hover lift, glow, blur를 붙이는 blanket motion
- `focus-visible` ring 또는 glow
- 55개 metadata gap을 무시한 “fully reduced-motion aware” 전제
- Motion, GSAP, shader runtime을 Foundation core dependency로 추가
- hero, pricing, testimonial block을 운영 UI의 기본 composition으로 사용
- source registry를 Foundation owner code 위에 덮어쓰는 설치 방식

## Sources

- [SmoothUI](https://smoothui.dev/)
- [Component catalog](https://smoothui.dev/docs/components)
- [Accessibility](https://smoothui.dev/docs/guides/accessibility)
- [Animation best practices](https://smoothui.dev/docs/guides/animation-best-practices)
- [AI integration](https://smoothui.dev/docs/guides/ai-integration)
- [GitHub repository](https://github.com/educlopez/smoothui)
- [MIT license](https://github.com/educlopez/smoothui/blob/main/LICENSE)