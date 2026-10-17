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
## 공통 UI 디자인·AI 구현 가이드

- UI·UX·frontend·접근성·반응형 작업 전에 [공통 가이드 안내](docs/wiki-design/README.md)와 [개발 가이드](UI-FOUNDATION-DESIGN-GUIDE.md)를 읽는다. 필요한 owner와 reference만 선택하며 문서 전체를 일괄 로드하지 않는다.
- 시각·동작 기준은 [공통 DESIGN](docs/wiki-design/lib/ui-foundation/DESIGN.md), 구현 API·maturity·선택 절차는 [AI-USAGE](docs/wiki-design/lib/ui-foundation/AI-USAGE.md)가 소유한다.
- 이 경로는 과거 WIKI 절대경로, 이전 Lab 개수, 프로젝트 DESIGN.md에 내장된 과거 공통 스냅샷보다 우선한다. 프로젝트 고유 output job·제품 결정과 더 엄격한 보안·접근성·runtime 제약은 보존한다.
- 공통 복사본은 WIKI에서 단방향 동기화한다. 공통 기준 변경은 원본 WIKI에서 하고 로컬 복사본은 직접 수정하지 않는다. UI가 없는 프로젝트에 새 화면을 만들라는 지시가 아니다.
<!-- ui-foundation-design-guide:end -->