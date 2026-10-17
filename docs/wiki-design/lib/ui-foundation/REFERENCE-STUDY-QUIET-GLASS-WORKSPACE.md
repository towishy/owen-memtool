---
schema_version: 1
reference_study: true
output_job: "general workspace layout with dense scanning and supporting utilities"
surface: "responsive quiet workspace"
evidence: ["8 user-provided utility UI screenshots", "independent interactive Cloud Desk specimen"]
confidence: high
axes_covered: ["typography", "color", "spacing", "radius", "borders", "shadows", "layout", "hierarchy", "iconography", "imagery", "motion", "interaction"]
unresolved_axes: []
allowed_range: "Use the sidebar, opaque work plane, and optional utility rail composition broadly; keep contextual glass panels bounded to cases where background context carries meaning."
counterexample: "Do not repeat glass across mail rows, form fields, table cells, or decorative nested cards."
transfer_specimen: "lib/ui-lab/src/cloud-desk-mockup.tsx"
---

# Quiet Glass Workspace Reference Study

이 composition은 Owen 제품의 기본 quiet workspace layout이다. Mail 예제에 한정하지 않고 navigation, primary work plane, supporting utility가 필요한 file, review, research, knowledge, task, security operations 화면에 폭넓게 적용한다.

2026-07-24에 제공된 파일 공유, 메일, 일정, 날씨, 통계, 폴더, 건강 지표 UI 이미지 8장을 공통 패턴 관점에서 분석한 기록이다. 특정 제품의 화면이나 문구를 복제하지 않고, 반복해서 나타나는 구조·표면·상호작용 원칙만 Owen UI Foundation에 반영한다.

## Pattern Summary

| 관찰 | Foundation 해석 | 채택 범위 |
| --- | --- | --- |
| 흰색 또는 반투명 shell 안에 조밀한 행과 작은 도구가 배치됨 | 업무 본문은 낮은 채도의 불투명 surface를 사용 | mailbox, table, task list, form |
| 실사 풍경 위 날씨·일정 위젯만 배경을 투과함 | glass는 맥락을 전달하는 단일 보조 surface로 제한 | weather, overlay, focal command |
| 큰 숫자 1개와 짧은 보조 지표가 강한 위계를 형성함 | 수치 위젯은 display metric 1개, 비교 수치 2개 이하 | KPI, health, weather |
| 그림자는 넓고 옅으며 경계선은 1px로 정리됨 | elevation은 2단계만 사용하고 테두리로 형태를 먼저 정의 | shell, floating widget |
| 행은 아이콘·제목·메타·상태·시간 순서로 스캔됨 | 반복 행은 고정된 정보 열과 density-appropriate target을 유지 | mail, files, people |
| 밝은 화면은 색을 폴더·태그·핵심 action에만 사용함 | 중립 surface 안의 의미색 사용, 단일 색조 화면 금지 | tag, folder glyph, primary action |
| 원형 icon action과 pill command가 함께 쓰임 | 익숙한 도구는 icon button, 텍스트 명령만 pill 사용 | toolbar |
| 큰 외곽 shell은 부드럽지만 내부 항목은 작고 단단함 | 제품 기본 radius 6/8px 유지, pill은 명령·상태에만 사용 | all foundation surfaces |

## Composition Contract

### 1. Opaque work plane

- 메일, 표, 폼, 파일 목록처럼 읽기 밀도가 높은 영역은 `--owen-color-surface`를 사용한다.
- 행 구분은 `--owen-color-border` 1px로 만들고, 행마다 별도 카드나 떠 있는 그림자를 만들지 않는다.
- 보조 텍스트도 WCAG AA 4.5:1을 충족한다. 작은 글자를 흐리게 만들어 hierarchy를 해결하지 않는다.

### 2. Context glass

- 한 viewport에 주된 glass surface는 1개를 기본값으로 한다.
- 배경 투과가 정보 의미를 가져야 한다. 날씨와 풍경, 선택 항목과 주변 맥락처럼 연결이 설명되어야 한다.
- 권장 구조는 반투명 fill, 1px 밝은 rim, `blur(16px–24px)`, 넓고 낮은 alpha shadow다.
- glass 위 본문은 충분한 대비를 갖춘 단색이어야 하며, 긴 문단·표·입력 본문은 두지 않는다.

### 3. Compact utility shell

- shell은 sidebar, main work plane, optional rail의 세 책임으로 나눈다.
- 이 책임 분리는 compact personal tool뿐 아니라 조밀한 업무 workspace의 기본 layout으로 사용한다.
- toolbar는 검색을 flexible track에 두고, 도구 icon button과 primary command를 오른쪽에 둔다.
- 좁은 container에서는 rail을 아래로 이동하고, mobile에서는 sidebar를 icon navigation으로 축약한다.
- 반응형 전환은 viewport가 아니라 실제 component container 폭을 기준으로 할 수 있다.

### 4. Metric hierarchy

- display metric은 한 surface에 1개만 둔다.
- 숫자는 tabular numerals를 사용하고 단위는 숫자보다 작되 대비를 낮추지 않는다.
- 차트가 있으면 hover 없이도 현재 값, 축, 기간을 읽을 수 있어야 한다.

## Interaction Contract

- 모든 icon-only action에 accessible name과 tooltip 또는 `title`을 제공한다.
- 반복해서 쓰는 mailbox·task navigation은 즉시 상태를 바꾸며 진입 애니메이션을 넣지 않는다.
- pointer press에는 140ms `scale(0.97)` 피드백을 허용한다. reduced motion에서는 transform을 제거한다.
- 선택 상태는 색만 쓰지 않고 `aria-current`, `aria-pressed`, checkbox 상태 중 알맞은 의미를 함께 제공한다.
- mobile에서 시각 라벨을 숨겨도 accessible name은 남겨 둔다.

## Do Not Adopt

- 참고 이미지의 과도하게 큰 외곽 radius를 foundation 기본값으로 만들지 않는다.
- glass를 메일 행, 폼 본문, 표 셀마다 반복하지 않는다.
- 10px 안팎의 보조 텍스트를 낮은 대비 회색으로 처리하지 않는다.
- 풍경 또는 blur를 실제 상태·데이터·제품 증거 대신 쓰지 않는다.
- 폴더·아바타·브랜드 이미지를 원본과 동일하게 복제하지 않는다.

## Lab Implementation

`../ui-lab/src/cloud-desk-mockup.tsx`의 Cloud Desk는 이 계약의 reference composition이다. 검색, mailbox navigation, task completion을 실제로 조작할 수 있으며, `../ui-lab/tests/ui-lab.spec.ts`에서 desktop/mobile overflow와 axe를 검증한다. Foundation 공용 API로 승격하는 것은 별도 제품에서 같은 shell 조합이 두 번 이상 필요할 때 검토한다.
