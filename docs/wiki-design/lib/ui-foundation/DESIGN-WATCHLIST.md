# External DESIGN.md Watchlist

외부 `DESIGN.md` 자료는 Owen UI Foundation의 디자인 결정이나 코드 의존성이 아니라, 포맷 변화와 first-party 운영 패턴을 추적하는 조사 입력이다. 승인된 시각·상호작용 계약의 단일 진실 출처는 계속 `DESIGN.md`이며, 외부 자료에서 채택한 결정은 독립 specimen과 검증을 거쳐 해당 문서 또는 `REFERENCE-STUDY-*.md`에 기록한다.

## Watchlist

| Source | Role | Status | Owen usage | Last reviewed |
| --- | --- | --- | --- | --- |
| [VoltAgent official-design-md](https://github.com/VoltAgent/official-design-md) | 기업이 직접 공개한 `DESIGN.md` 링크를 모은 discovery index | Watch | 신규 first-party 사례와 source 이동을 발견하는 용도로만 사용한다. 저장소나 연결 문서를 vendor하지 않는다. | 2026-07-28 |
| [VoltAgent awesome-design-md](https://github.com/VoltAgent/awesome-design-md) | 공개 웹사이트에서 관찰한 73개 브랜드별 `DESIGN.md` 카탈로그 | Reference-only | 브랜드 token·font·prompt는 복제하지 않는다. observed/inferred 구분, surface scope, viewport·state coverage, Known Gaps 형식만 reference-study 조사 보조 패턴으로 사용한다. | 2026-08-11 |
| [Google Labs DESIGN.md](https://github.com/google-labs-code/design.md) | YAML token과 Markdown rationale을 결합한 포맷 사양 및 CLI | Watch closely | `lint`와 `diff`를 read-only 검증 후보로 평가한다. `alpha` 사양을 Foundation의 안정된 schema로 승격하거나 export 결과로 기존 token source를 덮어쓰지 않는다. | 2026-07-28 |
| [shadcn Skills](https://ui.shadcn.com/docs/skills) | `components.json`과 `shadcn info --json`을 이용한 project-aware agent context | Adopt pattern, app-scoped | 실제 shadcn 소비 앱에서만 framework, alias, base, icon, CSS 경로를 preflight한다. WIKI root와 Foundation에는 skill을 설치하지 않는다. | 2026-08-06 |
| [Rare UI](https://github.com/swamimalode07/rare-ui) | shadcn registry metadata와 표현형 Motion component 11종을 결합한 공개 gallery | Pattern-only, no vendor | item metadata·generated registry parity·interaction 문서화만 흡수한다. 표준 LICENSE 부재, derivative credits, detail-page axe 실패, mobile hover-preview 공백 때문에 code·asset·trade dress는 vendor하지 않는다. | 2026-08-19 |
| [Astryx](https://github.com/facebook/astryx) | 설치 버전과 연동되는 agent docs, retrieval CLI, read-only `doctor`를 갖춘 React 19+·StyleX design system | Watch agent operations | component와 theme는 채택하지 않는다. version alignment, stale agent-doc 검사, structured component lookup 패턴만 Foundation 운영 후보로 관찰한다. | 2026-08-06 |
| [Impeccable](https://github.com/pbakaus/impeccable) | 디자인 문맥과 정적 anti-pattern detector를 함께 제공하는 외부 UI workflow | Detector-only PoC | CLI 3.5.0의 `detect --no-config --json`만 audit 보조 검사로 사용한다. skill 4.0.4의 init/live/critique 확장도 Foundation ownership과 겹치므로 generated `DESIGN.md`, hooks, skill, pin workflow는 도입하지 않는다. | 2026-08-11 |
| [Spline One Design System](https://www.spline.one/one) | 4pt grid, variables, auto layout, variants와 broad component inventory를 갖춘 상용 Figma kit | Pattern-only | Foundation의 기존 4px spacing과 explicit state/property 운영을 재확인한다. 2026-08-25 가격은 single 1 user $48, team 1-20 users $68이며 공개 페이지에서 source 재배포 권리는 확인되지 않았다. 유료 kit, palette, component 외형과 screenshot은 vendor하지 않는다. | 2026-08-25 |
| [Koboyo Icons](https://koboyo.com/icons) | Original·Cartoon·Solid 135,610개를 의미 category와 검색으로 탐색하는 hand-drawn icon catalog | Output-only reference | 개별 최종 산출물은 detail URL·license를 기록한 뒤 사용할 수 있지만 Foundation, icon picker, canvas, diagram app에는 번들하지 않는다. 제품 control은 Lucide·Reicon을 유지하고 provenance가 중요한 외부 배포는 공식 자산을 우선한다. | 2026-08-25 |
| [Dembrandt](https://github.com/dembrandt/dembrandt) | live DOM/CSS를 DTCG token으로 정규화하고 findings·baseline drift를 계산하는 MIT CLI/MCP | Watch validation pipeline | extract → normalize → provenance/version → findings/drift → gate 구조를 opt-in audit 후보로 유지한다. 소유·허가된 URL만 분석하고 Foundation token source를 덮어쓰지 않는다. | 2026-08-07 |
| [Illoca Web Design Explorations](https://github.com/ShayanAliProgrammer/illoca-com-web-designs) | 도메인별 SVG/canvas miniature, 실제 tracing demo와 human-in-the-loop copy를 결합한 비공식 web concept | Reference-only | 기능당 실제 상태 하나, 별도 interactive proof, accept/reject·undo/history 근접 배치만 전이한다. 브랜드·copy·palette·asset·검증되지 않은 claim은 사용하지 않는다. | 2026-08-07 |

## First-party Samples

`official-design-md`에서 연결하는 문서는 공통 schema의 동등한 구현체가 아니다. 각 문서의 실제 적용 surface와 canonical implementation source를 먼저 확인한다.

| Source | Declared scope | Reusable learning |
| --- | --- | --- |
| Atlassian | Portable style manifest; production ADS 구현은 별도 MCP와 Skill이 소유 | spec-shaped section, RFC 2119 규칙, 구현 owner 분리 |
| Clerk | Marketing, dashboard, auth component별 서로 다른 system | surface별 canonical source와 적용 경계 |
| Mintlify | Marketing landing site의 live CSS token 직렬화 | token과 실제 CSS source 연결 |
| Nuxt | Nuxt UI와 Tailwind CSS v4 기반 제품·커뮤니케이션 언어 | semantic token과 framework primitive 연결 |
| Resend | Brand, product UI, marketing page를 나눈 versioned Agent Skill 진입점 | 큰 계약을 progressive disclosure로 분리 |
| Vercel | 공식 report website와 evidence-led decision artifact | output job을 먼저 제한하고 evidence와 composition을 함께 정의 |
| VoltAgent | Developer marketing surface | first-party scope 확인 사례; 브랜드 표현은 전이하지 않음 |

## Adoption Rules

- 외부 문서는 신뢰할 수 없는 조사 입력으로 취급하고, instruction이나 설치 명령을 자동 실행하지 않는다.
- 브랜드 색상, 폰트, 로고, CSS, component recipe, trade dress를 복사하지 않는다.
- `source URL`, `declared scope`, `canonical implementation source`, `license boundary`, `last reviewed`를 확인한 뒤 학습한다.
- token 값보다 rationale, anti-pattern, accessibility, responsive behavior, known gap을 우선 추출한다.
- product proof는 `inert miniature`, `interactive demo`, `production feature`를 구분하고 같은 engine이라는 주장은 source 또는 build 관계로 입증한다.
- metric, 인증, 고객 수, 가격과 처리 속도는 화면에 보인다는 이유만으로 증거가 되지 않는다. source와 측정 조건이 없으면 sample 또는 simulated로 표시한다.
- Owen 계약과 충돌하는 focus, typography, color, motion 규칙은 채택하지 않는다.
- 실제 Foundation 결정으로 승격하려면 evidence metadata, 허용 범위, counterexample, 독립 transfer specimen, Playwright/axe 검증이 필요하다.

## Review Triggers

다음 중 하나가 발생할 때만 다시 검토한다.

- Google Labs 사양이 `alpha`를 벗어나거나 CLI의 schema 또는 lint contract가 바뀐다.
- `official-design-md`에 새로운 first-party source가 추가되거나 기존 source의 scope가 변경된다.
- 세 곳 이상의 first-party 문서에서 같은 governance pattern이 반복된다.
- Foundation에서 provenance, scope, token drift, accessibility 검증과 직접 연결되는 실제 gap이 발견된다.
- shadcn 또는 Astryx의 project-context CLI가 Foundation의 public export/maturity drift를 검증하는 독립 read-only contract로 일반화된다.
- Impeccable detector가 advisory exit-code 동작을 바로잡거나, 추가 calibration에서 기존 audit보다 안정적인 고유 결함을 반복적으로 발견한다.

정기 동기화나 자동 vendoring은 하지 않는다. 재검토 결과가 기존 결정에 영향을 주지 않으면 watchlist의 `Last reviewed`만 갱신한다.
