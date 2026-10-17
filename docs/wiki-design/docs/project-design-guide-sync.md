# 프로젝트 공통 디자인·AI 구현 가이드 동기화

## 계약

2026-10-17 사용자 승인: `D:\GITHUB`의 각 직접 자식 폴더를 프로젝트로 보고 최신 WIKI 공통 디자인·AI 구현 가이드를 같은 내용으로 복사한다. 자동화는 **VS Code에서 WIKI를 열어둔 동안만** 실행한다. Windows 시작 작업·서비스·Git hook·전역 설정을 설치하지 않는다.

- 원본: WIKI의 [개발 가이드](../../../UI-FOUNDATION-DESIGN-GUIDE.md), Foundation [DESIGN](../lib/ui-foundation/DESIGN.md)·[AI-USAGE](../lib/ui-foundation/AI-USAGE.md)·README·모든 reference study·토큰, Lab/Portal 사용 안내와 UI 수집·품질 검사 문서.
- 대상: WIKI 자신과 숨김 메타 폴더·`node_modules`를 제외한 직접 자식 프로젝트. Git 저장소 여부와 무관하다. 현재 대상은 Cert를 포함한 17개이며 Sarang.day의 하위 앱을 별도 프로젝트로 중복 생성하지 않는다.
- 프로젝트별 `DESIGN.md`, 제품 코드·데이터·보안 제약은 보존한다. 공통 기준이 오래된 내장 스냅샷과 충돌하면 최신 공통 가이드가 우선한다.
- 원본 Markdown 본문은 유지하고 링크만 복사 위치에 맞게 조정한다. 배포한 문서는 로컬로, 복사하지 않은 구현·이미지·실행 자산은 WIKI 원본으로 연결한다. 이것은 라이브러리/런타임 설치가 아니다.
- Foundation 문서와 별개로 원본 UI를 재해석하거나 미검증 예제를 정식 API로 등록하지 않는다.

## 배포 위치와 AI 진입점

| 위치 | 역할 |
| --- | --- |
| 프로젝트 루트 `UI-FOUNDATION-DESIGN-GUIDE.md` | 현재 공통 개발 가이드 전문 |
| `docs/wiki-design/lib/ui-foundation/` | DESIGN, AI-USAGE, README, 참조 연구와 토큰 |
| `docs/wiki-design/`의 나머지 문서 | Portal/Lab 안내, 원본 수집·품질 검사 |
| `docs/wiki-design/README.md` | 필요한 문서만 고르는 공통 읽기 순서와 실행 경계 |
| `docs/wiki-design/.sync-state.json` | 원문/복사본 SHA-256, bundle digest와 관리 소유권 |
| `AGENTS.md`의 기존 `ui-foundation-design-guide` 블록 | 모든 에이전트의 최신 공통 지침 진입점 |
| `.github/instructions/wiki-design.instructions.md` | UI 관련 파일용 Copilot 라우팅과 YAML frontmatter |

기존 AGENTS의 공통 블록 밖은 바꾸지 않는다. 최초 마이그레이션의 이전 공통 블록은 sync state에 보관한다. 이전에 14개 프로젝트에 동일하게 배포했던 루트 공통 가이드는 알려진 SHA-256으로만 인식해 갱신한다. 임의 기존 파일을 이름만 보고 덮어쓰지 않는다.

## 실행

WIKI 루트에서 실행한다. Node 내장 모듈만 사용하며 의존성 설치가 필요 없다.

```powershell
node scripts\sync-project-design-guides.mjs --dry-run
node scripts\sync-project-design-guides.mjs
node scripts\sync-project-design-guides.mjs --check
```

- `--dry-run`: 전체 대상과 충돌을 먼저 확인하며 쓰지 않는다.
- 기본 실행: 모든 프로젝트를 사전 점검한 뒤 변경된 관리 파일만 원자적으로 교체한다.
- `--check`: 현재 원본으로 생성될 내용과 각 프로젝트의 실제 파일·진입 블록·manifest를 비교한다. 차이가 있으면 실패한다.
- `--json`: 위 유한 명령의 프로젝트별 변경 수, 원본 수와 digest를 구조화해 출력한다.
- `--source-root`, `--projects-root`: 경로 이전 및 격리 fixture 검사에 사용한다. 원본은 프로젝트 상위 폴더의 직접 자식이어야 한다.

### 자동 동기화

[VS Code 작업](D:/GITHUB/wiki/.vscode/tasks.json)의 **Shared Design Guide Sync**가 `folderOpen`에서 시작한다. 현재 창에서는 `Tasks: Run Task`로 같은 작업을 실행할 수 있다.

