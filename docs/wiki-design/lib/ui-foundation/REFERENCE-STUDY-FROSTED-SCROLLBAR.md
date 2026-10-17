---
schema_version: 1
reference_study: true
output_job: "quiet custom vertical scrolling with a compact local drag target"
surface: "opaque work planes, settings bodies, overlays, and bounded lists"
evidence: ["Sarang.day interactive scrollbar mockup", "independent UI Lab transfer specimen"]
confidence: high
axes_covered: ["color", "spacing", "radius", "borders", "shadows", "layout", "hierarchy", "motion", "interaction"]
unresolved_axes: ["typography", "iconography", "imagery"]
allowed_range: "Use for bounded vertical scroll regions where a product-owned scrollbar should stay visually quiet while preserving native wheel, touch, and keyboard behavior."
counterexample: "Do not force it onto horizontal chip strips, virtualized engines that own scrolling, or surfaces that must expose the operating-system scrollbar unchanged."
transfer_specimen: "lib/ui-lab/src/frosted-scrollbar-study.tsx"
---

# Frosted Scrollbar Reference Study

## Pattern summary

Sarang.day의 반복 목록과 설정 본문에서 검증한 custom scrollbar를 Foundation 기본 template로 전이한다. Native scrollbar의 화살표와 content ratio만큼 긴 thumb를 시각적으로 숨기되, 실제 scroll viewport는 wheel, touch, keyboard semantics를 그대로 유지한다.

## Anatomy

1. Scroll viewport는 content overflow와 focus semantics를 소유한다.
2. Overlay rail은 viewport 오른쪽 14px hit area 안에 2px 반투명 선을 표시한다.
3. Local grip은 scroll ratio와 관계없는 configurable compact 높이를 사용한다.
4. Grip은 기본 폭 6px이며 hover와 pointer drag에서만 10px로 넓어진다.
5. Grip 중앙에는 1px 높이의 짧은 가로선 3개를 낮은 대비로 표시한다.

## Material contract

- Light rail: `rgb(65 82 94 / 0.12)`.
- Light grip: `rgb(255 255 255 / 0.72)`에서 `rgb(205 218 225 / 0.34)`로 내려가는 180deg glass fill.
- Grip rim: `rgb(65 82 94 / 0.3)`, 1px.
- Grip shadow: `0 2px 8px rgb(36 55 65 / 0.12)`와 약한 inset highlight.
- Dark mode는 밝은 white alpha와 neutral blue-gray alpha를 사용하되 같은 geometry와 interaction을 유지한다.
- Rail과 grip은 상태색이나 section tone을 상속하지 않는 neutral graphite material이다.

## Interaction contract

- Wheel, touch, Page Up/Down, Home/End, arrow key 동작은 native scroll viewport가 처리한다.
- Pointer는 grip을 직접 끌거나 rail을 눌러 해당 위치로 이동할 수 있다.
- Grip은 scroll position을 표현하지만 content ratio를 길이로 표현하지 않는다.
- Hover와 drag에서 width만 즉시 바뀌며 위치 animation, inertia, bounce는 추가하지 않는다.
- Overflow가 없으면 rail 전체를 숨긴다.
- Forced colors에서는 Canvas와 CanvasText로 rail, rim, grip을 표현한다.

## Responsive boundary

Mobile에서도 grip geometry를 줄이지 않는다. Touch scrolling이 주 경로이므로 rail은 보조 표현이며, horizontal category/tab scroller는 기존 swipe behavior와 숨김 scrollbar를 유지할 수 있다.

## Lab implementation

`../ui-lab/src/frosted-scrollbar-study.tsx`는 긴 생활 피드에서 wheel, keyboard, rail click, grip drag, light/dark material을 검증한다. `FrostedScrollArea`가 Foundation API와 Styles API의 canonical owner다.