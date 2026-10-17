---
schema_version: 1
reference_study: true
output_job: "explain a bounded operational sequence through user-controlled motion"
surface: "interactive product demo, guided evidence flow, or process visualization"
evidence: ["anime.js v4 official documentation reviewed 2026-08-05", "Motion for React official documentation reviewed 2026-08-05", "ReactVibe commit 443f6cf reviewed 2026-09-04", "independent UI Lab transfer specimen"]
confidence: high
axes_covered: ["typography", "color", "spacing", "radius", "borders", "shadows", "layout", "hierarchy", "iconography", "imagery", "motion", "interaction"]
unresolved_axes: []
allowed_range: "Use for one user-triggered sequence with a clear start, end, playback status, and an equivalent reduced-motion state. Keep routine product state in React and CSS."
counterexample: "Do not autoplay decorative scenes, run continuous ambient loops, animate keyboard navigation, or add both engines to the same element."
transfer_specimen: "lib/ui-lab/src/motion-graphics-study.tsx"
---

# Motion Graphics with anime.js and Motion

2026-08-05에 [anime.js](https://animejs.com/documentation/) v4와 [Motion](https://motion.dev/docs) 공식 문서를 검토하고, 두 엔진을 Owen UI Foundation의 제한된 모션 계약에 맞게 역할별로 분리했다. 외부 사이트의 브랜드, 화면, 예제 장면, 유료 자산은 복제하지 않았다.

## Learned Model

두 라이브러리는 모두 DOM과 SVG를 움직일 수 있지만 주된 강점과 소유권이 다르다. 한 효과를 두 엔진으로 동시에 제어하지 않는다.

| 필요 | Owner | 근거 |
| --- | --- | --- |
| 여러 대상과 callback을 하나의 시간축으로 묶기 | anime.js `createTimeline()` | animation, timer, callback, label을 같은 timeline에 동기화 |
| React subtree에 selector와 정리 범위 제한 | anime.js `createScope()` | root-scoped selector, media query, 일괄 `revert()` 제공 |
| 여러 신호의 순차 등장 | anime.js `stagger()` | target별 delay와 값 분배를 명시적으로 생성 |
| React state에 따른 짧은 visual feedback | Motion `motion.*` | state/prop 변화와 declarative animation 연결 |
| pointer press의 interruptible spring | Motion transition | spring stiffness, damping, mass를 React component에 가까이 유지 |
| layout, presence, gesture가 정보 구조와 직접 연결 | Motion | `layout`, `AnimatePresence`, gesture recognizer가 React 수명주기와 결합 |
| 단순 hover 색상이나 140ms opacity | CSS | Motion 공식 문서도 단순 self-contained effect에는 CSS를 권장 |

## Foundation Decision

ReactVibe commit `443f6cf` was cross-checked as a motion-first copy-paste catalog. It reinforces the need to record each recipe's purpose, trigger, duration, easing, interruption, static endpoint, reduced-motion behavior, dependency, and performance cost. It does not supply a new Foundation dependency or code source: the reviewed repository has no root license file, no release, and several examples use long blur entrances or infinite transform/path motion. Those examples remain rejection evidence rather than reusable recipes.

anime.js는 한 번 재생되는 장면의 시간축만 소유한다. React state, selection, accessibility attribute, product data는 소유하지 않는다. React component에서는 `createScope({ root })` 안에서 timeline을 만들고 effect cleanup에서 `scope.revert()`를 호출한다.

Motion은 사용자의 직접 조작과 React 상태 변화에만 사용한다. UI Lab transfer specimen에서는 pointer down에서만 spring scale을 적용한다. 키보드 activation은 `pressed` pointer state를 만들지 않으므로 즉시 선택되고, Foundation의 keyboard motion 금지 계약을 지킨다.

## Playback Contract

- 자동 재생하지 않는다. 사용자가 명시적인 재생 command를 실행한다.
- 재생, 일시정지, 완료 상태를 text live region으로 노출한다.
- timeline은 2초 안팎의 한정된 시퀀스로 끝나며 반복하지 않는다.
- 다시 재생은 기존 instance를 늘리지 않고 같은 timeline의 `restart()`를 사용한다.
- component unmount, dependency change, Strict Mode remount에서 모든 animation을 `revert()`한다.
- animation이 product action을 막거나 semantic state 반영을 지연시키지 않는다.

## Reduced Motion

Motion의 `useReducedMotion()`과 제품의 explicit reduced-motion 설정을 함께 확인한다. 둘 중 하나라도 활성화되면 위치, scale, path drawing을 실행하지 않고 최종 정보 상태를 즉시 렌더링한다.

축소 모션은 빈 장면이나 불완전한 중간 상태가 아니다. 모든 신호, evidence, decision을 읽을 수 있고 선택 control도 그대로 동작해야 한다. CSS `prefers-reduced-motion`은 잔여 transition과 animation을 제거하는 마지막 방어선으로 유지한다.

## Visual Contract

- 배경 grid는 공간 구조를 설명하는 stage substrate이며 움직이지 않는다.
- 입력 신호, correlation hub, evidence, decision의 좌우 흐름을 한 방향으로 유지한다.
- sky, amber, mint는 source category를 보조하고 icon과 text label을 함께 사용한다.
- decision은 mint semantic surface와 check icon, confidence text를 함께 사용한다.
- panel radius는 8px이며 card 안에 장식용 card를 중첩하지 않는다.
- glass는 toolbar, footer, central correlation boundary에만 제한한다.
- rounded surface에 vertical accent rail을 붙이지 않는다.

## Performance Boundaries

- 주로 `transform`, `opacity`, SVG stroke offset을 움직인다.
- blur와 backdrop filter는 정적인 material에만 사용하고 animation target으로 삼지 않는다.
- React render마다 timeline을 만들지 않는다.
- scroll-linked motion은 실제 읽기 진행이나 공간 관계가 있을 때만 Motion `useScroll()`을 검토한다.
- CSS variable animation은 paint를 유발할 수 있으므로 단순 transform을 우선한다.

## Accessibility Contract

- 재생 control은 native button과 accessible name을 사용한다.
- 일시정지 command는 재생 중 또는 일시정지 상태에서만 활성화한다.
- evidence 선택은 native button과 `aria-pressed`로 즉시 전달한다.
- 색상만으로 phase, selection, success를 표시하지 않는다.
- focus는 Foundation 정책에 따라 rim을 만들지 않으며 focus 전후 border와 shadow도 바뀌지 않는다.
- desktop, narrow viewport, dark theme, forced colors, OS와 앱 축소 모션, axe를 검증한다.

## When Not to Use

- 일반 page load에서 모든 section을 stagger로 등장시키는 경우
- 데이터가 바뀌지 않는 장식용 infinite loop
- table sorting, tab 이동, keyboard selection처럼 빈번한 작업
- 실제 progress를 알 수 없는데 timeline으로 진행률을 꾸미는 경우
- CSS transition 하나로 충분한 hover나 color change
- 같은 transform을 anime.js와 Motion이 동시에 쓰는 경우

## Validation Record

- UI Lab typecheck 통과.
- Playwright에서 timeline 완료, evidence selection, explicit reduced-motion 최종 상태, narrow overflow, axe를 검증한다.
- transfer specimen: `../ui-lab/src/motion-graphics-study.tsx`

## Sources

- [anime.js documentation](https://animejs.com/documentation/)
- [anime.js with React](https://animejs.com/documentation/getting-started/using-with-react)
- [anime.js Timeline](https://animejs.com/documentation/timeline)
- [anime.js Scope](https://animejs.com/documentation/scope)
- [anime.js stagger](https://animejs.com/documentation/utilities/stagger)
- [Motion for React](https://motion.dev/docs/react)
- [Motion React animation](https://motion.dev/docs/react-animation)
- [Motion gestures](https://motion.dev/docs/react-gestures)
- [Motion scroll animation](https://motion.dev/docs/react-scroll-animations)
- [Motion useReducedMotion](https://motion.dev/docs/react-use-reduced-motion)

## Recipe Catalog

The attributed 88-item [Nondev Thinking Motion Dictionary study](REFERENCE-STUDY-NONDEV-MOTION-DICTIONARY.md) is the vocabulary and recipe layer for common video scenes. It does not expand Foundation's component API or relax this study's playback, reduced-motion, engine-ownership and performance rules. Its independent HyperFrames runtime is a planning and composition surface rather than a reason to animate ordinary product UI.