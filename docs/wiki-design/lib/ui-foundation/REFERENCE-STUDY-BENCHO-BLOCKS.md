# Bencho 블록과 모션 참고

검토일: 2026-09-15. 대상: [Bencho](https://bencho.dev/)의 공개 블록 29개. 소유 구현: [원본 컬렉션](D:/GITHUB/wiki/lib/bencho-original/README.md). 구현·제시 후 검증이 승인됐으며, 발견 사항과 원본 비교 제한 때문에 Registry 승격은 보류한다.

## 사용자 지정 선호

사용자는 29개 전체의 UI·모션을 디테일하게 구현하고 이후 설계에서 선호도를 높이라고 요청했다. Clear·shadcn과 함께 작업에 맞는 Bencho를 높은 우선순위로 검토한다. 기존 제품 API, Clear 우선 검토, 명령 메뉴의 shadcn 우선 선택을 대체하지 않는다. 원본 컬렉션은 원본 스타일을 격리 보존하며 제품 적용은 별도 판단이다.

구현 화면 확인 후 사용자 재확인: “이번 Bencho 모션이 가미한 메뉴나 UI 구성요소가 마음에 들어. 구현시 우선 선호로 참고해주고 커밋/푸시해줘.” 메뉴·문맥 도구·인터랙티브 구성요소를 설계할 때 Bencho의 상태 전환과 모션 디테일을 우선 참고한다. 해당 선호는 제작·검증·권리 경계를 생략하라는 의미가 아니다.

`query-assets.mjs brief/context`의 `designPriorities`는 일치하는 Bencho 후보를 최대 3개 제시한다. `priority: 1`은 선호이지 품질 등급이 아니다. `pendingRegistration`과 `comparison-pending`은 유지한다. 선택한 블록의 스크린샷뿐 아니라 Live, 조절값과 실행 진입점도 열어 확인한다.

## MDBOX 하단 에디터

사용자 지정: “이런 메뉴구성이 우리 MDBOX 하단 에디터 디자인 갱신에도 도움이 될거같아. 기록해줘.” 사용자가 제공한 화면은 Canvas toolbar의 도형 하위 메뉴가 열린 상태다. 현재 요청은 참고 기록이며 MDBOX 구현 변경 승인은 아니다.

- 아래쪽에는 이동·손·프레임·도형·펜·텍스트라는 안정적인 주 도구 순서를 유지한다.
- 도형 그룹 바로 위에 사각형·원·선·별의 작은 관련 메뉴가 펼쳐진다. 다른 작업과 무관한 메뉴를 함께 늘리지 않는다.
- 선택한 도형을 주 도구막대에 기억한다. 다른 도구를 사용한 후에도 최근 도형을 다시 찾을 수 있다.
- 하위 메뉴의 열림과 주 도구 선택은 별도 상태다. 선택 배경, 현재 아이콘과 작은 펼침 표시의 역할을 구분한다.
- 구분선과 간격으로 도형 그룹과 펜·텍스트 그룹을 나누며, 상하 메뉴의 기준점·간격·아이콘 크기를 일관되게 유지한다.
- 원본의 초기 상태·열림·선택·복귀·닫힘 모션을 관찰한다. 소스 효과를 무조건 전체 에디터 표면에 복제하지 않는다.

MDBOX 적용 시 추가로 확인할 항목: 에디터 선택 영역 보존, 툴 전환과 문서 명령 분리, Escape·바깥 클릭·초점 복귀, 키보드·터치 입력, safe-area·가상 키보드·모바일 가로폭, 비활성·되돌리기·파괴적 명령, reduced-motion. 이 조건들은 향후 구현 기준이며 원본이 모두 충족한다고 주장하지 않는다.

참고 화면: [좁은 화면의 열린 도형 메뉴](D:/GITHUB/wiki/dev/ui-portal-intakes/bencho-blocks/implementation/previews/toolbar-narrow.png), [Portal 내장 Live](D:/GITHUB/wiki/dev/ui-portal-intakes/bencho-blocks/implementation/portal-live.png). 원 도형 선택 후 손 도구로 이동해도 원 도형 버튼이 유지되는 것을 로컬 실행에서 확인했다.

## 활용 구분

| 용도 | 우선 살펴볼 원본 | 가져올 판단 기준 |
| --- | --- | --- |
| 문맥 도구·입력 | Canvas toolbar, Icon bar, Magnifying dock, Command bar, Search | 주 명령과 관련 선택지 분리, 안정적인 크기, 선택 유지 |
| 결정·상태 전환 | Slide to confirm, Inline confirm, Notify, Liquid toggle, Create menu | 대기·진행·취소·완료를 구분하는 상태 전환 |
| 목록·선택 | Magnetic select, Assignees, Checklist, Reorder list, Selection list | 선택 집합, 행 간격, 드래그와 클릭의 구분 |
| 연속 값·범위 | Drag stepper, Progress ticks, Wheel, Range dial, Slosh slider | 클릭·드래그의 세밀도, 경계와 값 피드백 |
| 콘텐츠·공간 | Carousel, Palette, Aspect ratio, Tilt card, Now playing, Pull to refresh | 내용과 조절 모션의 관계, 과도한 움직임 억제 |
| 실험적 모션 | Escape button, Dragging ball, Radial menu | 제한된 탐색·데모 맥락; 필수 명령의 기본값으로 사용하지 않음 |

## 구현과 증거

- 29개 개별 `bencho:<id>` 카드, 원본 이름과 한국어 명칭, 전용 URL·소스 진입점·실제 스크린샷을 연결했다. 원본 81개 숫자·선택 파라미터와 테마, 지원하는 fill/stroke, 초기화, 선택적 합성 음향을 제공한다.
- 코드와 모션 의존성은 공개 배포 JavaScript에서 AST로 추출했다. 원본 사진 19회 사용은 제외하고 로컬 제작 PNG 6종으로 대체했다. 대체 대상은 컬렉션 메타데이터에 표시한다. 원본 사이트·계정·분석 연동은 포함하지 않았다.
- 원본은 배포 SHA-256으로 식별하며 공개 저장소·커밋은 확인되지 않았다. React/ReactDOM은 Lab의 19.2.7로 연결했다. 원본 배포 ReactDOM 19.2.8과 버전 일치를 주장하지 않는다.
- 기본 29개 화면, 주요 6개 390px 화면의 최소 로드·리소스·가로 넘침을 확인했다. Portal의 Live/소스/스크린샷, 닫기 후 프레임 해제와 선택 복원도 확인했다. [캡처 기록](D:/GITHUB/wiki/dev/ui-portal-intakes/bencho-blocks/implementation/capture-receipt.json), [Portal 제시 기록](D:/GITHUB/wiki/dev/ui-portal-intakes/bencho-blocks/implementation/portal-presentation.json).
- 격리 프리뷰는 숨겨질 때 블록을 해제하고 복귀 시 초기 상태로 재마운트한다. 폭이 큰 블록은 좁은 프리뷰에서 균등 축소한다. 원본의 반응형·백그라운드 상태 보존과 같은 동작으로 간주하지 않는다.

## 검증과 승격 경계

MIT 허용 범위는 블록 코드다. 사이트 셸·브랜드·사진·Maison Neue는 제외되며 제삼자 고지는 원본 컬렉션에 보존한다. 현재 대체 이미지와 폰트 revision 차이는 명시적 비동일성이다.

검증 승인 후 타입 검사·프로덕션 빌드, 선호 라우팅 회귀, 29개 블록의 4개 표시 조건, 원본 29개 기본 상태의 선택된 형상·의미 속성을 검사했다. 결과와 실제 제한은 [검증 기록](D:/GITHUB/wiki/dev/ui-portal-intakes/bencho-blocks/VALIDATION.md)에 기록한다. 원본의 대비·이름 문제는 스타일을 임의 변경해 숨기지 않는다.

모든 변형·키보드·드래그·취소·실패의 완전한 조합, 실제 모바일 기기·Safari/Firefox, 전체 모션 시각·성능 승인과 사진까지 동일한 재현은 아직 입증되지 않았다. 선호도나 정적 코드 추출만으로 Registry를 승격하지 않는다.
