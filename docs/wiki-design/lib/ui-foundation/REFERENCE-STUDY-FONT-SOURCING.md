---
schema_version: 1
reference_study: true
output_job: "select and ship Latin and Korean typefaces with explicit language, license, pairing, and delivery evidence"
surface: "Owen product UI, documents, visual assets, and editorial or display typography"
evidence: ["Fontshare catalog, About page, and Satoshi ITF Free Font License reviewed 2026-08-28", "Noonnu home, Wanted Sans detail, and FAQ reviewed in a rendered browser 2026-08-28", "Google Fonts catalog, About, FAQ, Noto Sans Korean, API and self-hosting guidance, and google/fonts repository reviewed 2026-08-28", "Fontjoy interface, pairing explanation, and Jack000/fontjoy repository reviewed 2026-08-28", "Velvetyne catalog, About, FAQ, writing-system index, and Pilowlava page reviewed 2026-08-28"]
confidence: medium
axes_covered: ["typography", "hierarchy"]
unresolved_axes: ["color", "spacing", "radius", "borders", "shadows", "layout", "iconography", "imagery", "motion", "interaction"]
allowed_range: "Use these services as role-specific discovery and evaluation inputs. Promote a family only after its exact version, language coverage, original license, delivery method, fallback behavior, and rendered Korean and English specimens pass review."
counterexample: "Do not equate free with open source, treat a catalog summary or AI pairing as legal or readability approval, load an external font CDN by default, or move an experimental display face into operational body text."
transfer_specimen: "pending"
---

# Reference Study: Font Sourcing

## Scope

이 문서는 Fontshare, 눈누, Google Fonts, Fontjoy, Velvetyne을 하나의 폰트 저장소처럼 취급하지 않고 서로 다른 단계의 도구로 라우팅한다. 검토 대상은 글꼴 외형 자체보다 다음 네 가지다.

1. 어떤 역할과 언어의 후보를 발견하는가?
2. 실제 폰트 파일에 어떤 라이선스가 적용되는가?
3. CDN, 셀프호스팅, 앱 임베딩 중 무엇이 허용되고 재현 가능한가?
4. 추천 결과를 어떤 렌더링·가독성 검증으로 승인하는가?

검토 시점의 카탈로그 수와 정렬은 변할 수 있다. 수치는 source snapshot이지 Foundation token이나 영구 계약이 아니다.

## Source Roles

| Source | Best role | Verified strength | Boundary |
| --- | --- | --- | --- |
| Fontshare | 영문 브랜드, 에디토리얼, display와 Latin UI 후보 | Indian Type Foundry가 운영하며 검토 시점에 100개 family를 제공한다. 자체 제작 family와 선별·보정한 타 foundry의 open-source family가 함께 있다. | 모든 family가 open source인 것은 아니다. Satoshi는 `Closed Source / ITF Free Font License`이며 135개 언어를 지원하지만 한글은 포함하지 않는다. family별 language와 license를 다시 확인한다. |
| 눈누 | 상업 이용 가능한 한글 폰트 탐색과 용도별 1차 필터 | 인쇄, 웹사이트, 포장, 영상, 임베딩, BI/CI, OFL 범위를 한 화면에서 비교하고 실제 제작자 다운로드 페이지와 웹폰트 예시를 연결한다. | 눈누는 모든 저작권이 각 제작자에게 있으며 요약은 참고용이라고 명시한다. 조건부 허용, 임베딩, BI/CI, 수정·재배포는 제작자 원문을 최종 근거로 사용한다. |
| Google Fonts | 다국어 제품 폰트, 한글 기준선, 공개 웹 배포 | 검토 시점에 1,946개 family를 제공한다. 전체 카탈로그는 open source이며 Noto는 1,000개 이상 언어와 150개 이상 writing system을 포괄한다. Noto Sans Korean은 Hangul과 Hanja, Latin, Cyrillic, Greek 등을 지원한다. | family마다 OFL, Apache 2.0, Ubuntu Font License 등이 다르며 Reserved Font Name 조건도 있을 수 있다. API와 셀프호스팅은 privacy, update, browser optimization 책임이 다르다. |
| Fontjoy | 제목·부제·본문 조합의 발산적 shortlist | Google webfonts의 1,883개 font variant 이미지에서 추출한 vector로 일부 특징은 공유하고 일부는 대비되는 후보를 만든다. font lock과 수동 교체로 탐색 범위를 좁힐 수 있다. | 조합의 품질을 보증하지 않는다. 공개 vector 저장소의 최신 commit은 검토 시점 기준 약 9년 전이고 release가 없으며, 한글 형태·fallback·본문 가독성 검증 근거도 없다. |
| Velvetyne | 포스터, 표지, 문화·예술 프로젝트의 실험적 display 후보 | hosted font는 libre/open source이며 개인·상업 작업에서 사용, 수정, 재배포, 수정본 재배포를 허용한다. source files와 개별 writing system, license를 함께 보여준다. | 카탈로그가 의도적으로 atypical, pattern, 심지어 illegible face도 수용한다. writing-system index에 Hangul은 없으며, designer와 foundry credit 및 수정본의 동일 license 배포 조건을 지킨다. |

