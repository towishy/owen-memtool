---
schema_version: 1
reference_study: true
output_job: "frame a compact visual status or thumbnail"
surface: "small non-interactive glass frame"
evidence: ["user-provided Figma glass tutorial and icon examples", "independent UI Lab frame specimen"]
confidence: high
axes_covered: ["color", "radius", "borders", "shadows", "layout", "hierarchy", "iconography", "imagery", "interaction"]
unresolved_axes: ["typography", "spacing", "motion"]
allowed_range: "Use for small calendar, status, media, or commerce visuals with separate back plate and front pane."
counterexample: "Do not use as a general card, form, table, long text panel, or interactive control container."
transfer_specimen: "lib/ui-lab/src/glass-frame-study.tsx"
---

# Glass Frame Window Reference Study

2026-07-25에 제공된 Figma glass effect 제작 튜토리얼과 완성 아이콘 예시를 분석한 기록이다. 특정 튜토리얼의 수치와 자산을 복제하지 않고, 두 겹 frame으로 깊이를 만드는 재사용 원칙만 Owen UI Foundation에 반영한다.

## Extracted Construction

| 단계 | Foundation 해석 | 구현 |
| --- | --- | --- |
| 같은 크기의 frame 2개를 겹침 | opaque back plate와 translucent front pane의 책임을 분리 | `backContent`, `children` slot |
| back frame에 방향성 gradient 적용 | 색은 뒤 레이어에 집중하고 pane은 중립 광택 유지 | `tone` + `--owen-glass-frame-start/end` |
| back frame에 inner/drop shadow 적용 | 안쪽 깊이와 외부 elevation을 별도 shadow로 표현 | `.owen-glass-frame__back` |
| front frame에 glass effect 적용 | 반투명 fill, backdrop blur, saturation으로 뒤 색을 전달 | `.owen-glass-frame__pane` |
| front frame에 밝은 inner shadow 적용 | 상단 rim highlight로 pane 경계 고정 | inset white highlight |
| 숫자·아이콘 등 짧은 content 추가 | 긴 본문이 아닌 상태, 날짜, 상징만 허용 | visual slot + 필수 `label` |

## Usage Contract

- `GlassFrameWindow`는 calendar, status, media, commerce thumbnail처럼 작은 시각 frame이 필요할 때만 사용한다.
- 일반 card, form, table, 긴 설명 panel을 glass frame으로 만들지 않는다.
- root는 `role="img"`와 필수 `label`을 가지며 내부 visual content는 중복 낭독되지 않는다.
- back plate는 색과 외부 shadow를, front pane은 blur와 inner rim을 소유한다.
- 한 화면에서 여러 tone을 장식용으로 무분별하게 섞지 않는다. 실제 category 또는 state가 있을 때만 tone을 선택한다.
- CSS variable은 frame root 범위에서만 재정의한다.

## Deliberate Exclusions

- Figma beta glass 수치, 특정 gradient stop, creator watermark는 포함하지 않는다.
- refraction/dispersion을 CSS로 과장해 흉내 내지 않는다.
- 지속 animation, 강한 glow, 큰 rainbow dispersion을 추가하지 않는다.
- interactive control은 glass pane 위에 넣지 않는다.
