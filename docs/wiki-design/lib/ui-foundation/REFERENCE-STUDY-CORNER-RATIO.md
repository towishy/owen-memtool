---
schema_version: 1
reference_study: true
output_job: "shape explicitly rounded panels, identity visuals, and commands with proportional corners"
surface: "opt-in rounded panels and visual showcases"
evidence: ["1 user-provided 768x960 app-install screenshot", "independent UI Lab corner-ratio specimen", "2026-10-17 user-provided Circular/Continuous comparison image and explicit continuous-corner preference"]
confidence: medium
axes_covered: ["spacing", "radius", "borders", "shadows", "layout", "hierarchy", "iconography", "imagery", "interaction"]
unresolved_axes: ["typography", "color", "motion"]
allowed_range: "When a surface explicitly adopts rounded corners, use a capped 15% ratio for panel boundaries and showcases, 21% for square identity visuals, and pill or circle geometry for commands."
counterexample: "Do not repeat panel radius on table cells, list-row separators, form controls, or nested cards."
transfer_specimen: "lib/ui-lab/src/corner-ratio-study.tsx"
---

# Corner Ratio Reference Study

2026-07-27에 제공된 768x960 app-install 이미지에서 요소 크기와 corner tangent를 근사 측정한 기록이다. 원본의 브랜드, app icon, 문구, 색상은 복제하지 않고 둥근 외곽을 선택한 surface에 한해 큰 shell에서 작은 command로 내려가는 곡률 비례를 옮긴다.

2026-10-17 추가 사용자 지시: 아래 측정값은 코너 크기·비례의 근거이며 circular 형상을 기본값으로 승인한 것은 아니다. 새로 만들거나 수정하는 일반 제품 UI의 코너 형태는 [`DESIGN.md`의 Continuous Corner Default](DESIGN.md#continuous-corner-default)를 따른다. 기존 Lab specimen의 구현·검증 상태가 이 지시만으로 변경되지는 않는다.

## Measured Ratio Ladder

원본은 오른쪽이 잘린 raster 이미지이므로 shell 전체 폭은 추정값이다. 좌측 corner tangent와 요소 bounding box 기준 오차 범위는 약 2~4px다.

| 요소 | 관측 크기 | 관측 radius | 정규화 | Lab 적용 |
| --- | ---: | ---: | ---: | --- |
| 큰 install shell | 높이 약 390px, 전체 폭은 clipping으로 추정 | 약 98~104px | 폭의 약 15%, 높이의 약 26% | `min(15cqi, 104px)` |
| 정사각 app icon | 약 276x277px | 약 58px | 한 변의 약 21% | `21%` |
| primary CTA | 약 140x59px | 약 29.5px | 높이의 50% | pill |
| utility action | 약 59x59px | 약 29.5px | 지름의 50% | circle |

핵심은 기존 panel을 모두 둥글게 만드는 것이 아니라, rounded-corner 표현을 선택했을 때 크기와 역할에 따라 `rounded panel -> showcase shell -> identity icon -> command pill/circle`로 곡률을 단계화하는 것이다. Rounded panel은 15% 비율을 16~32px로 제한하고, showcase는 40~104px, icon은 정사각 비율, command는 완전한 pill/circle로 닫는다.

## Transfer Contract

- 기존 운영 panel과 목업은 `--owen-radius-panel: 8px`을 유지한다.
- 둥근 panel을 명시적으로 선택한 경우에만 `--owen-radius-rounded-panel: clamp(16px, 15%, 32px)`을 사용한다.
- 큰 shell은 `--owen-radius-showcase: clamp(40px, 15cqi, 104px)` 범위로 제한한다.
- 정사각 identity icon은 `20~22%` radius 범위를 사용한다.
- 짧은 primary command와 정사각 utility command는 각각 pill과 circle을 사용한다.
- 큰 radius를 얻기 위해 내부 padding이나 입력 방식에 맞는 target을 줄이지 않는다.
- Continuous 형상은 선택적 장식이 아니라 새로 만들거나 수정하는 라운드 코너의 기본값이다. `corner-shape: squircle` 등의 지원 여부와 미지원 환경의 대체 형상은 [Continuous Corner Default](DESIGN.md#continuous-corner-default)에 따라 확인한다. 일반 `border-radius` fallback만으로 continuous 검증 완료를 주장하지 않는다.
- 좁은 화면에서는 layout을 한 열로 바꾸되 shell radius 비례와 command target은 유지한다.

## Deliberate Exclusions

- HYPERFOX, Pix, app icon glyph, publisher, Get 문구와 원본 색상은 transfer specimen에 사용하지 않는다.
- 운영 panel에 104px showcase cap을 그대로 적용하지 않는다.
- table cell, list row separator, form control마다 panel radius를 반복하지 않는다.
- panel을 중첩해 곡률과 shadow가 여러 겹 겹치게 만들지 않는다.
- 원본에서 확인할 수 없는 hover, loading, install progress, share menu 동작은 추론하지 않는다.
