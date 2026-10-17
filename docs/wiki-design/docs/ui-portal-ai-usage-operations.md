# UI Portal AI Asset Usage Operations

## 현재 상태

- 2026-09-11 구현: 복합 의도, 명시 제외, 역할별 조합, 공개 소스 패킷, 서비스 가용성, 범위별 피드백과 실행 샘플을 연결했다.
- 현재 Registry 918개, canonical/stress Recall@5 0.9722, MRR@5 0.9319. Role slot 71/71, adversarial 36/36 통과.
- 집중 테스트 20개, 세 샘플의 실제 소비 앱 typecheck/build, KO/EN 상호작용 및 desktop/mobile 검사 통과. 여섯 폭(320/375/414/768/1280/1440)씩 18개 URL 감사 통과.
- 전체 평가를 모두 통과한 것은 아니다. Registry의 meaningful reusable relation 비율은 0.9648이며 이번 작업은 Registry를 재생성하지 않았다. `without glazing dense content`의 두 원문/stress 질의는 미지원 제약으로 보류되어 기존 all-ready 기준은 118/120이다. 기대값이나 임계값을 낮추지 않았다.
- 실행 증거는 작성자 `R0`이며 독립 리뷰, 모든 12개 bundle의 검증, 원본 재현 승인 또는 모델 재학습 결과가 아니다.

### 기존 기준선

아래 수치는 이번 구현 이전에 기록한 기준선이다. 현재 실행 결과와 혼합하지 않는다.

- Registry: 637 Assets
- Canonical/Stress Recall@5: 0.9778
- Canonical/Stress MRR@5: 0.9319
- Role slot golden: 20 tasks, 71 labeled slots
- Multi-axis adversarial: 36 tasks, 6 axes
- Independent model pilot: 15/120 tasks, one agent family
- Bundle fixtures: 0/12 validated until the full browser runner is approved and executed
- Outcome shadow ranking: disabled until each surface has 30 events and each Asset has 5 events

## 검색에서 실행까지

`task-profile.mjs`와 `ai-asset-usage.mjs`는 browser-safe 공통 소유자다. CLI `brief`/`select`와 Controller `POST /api/implementation-packet`은 같은 `createImplementationPacket`을 호출한다. 동일 질의의 선택 ID, 공개 import와 `packetDigest` 일치를 테스트한다. HTTP는 현재 서비스 probe를 추가하고 CLI는 런타임을 `unverified`로 둔다.

| 요구사항 | 구현 계약 | 실행 확인 |
| --- | --- | --- |
| R1 복합 의도 | 구현을 주목적으로, 접근성 검증을 보조 목적으로 유지. 명시 조건과 추론을 구분 | 보안 설정 샘플, KO/EN 제외·설명·빈 상태·잘못된 입력 대조 |
| R2 일관된 조합 | 작업별 curated bundle 우선, 자산 포털은 Workbench/Cloud Desk 관계 사용. 무관한 선택형 evidence는 비움 | 20 tasks/71 slots, 36 adversarial cases |
| R3 실제 소스 | Foundation package-root named export, Props, 스타일, 의존성, 실제 root-import JSX 호출부와 원본 bytes SHA-256 | 소스 현재/변경/누락/경로 거절 및 CLI 일치 검사 |
| R4 정직한 상태 | 후보·이미지·공개 소스·호환성·실행 상태와 서버 가용성을 분리. 피드백은 project/task 범위 | 소스 신선도·별도 샘플 증거·HTTP scope·실패 후 재시도 |
| R5 실제 사용 | 정책 초안, 장바구니 수량/검토, 자산 검색·선택. 모바일에서 패킷 접근 유지 | build, KO/EN, axe, 자원, 가로 넘침, 뒤로가기·모달 복귀·스크롤·늦은 응답 차단 |

지원 제외는 dashboard, table, hero, glass, animation, nested-cards의 명시 표현이다. 규칙 기반이며 임의의 자연어 논리를 이해하는 엔진은 아니다. 모르는 조건은 `unresolvedConstraints`로 보류하고, 제외만 있고 만들 대상이 없는 요청은 거절한다. 이미지 원본 재현은 별도 mode로 분리하며 exact reference와 원본 비교 없이 제품 조합으로 대체하지 않는다.

