---
schema_version: 1
reference_study: true
output_job: "safe preference configuration"
surface: "desktop and responsive settings panels"
evidence: ["user-provided settings screenshot", "independent UI Lab settings specimen"]
confidence: high
axes_covered: ["color", "typography", "spacing", "radius", "borders", "shadows", "layout", "hierarchy", "iconography", "motion", "interaction"]
unresolved_axes: ["imagery"]
allowed_range: "Apply to grouped preferences with short explanations and compact trailing controls."
counterexample: "Do not use for onboarding questionnaires, long data editing, or repeated collections."
transfer_specimen: "lib/ui-lab/src/settings-panel-study.tsx"
---

# Reference Study: Settings Panels

이 composition은 Owen 제품의 설정 메뉴 기본 원칙이다. 별도 surface 요구가 없으면 `SettingsPanel -> SettingsRow -> role-specific control` 구조로 시작한다.

## Source pattern

사용자 제공 환경설정 화면에서 반복되는 구조를 분석했다. 원본의 문구나 아이콘 자산을 복제하지 않고, 설정 화면을 빠르게 읽고 안전하게 조작하게 만드는 composition만 Foundation 계약으로 추출한다.

## Extracted anatomy

1. **Group header**: 작은 icon tile, 짧은 제목, 한 줄 설명이 설정 범위를 먼저 정의한다.
2. **Setting row**: 왼쪽에는 결정 이름과 영향 설명, 오른쪽에는 실제 control을 둔다.
3. **Binary control**: switch는 현재 상태를 즉시 노출하고 행 제목과 별개의 접근성 이름을 가진다.
4. **Preset control**: 소수의 자주 쓰는 모드는 한 줄의 pressed button group으로 비교한다.
5. **Command entry**: 자유 입력은 독립 form으로 제공하고 빈 값 제출을 막는다.

Reference의 `계정`과 `고급 설정`은 같은 파랑 아이콘의 변형이 아니다. `계정`은 선명한 cyan-blue glyph, 같은 계열의 옅은 tile gradient와 border, blue-tinted header를 한 family로 사용하고, `고급 설정`은 slate-gray glyph, gray tile gradient와 border, neutral header를 한 family로 사용한다. 이 blue/gray pair가 tone 상속을 검증하는 최소 specimen이다.

## Visual decisions

- 설정 그룹은 하나의 얕은 panel이며 panel 안에 card를 중첩하지 않는다.
- header tint만 tone을 갖고, 실제 설정 행은 읽기 쉬운 opaque surface를 유지한다.
- 밝은 header tint는 `180deg` 세로 gradient를 사용한다. 상단의 고유 tint에서 하단의 `tint + white 64%` surface로 밝아지며 좌우 색상차는 거의 두지 않는다. `105deg` 대각선 gradient는 reference 해석과 맞지 않는다.
- radius는 8px 이하로 제한하고 border와 작은 shadow로 그룹 경계를 만든다.
- icon color는 그룹 구분을 보조할 뿐 상태나 성공 여부를 단독으로 전달하지 않는다.
- switch는 graphite track을 기본으로 사용한다. 강한 브랜드색은 preset 선택 등 현재 선택을 비교해야 하는 곳에만 쓴다.
- Header의 구조적 세로 gradient는 허용하지만 glass, gradient orb, 왼쪽 accent rail은 사용하지 않는다.

## Sarang.day transfer profile

Sarang.day 설정 메뉴에서 `계정` reference의 재질을 독립적으로 전이하고 desktop/mobile audit으로 확인했다. 이 프로필은 Foundation `SettingsPanel`을 소비 앱에서 확장하는 기준이며, 앱의 정보 구조와 tone 이름을 Foundation public API로 그대로 복제하지 않는다.

### Material and hierarchy

