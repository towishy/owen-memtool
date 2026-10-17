# UI Foundation Consumers

Owen UI Foundation은 공용 React package만을 뜻하지 않는다. `DESIGN.md`, semantic token, component anatomy, reference composition, accessibility·responsive 계약을 실제 제품이 소비하고, 제품에서 검증된 패턴을 다시 Foundation과 UI Lab으로 일반화하는 양방향 체계다.

## 실제 제품 적용 현황

| 제품 | 로컬 소스 | 소비 형태 | 확인된 Foundation 계약 | 검증 근거 |
| --- | --- | --- | --- | --- |
| `sarang.day` | `D:\Github\Sarang.day\web` | 디자인 계약 + 앱 전용 정적 구현 | Foundation-first AGENTS 라우팅, `SettingsPanel`, `FrostedScrollArea`, 6px/8px geometry, dark·forced-colors 경계 | `AGENTS.md`, `index.html`, `dashboard-features.css/js`, `tests/smoke.test.js` |
| `day.sarang.day` | `D:\Github\Sarang.day\day` | 디자인 계약 + 앱 전용 정적 구현 | `FrostedScrollArea` viewport·rail·configurable compact grip, keyboard semantics, responsive placement | `public/app.css`, `public/index.html` |
| `mdbox.sarang.day` | `D:\Github\Sarang.day\mdbox` | 제품·브랜드 surface에 시각 계약 적용 | Pretendard/Segoe fallback, 6px control·8px panel geometry, settings surface, reduced-motion handling | `public/index.html`과 배포 asset |
| Owen MDBOX | `D:\Github\owen-mdbox` | 디자인 계약 + 앱 전용 구현 + Foundation 원천 패턴 | Foundation-first AGENTS 라우팅, Cloud Desk/Workbench 방향, hierarchical flying panels, desktop/mobile interaction 계약 | `AGENTS.md`, `desktop/wiki-public/`, `desktop/tests/e2e/app.spec.ts` |

## 직접 React package 검증 소비자

| 소비자 | 역할 | 직접 import | 브라우저 근거 |
| --- | --- | --- | --- |
| UI Lab | canonical specimen과 component 회귀 | 전체 public API 대표군 | desktop/mobile, axe, keyboard, visual golden |
| `lib/ui-foundation-consumer` | 제품형 settings integration app | `WorkbenchShell`, `SettingsPanel`, `FrostedScrollArea`, controls, status | 한국어·영어 장문, desktop/mobile, dark, reduced motion, forced colors, axe |

## 소비 형태 해석

- 네 제품은 Foundation의 시각·상호작용 계약을 실제 운영 화면에서 사용한다.
- Sarang.day 계열은 정적 HTML/CSS/JavaScript 구조에 Foundation anatomy와 token을 전이하므로 React package import가 필수 조건이 아니다.
- Owen MDBOX의 `desktop/package-lock.json`에는 `@owen-wiki/ui-foundation`이 `extraneous: true`로 남아 있다. 이를 현재 package dependency 증거로 계산하지 않는다.
- UI Lab은 canonical browser consumer이고 `lib/ui-foundation-consumer`는 독립 제품형 integration consumer다.
- 제품 적용 수와 개별 component maturity는 구분한다. 예를 들어 hierarchical flying panels는 Owen MDBOX 한 제품에서만 운영 검증됐으므로 여전히 reference composition이다.

## 성숙도 판단

| 축 | 현재 상태 |
| --- | --- |
| 디자인 계약의 실제 제품 채택 | 4개 제품에서 확인 |
| 제품 → Foundation 패턴 환류 | Sarang.day settings/scrollbar, MDBOX flying panels에서 확인 |
| 공용 React package 직접 import | UI Lab + 독립 integration app에서 검증; 두 실제 제품의 동일 API 직접 소비 증거는 아직 부족 |
| 화면별 `DESIGN.md` 의사결정 기록 | 네 제품 모두 전용 파일 없음; AGENTS와 구현·테스트에 분산 |

Foundation 전체는 운영 디자인 시스템으로 평가한다. 다만 public React API의 호환성, 개별 experimental composition의 maturity, 화면별 디자인 의사결정 기록은 각각 별도 gate로 유지한다.

화면별 결정 기록은 [`templates/screen-design.md`](../../templates/screen-design.md)를 사용한다. 완성 예시는 [`Sarang.day Family Dashboard DESIGN.md`](../../docs/UI-Design/samples/sarang-day-dashboard/DESIGN.md)다.
