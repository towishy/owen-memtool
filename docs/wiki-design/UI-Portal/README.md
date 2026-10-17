# Owen UI Portal

`UI-Portal/`은 WIKI의 UI 디자인, 목업, Foundation API, 근거와 운영 도구를 source 구조와 무관하게 8개 asset family로 검토하고 선택하는 통합 진입점이다.

## Asset-First Shell

| Internal adapter | Portal manifest | Canonical owner | Runtime |
| --- | --- | --- | --- |
| UI LAB | `ui-lab/manifest.json` | `lib/ui-lab/` | `127.0.0.1:4173` |
| UI Foundation | `ui-foundation/manifest.json` | `docs/ui-foundation/`, `lib/ui-foundation/` | controller static route |
| UI 시스템 | `ui-system/manifest.json` | `lib/ui-foundation-consumer/` | `127.0.0.1:4175` |

이 adapter는 top-level navigation이 아니다. Portal은 화면·목업, 컴포넌트·컨트롤, 패턴·상호작용, 시각 시스템, 지식·근거, UI 언어(영문 UI Vocabulary), 이미지·비디오 프롬프트, 검증·운영 family로 탐색하고 live preview가 필요할 때만 owner runtime을 연다. UI 언어는 실제 화면 목업을 보며 앱 패턴과 설계 어휘를 고르는 visual reference이고, 이미지·비디오 프롬프트는 생성 미디어 제작 자산이다. 기존 구현 원본은 canonical owner에 유지한다.

## Lucian workflow originals (comparison pending)

