# Mirror Room · Light & Billiard Dynamics

**One HTML file that turns Penrose's 1958 "unilluminable room" into a lab you can drag, measure, and switch between ten different rooms.**

Zero dependencies. Double-click and it runs. No build step, no npm, no `node_modules`.

> **This is a personal-interest project.** No roadmap, no issue templates, no promised response time. The code is written to the standard of "works well on my own machine", not the standard of a general-purpose library. The UI is in Chinese; the physics and the numbers are not.

---

## What it is

An interactive bench for 2D mathematical billiards. Light leaves a point source, reflects specularly off perfect mirrors, and never fades. You can change the room shape, crank the ray count, push reflections up to 20,000, drop obstacles into the room — and watch two things at once:

- **Real space** — which cells the light has reached and which it never will (a live dark-region mask), plus the density skeleton of the caustics (an exposure map).
- **Phase space** — one dot per wall hit: horizontal axis is the hit position along the boundary, vertical axis is the cosine of the incidence angle. Does the orbit occupy a 1D line, a 2D band, or fill the plane?

Both views answer two sides of the same question: **can the light in this room ever fill it?**

The interface is bilingual: a 中 / EN toggle at the bottom of the left rail switches between Chinese and English, and the choice is remembered locally. Switching language changes text only — geometry, trace results, playback position and the dark-region mask are untouched, so a maxed-out 960 × 20k run is not reset.

![Just opened, light not launched yet](screenshots/01-initial.png)

![960 rays × 20k reflections, a few seconds into playback at the default speed](screenshots/02-running.png)

![Finished: progress 100%, phase plot at 62,400 points covering 92%, verdict "diffuse"](screenshots/03-finished.png)

![English UI, just opened](screenshots/04-en-initial.png)

![English UI, 960 rays × 20k reflections a few seconds in](screenshots/05-en-running.png)

---

## What's in the repo

| File | Purpose | Must sit next to the HTML? |
|---|---|---|
| `penrose-room.html` | Everything (≈4900 lines, 190 KB; bilingual UI) | — |
| `打开镜室-干净浏览器.cmd` | Windows launcher: opens it in an isolated, clean browser profile | **Yes** |
| `README.md` / `README.en.md` | Chinese / English docs | No |
| `简介.md` | Blurb drafts in several lengths (CN + EN) | No |
| `screenshots/` | Five screenshots (three Chinese UI, two English UI) | No |

**The `.cmd` launcher and the HTML must be in the same folder** — the launcher resolves the page relative to its own directory (`%~dp0`). The launcher is optional: you can always open the HTML directly.

---

## How it differs from what's already out there

The topic is not new. Penrose published the room in 1958, and there are several implementations online. Very few of them are built to be *measured*:

