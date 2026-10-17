---
schema_version: 1
reference_study: true
output_job: "collect structured account details with low effort and clear progress"
surface: "mobile multi-field forms with selects, numeric identifiers, names, and a final submit action"
evidence: ["public Instagram reel by Zander Whitehurst with Revolut Insider, Db8J5z5Oy8-, 41.5 seconds at 1080x1920, reviewed frame-by-frame 2026-08-13", "reel caption states that each interaction reduces effort, builds confidence, and keeps the user moving"]
confidence: medium
axes_covered: ["typography", "spacing", "radius", "borders", "layout", "hierarchy", "motion", "interaction"]
unresolved_axes: ["color", "shadows", "iconography", "imagery"]
allowed_range: "Use for mobile forms where persistent labels, correct input modes, field-to-field progression, and a reachable contextual action materially reduce repeated interpretation and keyboard switching."
counterexample: "Do not replace semantic labels with placeholders, force 56px controls into dense desktop forms, turn every input into a pill, or add a floating next button when native keyboard progression is sufficient."
transfer_specimen: "pending"
---

# Reference Study: Mobile Form Flow

## Source pattern

A public form-design reel contrasts a conventional bank recipient form with a Revolut-style mobile account-details flow. The source shows the same information architecture in three forms: an initial desktop-like stack with labels above 40px controls, a redesign exercise, and the final dark mobile implementation.

The transferable value is not the dark palette or branded appearance. It is the reduction of repeated interpretation between fields, keyboard, and next action. No source code, brand token, copy set, or complete screen is copied into the Foundation.

## Observed sequence

1. The conventional form repeats field names in external labels and placeholders such as `Account number` and `Enter account number`.
2. The redesign removes the duplicate wording but briefly demonstrates why placeholder-only labels fail: the field purpose disappears after typing.
3. The accepted pattern keeps a small persistent label inside the field and places the entered or selected value below it.
4. The example increases mobile field height from 40px to 56px so the text hierarchy and touch target fit without crowding.
5. The exercise rejects a `999px` pill radius for data entry and demonstrates a bounded rounded rectangle, annotated as 24px in the consumer-mobile example.
6. Country and currency remain selection controls, while account number and sort code summon a numeric keyboard.
7. A contextual arrow stays reachable above the keyboard and changes direction or extent as the user advances. The final action returns to a full-width `Continue` command when the keyboard is dismissed or the step is complete.
8. Business and Individual are chosen before entering details, so downstream fields have an explicit context.

## Decision

Adopt this as a **form-flow contract**, not a universal visual style.

- Preserve one visible label for every field before, during, and after entry.
- Reduce redundant wording between label, placeholder, help text, and validation message.
- Match the input method to the expected value and make field progression predictable.
- Keep the next valid action reachable while the software keyboard reduces the viewport.
- Increase touch-first control height before increasing decorative padding or radius.
- Use radius to group the field surface, not to make text-entry controls look like action pills.
- Reveal success, error, and completion at the field or action that caused the state.

## Field anatomy

### Persistent label

The source uses a compact label above the value within one control surface. In an implementation, the visible label must still be a real `<label>` associated with the native input or select. Placeholder text is optional supporting copy, never the accessible name.

A field may use two visual states:

| State | Visible presentation | Semantic requirement |
| --- | --- | --- |
| Empty and idle | label remains readable; optional example is quieter | associated `<label>` exists |
| Focused or populated | label becomes compact; value owns the primary line | same label association remains stable |

The transition must not move adjacent fields or delay focus. Browser autofill, password managers, zoom, translation, and long Korean labels must not overlap the value.

### Height and spacing

The source contrasts 40px and 56px fields. Foundation does not turn either value into a universal interaction target; each surface resolves density, input modality, and spacing explicitly.

- Touch-first mobile account forms may use 52-56px controls when a compact label and value share the surface.
- Ordinary desktop operational forms use compact visual height appropriate to the workflow, while touch surfaces provide larger effective targets and sufficient spacing where required.
- Vertical rhythm should make the current field and next field distinguishable without card wrappers.
- Error or help text expands below the owning field instead of being overlaid inside the value line.