- Header anatomy: tinted band, 48px accent outline icon tile, compact title, one-line description, 1px divider.
- Background: `linear-gradient(180deg, tint 0%, color-mix(in srgb, tint, #fff 64%) 100%)`.
- Icon tile: 8px radius, 위쪽 `accent + white 96%`에서 아래쪽 `accent + white 88%`로 이어지는 세로 tonal gradient, `accent + white 60%` border, `0 4px 10px rgb(15 23 42 / 0.05)` 이하의 shadow.
- Icon glyph: filled pictogram보다 `fill: none`, `stroke: currentColor`, 약 1.75px stroke와 20px visual size의 단순 outline을 우선한다. Glyph, tile border, tile surface는 별도 고정색을 쓰지 않고 해당 header tone의 accent를 함께 따른다.
- Typography: title `0.92rem`/700+/1.35, description `0.7rem`/500/1.4, letter spacing 0.
- Panel: 8px radius, opaque white body, 1px divider. 좁은 화면에서도 font와 입력 방식에 맞는 interaction target은 훼손하지 않는다.
- Dark mode: 설정 그룹은 tone별 opaque dark tint를 우선하고, 반복 widget형 설정 header만 accent 14%와 `#24262b`를 섞은 상단 tint에서 `#24262b`로 내려가는 180deg gradient를 허용한다.

### Foundation tone presets

| Tone | Accent | Header tint | Icon border |
| --- | --- | --- | --- |
| neutral | `#64748b` | `#f7f8fa` | accent-derived |
| gray | `#4b5563` | `#f3f4f6` | accent-derived |
| sky | `#007dba` | `#eef7fa` | accent-derived |
| mint | `#287563` | `#eef7f4` | `#c9e3da` |
| rose | `#aa4568` | `#fbf1f4` | `#ebd0da` |
| amber | `#95651f` | `#fbf6ec` | `#eadbbf` |
| violet | `#6856a4` | `#f4f2fb` | `#d9d3ec` |
| teal | `#147975` | `#edf7f6` | `#c5e2e0` |
| coral | `#a65143` | `#fbf1ef` | `#ebd1cb` |
| indigo | `#4d62a6` | `#f1f3fa` | `#d0d7ec` |
| olive | `#62762e` | `#f4f7ed` | `#d8e1c4` |

Foundation의 named tone은 `neutral | gray | sky | indigo | violet | rose | coral | amber | olive | mint | teal`이다. Named preset은 시작점일 뿐 폐쇄된 palette가 아니다. 소비 앱은 네 가지 settings color variable을 같은 scope에서 재정의해 필요한 header tone을 추가하고, icon glyph는 그 accent를 상속한다.

## Responsive behavior

- switch처럼 폭이 작은 control은 좁은 화면에서도 행 오른쪽에 유지한다.
- preset group과 command input은 좁은 container에서 설명 아래로 이동한다.
- 긴 설명은 줄바꿈하고 control을 밀어내거나 horizontal scroll을 만들지 않는다.
- 모든 button과 input은 입력 방식, 밀도, 인접 간격에 맞는 interaction target을 유지한다.

## Accessibility contract

- `SettingsPanel`은 제목으로 이름 붙은 section landmark다.
- `SettingsSwitch`는 `role="switch"`와 `aria-checked`를 사용한다.
- `SettingsPresetGroup`은 이름 있는 group이며 각 option은 `aria-pressed`를 사용한다.
- `SettingsCommandInput`은 이름 있는 input과 native submit button을 사용한다.
- 색상 외에 text, checked/pressed semantics로 상태를 전달한다.
- Keyboard focus는 background, text, icon 변화로만 지원하며 focus 전용 outline, ring, border, inset/outer shadow는 금지한다. Reduced motion과 forced colors는 owner CSS에서 지원한다.

## When to use

- 편집기, 플러그인, 업무 도구의 환경설정 화면
- 한 설정에 제목과 영향 설명이 함께 필요한 경우
- switch, preset, 짧은 command entry가 같은 설정 vocabulary를 공유하는 경우

## When not to use

- 한 번만 실행하는 일반 form이나 onboarding questionnaire
- 긴 데이터 편집, 표, 반복 collection을 설정 행에 넣어야 하는 경우
- 경고, 오류, 저장 상태를 panel tone만으로 표현하려는 경우

## Foundation mapping

| Reference role | Foundation API |
| --- | --- |
| Grouped setting surface | `SettingsPanel` |
| Title, description, trailing control | `SettingsRow` |
| Binary preference | `SettingsSwitch` |
| Mutually exclusive quick modes | `SettingsPresetGroup` |
| Short command addition | `SettingsCommandInput` |

실제 조합과 desktop/mobile 검증은 `../ui-lab/src/settings-panel-study.tsx`와 `../ui-lab/tests/ui-lab.spec.ts`에서 확인한다.
