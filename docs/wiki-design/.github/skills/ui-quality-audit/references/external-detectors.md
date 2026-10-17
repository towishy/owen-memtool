# External Detector Adoption Boundaries

External UI detectors provide candidate findings. They do not define the product's design system, replace browser evidence, or become an automatic quality gate without local calibration.

## Impeccable

Use only the standalone deterministic detector against an explicit local source path:

```powershell
npx impeccable detect --no-config --json <source-path>
```

Keep the run stateless:

- Do not run initialization or pin/unpin commands.
- Do not install the Impeccable skill, lifecycle hooks, or generated governance files.
- Do not create or overwrite `PRODUCT.md`, `DESIGN.md`, tokens, or project memory.
- Do not treat a clean detector result as proof of accessibility, responsive behavior, interaction quality, or visual quality.
- Do not report raw detector output without checking the source location and rendered impact.

Do not use the detector exit code alone as a pass/fail signal. Exit code 1 can represent ordinary findings or advisory-only output; parse the JSON and classify each result against the output job and owning design contract. Impeccable 3.5.0 still emitted advisory output and exited with code 1 when passed `--no-advisory`, so that flag is not part of the default workflow. `--scope type,layout` returned a clean exit but missed a known layout-property animation, so the default workflow uses the full ruleset and filters results after collection.

Classify each result as one of:

| Classification | Meaning | Action |
| --- | --- | --- |
| confirmed defect | Reproduced in source or browser and conflicts with the owning contract | Report with evidence and repair |
| duplicate | Already covered by axe, runtime, overflow, screenshot, or manual findings | Merge into the stronger finding |
| contextual recommendation | Rule may help but depends on output job or product context | Mark as a recommendation |
| false positive | Intentional contract, unsupported file type, generated code, or incorrect inference | Ignore and record only during calibration |

## Calibration

Before promoting any external detector to a required command, compare it on at least three known-good and three intentionally defective specimens. Record unique confirmed defects, duplicates, contextual recommendations, and false positives. Promote only stable rules that add evidence beyond the existing Playwright, axe, typecheck, and manual rubric workflow.

The default status is advisory and opt-in. No detector configuration or dependency is committed at this stage.

## 2026-08-06 Calibration

Impeccable 3.5.0 (`Apache-2.0`) was run with `--no-config --json` against three minimal known-good specimens and three intentionally defective specimens.

| Specimen group | Detector result | Interpretation |
| --- | --- | --- |
| readable type, stable grid, transform-only press motion | 0 findings across 3 specimens | no false positives in the small control set |
| 9px body text with 1.1 line height | 3 warnings | undersized UI text, tight leading, and tiny body text confirmed |
| width and margin transition | 1 warning | layout-property animation confirmed |
| fixed 1800px two-column layout | 0 findings | static source scan does not replace browser overflow checks |
| full UI Lab source before repair | 1 warning, 1 advisory | width transition confirmed; grid advisory was contextual to a specimen canvas |
| full UI Lab source after repair | 0 warnings, 1 advisory | warning removed; contextual grid retained |

Observed recall was two of three intentionally defective specimens, with zero findings on the three known-good controls. This sample is too small for a required gate but sufficient to retain the detector as an opt-in source scan. Playwright remains the owner for viewport overflow and rendered behavior.
