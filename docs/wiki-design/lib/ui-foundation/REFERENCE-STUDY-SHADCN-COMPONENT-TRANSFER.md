---
schema_version: 1
reference_study: true
output_job: "select an existing Owen owner from a source-grounded review of the shadcn component catalog"
surface: "bilingual component review workbench and five independent Lab composition groups"
evidence: ["shadcn/ui revision 4dbe072997507545dbf648ab45662d9c1e5b5b56", "65 topic decisions from 64 live Base catalog entries plus Sonner", "192 MDX documents and 182 corresponding TSX import inventories", "seven local presentation captures on 2026-09-06; not acceptance evidence"]
confidence: medium
axes_covered: ["typography", "color", "spacing", "radius", "borders", "layout", "hierarchy", "iconography", "interaction"]
unresolved_axes: ["shadows", "imagery", "motion"]
allowed_range: "Transfer anatomy, state boundaries and verified engine identity through existing Foundation APIs. Keep missing APIs in an app-owned Lab until repeated real consumers and validation justify promotion."
counterexample: "Do not install every catalog component, replace Owen tokens, infer accessibility from a headless dependency, or present a family example as 65 individually implemented components."
transfer_specimen: "lib/ui-lab/src/shadcn-study-workbench.tsx"
---

# Reference Study: shadcn Component Transfer

## Decision

Adapt the component decision process, not the visual skin or entire registry.
The knowledge layer covers 65 topics. The implementation contains five related example groups, not 65 new public APIs.
Implementation was explicitly approved on 2026-09-06. Full validation and Portal registration remain pending.

## Evidence Scope

The pinned official repository and a selective live browser review provide source identity, document anatomy and import evidence.
The [review](D:/GITHUB/wiki/dev/ui-portal-intakes/shadcn-ui-full-review/REVIEW.md), [component matrix](D:/GITHUB/wiki/dev/ui-portal-intakes/shadcn-ui-full-review/COMPONENT-MATRIX.md) and [source inventory](D:/GITHUB/wiki/dev/ui-portal-intakes/shadcn-ui-full-review/source-inventory.json) retain the detailed decisions and source hashes.

- The live Base catalog contained 64 topics; Sonner adds the 65th review topic.
- The inventory covers 192 MDX files, 182 corresponding TSX files and 13 supplemental documents.
- These counts measure static coverage, not tested components or all runtime variants.
- Selective browser observations cover Field, Combobox, Questionnaire and Message Scroller. They do not establish accessible names, contrast or full keyboard behavior.
- Import declarations identify dependencies, not the behavior or quality of their implementations.

Important engine distinctions must survive reuse: the reviewed Radix Combobox uses Base UI; Drawer differs between Base UI and Vaul; Toast deprecation differs by base. Data Table documentation uses TanStack Table v9. Message Scroller and Questionnaire import an unreviewed `@shadcn/react` core. Do not infer a uniform engine from the selected documentation base.

## Transfer Contract

| Concern | Adopt or adapt | Do not inherit |
| --- | --- | --- |
| Anatomy | label, control, description, error and group relationships | placeholder-only naming |
| Semantics | command, navigation, selection, confirmation and async states | clickable containers that hide native meaning |
| Data | separate configuration, state, rendering and equivalent values | replacing a simple table just to match an engine |
| Ownership | use the existing Foundation owner first | app-local clones of common primitives |
| Style | Owen fonts, semantic colors, 6px controls and 8px panels | global rings, negative spacing and wholesale source skin |
| Scrolling | Foundation scroll ownership and reader intent | duplicate ratio scrollbars and forced bottom jumps |
| Persistence | explicit session-only examples | global shortcuts, cookies and unannounced network transfer |

## Implemented Specimen