공개 API 자동 추출은 `lib/ui-foundation/src/` owner에 한정한다. 지원 밖 원본은 `unavailable`로 반환하고 실제 원본 검토가 필요하다. 스크린샷의 디자인 방향은 이미지 해시와 관찰에 결합하지만, 대응한 owner를 그 원본의 구현이라고 주장하지 않는다. Cloud Desk는 시각 조합이고 Workbench의 실제 import 예제는 기존 consumer에서 찾는다. 예제는 주변 핸들러·데이터가 필요한 발췌이며 독립 실행 파일이 아니다.

`implementationReady`는 후보만으로 true가 되지 않는다. `sampleVerification`은 고정된 로컬 보고서의 성공한 build/browser 결과, exact query/packet/Registry digest와 현재 입력 해시가 모두 맞을 때만 `current`다. 일반 구현 승인이나 이미지 원본 충실도를 승격하지 않는다. 보고서는 로컬 작성자 기록이며 인증된 독립 증명이 아니다. Controller 시작 후 라우팅 소스가 바뀌면 기존 모듈을 현재 코드로 취급하지 않고 재시작을 요구한다.

### 샘플과 검증

검증용 Controller는 4182, consumer는 4185를 사용했다. 기본 사용자 Controller 4172는 재시작하지 않았다. 아래 주소는 해당 로컬 서버가 실행 중일 때 사용한다.

