---
schema_version: 1
reference_study: true
output_job: "desktop food discovery and order review"
surface: "responsive commerce dashboard"
evidence: ["user-provided food delivery dashboard reference", "independent Citrus Market UI Lab specimen"]
confidence: high
axes_covered: ["typography", "color", "spacing", "radius", "borders", "shadows", "layout", "hierarchy", "iconography", "imagery", "motion", "interaction"]
unresolved_axes: []
allowed_range: "Use for image-led menu discovery with one compact navigation rail and one persistent order summary; adapt the accent color to the product brand."
counterexample: "Do not use this visual density or persistent payment rail for document, settings, security operations, or text-led workspaces."
transfer_specimen: "lib/ui-lab/src/food-commerce-dashboard.tsx"
---

# Food Commerce Dashboard Reference Study

2026-07-27에 제공된 food delivery dashboard 이미지에서 재사용 가능한 composition을 추출한 기록이다. 원본 브랜드, 문구, 음식 사진, 카드 번호, 가격을 복제하지 않고 menu discovery와 order review의 책임 분리만 Foundation Lab에 반영한다.

## Extracted Pattern

| 관찰 | Foundation 해석 | 채택 범위 |
| --- | --- | --- |
| 상단 utility bar와 좁은 icon rail이 탐색을 분담함 | 페이지 전환은 rail, 검색·알림·프로필은 header에 둔다 | desktop commerce shell |
| 큰 음식 visual이 첫 작업 영역을 차지함 | promotion copy보다 실제 선택 대상의 시각 신호를 우선한다 | hero recommendation, category preview |
| category와 최근 메뉴가 같은 work plane에 있음 | 발견과 재주문을 한 흐름으로 연결하되 각 영역은 제목으로 구분한다 | discovery plane |
| 결제 정보와 현재 주문이 오른쪽에 고정됨 | 예산·위치·수량·합계를 한 supporting rail에서 검토한다 | order rail |
| 주황색이 action, 가격, 결제 상태에 반복됨 | accent는 interactive priority와 commerce status에 제한한다 | primary command, price, active state |
| 외곽 shell은 부드럽고 내부 정보 surface는 단단함 | rounded shell 안에서 panel은 8px, command는 pill/circle을 유지한다 | radius hierarchy |

## Composition Contract

### Three responsibilities

- Compact navigation rail, flexible discovery plane, persistent order rail의 세 책임을 시각적으로 분리한다.
- Search는 header의 flexible track에 두고 category filter와 중복하지 않는다.
- Medium container에서 order rail을 discovery plane 아래로 이동한다. 좁은 화면에서는 navigation을 가로 dock으로 바꾼다.

### Visual-first discovery

- 음식 visual은 메뉴 식별과 category 차이를 전달해야 한다. 단순한 분위기 배경으로 쓰지 않는다.
- Hero는 추천 메뉴 한 개에만 사용하고, category와 menu preview는 더 작은 반복 grid로 유지한다.
- 실제 제품에서는 검증된 로컬 또는 CDN 이미지와 유효한 대체 텍스트 전략을 사용한다. Lab의 CSS still-life는 독립 specimen 전용이다.

### Opaque transaction surfaces

- 메뉴, 예산, 위치, 장바구니, 합계는 불투명 surface를 사용한다.
- 색은 가격, active category, primary checkout처럼 의미가 있는 곳에만 사용한다.
- 카드 정보는 최소한으로 마스킹하고 checkout 전 실제 처리 여부를 정직하게 알린다.

## Interaction Contract

- Category button은 `aria-pressed`, primary navigation은 `aria-current`로 상태를 노출한다.
- Search는 native `type="search"`와 visible 또는 programmatic label을 가진다.
- 수량 변경은 item별 labeled group으로 제공하고 총액을 즉시 갱신한다.
- Checkout specimen은 결제를 흉내 내지 않고 preview 상태를 live region으로 알린다.
- 반복 탐색과 수량 조절에는 entrance animation을 쓰지 않는다. Pointer press feedback만 140ms 이내로 허용한다.

## Deliberate Exclusions

- 원본 food delivery 브랜드, 카피, 음식 사진, 사용자 정보, 결제 번호를 재사용하지 않는다.
- 배달 추적, 실제 결제, 할인, 쿠폰, fulfillment 기능을 reference 이미지에서 추론하지 않는다.
- 모든 업무 dashboard를 주황색 commerce shell로 바꾸지 않는다.
- 작은 회색 글자와 hover-only control로 정보 밀도를 해결하지 않는다.

## Lab Implementation

`../ui-lab/src/food-commerce-dashboard.tsx`의 `Citrus Market`은 category filter, search, quantity adjustment, honest checkout preview를 제공한다. `../ui-lab/tests/ui-lab.spec.ts`에서 상호작용, overflow, axe를 검증한다.

공용 Foundation component로 승격하는 것은 별도 제품에서 동일 composition이 반복될 때 검토한다.