| Project | Shapes | Live trajectory | Dark regions in real space | Phase-space analysis | Scale | Dependencies |
|---|---|---|---|---|---|---|
| **Mirror Room (this)** | **10 + custom polygon + obstacles** | **Yes, speed-controllable** | **Live mask + exposure density map** | **Poincaré section + coverage + 3-way classification** | **960 rays × 20k bounces = 19.2M reflections** | **Single file, zero deps** |
| [PhyDemo Ray Optics](https://phydemo.app/ray-optics/) | General optics bench | Yes | No (count rays by eye) | No | Hundreds of rays | Web app |
| [Wolfram: The Penrose Unilluminable Room](https://demonstrations.wolfram.com/ThePenroseUnilluminableRoom/) | 1 | No (static lit/unlit map) | Yes, precomputed | No | Fixed | Wolfram Player |
| [tellurion.dev billiards playground](https://tellurion.dev/playgrounds/bsc-y2s2/FIS2021-billiards-circle-stadium-sinai/index.html) | 3 (circle / stadium / Sinai) | Yes | No | Only a twin-orbit separation curve | Hundreds of rays | Web |
| [Stadium Billiards (CindyJS)](https://maxthematics.github.io/illustrating-math/stadium-billiards) | 1 | Yes | No | No | ≤1000 rays | Web |
| [Quantum Billiards (Emergent Mind)](https://www.emergentmind.com/visualizations/quantum-billiards) | 5 | Yes (supporting role) | No | Husimi (quantum side) | Wave packet | Web |
| GitHub `penrose-unilluminable-room` projects | 1 | Some | Mostly no | No | Tiny | Varies |

Three differences that actually matter:

1. **Others do one room; this does ten.** Integrable (circle, ellipse, rectangle), rational polygons (triangle, pentagon, star), chaotic (stadium, Sinai), mixed phase space (mushroom), and Penrose — all in one UI, with identical parameters and identical verdict thresholds, so they can be compared directly.
2. **The dark region is a computed live state, not a pasted mask.** The mask grows with playback: as light advances, the dark area shrinks. Pause halfway and you see exactly the halfway state.
3. **The phase-space plot is a reading, not an illustration.** Every dot is one real wall hit from one real ray (position + incidence angle + path arc length). The coverage denominator is the number of phase-space cells, and it is stated on screen.

Current landscape: a GitHub search for `penrose unilluminable room` returns 5 repos, the most-starred one has 1 star; high-star `billiard simulation` repos are all snooker/eight-ball physics engines, unrelated to mathematical billiards. **This niche has no mature interactive work** — which is why I open-sourced it.

---

## The ten rooms

| Room | Class | One line |
|---|---|---|
| Penrose | 1958 | Two translated half-ellipses plus a winged mushroom; some region is always dark |
| Circle | Integrable | Incidence angle is invariant; every orbit hugs a concentric caustic |
| Ellipse | Integrable | A ray through one focus reflects through the other |
| Rectangle | Integrable | Periodic or a tidy grid of parallel tracks |
| Triangle | Rational | No exponential divergence, but still fills the room |
| Pentagon | Rational | Same, regular-pentagon version |
| Star | Rational | Non-convex; the spikes fold light back and produce caustics easily |
| Stadium | Chaotic | Replace the rectangle's straight sides with semicircles and integrability dies |
| Sinai | Chaotic | A central pillar destroys the rectangle's integrability |
| Mushroom | Mixed | Chaotic sea in the cap, regular islands trapped in the stem |

Extras: drop obstacles (circle / triangle / star / rectangle / ellipse) with drag, wheel-zoom and Delete; or draw a custom polygon (drag vertices, click the cyan dot to add, double-click to remove).

---

## How to read the two percentages

This is the easiest thing to misread, so it is written on the interface:

| Number | Denominator | Meaning |
|---|---|---|
| "Dark" (bottom-left HUD) | **room cells in real space** | fraction of room area the light has not reached yet |
| "Phase coverage" (bottom-right card) | **phase-space cells** (96 × 48 = 4608) | fraction of (s, p) cells that wall hits have landed in |

**They are naturally different, and should be.** The circle room lights only 4.8% of its area while covering most of phase space — because the light stays in a thin annulus, but hits the wall at infinitely many angles.

---

## Math: what has actually been checked

Not "looks right" — audited item by item against an independently written physics loop (not the code's own tracer):

| Invariant | Result |
|---|---|
| Direction stays a unit vector after reflection | deviation ≤ 1e-9 |
| Circular billiard: `\|d·n\|` conserved (caustic radius R·cosα) | drift **6.3e-14** |
| Elliptical billiard: caustic parameter `λ = a²dy² + b²dx² − (x·dy − y·dx)²` conserved | relative drift **4.9e-14** |
| Rectangular billiard: vertical vs horizontal wall hit ratio vs analytic prediction | **0.05%** off |
| Penrose room: left-right mirror symmetry | **0.0** |
| Ellipse phase-space abscissa: parameter angle → arc length | max deviation 5.6e-5 |
| Arc-length lookup (coarse table + bisection) vs brute-force scan | position diff **0.0** |
| Landing residual / zero-length bounce / NaN | 10 scenes × 200 rays × 3000 bounces: all zero |

**The classification is gated, not guessed.** Phase space is sorted into three classes (line / band / diffuse) only if:

- sampled points ≥ 1.5 × phase cells, **and**
- rays ≥ 240

Otherwise it reports coverage only. Reason: 60 trajectories in a 96×48 phase portrait are just 60 one-dimensional curves — coverage there is driven by ray count, not by ergodicity. Measured: same shape, 60 rays → 28%, 240 → 68%, 960 → 93%.

---

## Engineering: how one file does this

```
penrose-room.html          ← everything (~4600 lines)
├─ trace kernel (single source, shared)
│   ├─ Blob Worker on main thread   → multi-thread tracing (default)
│   └─ new Function in place        → single-thread fallback
├─ render kernel (Worker + OffscreenCanvas: stroke, decay, density)
└─ main thread (compositing, mask, phase plot, UI)
```

Hard-won constraints:

- **The kernel exists once.** The same source is used by the Worker and by the main-thread fallback, so the two paths cannot diverge.
- **Canvas transfer is one-way.** After `transferControlToOffscreen()` the main thread can never draw on that canvas again — so the kernel source is compiled with `new Function` *before* spawning the Worker. A syntax error left to the Worker is async and fails silently to a blank screen.
- **Parameters don't lie.** Ask for 20k reflections and it does 20k. Panel numbers come from actual tracing, not estimates.
- **Viewport changes never retrace physics.** Results depend only on geometry, source, ray count and bounce cap — resizing only redraws.

Performance reference: on a 16-thread machine, 960 rays × 20k bounces (19.2M reflections) traces in roughly a second; the HUD reports about 23M reflections/sec.

---

## Getting started

1. Put `penrose-room.html` and `打开镜室-干净浏览器.cmd` in the same folder
2. **Windows**: double-click the `.cmd` (recommended) or the `.html`
3. Pick a room on the left, tune parameters on the right, hit Start
4. To max out: rays → 960, bounce cap → 20k

Readouts: bottom-left HUD (rays, bounces, distance, progress, dark, lit, speed, bounces/sec, fps — click it for a 3-second self-benchmark); bottom-right phase card (points, coverage, verdict); the speed slider goes from 0.1 mm/s to the speed of light and is a real physical speed × an explicit multiplier.

---

## Why the launcher: a measured difference

Opening the HTML by double-click usually works. On my Windows machine, measured:

> **Same maxed-out settings (960 rays / 20k bounces): direct double-click drops frames; launched in its own clean window, it stays smooth.**

The cause is neither the page nor `file://`:

| | Direct double-click | Launcher |
|---|---|---|
| Browser profile | your daily one (extensions, sidebar, dozens of tabs) | fresh isolated profile |
| Extension scripts | content scripts injected into the page | `--disable-extensions`, none |
| Compositor | extension popups, sidebars, other tabs all take part in every frame | separate process tree + GPU process, no overlays |
| Window | address bar and tab strip | `--start-fullscreen`, borderless |

The page composites three layers per frame (background + trails + exposure density) and is sensitive to compositor overlays. Unrelated extension panels add extra full-screen blends every frame — that's where the frame rate goes.

So: **double-click works, but performance may not be optimal. For maxed-out settings, use the launcher.** If your browser is already clean (incognito, no extensions), double-click is just as fast.

---

## Cross-platform: the page is portable, the launcher is not

| | `penrose-room.html` | `打开镜室-干净浏览器.cmd` |
|---|---|---|
| Windows | ✅ | ✅ double-click |
| macOS | ✅ double-click, opens in your default browser | ❌ `.cmd` is a Windows batch file |
| Linux | ✅ double-click or `xdg-open` | ❌ same |
| Mobile | Opens, but the UI is desktop-only | ❌ |

The page itself is fully portable: plain HTML5 Canvas, Web Worker and OffscreenCanvas, no platform-specific code, no external assets.

Browser support (`transferControlToOffscreen` — all three engines since March 2023):

| Browser | Version | Behaviour |
|---|---|---|
| Chrome | 69+ | full, Worker rendering by default |
| Edge | 79+ | full |
| Firefox | 105+ | full; no fullscreen flag — press F11 once and the profile remembers it |
| Safari | 16.4+ | full |
| Older browsers | — | automatic fallback to main-thread rendering (slower but works) |

### Getting the same clean window on macOS

The `.cmd` won't run, but the equivalent is one line in Terminal:

```bash
open -na "Google Chrome" --args \
  --user-data-dir=/tmp/penrose-profile \
  --no-first-run --disable-extensions --start-fullscreen \
  "file:///Users/you/Downloads/penrose-room.html"
```

`open -na` starts a new instance; the `--user-data-dir` can be a temp directory and is safe to delete. Safari has no equivalent flag — "File → New Private Window" is the closest (private windows have no extensions).

> The repo intentionally ships no macOS launcher: I have no Mac to test on, and an unverified script is worse than one line you run yourself.

---

## Known limits

- **2D, geometric optics.** No diffraction, interference or polarisation. It answers "where does the ray go", not "what happens at wavelength scale".
- **Perfect mirrors.** No absorption, no scattering, no roughness.
- **Mask resolution is one cell.** Cell size comes from the bounding box and a 460×340 grid; dark regions smaller than one cell won't show.
- **Penrose's result is geometric, not numerical.** Given enough time, stray numerical photons will eventually graze a dark region's corner — that's discretisation meeting continuous math, not a bug.
- **Performance is environment-dependent.** Same file, same settings, clean vs daily window can differ several-fold. Please say which window you used when reporting performance.

---

## License

MIT — see [`LICENSE`](LICENSE). The copyright line reads `Mirror Room contributors`; change it to your own handle if you prefer.
