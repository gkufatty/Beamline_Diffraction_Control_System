# Diffraction Scan Summary — Slide Deck

Generates a 6-slide PowerPoint deck (`diffraction_scan_summary.pptx`) that documents an automated laser diffraction grating scan control script: what it does, the two EPICS control-system stacks it talks to, the scan geometry, the run-time execution flow, and the output data format.

This repo builds the *slide deck*, not the scan itself — it's a presentation-generation pipeline, not the beamline control code.

## Files

- `gen_icons.js` — renders a set of Feather icons (via `react-icons`) to white-on-transparent PNGs (`icon_*.png`), used as the deck's icon-in-circle motif.
- `build.js` — builds the actual deck with `pptxgenjs`: six slides (title, overview, control-system setup, scan design, execution flow, output), styled with a navy/ice/red palette. Reads the `icon_*.png` files generated above and embeds them as base64.
- `icon_*.png` — pre-rendered icon assets consumed by `build.js` (target, zap, activity, repeat, database, clock, wifi, cpu, move, eye, alertTriangle, checkCircle, save, sliders).
- `diffraction_scan_summary.pptx` — the generated deck (output of `build.js`).
- `diffraction_scan_summary.pdf` — PDF export of the deck.
- `slide-1.jpg` … `slide-6.jpg` — per-slide JPEG exports/previews of the deck.

The `.pdf` and `slide-*.jpg` files are rendered exports of the `.pptx` (e.g. via LibreOffice/`soffice --convert-to`), not produced by any script in this repo — they're checked in as previews.

## Prerequisites

Node.js, plus these packages (no `package.json` is currently checked in, so install directly):

```bash
npm install pptxgenjs react react-dom react-icons sharp
```

## Usage

Icons must exist before building the deck, since `build.js` reads `icon_*.png` from disk:

```bash
node gen_icons.js   # writes icon_<name>.png for each icon in the icons map
node build.js        # writes diffraction_scan_summary.pptx
```

To refresh the PDF/JPG previews after a rebuild, re-export the `.pptx` with whatever tool you used originally (e.g. LibreOffice headless) — that step isn't automated here.

## What the deck covers

1. **Title** — one-line summary of the scan script and its main hardware/software dependencies (SMARACT rotation motor, Keithley photocurrent readout, `p4p` + `pyepics`).
2. **Overview** — what the script does: sweeps the grating motor, reads photocurrent at each angle, repeats the sweep 4× for reproducibility, and drives status LEDs.
3. **Control system setup** — the two EPICS stacks involved: pvAccess (`p4p.Context`) for the LaserDiffraction IOC (LEDs, laser, Keithley), and Channel Access (`pyepics`) for the SMARACT motor.
4. **Scan design** — a coarse ±background sweep (5° steps, −40° to +5°) merged with nine fine-resolution points at expected diffraction orders, sorted into one monotonic sweep.
5. **Execution flow** — the 5-step per-run sequence (arm → fast reposition → set scan speed → step & measure → wrap up), repeated 4 times.
6. **Output** — data format (`results/samples{idx}.npz`, containing `motor_positions[]` and `samples[]` as float64 arrays) and a noted limitation: motion timing relies on fixed sleeps rather than a move-complete check.

## Customizing

Colors, fonts, and copy all live inline in `build.js` (see the constants at the top of the file — `NAVY`, `RED`, `ICE`, etc., plus `FONT`/`HEAD_FONT`). Each slide is built in its own `{ ... }` block, so edits to one slide's content or layout are isolated from the others. To add a new icon, add an entry to the `icons` map in `gen_icons.js`, regenerate, then reference it by name via the `icon()`/`iconCircle()` helpers in `build.js`.
