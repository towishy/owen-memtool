---
schema_version: 1
reference_study: true
output_job: "help a user name and describe a UI layout precisely before implementation"
surface: "searchable UI vocabulary catalog with local favorites and copy-ready Owen descriptions"
evidence: ["vibeprompts.dev home, 15 category pages, representative detail page, robots.txt, and sitemap reviewed 2026-08-20", "all 251 public card titles, summaries, categories, canonical links, and attributed preview thumbnails indexed 2026-08-20", "desktop catalog and representative detail page rendered in the VS Code internal browser", "independent transfer catalog in docs/ui-foundation/index.html"]
confidence: high
axes_covered: ["typography", "color", "spacing", "radius", "borders", "shadows", "layout", "hierarchy", "iconography", "imagery", "motion", "interaction"]
unresolved_axes: []
allowed_range: "Index public titles, short summaries, categories, canonical links, and attributed preview thumbnails for private reference; generate independent Owen-oriented descriptions; store favorites locally; use the source as vocabulary discovery rather than implementation authority."
counterexample: "Do not copy prompt bodies, Tailwind source, visual trade dress, focus-ring instructions, or ready-to-ship claims into Foundation or consumer products. Do not republish the preview thumbnails independently."
transfer_specimen: "docs/ui-foundation/index.html"
---

# Reference Study: VibePrompt UI Vocabulary

## Scope

[VibePrompt](https://vibeprompts.dev/)는 15개 category에 251개 UI layout idea를 분류한 searchable prompt library다. Auth, pricing, feature, hero, CTA, stats, navigation, testimonial, footer, FAQ, dashboard, onboarding, blog, contact와 bonus pattern을 다룬다.

Owen이 흡수하는 것은 prompt 원문이나 화면 외형이 아니라 다음 vocabulary workflow다.

1. 사용자가 모르는 layout 이름을 검색한다.
2. 한 줄 intent로 후보를 빠르게 비교한다.
3. category로 범위를 줄인다.
4. 자주 쓰는 후보를 local favorite로 보존한다.
5. 선택한 idea를 Foundation 계약이 포함된 독립 UI 설명으로 변환한다.

## Rights Boundary

2026-08-20 검토 시 site footer, metadata, robots와 sitemap에서 표준 software/content reuse license나 source repository 링크를 확인하지 못했다. 공개 접근 가능성과 복제·재배포 허용은 같은 뜻이 아니다.

따라서 로컬 catalog에는 다음 참조 자료만 저장한다.

- category와 공개 card title
- card에 표시된 짧은 summary
- canonical detail URL
- 출처 URL을 함께 보존한 로컬 preview thumbnail
- 수집 일시와 provenance boundary

Prompt body와 Tailwind code는 저장하지 않는다. Preview thumbnail은 private reference catalog 안에서만 사용하며 이미지 클릭 시 canonical detail page를 연다. Copy command가 만드는 한국어 설명은 공개 prompt를 복사한 것이 아니라 title과 summary를 입력으로 Owen 요구사항을 새로 구성한 template이다.

## Source Review

### Strong patterns

- 251개 전체 수와 category count를 navigation 가까이에 둔다.
- 검색이 title과 description을 함께 찾는다.
- card마다 category, name, one-line distinction, preview와 detail path를 제공한다.
- detail page는 Live, Tablet, Mobile preview responsibility를 구분한다.
- auth와 dashboard에 OTP, SSO, incident board, data table, loading/empty처럼 실제 workflow 이름이 풍부하다.

### Limits

- “ready-to-ship Tailwind markup”은 제품의 semantics, state, i18n, data truth와 Foundation 계약을 보증하지 않는다.
- 대표 prompt가 clear focus ring을 요구해 Owen의 no-focus-visual 계약과 충돌한다.
- marketing section category 비중이 높아 operational product UI의 기본 우선순위로 사용할 수 없다.
- source preview의 monochrome editorial skin은 vocabulary와 무관하며 Owen에 전이하지 않는다.
- 같은 layout name도 target user와 output job이 없으면 generic shell에 그칠 수 있다.

## Transfer Catalog

`docs/ui-foundation/index.html`의 `UI 설명 프롬프트` tab이 독립 transfer specimen이다.

| Capability | Contract |
| --- | --- |
| Search | title, summary, English category와 Korean category alias를 함께 검색 |
| Category | 원본 15개 category와 전체·즐겨찾기 view 제공 |
| Favorite | browser `localStorage`에 item ID만 저장 |
| Detail | pattern intent, source metadata, rights boundary 표시 |
| Preview | local thumbnail을 표시하고 클릭하면 canonical detail page를 새 tab으로 열기 |
| Copy | user, task, data, state, action, responsive, a11y, Foundation owner를 묻는 독립 description 생성 |
| Source | 원본 detail page를 새 tab으로 열어 attribution과 최신 내용을 유지 |
| Scroll | document-level FrostedScrollArea anatomy 유지 |

`scripts/sync-vibe-prompts-catalog.mjs`는 headless browser로 public card DOM을 구조적으로 읽는다. 정확히 251개 고유 canonical URL이 아니면 실패하며, preview thumbnail을 `docs/ui-foundation/vibe-prompts-previews/`에 저장한다. Generated data는 로컬 경로와 원본 이미지 URL을 모두 보존하고 prompt body는 포함하지 않는다.

## Use In UI Requests

1. Catalog에서 output job에 가까운 pattern을 검색한다.
2. Favorite로 shortlist를 만든다.
3. `설명 초안 복사`를 눌러 target user, primary task, data와 state placeholder를 채운다.
4. Foundation tab에서 실제 primitive/composition을 선택한다.
5. 외부 prompt의 radius, focus, card, motion, color 지시는 버리고 `DESIGN.md`를 적용한다.
6. 실제 consumer app에서 desktop/mobile, Korean/English, focus, scroll, axe와 screenshot을 검증한다.

## Sources

- [VibePrompt library](https://vibeprompts.dev/)
- [Dashboard prompts](https://vibeprompts.dev/dashboards/)
- [Representative auth prompt](https://vibeprompts.dev/auth/auth-split-screen-with-visual/)
- [Sitemap](https://vibeprompts.dev/sitemap.xml)
