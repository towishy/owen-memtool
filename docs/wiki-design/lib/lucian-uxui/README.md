# Lucian original workflow specimens

Six MIT-licensed originals from [Seokwoooo/lucian-uxui-prompt](https://github.com/Seokwoooo/lucian-uxui-prompt), pinned at `7e339faa1cc5e87496cb7ce556a5b22aadbe76f8`. This is a source collection, not a new Foundation API or a Lucian-first design policy.

## Scope and status

- Selected originals: 127 change-hunk review, 130 CSV mapping, 176 revision filmstrip, 177 branching edit history, 191 event replay and 201 automation flow.
- Original HTML/CSS/JS and the full [MIT license](D:/GITHUB/wiki/lib/lucian-uxui/upstream/LICENSE) are preserved byte-for-byte. [collection.json](D:/GITHUB/wiki/lib/lucian-uxui/collection.json) pins all nine Git blob identities.
- The source executes inside a nested `sandbox="allow-scripts"` iframe with an opaque origin and no network access. Foundation/Portal styles and continuous-corner rules do not enter this frame.
- Korean and English variants use the upstream localization helper. Both have explicit light/dark views. Demo playback is opt-in and preserves the original step data, including the replay tape's drag.
- Original-snippet packets use `ui-portal.source-packet.v1`, but do not claim public exports, consumer compatibility, visual parity or registration. The existing Foundation packet resolver is unchanged.
- Validation approval and Registry promotion remain pending after implementation presentation. The actual gate is recorded in the [intake](D:/GITHUB/wiki/dev/ui-portal-intakes/lucian-uxui/intake.json).

## Open in Portal

[Six pending assets](http://127.0.0.1:4172/portal/?family=patterns-interactions&origin=lucian) share the existing Portal cards, per-item detail links, screenshot/live/source viewer and variant selector. Each live preview runs one original only.

The preview toolbar adds **Play demo**, **Stop / reset** and **Porting prompt**. Stopping or changing the variant recreates the source iframe, cancelling the old context. A trusted pointer or key interaction interrupts automatic demo steps. Demo completion is not a test result.

Touched Portal-owned preview controls use native `corner-shape: squircle`; unsupported browsers display a limitation instead of reporting a circular fallback as continuous. This is not a portable SVG fallback or a bulk migration of existing Portal components.

## Prepare

Use existing Node.js; no packages or global skills are installed.

```powershell
node scripts\ui-portal\prepare-lucian.mjs --fetch
node scripts\ui-portal\prepare-lucian.mjs --capture
```

`--fetch` downloads only missing pinned files and rejects Git blob mismatches. Existing changed files are never silently overwritten. `--capture` uses the existing UI Lab Playwright and Edge installations, opens six initial states, and writes distinct PNGs plus capture receipts. These are minimum presentation/load checks, not final validation.

Generated runtimes and pending discovery records are in [implementation](D:/GITHUB/wiki/dev/ui-portal-intakes/lucian-uxui/implementation). Source HTML is unchanged; the local wrapper, initial layout and demo orchestration are integration-only changes, with full visual comparison still pending.

## Query selected original sources

Normal `search`, `brief`, `resolve` and `select` keep their registered-asset contracts. Use an explicit original command:

```powershell
node scripts\ui-portal\query-assets.mjs originals "CSV mapping" --limit 3
node scripts\ui-portal\query-assets.mjs original --id lucian:csv-mapping --lang ko --output dev\temp\lucian-source-packet.json
node scripts\ui-portal\query-assets.mjs check --input dev\temp\lucian-source-packet.json
```

`original` resolves one exact selected ID at a time and checks its four required source files against both the packet SHA-256 and pinned Git blobs. `check` reports input identity only. The prompt requires an insertion point and replacement target, preserves real handlers/data, calls out cleanup, and separates original fidelity from an explicitly requested product adaptation.

Source and fidelity details: [review](D:/GITHUB/wiki/dev/ui-portal-intakes/lucian-uxui/REVIEW.md), [reference study](../ui-foundation/REFERENCE-STUDY-LUCIAN-UXUI.md).