### Radius

The source contrasts `999px` and 24px. That observation does not replace the Foundation control radius.

- Foundation operational controls continue to use the 6px control token by default.
- Consumer-mobile forms may test 12-24px only when the product geometry already uses rounded controls and long values retain adequate inset width.
- Full pill radius is reserved for commands, segmented choices, chips, and circular utilities, not ordinary text entry.
- Radius must not reduce usable value width or make adjacent stacked fields merge visually.

## Keyboard and progression contract

Use native platform hints before adding a custom floating action.

| Field | Preferred semantics |
| --- | --- |
| Country or currency | `SelectControl` or native select with typeahead |
| Account number | text input with the provider-required character rules, appropriate `inputMode`, and `autocomplete` where standardized |
| Sort code or routing code | numeric or text input according to locale; do not assume every routing identifier is numeric |
| First and last name | text input with name autocomplete tokens and normal capitalization behavior |
| Intermediate field | `enterKeyHint="next"` when supported and safe focus advance |
| Final field | `enterKeyHint="done"` or submit without hiding validation failures |

A keyboard-adjacent next action is allowed only when it:

- stays inside the visual viewport above the IME;
- does not cover the focused field, errors, or native keyboard affordances;
- has a text or accessible name that identifies `next` versus `submit`;
- produces the same result through Enter, hardware keyboard, switch input, and screen-reader activation;
- disappears or becomes the final submit action at a deterministic point;
- respects reduced motion and does not make semantic state wait for animation.

## Validation and confidence

The source shows masked account and routing values, field progression, and a final `Continue` state, but it does not demonstrate error recovery, localization, autofill, screen reader output, offline state, or server validation. Those states remain required and cannot be inferred from the reel.

Inline validation should run at a useful boundary such as blur, complete format, or submit. Do not mark incomplete typing as an error on every keystroke. Success must not rely on green alone; use concise text or an icon with an accessible status when confirmation matters.

## Foundation mapping

| Observed need | Foundation owner | Transfer decision |
| --- | --- | --- |
| Label, description, error, required state | `FormField` | existing canonical owner; extend only after two product needs |
| Country and currency choice | `SelectControl` | existing canonical owner |
| Primary continuation | `ActionButton` | full-width on narrow screens when it is the single primary command |
| Loading, error, offline, success | `AsyncState` plus field-level status | explicit states, not spinner-only feedback |
| Business or Individual mode | native radio group or existing segmented pattern | selection precedes dependent fields |
| Keyboard-adjacent progression | platform input semantics first | app-owned enhancement until independently validated |

## Transfer specimen

No independent specimen exists yet, so confidence remains `medium`. A future UI Lab specimen must use neutral Owen copy and styling, not Revolut branding, and verify:

1. empty, focused, populated, invalid, disabled, autofilled, and submitting states;
2. 390px and 320px widths with the software keyboard viewport simulated;
3. Korean and English labels, 200% zoom, and long account-format help text;
4. native keyboard, hardware keyboard, screen reader, and pointer progression;
5. no overlap between compact label, value, validation, and keyboard action;
6. reduced motion, dark/light themes, forced colors, axe, and browser autofill.

## When not to use

- single-field search, command input, or chat composer;
- dense desktop data entry where external labels improve row scanning;
- forms where legal or clinical instructions need persistent full-width explanatory text;
- identifiers whose locale-specific format is unknown;
- a custom keyboard or floating action added only for visual novelty;
- placeholder-only fields, pill-shaped text inputs, or motion that blocks the next keystroke.

## Source

- Public reel: [Instagram reel `Db8J5z5Oy8-`](https://www.instagram.com/reel/Db8J5z5Oy8-/)
- Creator: Zander Whitehurst, with Revolut Insider
- Reviewed: 2026-08-13
- Local analysis evidence: temporary 1-second frame sheets under `dev/temp/`, excluded from product source and distribution