The standalone [entry](D:/GITHUB/wiki/lib/ui-lab/shadcn-review.html) opens at [the local Lab URL](http://127.0.0.1:4173/shadcn-review.html?lang=ko&component=field).
It has a searchable 65-entry directory, family and decision filters, a related-example view, a transfer record, and an inspector with pinned source links and actual imports.
Language and selected component are stored in the URL; example data exists only in the current tab.

| Example group | Existing owner and bounded implementation |
| --- | --- |
| Input and selection | FormField, SelectControl, native radios, Base UI multi-combobox, local save/reset |
| Commands and navigation | Base UI Menu and Tooltip, local filtering/pinning/sorting, ResponsiveOverlay |
| Confirmation and state | AsyncState, cancelable local response simulation, ConfirmableAction clearing sample state only |
| Data and content | OperationalDataTable selection/filter/sort, Recharts with equivalent visible values |
| Conversation and questions | FrostedScrollArea transcript, local file metadata, native two-step questions with back/save/restart |

Base UI `1.6.0` is an explicit Lab dependency matching the existing Foundation version, not a new headless engine.
Menu, Combobox, Tabs and Tooltip remain app-owned compositions. No corresponding public Foundation API was invented.
The Lab build configuration records both the normal entry and the standalone study entry; production build has not run.

### Small Foundation Extensions

Three optional label inputs were added in their owning modules with existing English defaults retained:

- `ResponsiveOverlay.closeLabel` localizes the dismiss command.
- `OperationalDataTable.labels` localizes the region, loading and selection names.
- `ConfirmableAction.pendingLabel` localizes the in-progress confirmation label.

These are backward-compatible intent, not a claim of regression acceptance. Their existing tests and new locale cases belong to the next validation gate.

### Responsive And Language Boundaries

The desktop layout separates directory, main work area and source inspector. Below 920px the inspector moves below the work area; below 620px the layout becomes one column with a bounded directory.
Document and owned list/panel scrolling reuse FrostedScrollArea. Native horizontal scrolling remains appropriate for the data table.
KO/EN controls and transfer summaries share the same state and geometry. Technical API names, dependency identifiers and synthetic filenames remain unchanged across locales.
English owner summaries are condensed API guidance rather than a literal translation of every Korean matrix note.

## Held And Omitted Work

Calendar/time-zone policy, natural-language dates, OTP, carousel, resizing engines and a new toast provider remain on hold.
The transcript is not an implementation of upstream Message Scroller. The questionnaire is a bounded native two-step example, not the upstream Questionnaire engine.
Selected files are retained as local metadata only; contents are not read, uploaded or bound to individual messages. There is no AI service, durable storage or real network response.

The catalog is reviewed at the topic level. Choosing Slider or Calendar may show the related input family example; it does not mean that specific engine was implemented. The transfer record retains the topic-specific owner and limits.

## Presentation And Pending Gates

The [presentation receipt](D:/GITHUB/wiki/dev/ui-portal-intakes/shadcn-ui-full-review/implementation/presentation-receipt.json) binds seven local PNG captures to source hashes, locale, viewport, DPR and browser version.
It records five Korean desktop views at 1440x1000 and two English mobile views at 390x844, with reduced motion and no page exceptions.
The screenshots are viewport captures, not proof that all off-screen states or interactions are correct. A chart extending below the viewport remains scrollable content, not a complete chart capture.

Before publication, obtain explicit validation approval after the live presentation, then run each relevant suite once and selectively rerun failures:

1. Foundation typecheck/unit and locale-label regressions.
2. Lab typecheck and production build, including the standalone entry.
3. KO/EN desktop/mobile keyboard, popup/overlay focus, save/reset, cancellation, table selection and questions.
4. Axe, contrast, forced colors, reduced transparency/motion, overflow and input-appropriate target checks.
5. Frosted document/panel/menu scrolling with wheel, keyboard, touch and grip dragging.
6. Source/data parity and intake/Registry publication gates.

No full typecheck, unit, axe, E2E, build, dependency audit or generated Registry promotion has been performed for this implementation stage.

## Rights And Sources

The reviewed code and documentation are MIT licensed. The original notice is preserved in the source inventory and accompanies the source-derived document packets.
No source screenshot, font file, icon asset or distinctive page layout was copied into the implementation. Existing Owen fonts and Lucide icons remain in use.
Code licensing does not grant rights to every trademark, media asset, font or dependency.

Primary source: [pinned shadcn/ui tree](https://github.com/shadcn-ui/ui/tree/4dbe072997507545dbf648ab45662d9c1e5b5b56). Local design authority: [DESIGN.md](DESIGN.md). Approval ledger: [intake.json](D:/GITHUB/wiki/dev/ui-portal-intakes/shadcn-ui-full-review/intake.json).
