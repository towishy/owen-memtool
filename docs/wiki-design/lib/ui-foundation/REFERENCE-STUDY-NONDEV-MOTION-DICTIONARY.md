---
schema_version: 1
reference_study: true
output_job: "select a named motion-graphics recipe and turn supplied content into a finite, seekable video composition"
surface: "searchable motion recipe catalog, prompt builder and isolated deterministic preview"
evidence: ["nondev-thinking motion dictionary public page reviewed 2026-10-01", "88 source cards across 14 categories", "19 source 3D recipes and 19 industry tags", "source material attribution notice states CC BY 4.0", "existing Owen HyperFrames 0.8.1 integration and Motion Graphics reference study"]
confidence: high
axes_covered: ["typography", "color", "spacing", "radius", "borders", "shadows", "layout", "hierarchy", "iconography", "imagery", "motion", "interaction"]
unresolved_axes: []
allowed_range: "Use as a bilingual vocabulary, prompt schema and deterministic planning preview for the 88 attributed motion recipes. Final video work still requires real copy, licensed assets, audio policy, aspect-ratio composition and render validation."
counterexample: "Do not mirror the source website shell, execute its analytics or ranking APIs, copy unlicensed JavaScript or media, treat a preview as a finished video, or autoplay motion when reduced motion is requested."
transfer_specimen: "lib/hyperframes/examples/nondev-motion-catalog/index.html"
---

# Nondev Thinking Motion Dictionary Reference Study

## Source Identity

- Canonical source: [모션그래픽 주문 사전](https://nondev-thinking.web.app/motion/)
- Publisher: 한국경영교육연구소 AI ACADEMY
- Attribution shown by the source: 외부강사 김지백
- Source page final-modified label: 2026-09-26
- Reviewed and cryptographically pinned: 2026-10-01
- Main HTML SHA-256: `cad6c2ab64ed3aec98b7257adf7ada249e6a51ed97c14959c58505730e30f2f2`

The downloaded-copy notice says the material may be used freely for classes and lectures with attribution and identifies it as CC BY 4.0. The content importer preserves that attribution. The JavaScript modules, Three.js bundle, two MP4 files and poster images do not expose separate license headers in the reviewed files, so they are not copied into WIKI.

## Observed Inventory

The public page contains 88 cards in 14 categories:

| Category | Count |
| --- | ---: |
| Image insertion | 10 |
| Captions and typography | 6 |
| Explanation and education | 7 |
| Data and comparison | 5 |
| Scene transitions | 6 |
| Openings and logos | 4 |
| Effects and objects | 4 |
| People and testimonials | 4 |
| Endings and subscription | 4 |
| Maps and place guidance | 11 |
| Shops and services | 9 |
| Schedules and events | 7 |
| Notices, procedures and campaigns | 8 |
| Everyday helpers | 3 |

Every card has a stable source ID, Korean name, English technical name, plain-language description, duration, use case, industry tags, simple prompt, detailed prompt and editable variable schema. Nineteen cards are marked 3D. The page offers 19 industry filters and three aspect-ratio choices.

## Source Interaction Model

- Search covers Korean name, English name and use case.
- Category, industry and 3D filters narrow the same 88-item inventory.
- Global settings choose tool wording, aspect ratio, optional color or mood, and an optional video file.
- A local image picker changes compatible previews without uploading the selected file.
- Every recipe switches between a compact and detailed request, accepts recipe-specific values, can be copied, and can be added to a combined order sheet.
- Previews can be paused globally. The source code describes preview state as a pure function of time and shares one WebGL renderer across 3D canvases.
- Two introductory videos explain the catalog and installation flow.
- A remote Firestore document supplies popularity ranking, and the page includes feedback telemetry.

The WIKI transfer keeps the catalog, prompt-builder and deterministic-time ideas. It excludes remote popularity, feedback, analytics, installer shell commands, source videos and source-site navigation.

## Ownership Decision

| Concern | Canonical WIKI owner |
| --- | --- |
| Provenance, hashes, CC BY notice and 88-item inventory | `lib/nondev-thinking-motion/` |
| Reusable Korean and English prompt documents | `docs/video-prompt/nondev-motion-*.md` |
| Deterministic preview and composition recipes | `lib/hyperframes/examples/nondev-motion-catalog/` |
| Single-composition production workflow | `.github/skills/hyperframes-video/SKILL.md` |
| Search, cards, screenshot, live preview and source inspection | generated UI Portal Registry |
| General bounded-motion and accessibility rules | `REFERENCE-STUDY-MOTION-GRAPHICS.md` |

Foundation does not own the video copy, recipe data, composition source or output media.

## Transfer Contract

1. Keep all 88 source IDs stable and individually searchable.
2. Preserve Korean source meaning and provide a separate English counterpart; do not silently replace the original locale.
3. Store category, industry, duration, 3D status, variable schema, simple prompt, detailed prompt, negative constraints and attribution with every recipe.
4. Implement every preview independently from the observed motion and final state. Do not copy source JavaScript, CSS, canvas commands, Three.js scenes or media.
5. Make time deterministic and seekable. Random-looking particles or layouts use seeded data.
6. Support 16:9, 9:16 and 1:1 by recomposition rather than final cropping.
7. Provide play, pause, replay and seek. Reduced motion renders the complete informative endpoint without spatial or continuous motion.
8. Use local assets only in the preview and production runtime. No analytics, ranking, feedback or other network calls are permitted.
9. Distinguish the catalog preview from a final render. User copy, media, narration, captions and audio remain explicit production inputs.
10. Give every Portal asset its own screenshot, direct live URL and recipe source.

## Fidelity Boundary

The work preserves each recipe's named motion, information hierarchy, primary beat, duration range, configurable content and final readable state. It does not reproduce the source site's beige/red shell, page layout, ranking UI, introductory videos, sample people or places, exact illustrations, fonts, analytics or network behavior.

This is a content and behavior transfer, not an exact mirror of the public website. Pixel fidelity to source previews is not claimed because their execution code and media have no separately verified license. The independent implementation must be compared by recipe identity, motion beat, sequencing, static endpoint, aspect-ratio behavior and prompt-variable coverage.

## Relationship To Owen Motion Rules

The existing [Motion Graphics reference study](REFERENCE-STUDY-MOTION-GRAPHICS.md) remains authoritative for bounded playback, engine ownership, reduced motion, performance and accessibility. The source page's always-moving preview grid is not adopted as a general product default. UI Portal may show one isolated selected recipe at a time, while the catalog grid uses static screenshots until the user opens a preview.

## Held Source Material

- Original JavaScript and CSS modules
- Vendored Three.js source
- Introductory and installation MP4 files
- Poster images
- Firestore ranking data and write endpoints
- Feedback form and telemetry
- Source-site shell, navigation and visual trade dress

These items remain linked in provenance where useful but are not redistributed or executed by WIKI.
