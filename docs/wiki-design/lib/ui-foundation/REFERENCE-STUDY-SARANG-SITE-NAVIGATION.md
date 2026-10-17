---
schema_version: 1
reference_study: true
output_job: "Preserve the user-approved Sarang cross-site menu as an isolated Portal component"
surface: "cross-site navigation menu"
evidence: ["Sarang product source", "user-reviewed built-in browser preview", "six-width browser geometry, keyboard and axe checks"]
confidence: medium
axes_covered: ["spacing", "radius", "borders", "layout", "hierarchy", "iconography", "interaction", "motion", "color"]
unresolved_axes: ["exact external-video motion fidelity", "all-browser performance"]
allowed_range: "Preserve this product implementation in an isolated runtime; use only for explicit cross-site navigation."
counterexample: "Do not replace an application's primary navigation or silently apply this oversized dock to dense editor commands."
transfer_specimen: "lib/sarang-navigation/index.html"
---

# Sarang Site Navigation

## Identity And Scope

The saved source is the user-approved Sarang implementation, with five actual destinations. The user explicitly requested the implementation be added to all five sites, deployed, and stored as a UI Portal menu component after repeatedly inspecting its local browser preview.

Visual reference: [Nexvyn on UIInspoo](https://uiinspoo.com/designs/dropdown-ui-design-inspiration/cmtpvbfx6002ruel2sjfgiy9o). The reference video showed an edge-docked blue rounded square, pointer approach and expansion. The public Nexvyn repository examined at `d3f1552764f784d1041686d098aa52bf364fec40` did not establish the exact source of this video's first button. No video, brand artwork or repository implementation is distributed here.

## Explicit Product Changes

The user requested organic submenu and row hover contours, five Korean/product destination labels opening in new tabs, and a round close hover staying within the panel. The implementation uses local OrganicShape curves and native Web Animations. These are explicit product adaptations, not unreported differences in an original collection.

## Fidelity Ledger

| Surface | Saved behavior | Boundary |
| --- | --- | --- |
| Closed dock | 224px rounded square, partial right-edge clipping, -12 degree tilt, bounded pointer approach | Exact product source; external motion parity unverified |
| Open panel | Deterministic organic outline and five real links | Explicit user-requested adaptation |
| Row hover | Separate deterministic organic contour per link | Explicit user-requested adaptation |
| Close | 44px circle inset 20px from right | 72 boundary points checked inside the curve at six widths |
| Keyboard | Enter, Tab, arrows, Home, End, Escape, outside dismissal | Native links and closed inert content |
| Accessibility | Reduced motion, forced colors, accessible names | Browser checks are scoped, not universal acceptance |

## Ownership And Rights

The product owns the script, geometry, content and stylesheet. Portal keeps a byte-identical snapshot in `lib/sarang-navigation/`, using its normal inspector around an isolated runtime. Foundation is not modified to export a product-specific API. Lucide icon paths retain their ISC/Feather MIT notices in `shared-navigation-LICENSE.txt`; no reference media is copied.

The component's fixed Korean labels are intentionally preserved. Portal metadata supplies an English title. Default platform font fallback is inherited from the product code; no font binaries are newly distributed.

## Integration

- Registry ID: `component:sarang-site-navigation`
- Live: `/repo/lib/sarang-navigation/index.html?state=open`
- Source: `lib/sarang-navigation/shared-navigation.js`
- Screenshot and receipt: `lib/sarang-navigation/captures/`
- Product verification: `node scripts/check-navigation.cjs` and `node scripts/check-navigation.cjs --live` from Sarang.day/web.

The independent Portal capture check binds the four product snapshot files to source hashes. The reference video is not a licensed or captured acceptance artifact. Any future generalized menu API must remain separate from this preserved product snapshot.