## License And Provenance Gate

`무료`, `상업 이용 가능`, `오픈소스`는 같은 상태가 아니다. 후보 family를 제품이나 산출물에 넣기 전에 다음 ledger를 남긴다.

| Field | Required record |
| --- | --- |
| Identity | family, styles or variable axes, version, source URL, downloaded date, file hash |
| Authorship | designer, foundry or copyright holder |
| License | exact license name, bundled license file or canonical URL, Reserved Font Name 여부 |
| Allowed surfaces | print, web, app, document/PDF, video, logo/BI/CI, editable template or user-generated content |
| Font operations | self-hosting, embedding, subsetting, format conversion, modification, redistribution |
| Third parties | contractor, printer, customer, SaaS end user에게 파일을 제공할 수 있는지 |
| Obligations | attribution, license notice, renamed derivative, share-alike or same-license 조건 |
| Lifecycle | API availability reliance, manual update owner, source version pin, replacement and rollback path |

Fontshare의 ITF Free Font License family는 개인·상업 작업, 로고, 웹, 앱과 문서 임베딩에 무료로 사용할 수 있고 원본 파일의 셀프호스팅도 허용한다. 그러나 glyph 수정, subsetting, format conversion, 파일 재배포, 외부 계약자에게 파일 전달, 제3자가 선택해 쓰는 SaaS font service는 금지된다. 외부 작업자는 Fontshare에서 자기 사본을 직접 받아야 한다.

Google Fonts는 모두 상업적으로 사용할 수 있고 license 조건에 따라 재배포할 수 있지만, 각 family directory의 license가 최종 근거다. OFL family를 수정할 때도 Reserved Font Name과 license notice를 확인한다.

눈누의 표와 OFL 설명은 탐색을 돕는 요약이다. 다운로드 링크의 제작자 페이지와 실제 배포 파일에 포함된 license가 다르거나 더 구체적이면 원문을 따른다.

Velvetyne는 제품 표면에 credit을 직접 넣기 어려운 경우에도 제품 페이지, 온라인 게시물 또는 portfolio에 font, author, foundry를 밝히도록 안내한다. Owen은 이 credit을 provenance ledger와 배포 문서에 보존한다.

## Pairing Gate

운영 UI는 같은 family의 weight, width, size hierarchy로 먼저 해결한다. 서로 다른 family의 조합은 정보 역할이 실제로 분리되는 editorial, landing hero, cover, poster에만 사용한다.

1. body family와 locale coverage를 먼저 고정한다.
2. display 후보는 body와 한두 축에서만 명확히 대비시키고 x-height, stroke contrast, width, weight, optical size를 함께 본다.
3. Fontjoy 결과는 shortlist에만 추가한다. 추천 순위나 neural vector distance를 품질 점수로 저장하지 않는다.
4. 한글 display와 Latin display를 섞을 때는 같은 문장에서 fallback이 바뀌지 않게 script별 family 책임을 명시한다.
5. 일반 화면은 본문·제목 family 두 개 이하를 기본으로 하고, code 또는 telemetry mono는 의미상 필요할 때만 별도 역할로 둔다.

Fontjoy가 설명하는 유효한 원칙은 `공통된 성격 + 특정 축의 대비`다. 너무 비슷한 두 글꼴은 우연한 불일치처럼 보이고, 관계가 전혀 없는 두 글꼴은 무작위처럼 보일 수 있다. 다만 어떤 대비 축이 적합한지는 알고리즘이 보증하지 않으므로 실제 문구와 크기에서 사람이 판단한다.

## Language And Readability Gate

카탈로그의 language badge만으로 승인하지 않는다. 한국어와 영어를 모두 제공하는 Owen UI는 최소 다음 specimen을 실제 target renderer에서 확인한다.