1. 시작 시 현재 원본으로 전체 대상을 맞춘다.
2. 원본 디렉터리 변경을 짧게 debounce한 후 다시 동기화한다. 새 reference study·새 프로젝트도 반영한다.
3. 파일 시스템 이벤트 누락에 대비해 60초마다 다시 비교하되, 내용이 같으면 쓰지 않는다.
4. WIKI 창을 닫거나 작업을 종료하면 감시도 중단한다. 그동안 놓친 변경은 다음 시작에 반영한다.

VS Code가 자동 작업 허용을 묻는 경우 사용자가 직접 허용해야 한다. 이 프로세스는 workspace trust나 사용자 전역 보안 설정을 바꾸지 않는다.

### 충돌·실패

- 복사본 또는 AGENTS 공통 블록에 로컬 수정이 있으면 전체 사전 점검을 실패시키고 원래 내용을 보존한다. `--force`로 무시하는 기능은 없다.
- 작업 터미널의 `[project-design-sync] ERROR`에 충돌 경로가 표시된다. 로컬 변경을 별도로 보존·검토한 뒤 이전 관리 내용으로 복구하거나 공통 원본에 승인된 변경을 반영해 재실행한다.
- 필수 원본이 없거나 JSON·marker가 잘못됐거나 source/target에 symlink/junction이 있으면 명시적으로 거부한다. 원본 누락을 빈 문서나 성공으로 바꾸지 않는다.
- 삭제된 선택 reference는 마지막 관리 hash와 일치할 때만 해당 파일 하나를 제거한다. 사용자 파일·폴더와 원본 자료는 정리하지 않는다.
- 쓰기는 파일별 원자적 교체다. 여러 프로젝트 전체를 하나의 파일 시스템 트랜잭션으로 묶지는 않으며 I/O 실패 후에는 오류를 해결하고 다시 실행한다.
- 운영 중 watcher 오류·권한 오류가 있으면 터미널을 확인하고 작업을 재시작한다. 일부 서비스의 실행만으로 동기화 성공을 추정하지 않는다.

## 기존 도구와의 관계

[프로젝트 DESIGN 생성기](D:/GITHUB/wiki/scripts/generate-project-design-docs.py)는 과거 제품별 결정 문서를 생성하는 별도 도구다. 고정 profile과 전체 파일 재생성을 사용하는 그 도구로 현재의 공통 가이드 동기화를 대신하지 않는다. 이 프로세스는 기존 프로젝트 `DESIGN.md`를 재생성하지 않는다.

## 검증 범위

가까운 검사는 [동기화 회귀 테스트](D:/GITHUB/wiki/scripts/tests/sync-project-design-guides.test.mjs)다. 동일 내용 배포, 링크/출처, 프로젝트 규칙 보존, 변경 없는 재실행, 업데이트/삭제, 로컬 충돌, 경로 격리, 감시 중 갱신·새 프로젝트를 다룬다.

실제 배포에서는 dry-run → 초기 복사 → `--check`와 AGENTS 공통 블록 밖 hash 비교 → VS Code watcher 시작 → 실제 공통 문서 갱신의 자동 반영을 구분해 확인한다. UI 동작을 바꾸는 작업이 아니므로 브라우저·전체 제품 빌드 검사는 실행하지 않는다.

### 2026-10-17 초기 배포 확인

- Node 내장 테스트 13개 통과: IDE 테스트 어댑터는 이 파일을 인식하지 않아 `node --test scripts\tests\sync-project-design-guides.test.mjs`로 실행했다.
- 실제 프로젝트 17개에 원본 58개를 바탕으로 프로젝트당 공통 파일 60개와 AGENTS 블록·sync state를 배포했다. 최초 `--check`의 변경 필요 파일 수는 0이었다.
- 기존 AGENTS 14개의 원문을 보존했다. 13개는 기존 공통 블록 밖 hash가 그대로였고, 원래 공통 블록이 없던 GSA-Dashboard 1개는 구분 줄을 제외한 기존 전체 prefix hash가 동일했다. 제품별 `DESIGN.md` 13개도 SHA-256이 변하지 않았다.
- VS Code의 실제 감시 작업에서 11개 디렉터리 감시를 확인했다. 이후 이 문서와 개발 가이드의 운영 링크를 수정하자 수동 sync 없이 17개 프로젝트의 51개 관리 파일이 자동 갱신됐고, 다음 비교는 0개 변경으로 수렴했다.
