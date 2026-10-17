---
schema_version: 1
reference_study: true
output_job: "mobile product discovery and cart review"
surface: "mobile commerce home and cart"
evidence: ["user-provided furniture commerce screenshots", "independent UI Lab commerce specimen"]
confidence: high
axes_covered: ["typography", "color", "spacing", "radius", "borders", "shadows", "layout", "hierarchy", "iconography", "imagery", "interaction"]
unresolved_axes: ["motion"]
allowed_range: "Apply to image-led discovery and compact cart flows with one dominant checkout command."
counterexample: "Do not infer swipe, payment, promotion, or fulfillment behavior from the presentation reference."
transfer_specimen: "lib/ui-lab/src/mobile-commerce-study.tsx"
---

# Mobile Commerce Reference Study

2026-07-25에 제공된 furniture shopping home/cart 이미지에서 모바일 commerce의 반복 가능한 구조를 추출한 기록이다. 특정 제품, 가격, 사진, 문구를 복제하지 않고 product discovery와 checkout hierarchy만 반영한다.

## Extracted Pattern

| 관찰 | Foundation 해석 | 채택 범위 |
| --- | --- | --- |
| warm-neutral canvas와 검은 active control | background는 조용하게, 현재 filter와 primary action은 단일 고대비 색으로 고정 | shell, filter, primary action |
| search와 category filter가 첫 viewport 상단에 있음 | 발견 workflow를 product 목록보다 먼저 배치 | search, filter group |
| 제품은 이미지, 제목, 짧은 설명, 가격 순서 | media 우선이지만 text 의미와 가격 hierarchy 유지 | product card/row |
| cart item 옆에 수량 조절이 있음 | minus/value/plus를 하나의 labeled group으로 제공 | quantity stepper |
| checkout action이 한 개의 넓은 검은 button | 한 화면의 primary command는 하나만 강하게 표시 | primary action |
| 하단 dock은 원형 active state를 사용 | icon-only item은 accessible label과 `aria-current` 필수 | commerce dock |

## Material Contract

- product row와 order summary는 불투명 surface를 사용한다. Glass는 dock 같은 boundary에만 제한한다.
- 제품 row의 radius는 `--owen-radius-panel`을 유지한다. Search, filter, primary action, dock만 pill을 사용할 수 있다.
- warm canvas는 배경 역할만 하며 text, image, black action이 충분한 대비와 palette 다양성을 만든다.
- product photo는 실제 상품 식별에 도움이 되는 media를 사용한다. placeholder는 UI Lab specimen에만 허용한다.
- quantity와 price는 tabular number로 정렬한다.

## Accessibility Contract

- search는 필수 accessible label과 native `type="search"`를 사용한다.
- filter group은 label을 받고 각 item은 `aria-pressed`로 현재 상태를 노출한다.
- product는 제목으로 labeling된 `article`이며 media는 장식 처리한다.
- quantity는 labeled group이고 증감 button은 별도 accessible name을 가진다.
- dock의 active item은 `aria-current="page"`를 사용한다.

## Deliberate Exclusions

- 특정 furniture 사진, 할인율, 가격, 브랜드, avatar는 포함하지 않는다.
- swipe carousel, payment 처리, promo validation을 presentation primitive에 넣지 않는다.
- 모든 surface를 beige 또는 glass로 통일하지 않는다.
- 검은 button 여러 개를 동시에 primary로 사용하지 않는다.
