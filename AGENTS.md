# Agent Instructions

<!-- ui-portal-usage:start -->
## Owen UI Portal 사용

- UI/UX, frontend, component, 접근성, 반응형 또는 시각 자산 작업을 계획하거나 편집하기 전 companion WIKI의 UI Portal을 task-specific 자산 선택의 기본 라우터로 사용한다.
- WIKI 루트는 멀티루트 workspace의 `wiki`, sibling `../wiki`, 현재 플랫폼의 알려진 WIKI 경로 순서로 찾으며 하나의 절대 경로만 가정하지 않는다.
- 구현용 선택은 WIKI 루트에서 `node scripts/ui-portal/query-assets.mjs brief "<한 문장의 output job>" --limit 5`를 실행하고 Task Profile, Context Pack, exact Asset ID, `ownerPath`/`ownerApi`, maturity와 validation을 확인한다. broad Registry를 모델 컨텍스트에 넣거나 Asset ID를 추측하지 않는다.
- 시각 검토는 WIKI의 `process: UI Portal Controller`를 실행·재사용하고 VS Code 내장 브라우저에서 `/uiportal query="<작업>"` 또는 `http://127.0.0.1:4172/portal/`을 연다.
- Portal은 라우팅·증거 surface이고 Foundation의 `DESIGN.md`와 owning source가 최종 계약이다. WIKI는 명시적 요청이 없으면 읽기 전용으로 유지하며, 접근할 수 없으면 미검증 범위를 보고한다.
<!-- ui-portal-usage:end -->

<!-- ui-foundation-design-guide:start -->
## UI Foundation Lab 디자인 가이드

- 모든 UI 설계·구현 전에 [UI-FOUNDATION-DESIGN-GUIDE.md](UI-FOUNDATION-DESIGN-GUIDE.md)를 먼저 읽는다.
- UI Foundation Lab 왼쪽 패널의 26개 UI를 모두 `Priority 1` 디자인 후보로 취급한다.
- `Priority 1` 안에서는 Clear glass search, controls, workflow를 가장 먼저 검토한다.
- 나머지 Lab specimen을 검토한 뒤에만 앱 전용 신규 디자인이나 외부 reference를 고려한다.
- 이 프로젝트의 기존 제품 제약과 더 엄격한 접근성·runtime 규칙은 그대로 유지한다.
<!-- ui-foundation-design-guide:end -->
