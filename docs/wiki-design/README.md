# WIKI 공통 디자인·AI 구현 가이드

이 폴더와 루트 개발 가이드는 **D:/GITHUB/wiki**에서 생성한 단방향 관리형 복사본이다. 모든 소비 프로젝트에 같은 내용을 배포한다.

## 읽는 순서

1. [개발 가이드](../../UI-FOUNDATION-DESIGN-GUIDE.md): output job, Portal query, 소유권과 구현·검증 순서.
2. [DESIGN](lib/ui-foundation/DESIGN.md): Continuous 코너, 컴팩트 UI·상세 툴팁, Clear, 반응형·접근성 기준.
3. [AI-USAGE](lib/ui-foundation/AI-USAGE.md): 현재 public API, maturity, 구현 경계와 specimen 선택.
4. [Foundation README](lib/ui-foundation/README.md), 필요한 reference study와 토큰만 선택한다.
5. 원본 UI 수집은 [수집 절차](UI-Portal/INTAKE-WORKFLOW.md)를 따른다. 원본 보존·구현 승인·검증 승인·정식 등록은 별개다.

## 소유권과 실행

- 프로젝트의 기존 DESIGN.md에서 제품 고유 결정은 유지한다. 그 안의 과거 공통 스냅샷보다 이 최신 공통 문서가 우선한다.
- Markdown의 문서 본문은 보존하고 링크만 배포 위치에 맞게 조정한다. 포함한 문서는 로컬 복사본, 포함하지 않은 구현·이미지·실행 자산은 WIKI 원본을 가리킨다.
- 문서 복사는 Foundation package, 스킬 runtime, Node 의존성이나 브라우저를 설치하지 않는다. 라이브 API·실제 reference·검증은 원래 owner에서 확인한다.
- 원문에 나오는 WIKI 상대경로 명령은 WIKI 루트에서 실행한다. 소비 앱의 코드·데이터·검사는 해당 프로젝트에서 수행한다. 접근 불가능한 원본이나 미실행 검사를 완료로 주장하지 않는다.
- 프로젝트 AGENTS.md 공통 블록과 Copilot 파일별 지침도 연결되어 있다. 공통 원본·참조 연구·토큰의 정확한 입력/복사본 SHA-256은 [.sync-state.json](.sync-state.json)에 기록한다.
- WIKI를 VS Code에 열어두면 **Shared Design Guide Sync** 작업이 저장 변경과 새 프로젝트를 자동 반영한다. 시작 시 누락된 변경도 동기화한다.
- 복사본에 로컬 수정이 있으면 자동 덮어쓰기나 삭제를 하지 않고 충돌을 알린다. 원본과 차이를 검토해 로컬 수정을 보존한 후 재실행한다.

상세 운영: [WIKI 동기화 프로세스](docs/project-design-guide-sync.md).
