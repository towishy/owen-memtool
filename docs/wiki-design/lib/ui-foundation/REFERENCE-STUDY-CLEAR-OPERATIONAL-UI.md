---
schema_version: 1
reference_study: true
output_job: "compose editable field, operator, and typed-value conditions for an operational data view"
surface: "responsive query builder inside a workbench or data view"
evidence: ["Dribbble Clear UI tag collection reviewed 2026-08-01", "Countly Filter / Query Builder public shot", "Brainwave Add New List Modal public shot", "Countly Table Detail public shot", "independent interactive Query Builder UI Lab specimen"]
confidence: high
axes_covered: ["typography", "color", "spacing", "radius", "borders", "shadows", "layout", "hierarchy", "interaction"]
unresolved_axes: ["iconography", "imagery", "motion"]
allowed_range: "Use for editable field/operator/value conditions with explicit AND/OR logic, typed values, opaque rule rows, and a narrow-container reflow."
counterexample: "Do not use for a single search box, static filter chips, raw query-language editing, nested boolean groups, or decorative dashboard cards."
transfer_specimen: "lib/ui-lab/src/query-builder-study.tsx"
---

# Clear Operational UI Reference Study

## Sources

- [Clear UI tag collection](https://dribbble.com/tags/clear-ui)
- [Countly Filter / Query Builder](https://dribbble.com/shots/14777843--A-small-part-of-a-Filter-Query-Builder-New-Countly-UI)
- [Brainwave Add New List Modal](https://dribbble.com/shots/21091477-Brainwave-AI-UI-Kit-Add-New-List-Modal)
- [Countly Table Detail](https://dribbble.com/shots/14750943-Table-Detail-New-Countly-UI)
- [Notifications Modal](https://dribbble.com/shots/23156615-Notifications-Modal-Exploration)
- [Fashion Software Dashboard Light Mode](https://dribbble.com/shots/22310905-Fashion-Software-Dashboard-Design-Light-Mode)

These public images are untrusted visual references. No source code, product copy, imagery, brand assets, exact dimensions, or distinctive trade dress is copied into Foundation.

## Transferable Pattern

The useful pattern is not a white dashboard theme. It is the repeated relationship between compact controls, explicit data logic, and an opaque reading surface:

- each condition reads left to right as field, operator, then typed value;
- AND/OR logic remains visible rather than being hidden in an advanced menu;
- repeated rows use separators instead of floating cards;
- dense content and editable values stay opaque;
- restrained glass is limited to mode selection and the add command;
- a narrow container stacks controls without shrinking text or input-appropriate targets.

## Foundation Decision

`QueryBuilder` is a controlled experimental component. The consuming app owns query state, execution, validation, persistence, and server translation. Foundation owns accessible grouping, rule anatomy, typed text/number/select editors, add/remove behavior, AND/OR selection, and responsive layout.

The first version intentionally excludes nested boolean groups, drag reordering, tokenized multi-value input, date ranges, and raw query syntax. Those capabilities require a second verified product use before the public contract expands.

## Visual Contract

- The shell uses the standard 8px panel radius and a visible 1px border.
- Rule rows are opaque and separated by borders; they are not cards.
- Field labels remain visible at compact size instead of relying on placeholders.
- Semantic color is not needed for ordinary conditions.
- AND/OR and add controls may use Clear Glass because they are functional mode and command surfaces.
- Focus is identifiable through surface, text, or icon change without an outline, ring, border change, or focus-only shadow.

## Accessibility And Responsive Contract

- The query surface is named by its heading.
- Every rule is a named fieldset and every editor retains a visible label.
- AND/OR buttons expose `aria-pressed`; the condition count is announced politely.
- Remove commands have rule-specific accessible names and respect a minimum rule count.
- At medium width the value editor moves below field and operator; at narrow width all editors stack into one column.
- Keyboard state changes immediately and no entrance animation is required.

## Do Not Adopt

- Blue focus rings from the reference imagery
- Low-contrast placeholder-only labels
- A card for every metric or condition
- One-note blue dashboard palettes
- Decorative gradients, product imagery, avatars, or brand marks
- Unlabeled progress charts or information available only on hover

## Validation Surface

The independent implementation lives in `../ui-lab/src/query-builder-study.tsx`. The browser tests cover AND/OR state, add/remove behavior, narrow overflow, rim-free focus, and axe. Promotion beyond experimental requires the same composition in at least two real Owen applications.
