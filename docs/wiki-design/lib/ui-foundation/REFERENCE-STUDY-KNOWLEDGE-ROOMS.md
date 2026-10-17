---
schema_version: 1
reference_study: true
output_job: "browse a local knowledge collection, narrow it by type, and open one item without losing collection context"
surface: "responsive knowledge workspace"
evidence: ["Threads post @rnmp/Dc03s33iiqg reviewed 2026-09-04", "six temporary frames from the 17.1-second public video", "independent bilingual UI Lab transfer specimen"]
confidence: high
axes_covered: ["typography", "color", "spacing", "radius", "borders", "shadows", "layout", "hierarchy", "iconography", "imagery", "motion", "interaction"]
unresolved_axes: []
allowed_range: "Use one stable collection navigation, one opaque knowledge work plane, type filters, a responsive preview grid, selected-item reading, and one compact command strip."
counterexample: "Do not copy the source background, window chrome, emoji labels, card media, typography, exact glass treatment, or camera zoom reel."
transfer_specimen: "lib/ui-lab/src/knowledge-rooms-mockup.tsx"
---

# Knowledge Rooms Reference Study

## Source boundary

The public Threads share resolves to `@rnmp/Dc03s33iiqg`, titled "thinking was never this fun". Its 17.1-second video shows a desktop knowledge browser but provides no source repository, component API, accessibility evidence, or reuse license.

The video and temporary review frames are not Foundation assets. The implementation transfers only responsibilities and interaction order through independently written React, CSS, copy, icons, and specimen data.

## Observed structure

| Observed role | Foundation interpretation |
| --- | --- |
| Stable left list for broad views and rooms | `WorkbenchSidebar` with explicit collection navigation |
| One main reading or card area | Opaque `WorkbenchMain` work plane |
| Category controls above a card grid | Compact filter group with native button state |
| Preview cards with persistent labels | Layered Stacks preview, label, selection, and local-command responsibilities |
| Selected item opens in the same window | App-owned browser/detail state that preserves collection context |
| Small bottom action group | Compact command strip; glass is limited to the interaction boundary |
| Loading indicator during navigation | Real pending state with text, not decorative progress |

## Foundation mapping

- `WorkbenchShell` owns toolbar, sidebar, main, and status landmarks.
- Cloud Desk supplies the stable navigation and opaque work-plane composition.
- Layered Stacks supplies preview, persistent label, selection, and item-local command roles.
- `FrostedScrollArea` owns the sidebar and main vertical scroll regions.
- Micro UI informs the compact command role, but the source mockup is not imported as a product component.
- The knowledge data, filters, search, locale, offline status, and item state remain app-owned.

No new Foundation primitive is required. The transfer specimen belongs to UI Lab because the composition has not been validated in two products.

## Interaction contract

- Changing a space clears stale search, filter, selection, detail, and notice state before loading the next local collection.
- Search and type filters can produce an explicit empty state.
- One card may be selected, opened, and returned from without losing the current room.
- Offline mode keeps cached items readable. Refresh while offline reports a recoverable error instead of clearing content.
- Locale switching updates visible copy and accessible names in the same state.
- Desktop uses the stable sidebar. Narrow layout uses a labeled native space selector instead of hiding navigation.
- Keyboard activation changes state immediately. Focus does not add an outline, border, shadow, or lift.

## Material and layout

- The outer shell may use one contextual translucent surface because the surrounding scene explains depth.
- The card grid, reading surface, search, and repeated navigation rows remain opaque or near-opaque.
- Repeated item cards use 8px panel radius, stable aspect-ratio previews, and density-appropriate commands.
- Teal, indigo, and warm neutral tones distinguish content roles without turning the screen into a one-hue palette.
- No external image, source icon, font, logo, or copied card content is used.

## Motion

The source video uses camera zoom and blur as a presentation reel. Those effects are not product navigation. The specimen uses only a short real loading state after collection or refresh changes. Reduced motion removes residual animation and does not hide any state or content.

## Validation record

2026-09-04 explicit validation approval 이후 isolated specimen을 desktop/mobile에서 검증했다.

- collection change, filter, search empty state, selection, open, back, offline refresh error, and KO/EN switching;
- axe, runtime/resource errors, text fit, horizontal overflow, and fixed layout dimensions;
- focus computed styles and `FrostedScrollArea` wheel, keyboard, grip, and drag behavior.

UI Lab build, targeted and interrupted-tail Playwright regression, axe, focus, overflow, full-page visual baseline, reference-study/catalog parity, capture receipt hash가 통과했다. Generated UI Portal Registry의 `lab:knowledge-rooms`, `study:reference-study-knowledge-rooms`, `intake:threads-knowledge-browser`와 641개 preview 전수 검사를 확인했다.

## Sources

- [Threads reference post](https://www.threads.com/share/BAZp9BmHA6/)
- `lib/ui-foundation/REFERENCE-STUDY-QUIET-GLASS-WORKSPACE.md`
- `lib/ui-foundation/REFERENCE-STUDY-MICRO-UI.md`