- [Portal](http://127.0.0.1:4182/portal/)
- [보안 정책](http://127.0.0.1:4185/?surface=routing-samples&sample=settings&controller=4182): 구현과 접근성 보조 의도, 스위치와 로컬 초안 저장.
- [장바구니](http://127.0.0.1:4185/?surface=routing-samples&sample=commerce&controller=4182): dashboard/table 제외, 수량 0..10, 합계와 주문 검토·취소. 실제 결제 없음.
- [자산 탐색](http://127.0.0.1:4185/?surface=routing-samples&sample=navigation&controller=4182): Workbench/Cloud Desk, 필터·빈 결과·선택, 공개 소스와 별도 검증 상태.

```powershell
node scripts/ui-portal/query-assets.mjs brief "보안 정책 설정 화면을 구현하고 접근성 검증도 포함해줘"
node scripts/ui-portal/query-assets.mjs check --input <saved-packet.json>
node scripts/ui-portal/check-routing-samples.mjs
node scripts/ui-portal/eval-ai-usage.mjs --output-dir dev/temp/routing-samples-evaluation
node scripts/ui-portal/check-portal.mjs
```

샘플 검증기는 기존 UI Lab Playwright/axe와 consumer TypeScript/Vite를 사용한다. 성공한 build의 명령·출력 digest, source snapshot, sample packet digest, viewport/locale, checks와 캡처 경로를 `dev/temp/routing-samples-verification/report.json`에 남긴다. 실패하면 status가 failed이며 새 성공 증거로 취급하지 않는다. 이 로컬 실행 폴더는 재실행 시 갱신된다. 원문 실행 로그는 별도 `command-evidence` receipt로 보존할 수 있다.

최종 실행 근거: [종단 검사](D:/GITHUB/wiki/dev/temp/command-evidence/run-QJ4gTU/receipt.json), [집중 테스트](D:/GITHUB/wiki/dev/temp/command-evidence/run-FTjzTq/receipt.json), [Portal gate](D:/GITHUB/wiki/dev/temp/command-evidence/run-NVeWni/receipt.json), [검색 평가](D:/GITHUB/wiki/dev/temp/routing-samples-evaluation/registry-evaluation.json). URL 감사는 `dev/temp/routing-samples-audit/{settings,commerce,navigation}-final/report.json`에 있다. 320/375px 자산 목록의 긴 이름 줄바꿈 경고는 실제 캡처에서 가독성과 경계 안 배치를 확인했다. Native mobile gesture/keyboard, 실제 정책·결제 연동, 성능 개선율과 원본 디자인 전수 재현은 검증 범위가 아니다.

## VS Code 진입점

```text
/uiportal
/uiportal-trial shard=v3-shard-01 model=<model identity>
/uiportal-fixture task-id=<slug> query=<UI task>
```

## Deterministic 평가

### UI 언어 이미지 참고 경로

2026-09-08부터 기존 UI 언어 251개를 `visualReferences`로 전달한다. 구현 role slot의 `owner`·`composition`·`validation`과 분리하여 스크린샷을 코드 소유자나 검증된 동작으로 오인하지 않는다. `brief`·`context`와 Portal의 기존 AI 구현 패킷 복사에서 관련 이미지 최대 3개를 받으며, Portal에서 고른 이미지가 있으면 우선한다.

```powershell
node scripts/ui-portal/query-assets.mjs references "패스키 로그인과 복구 옵션" --limit 3
node scripts/ui-portal/query-assets.mjs references --id vibe:auth-passkey-sign-in-with-fallback
node scripts/ui-portal/query-assets.mjs references --list
node scripts/ui-portal/generate-registry.mjs --screen-references-only
node --test scripts/ui-portal/screen-references.test.mjs
node scripts/ui-portal/check-screen-references.mjs
```

`--screen-references-only`는 기존 Registry의 ID·타 자산·maturity를 유지한 채 251개 이미지 경로·bytes·SHA-256·원본 출처·권리 제한과 이미지 결합 분석을 갱신한다. 전체 생성도 동일한 metadata owner를 사용하지만 다른 미등록 자산 발견까지 포함하므로 이 작업의 갱신에는 한정 옵션을 사용한다. 생성 파일을 직접 편집하지 않는다.

검색은 공개 카드 제목·요약·분류, 한국어 개념어와 검토된 배치·위계·밀도·적합 용도를 기반으로 한다. 이미지 임베딩 검색이나 모델 재학습은 아니다. 패킷의 `visualInspection: required`에 따라 실제 이미지를 연 다음 관찰·해석·적용 판단을 구분한다. 전수 기본 시각 분석과 파일/디코딩 검사는 시각 품질·라이선스·원본 동작 승인을 뜻하지 않는다.

`designPriorities`는 Clear·shadcn/ui·UI 언어를 높은 우선 후보로 분리해 전달한다. CLI는 기존 shadcn discovery JSON을 읽고 Portal은 이미 로드한 동일 데이터를 사용한다. 미등록 원본을 Registry owner나 verified 상태로 승격하지 않는다. 분석은 [분류별 원장](D:/GITHUB/wiki/dev/ui-portal-ai-usage/screen-design-analysis/README.md), 선택 품질 비교는 [고정 15질문 결과](D:/GITHUB/wiki/dev/ui-portal-ai-usage/screen-design-evaluation.json)에 있다.

```powershell
node scripts/ui-portal/validate-screen-design-analysis.mjs
node --test scripts/ui-portal/screen-references.test.mjs scripts/ui-portal/design-priorities.test.mjs
node scripts/ui-portal/eval-screen-design-analysis.mjs --write
```

검토 시트의 실제 파일까지 대조할 때만 `validate-screen-design-analysis.mjs --review-evidence`를 사용한다. 시트는 로컬 임시 자료이며 일반 metadata 갱신은 원본 이미지 해시와 보존된 분석을 검사한다. 원본 이미지가 달라지면 생성이 실패하므로 분석을 새로 검토한 뒤 갱신한다.

상세 활용 절차는 [Foundation AI 사용 가이드](../lib/ui-foundation/AI-USAGE.md#ui-언어-스크린샷-활용), 실행 근거는 [스크린샷 참고 검증 기록](D:/GITHUB/wiki/dev/ui-portal-ai-usage/screen-reference-validation.md)을 따른다.

### 기존 검색 평가

```powershell
node scripts/ui-portal/check-portal.mjs
node scripts/ui-portal/eval-ai-usage.mjs
```

평가는 canonical 60, mixed/long stress 60, legacy no-media 30, role slot 20/71과 multi-axis adversarial 36 cases를 분리한다. Slot accuracy는 같은 role 안에서 의미상 맞는 exact Asset ID를 선택했는지 측정한다. Adversarial axes는 owner confusion, bundle confusion, role boundary, maturity boundary, near-keyword와 prompt leakage다.

## 독립 Agent Trial

40-task packet은 재현 snapshot이다. 실제 model 입력은 5-task shard만 사용한다.

```powershell
node scripts/ui-portal/prepare-ai-trials.mjs
node scripts/ui-portal/prepare-ai-trial-shards.mjs
node scripts/ui-portal/trial-work-queue.mjs
```

Agent 응답은 broad Registry 없이 해당 shard만 사용한다. Normalization과 score 후 run identity를 기록한다.

```powershell
node scripts/ui-portal/structured-selection.mjs --input <raw> --packet <shard> --output <response> --receipt <normalization>
node scripts/ui-portal/score-ai-trial.mjs --input <response> --packet <shard> --label <label>
node scripts/ui-portal/record-trial-run.mjs --label <label> --agent <agent> --model <exact model identity>
node scripts/ui-portal/trial-work-queue.mjs
```

Model identity를 확인할 수 없으면 추측하지 않고 `unspecified-default`로 기록한다. 현재 pilot은 15/120이며 full-corpus 또는 model-diversity 증거가 아니다.

## Agent-generated Fixture

Fixture 준비와 구현은 validation과 분리한다.

```powershell
node scripts/ui-portal/prepare-agent-fixture.mjs --task-id <slug> --query "<task>"
```

Agent는 생성된 `src/App.tsx`, `src/styles.css`만 수정한다. 구현 화면을 사용자에게 보여 준 뒤 별도의 검증 승인이 있을 때만 실행한다.

```powershell
node scripts/ui-portal/run-agent-fixture.mjs <slug> --record-outcome
```

Runner는 starter 변경, package-root import, owner path, typecheck, build, KO/EN, required states, desktop/mobile, axe, overflow, runtime error와 PNG evidence를 검증한다.

## Bundle Fixture와 Drift

12개 bundle은 version을 가진다. Full validation 승인 후 두 preview runtime을 시작하고 다음을 실행한다.

```powershell
node scripts/ui-portal/run-bundle-fixtures.mjs
node scripts/ui-portal/bundle-receipts.mjs check --require-validated true
```

Bundle receipt는 definition, source file, Context Pack과 fixture receipt digest를 결합한다. Source, context, Registry 또는 failed fixture가 달라지면 stale이다. Fixture를 실행하기 전 상태는 실패가 아니라 `unvalidated`다.

## Outcome과 Shadow Ranking

Outcome은 exposed, selected, excluded, implementation, validation, final-decision event를 구분한다. Portal은 사용자가 `결과 기록`을 누른 final decision만 기록하며 자동 노출 telemetry를 만들지 않는다. Raw query는 저장하지 않고 query/profile digest를 저장하며 reason의 email, IP와 일반적인 secret pattern은 마스킹한다.

```powershell
node scripts/ui-portal/asset-outcomes.mjs report
node scripts/ui-portal/asset-outcomes.mjs report --project wiki --task settings
```

Shadow ranking은 실제 추천에 적용되지 않는다. Surface 30 events와 Asset 5 events가 모두 모인 후보만 score를 계산한다. 승격에는 별도 회귀 평가와 사용자 승인이 필요하다.

`record`도 `--project`와 `--task`를 받는다. 짧은 식별자만 허용하고 경로나 비밀값을 넣지 않는다. Portal은 현재 활성 project ID와 작업 surface를 기록·조회하며, task 없는 project 또는 legacy 무범위 이벤트를 다른 범위로 자동 합치지 않는다. API 전체 이벤트 요약은 전역 집계이고 `shadowRanking.scope`만 명시 범위다. `excluded` 개수는 별도로 집계한다. 사용자 기록의 `validation:passed`는 검증된 빌드 영수증과 동등하지 않다.

## 완료 경계

- Deterministic PASS는 검색과 packet 계약을 증명한다.
- Independent trial PASS는 제한된 candidate 안의 AI 선택을 증명한다.
- Fixture receipt는 연결된 file, command와 browser evidence를 증명한다.
- 어느 것도 제품 사실의 정확성, 전체 사용자 가치나 주관적 시각 품질을 자동 승인하지 않는다.