- 한글 완성형, 자모, Hanja가 필요한 범위와 Latin, 숫자, 통화, 날짜, 괄호, slash, ellipsis
- regular, medium, bold의 실제 weight 구분과 synthetic bold/italic 발생 여부
- 12–16px body, compact label, 긴 한국어 설정 설명, 긴 영어 compound word
- tabular numeral, punctuation baseline, mixed-script line height와 fallback 전환
- desktop와 narrow mobile, 200% zoom, dark/light surface, Windows와 macOS fallback
- long-form body의 지속 가독성, display face의 짧은 제목 한계, PDF 또는 image export의 glyph 보존

Velvetyne처럼 실험성과 불완전성을 가치로 삼는 catalog는 짧은 display 역할에서만 검토한다. `illegible` 또는 incomplete character set을 의도한 face는 body, setting, table, form, security status에 사용하지 않는다.

## Delivery Gate

- 제품 acceptance build는 license가 허용할 때 version-pinned WOFF2 셀프호스팅을 우선 검토한다. font file, license, source URL, version과 hash를 함께 보존한다.
- 외부 CDN은 prototype이나 명시적으로 승인된 public web surface에만 사용한다. privacy, offline, availability, CSP와 vendor change를 검토하고 system fallback을 유지한다.
- Google Fonts API는 cookie를 설정하지 않지만 visitor IP, 요청 URL, user agent, referer가 Google server로 전달된다. 셀프호스팅은 이 전송을 없애는 대신 전체 파일 크기, browser별 최적화, 업데이트 책임을 제품이 맡는다.
- Fontshare API는 선택 사항이며 availability가 보장되지 않는다. ITF는 license가 허용하는 own-site self-hosting을 control, reliability, performance 측면에서 권장한다.
- 필요한 family와 weight만 요청한다. preload는 첫 화면의 실제 critical face에만 쓰고 `font-display`와 fallback을 명시한다.
- license가 subsetting 또는 format conversion을 막으면 성능 최적화를 이유로 파일을 변형하지 않는다. 다른 family를 선택하거나 원본 배포 형식을 그대로 사용한다.

## Owen Decisions

- Foundation의 기본 운영 UI stack인 Aptos, Pretendard Variable, Segoe UI Variable은 유지한다. 이번 검토만으로 font token이나 bundled asset을 바꾸지 않는다.
- 한국어 제품 UI 후보는 Google Fonts의 Korean filter와 눈누에서 발견하되, 제작자 원문 license와 실제 한영 specimen을 통과해야 한다.
- Fontshare는 주로 Latin branding, editorial, display 후보로 사용한다. family별 language coverage와 closed/open license를 구분한다.
- Fontjoy는 pairing brainstorm 도구일 뿐 acceptance oracle이 아니다. 결과를 그대로 디자인 토큰이나 제품 기본 조합으로 승격하지 않는다.
- Velvetyne는 명시적인 experimental/editorial output job에만 사용하고 operational body에는 사용하지 않는다. credit과 동일 license 의무를 배포 기록에 남긴다.
- 어떤 source도 `무료`라는 이유만으로 자동 다운로드, vendoring, CDN 연결 또는 Foundation 등록을 허용하지 않는다.

## Do Not Adopt

- Fontshare의 고유 family, Fontjoy 조합 또는 Velvetyne의 실험적 외형을 Owen 기본 시각 언어로 복제
- 눈누의 사용 가능 표만 보고 계약자 전달, 앱 임베딩, BI/CI 또는 수정 권한을 확정
- Google Fonts catalog 전체가 하나의 동일 license라는 가정
- Fontjoy의 오래된 Latin 중심 vector를 한글 pairing 근거로 사용
- source, version, license file과 hash가 없는 font binary vendoring
- privacy와 장애 fallback 검토 없는 third-party font request
- 작은 본문을 display face로 강제하거나 fallback 차이를 letter spacing 조정으로 숨기는 처리

## Review Triggers

- 후보 family를 Foundation token 또는 두 개 이상의 제품에 공통 번들하려는 경우
- font license, CDN/API 약관, source version 또는 writing-system coverage가 변경된 경우
- 한국어와 영어의 fallback, line-height, export 결과가 달라지는 경우
- Fontjoy가 최신 dataset, Korean glyph representation, reproducible model version과 validation evidence를 공개하는 경우
- Foundation에 font manifest, license ledger 또는 automated glyph-coverage check를 추가할 실제 반복 수요가 생긴 경우