Six selected Lucian originals are available through the normal [Portal cards and detail views](http://127.0.0.1:4172/portal/?family=patterns-interactions&origin=lucian): change review, CSV mapping, revision restore, branching history, event replay and automation flow. Screenshot, isolated live preview, source code and porting prompt open inside Portal. Live variants preserve the original KO/EN light/dark code; demonstration playback is opt-in and is not a test result.

These are pending discovery items, not promoted Registry assets or public Foundation APIs. Normal product selection remains Foundation-first. See the [owner guide](../lib/lucian-uxui/README.md) for explicit original-source query commands, provenance and remaining validation.

## Open

VS Code에서 WIKI workspace를 열면 `UI Portal Controller` task가 자동 실행된다.

VS Code Chat에서는 `/uiportal`을 실행하면 controller task를 재사용하고 Portal을 VS Code 내장 브라우저로 연다. `query=<자연어 작업>`과 `asset=<exact Asset ID>`를 선택적으로 전달하면 검색 또는 자산 deep link로 바로 이동한다. Command Palette의 `Chat: Run Prompt...`에서 `UI Portal`을 선택해도 같은 prompt를 실행한다.

`.github/prompts/uiportal.prompt.md`는 workspace prompt이므로 WIKI가 아닌 별도 workspace의 Chat에는 나타나지 않는다. 모든 workspace에서 같은 `/uiportal` 명령을 쓰려면 VS Code user profile의 `prompts/uiportal.prompt.md`에도 global prompt를 둔다. Global prompt는 먼저 기존 `4172` controller를 재사용하고, 연결이 없을 때만 현재 workspace와 알려진 WIKI 경로에서 `scripts/ui-lab-controller.mjs`를 찾아 loopback controller를 시작한다.

Windows와 macOS에서 canonical prompt를 현재 VS Code user profile로 설치하거나 drift를 확인한다.

```powershell
node scripts/ui-portal/install-user-prompt.mjs
node scripts/ui-portal/install-user-prompt.mjs --check
```

User prompt는 Settings Sync 대상이다. Sync를 사용하지 않는 장비에서는 WIKI clone에서 installer를 한 번 실행한다. Installer는 `VSCODE_USER_PROMPTS_FOLDER` 환경변수 또는 `--target`을 우선하고, 기본값으로 Windows `%APPDATA%\Code\User\prompts`, macOS `~/Library/Application Support/Code/User/prompts`를 사용한다.

```text
http://127.0.0.1:4172/portal/
```

상단 `Preview runtime` utility의 `전체 시작`은 UI LAB과 UI 시스템 중 중지된 서비스를 시작한다. `전체 종료`는 Portal controller가 직접 시작한 process만 종료하며, 다른 terminal이 시작한 외부 process는 중지하지 않는다.

## Canvas Lifecycle

상단 `Canvas` 버튼은 필요한 Canvas 서비스와 렌더러를 시작하고, 준비 API와 편집기의 ready 메시지를 확인한 뒤 연결한다. 시작 단계는 Canvas 헤더에 표시한다. 준비 실패 또는 응답 시간 초과 시 `다시 연결`을 누르면 Controller 소유 Canvas를 종료한 뒤 다시 시작한다. 이미 실행 중인 외부 Canvas는 재사용하며 강제 종료하지 않는다.

같은 `Canvas` 버튼을 다시 눌러 닫으면 iframe 연결과 대기 중인 배치를 정리하고 Controller 소유 Canvas 서비스만 종료한다. 공유 Lab·shadcn 렌더러와 브라우저 저장 문서는 유지한다. 시작 중 닫기와 빠른 재열기는 시작·종료 요청을 순서대로 처리한다. 이 계약은 Canvas 버튼으로 닫는 경우이며 브라우저 탭 종료나 비정상 종료 시 자동 정리를 보장하지 않는다. 서비스는 Controller 단위로 공유되므로 다른 Canvas 창도 같은 서비스 종료의 영향을 받는다.

```powershell
node scripts/ui-portal/check-canvas-bridge.mjs
node scripts/ui-portal/check-canvas-bridge.mjs --live-lifecycle
```

첫 검사는 네트워크 fixture로 소유권·실패·취소·재열기를 확인한다. 실제 검사는 실행 중인 Controller와 닫힌 Canvas를 전제로 독립 브라우저에서 시작·편집·닫기·재열기·저장 문서 보존, 확인창 취소 초점, 1440/390/320px 헤더의 12px 글꼴·axe·overflow·console/resource를 확인한다. 결과와 화면·녹화는 `dev/temp/canvas-lifecycle/`에 저장하며 모바일 편집기 전체나 실제 기기 인증은 아니다.

## Desigma Desktop

왼쪽 위 도구 영역의 **Desigma 실행** 아이콘은 원본 Desigma를 **별도 Windows 데스크톱 창**으로 연다. Portal iframe 편집기가 아니며 기존 Canvas를 대체하지 않는다.

- 고정 버전: `0.1.0-alpha.5`. [휴대형 설치](D:/GITHUB/wiki/lib/desigma/README.md)는 승인된 GitHub ZIP과 실행 파일의 크기·SHA-256을 검사하며 runtime을 Git에서 제외한다.
- 아이콘 클릭은 다운로드나 설치를 하지 않는다. 미설치·Windows 외 환경·해시 불일치·native 창 준비 실패는 명확히 안내한다.
- 동일 경로의 실행 중인 앱이 있으면 다시 실행하지 않고 기존 창을 안내한다. 사용자 문서를 자동으로 열거나 닫거나 삭제하지 않는다.
- Portal/Controller 종료와 native 문서 종료는 별개다. 편집 작업은 Desigma 창에서 직접 저장·종료한다.
- 원본은 알파·미서명 배포본이며 OS 보호 설정을 자동 우회하지 않는다. 폰트 다운로드·외부 링크 등 원본 기능의 네트워크 동작까지 차단하는 샌드박스가 아니다.

검토 범위와 승인·검증 상태는 [Desigma intake](D:/GITHUB/wiki/dev/ui-portal-intakes/desigma-native-design-tool/REVIEW.md)를 참고한다.

```powershell
node --test scripts\ui-portal\desigma-service.test.mjs
node scripts\ui-portal\check-desigma-launcher.mjs
node scripts\ui-portal\check-desigma-launcher.mjs --live
```

첫 검사는 inert 파일과 가짜 프로세스로 실행 파일·경로·중복 실행·준비 실패·HTTP 경계를 확인한다. 두 번째는 격리된 브라우저 fixture로 언어·busy·오류·재시도·stale status·bfcache를 확인한다. `--live`는 실행 중인 Controller와 이미 열린 Desigma 창을 전제로 실제 Portal의 한·영·Tab/Enter·1440/390/320px·아이콘 범위 axe·overflow·console/resource·native PID 재사용을 검사한다. 사용자의 native 문서를 닫거나 저장하지 않는다. 결과는 [intake attachments](D:/GITHUB/wiki/dev/ui-portal-intakes/desigma-native-design-tool/attachments)에 기록한다.

## Image Upscale (Upscayl)

상단 **이미지 업스케일** 또는 **라이브러리 작업 > 이미지 업스케일**에서 로컬 GPU 작업을 실행한다.
직접 열기: <http://127.0.0.1:4172/portal/?tool=upscayl>.

- PNG/JPEG/WebP 파일 선택, 보관 모델 7종, 2/3/4배, 타일 64/128/256, GPU 자동 또는 ID 선택.
- 원본/결과/나란히 비교, 연결 확대·이동, 방향키 이동, 맞춤 복귀, PNG·실행 기록 다운로드.
- 시작·준비·추론·검증·취소·실패를 구분한다. 창 닫기는 실행 취소가 아니며 다시 열어 상태를 확인한다. 같은 탭의 새로고침은 sessionStorage 작업 ID로 복귀한다.
- 실행 취소는 소유한 추론 프로세스만 종료한다. **작업 지우기**는 해당 작업의 로컬 입력 사본·결과·기록을 삭제하며 선택한 원본 파일은 수정하지 않는다.

Windows의 기존 NCNN 바이너리·모델과 PATH의 FFmpeg/ffprobe를 사용하며 Electron·Python·새 모델 설치는 필요하지 않다. 서버는 한 번에 한 작업, 세션당 보관 12개, 파일 20 MiB, 입력 4,194,304 pixels, 4배 중간 결과 67,108,864 pixels로 제한한다. 추론은 최대 10분이며 타일은 VRAM 작업 단위를 줄일 뿐 전체 출력 메모리를 무제한으로 줄이지 않는다. 정지 이미지를 대상으로 첫 프레임을 사용하며 애니메이션 보존은 지원하지 않는다.

처리는 loopback Controller의 same-origin API에서 이루어진다. 임의 파일 경로·URL·명령은 받지 않으며 업로드 파일명 대신 생성한 작업 ID를 사용한다. Host/Origin/header·형식·바이트·픽셀 상한과 실행 파일/모델 SHA-256을 검사하고, 종료 코드 0 + 결과 디코딩 + 정규화된 입력 기준 배율 일치 후에만 완료한다. EXIF 등 원본 메타데이터는 복사하지 않는다. 인증된 다중 사용자 서버나 파일 보안 샌드박스가 아니므로 LAN/인터넷으로 노출하지 않는다.

작업 파일은 ignored `dev/temp/upscayl-jobs/<id>/`에 저장한다. 지우기 전까지 남으며 Controller 재시작 시 작업 인덱스는 복구하지 않는다. 이전 세션의 임시 디렉터리는 자동 삭제하지 않는다. 준비 상태는 실제 GPU 추론 성공과 별개다. AI가 추정한 글자·얼굴·세부는 원본 사실의 증거가 아니며 결과를 직접 검토한다. 전체 원본 Upscayl UI 수집·Cloud 연결·모델 배포 승인을 의미하지 않는다.

```powershell
node --test scripts/ui-portal/upscayl-service.test.mjs
$env:UPSCAYL_TEST_URL = 'http://127.0.0.1:4172'
node scripts/ui-portal/check-upscayl.mjs
```

실제 검사는 실행 중인 Controller, 기존 UI Lab Playwright/axe, 설치된 Edge와 Vulkan GPU가 필요하다. 결과는 `dev/temp/upscayl-portal-check/`에 저장한다. 범위와 분석은 [Upscayl adoption review](D:/GITHUB/wiki/dev/local-ai-tools-review/upscayl-portal-adoption.md)를 참고한다.

## Selection contract

각 surface는 현재 선택이 바뀔 때 parent window로 다음 message를 보낼 수 있다.

```js
window.parent.postMessage({
  type: "owen-ui-portal-selection",
  surfaceId: "ui-lab | ui-foundation | ui-system",
  id: "stable-selection-id",
  label: "visible selection label",
  detail: "short context",
  url: "direct local URL",
}, "http://127.0.0.1:4172")
```

Portal은 현재 선택을 공통 비교·검토 목록에 저장한다. 목록은 Portal origin의 localStorage에만 보존되며 외부로 전송하지 않는다.

검토 목록은 후보 ID와 함께 `검토 중`, `채택`, `보류` 상태와 한 줄 decision note를 저장한다. 검색어와 family/category/validation/origin/maturity/preview/sort/asset 상태는 URL에 보존되어 같은 탐색 결과를 다시 열 수 있다.

## Library Review Tools

찾아보기의 `라이브러리 작업`에서 다음 로컬 작업을 실행한다. 원본 owner와 Registry는 변경하지 않는다.

- **저장 검색 / 스마트 앨범**: 현재 검색어·필터·정렬을 이름으로 저장하고 수정·적용·삭제한다. family/category/validation/origin/maturity/preview/reviewStatus/projectId/tags 조건을 AND 또는 OR로 결합한다. JSON 가져오기·내보내기를 지원하며 가져오기는 전체 유효성 검사 후 한 번에 반영한다. 전체 필터 초기화는 추가 규칙도 제거한다.
- **이미지 비교**: 비교 목록 최대 4개, 2/4분할, 연결된 확대·이동 또는 개별 조작, 맞춤 복귀를 제공한다. 모바일에서는 활성 이미지를 전환한다. 방향키 이동, `+`/`-` 확대, `0` 맞춤을 지원한다.
- **검토 근거**: 현재 이미지 또는 로컬 이미지·영상 프레임에 판정 기준, 관찰, 수정 제안, 심각도와 실행 상태를 연결한다. 원본 source stamp와 프레임 SHA-256을 보존하고 변경·누락을 구분한다. 이는 작성자 검토이며 자동 품질 승인이나 독립 검토가 아니다.
- **로컬 유사 검색**: 현재 탐색 범위 최대 600개의 실제 미리보기 바이트를 해시하고 색상·공간 특징을 캐시한다. 텍스트는 기존 메타데이터 ranker를 사용한다. 선택 이미지·업로드 이미지 검색, SHA-256 중복 그룹, 모든 구성원 쌍이 임계값을 만족하는 유사 그룹을 제공한다. 기본 임계값은 `0.995`이며 자동 삭제·이동은 없다.
- **설명 영상**: 비교 목록 또는 선택 이미지에서 대본·출처·로컬 음성을 확정하고 최대 30초 파일을 검토·승인한 뒤 전체 WebM을 생성한다. 16:9/9:16, 자막 VTT와 입력·출력 digest 기록을 지원한다. 대본·형식·음성 변경은 승인을 무효화하고 전체 생성 전 이미지 바이트도 재검증한다.

저장 검색과 근거 메타데이터는 localStorage `owen-ui-portal-review-tools-v1`, 근거 이미지·특징 캐시·선택적 임베딩은 IndexedDB `owen-portal-review-media-v1`에 저장한다. 브라우저 프로필과 origin에 종속되며 Git 동기화나 서버 백업이 아니다. 근거 JSON 내보내기는 메타데이터만 포함하고, 근거 기록 삭제는 공유 이미지 Blob을 자동 정리하지 않는다. 브라우저 사이트 데이터를 지우면 로컬 기록도 사라진다.

이미지는 최대 20 MB, 영상 입력은 최대 150 MB/10분이며 시작·끝 인근과 25/50/75% 지점을 표본 추출한다. 근거 하나는 최대 12프레임이다. 전환 검사는 표본을 통한 사람의 검토이며 전 프레임의 모션·가독성을 자동 판정하지 않는다. 설명 영상은 최대 8장면/300초, 로컬 음성은 50 MB 이하이다. 브라우저 실시간 녹화이므로 탭을 유지해야 하며 숨겨지면 취소한다. MP4, 프레임 정확한 렌더링, 자동 TTS·외부 AI 생성은 포함하지 않는다. 다운로드·공유 전 원본 이미지와 음성의 이용 권한을 확인한다.

학습 모델을 자동 설치하거나 이미지를 외부로 보내지 않는다. 이미 확보한 이미지 임베딩은 아래 JSON 계약으로 가져올 수 있다. `model`은 버전까지 식별하는 이름을 권장하며 같은 모델·전처리·차원의 벡터만 함께 사용한다. Asset ID와 현재 이미지 SHA-256이 모두 일치해야 사용하며 다른 특징 공간의 점수를 한 순위에 섞지 않는다. 텍스트-이미지 의미 추론 엔진 자체는 내장하지 않는다.

```json
{
  "version": 1,
  "model": "local-model@version/preprocess-v1",
  "dimensions": 2,
  "items": [{ "id": "lab:mono-telemetry", "imageSha256": "<64 lowercase hex characters>", "vector": [0.6, 0.8] }]
}
```

임베딩 파일은 50 MB 이하, 최대 10,000개, 차원 2~4,096, 유한·비영벡터이며 좌표 절댓값은 1,000,000 이하이다. 위 예시의 해시는 실제 이미지 값으로 교체해야 한다.

```powershell
node scripts/ui-portal/review-tools.test.mjs
node scripts/ui-portal/review-tools.test.mjs --browser --audit
```

브라우저 검사는 실행 중인 `4172` controller, 기존 UI Lab Playwright/axe와 설치된 Edge를 사용한다. 결과는 `dev/temp/portal-review-tools/`에 둔다. 채택 범위와 검증 경계는 [adoption record](D:/GITHUB/wiki/dev/local-ai-tools-review/anything2explainer-lap-portal-adoption.md)에 기록한다.

## Unified Asset Registry

Asset-first shell은 원본 owner를 이동하거나 복사하지 않고 UI·UX·디자인 시스템 자산을 하나의 registry로 합친다. 총계와 family count는 generated Registry에서 읽으며 고정값으로 관리하지 않는다.

```powershell
node scripts/ui-portal/generate-registry.mjs
node scripts/ui-portal/validate-registry.mjs
```

Generated files:

- `assets/registry.json` — category, multi-family membership, owner, source, static preview, isolated `livePreviewUrl`, maturity, tag와 canonical content SHA-256을 가진 index
- `assets/search-index.json` — Portal search용 compact index
- `assets/REGISTRY-MANIFEST.md` — category별 count와 생성 계약

현재 registry는 Foundation public module, Lab specimen, reference study, contract, UI knowledge, prompt, evidence, screenshot, test, controller, token, template, skill, intake record와 integration reference를 포함한다. Validator는 core baseline의 감소를 차단하되 승인된 신규 intake의 증분 등록은 허용한다.

모든 family의 Browse view는 같은 card shell을 사용한다. UI Lab 30개와 UI System 11개는 각각 하나의 component만 mount하는 isolated live preview를 제공하고, runtime surface 4개는 전체 앱 preview를 유지한다.

Registry item은 canonical `family`와 탐색용 `families[]`를 함께 가진다. UI 언어 251개는 같은 exact ID로 `UI 언어`와 `화면·목업` 양쪽에 나타나며, AI context에서는 앱 화면 설계용 `composition` reference로 사용한다. family count는 membership 수이고 전체 626개는 unique asset ID 수다.

모든 Registry asset은 screenshot과 card-level `Live preview` 버튼을 제공한다. 공용 component와 구현된 reference study는 기존 독립 specimen으로 연결하고, 문서·근거·prompt·test·tool은 source와 provenance를 읽는 `preview.html` artifact viewer로 표시한다. 이 viewer는 제품 UI를 가장하는 생성 목업이 아니라 실제 asset을 검토하는 실행 surface다.

Blurssism은 사용자 승인 범위의 원본 9개 specimen을 같은 검색·카드·상세·스크린샷/Live preview/소스코드 경로에 연결한다. `dev/ui-portal-intakes/blurssism/implementation/portal-items.json`을 pending discovery로 읽고 원본 비교 대기 상태로 표시하며, generated Registry 승격과 구분한다. 원본 스타일·로컬 글꼴·React UMD는 독립 iframe에 격리하고 `lib/blurssism/`에서 보존한다. 절차와 범위는 [원본 연구](D:/GITHUB/wiki/docs/UI-Design/reference-study-blurssism.md)를 참조한다.

```powershell
node scripts/ui-portal/capture-asset-previews.mjs
node scripts/ui-portal/check-asset-previews.mjs
```

`capture-asset-previews.mjs`는 artifact/full-runtime screenshot과 SHA-256 receipt를 생성한다. `check-asset-previews.mjs`는 image resource, artifact route, implementation route, full runtime과 category별 desktop/mobile axe를 전수 확인한다.

AI asset selection은 `query-assets.mjs profile|context|brief`의 Task Profile과 5개 이하 Context Pack V3 안에서만 수행한다. `select`는 packet 밖 ID를 거부하고 Registry/ranker/query/profile/candidate/relation identity를 `selection-receipt.v3` SHA-256으로 묶는다. Agent 응답은 `structured-selection.mjs`가 schema와 exact ID, owner, role, task completeness를 검증한 뒤 canonical JSON과 normalization receipt로 저장한다.

Task Profile은 output job, surface, density, risk, states, KO/EN, desktop/mobile, required/preferred/forbidden role과 canonical owner hint를 deterministic하게 만든다. Locale·viewport·검증 제약은 `routingQuery`에서 분리하고 역할별 후보군을 독립 검색한다. Context Pack V3는 필수 역할을 모두 채운 경우에만 `ready`이며, 검증된 12개 bundle을 우선 사용하고 관련 후보가 부족하면 5개를 억지로 채우지 않는다. Implementation Brief는 owner path/API, composition, 상태, locale, viewport, 금지 경계와 validation ID를 AI가 바로 실행할 구조로 제공한다.

사람이 Inspector에서 고른 asset은 첫 `selected-anchor`로 고정한다. Prompt/media 의도가 없는 선택에는 관계없는 media prompt를 넣지 않는다. Review의 `결과 기록`은 명시적 사용자 명령이며, append-only outcome 원장에는 raw query 대신 query/profile digest, exact Asset ID, owner path, 채택 상태와 검증 결과만 저장한다.

AI 구현 결과는 `fixture-trial.mjs`가 packet/context digest, owner path, implementation file, required state, KO/EN, desktop/mobile, 성공 명령 로그, PNG screenshot, axe·overflow·runtime evidence를 묶어 검증한다. `run-bundle-fixtures.mjs`는 12개 bundle의 실제 Lab/System surface를 같은 계약으로 검사한다. Receipt는 이 evidence의 존재와 일치만 증명하며 사실 정확성이나 주관적 시각 품질을 자동 승인하지 않는다.

독립 AI 평가는 `prepare-ai-trial-shards.mjs`로 120-task corpus를 5-task shard 24개로 나눠 실행한다. VS Code Chat의 `/uiportal-trial shard=v3-shard-01` 또는 `Chat: Run Prompt...`의 `Run UI Portal AI Trial`을 사용한다. Shard를 생략하면 work queue의 첫 pending shard를 사용한다. 현재 독립 pilot은 3개 shard·15개 task이며 전체 corpus나 model diversity 결과로 확장 해석하지 않는다.

Agent가 실제 Foundation 소비 코드를 구현하는 trial은 `/uiportal-fixture task-id=<slug> query=<task>`로 준비한다. 생성된 두 source file만 수정하고 browser presentation 뒤 별도 validation 승인을 받아 `run-agent-fixture.mjs`를 실행한다. Review의 `AI 활용 준비도`는 deterministic MRR, slot/adversarial pass, independent trial coverage와 validated bundle 수를 함께 보여 준다.

상세 명령과 완료 경계는 [AI Asset Usage Operations](../docs/ui-portal-ai-usage-operations.md)를 따른다.

## Link Intake

사용자가 공개 링크와 함께 “이거 UI Portal에 추가해줘”라고 요청하면 [UI Portal Link Intake Workflow](INTAKE-WORKFLOW.md)와 [ui-portal-intake skill](../.github/skills/ui-portal-intake/SKILL.md)을 사용한다.

```powershell
node scripts/ui-portal/intake.mjs create --url "<public-url>" --slug "<slug>" --title "<title>"
node scripts/ui-portal/intake.mjs check --manifest dev/ui-portal-intakes/<slug>/intake.json
```

프로세스는 source review 뒤 구현 승인, 실제 브라우저 제시 뒤 검증 승인을 각각 요구한다. `registration-ready` 또는 `registered` intake만 Registry generator가 읽으며, generated asset 파일은 직접 수정하지 않는다.

## Guardrails

- Portal은 localhost에만 bind한다.
- UI Foundation content는 controller의 same-origin static route로 표시한다.
- UI LAB과 UI 시스템은 별도 Vite origin의 on-demand preview adapter이며 외부 URL을 iframe에 허용하지 않는다.
- 서비스 종료는 controller가 소유한 process tree에만 적용한다.
- preview frame 내부의 dense content와 vertical scroll은 각 surface owner가 관리한다.
- Portal document와 app-owned vertical scroll은 density에 맞게 조정 가능한 compact Frosted grip과 native wheel, touch, keyboard scroll을 유지한다.
- focus-only outline, ring, border, shadow나 lift를 추가하지 않는다.
- Browse는 family당 초기 36개 asset만 렌더하고 다음 묶음을 점진적으로 추가한다. Registry 전체 결과 수는 header와 status에 별도로 유지한다.
