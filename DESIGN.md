# DESIGN.md — FAW Trucks Turkmenistan

> Showroom lighting for working trucks: dark photography bands, white engineering sheets, one blue that means "act".

## 1. Visual Theme & Atmosphere

**Style**: Industrial Showroom (automotive rhythm in the BMW manner, adapted to commercial trucks)
**Keywords**: engineered, angular, confident, legible, road-speed, trustworthy, spec-driven
**Tone**: calm technical authority — NOT flashy gamer-tech, NOT soft lifestyle pastel
**Feel**: Walking from a dark showroom floor, past lit trucks, to a clean spec board with the dealer's desk at the end.

**Interaction Tier**: L2 — Fluid interaction (scroll reveal, parallax, nav state, count-up, magnet CTA, spotlight cards)
**Dependencies**: CSS + vanilla JS only (IntersectionObserver, rAF, Canvas 2D). No GSAP, no Lenis.

Page rhythm: banner slider (user photography) → dark hero band with road-streak canvas → model-name marquee → white bento catalog → featured JH6 photo → services → about → dark contact desk → footer.

## 2. Color Palette & Roles

```css
:root {
  /* Backgrounds */
  --bg: #F3F5F8;               /* page background, cool sheet-metal grey */
  --surface: #FFFFFF;          /* cards, form */
  --surface-alt: #E9EDF2;      /* card art wells, alternating rows */
  --surface-hover: #F8FAFC;    /* hovered light surface */
  --surface-dark: #0B1424;     /* hero band, contact desk */
  --surface-dark-2: #111D31;   /* marquee band, slider backdrop */
  --footer-bg: #060C17;

  /* Borders */
  --border: #D5DCE5;
  --border-hover: #9FB0C6;

  /* Text */
  --text: #0F1828;
  --text-secondary: #4F5B6D;
  --text-tertiary: #7D8899;
  --on-dark: #FFFFFF;
  --on-dark-secondary: #B9C4D4;
  --on-dark-tertiary: #8796AB;

  /* Accent — FAW blue, the only colour that means "act" */
  --accent: #0A4EA8;
  --accent-hover: #083E86;
  --accent-active: #06326C;
  --accent-bright: #3D8BFF;    /* accent on dark surfaces */
  --focus: #5AA0FF;

  /* RGB variants for rgba() */
  --bg-rgb: 243,245,248;
  --dark-rgb: 11,20,36;
  --on-dark-rgb: 255,255,255;
  --accent-rgb: 10,78,168;
  --accent-bright-rgb: 61,139,255;

  /* Semantic */
  --success: #1E7A3C;
  --error: #B3261E;
  --warning: #B26A00;

  /* Truck line drawings */
  --truck-fill: #FFFFFF;
  --truck-line: #1B2638;
  --truck-glass: #CFE0F5;
  --art-top: #F7F9FC;
  --art-bottom: #E4EAF2;
}
```

**Color Rules:**
- Every colour in components comes from these variables; no hex inside component CSS or JS (canvas reads tokens with getComputedStyle).
- Blue is reserved for interactive elements, active states and one stripe on the truck drawings. Never as a large decorative fill.
- Dark bands use `--on-dark*` text tokens only; light sections use `--text*` only.
- Single theme by choice (light page with dark bands); `color-scheme: light`.

## 3. Typography Rules

**Font Stack:**
```css
@import url('https://fonts.googleapis.com/css2?family=Oswald:wght@500;600;700&family=IBM+Plex+Sans:wght@400;500;600&family=IBM+Plex+Mono:wght@500&display=swap');
--font-display: "Oswald", "Arial Narrow", Arial, sans-serif;
--font-body: "IBM Plex Sans", "Segoe UI", Roboto, Arial, sans-serif;
--font-mono: "IBM Plex Mono", ui-monospace, Consolas, monospace;
```
All three cover Cyrillic and Turkmen Latin (ý ň ş ç ž ä ö ü).
The deploy build embeds these fonts as base64 woff2 (latin, latin-ext, cyrillic) and drops the Google Fonts link, because Google is blocked in Turkmenistan; the page makes no external requests.

| Role | Font | Size | Weight | Line Height | Letter Spacing |
|------|------|------|--------|-------------|----------------|
| Hero H1 | Oswald, uppercase | clamp(40px, 6vw, 76px) | 700 | 1.02 | 0.005em |
| Section H2 | Oswald, uppercase | clamp(32px, 4vw, 48px) | 600 | 1.05 | 0.01em |
| H3 (model name) | Oswald | 30px (feature card 44px) | 600 | 1.05 | 0.01em |
| Body | IBM Plex Sans | 16px (lead 18px) | 400 | 1.6 | — |
| Label / eyebrow | IBM Plex Sans, uppercase | 12–13px | 600 | 1 | 0.14em |
| Mono (spec values, engine codes) | IBM Plex Mono | 13–14px | 500 | 1.4 | — |

**Typography Rules:**
- Display is always uppercase Oswald; body never uppercase except labels.
- Spec values and engine codes use mono + tabular numerals so columns line up.
- Running text max ~62ch.
- **NEVER use**: Inter, Space Grotesk, Montserrat, any script/serif display, system-only stacks without fallback.

**Text Decoration:**
- Hero H1: no gradient, no shadow (photography carries drama); words reveal through a mask.
- H2: no gradient, no shadow; a 48px × 3px accent bar sits under the section eyebrow.
- H3: plain.

## 4. Component Stylings

### Buttons
```css
.btn{display:inline-flex;align-items:center;justify-content:center;gap:10px;min-height:48px;padding:0 24px;font:600 15px/1 var(--font-body);letter-spacing:.02em;border-radius:var(--radius);border:2px solid transparent;cursor:pointer;text-decoration:none;transition:background-color .2s,color .2s,border-color .2s,transform .2s}
.btn-primary{background:var(--accent);color:var(--on-dark)}
.btn-primary:hover{background:var(--accent-hover)}
.btn-primary:active{background:var(--accent-active);transform:translateY(1px)}
.btn:focus-visible{outline:3px solid var(--focus);outline-offset:2px}
.btn:disabled,.btn[aria-disabled="true"]{background:var(--border);color:var(--text-tertiary);cursor:not-allowed;transform:none}
.btn-ghost{border-color:rgba(var(--on-dark-rgb),.35);color:var(--on-dark);background:transparent}
.btn-ghost:hover{border-color:var(--on-dark);background:rgba(var(--on-dark-rgb),.06)}
.btn-ghost:active{background:rgba(var(--on-dark-rgb),.12)}
.btn-outline{border-color:var(--accent);color:var(--accent);background:transparent;min-height:44px;padding:0 18px;font-size:14px}
.btn-outline:hover{background:var(--accent);color:var(--on-dark)}
.btn-outline:active{background:var(--accent-active);border-color:var(--accent-active)}
```

### Cards (model cards, spotlight)
```css
.card{position:relative;background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;transition:border-color .25s,transform .25s,box-shadow .25s}
.card::before{content:"";position:absolute;inset:0;pointer-events:none;opacity:0;transition:opacity .3s;background:radial-gradient(420px circle at var(--mx,50%) var(--my,50%),rgba(var(--accent-rgb),.10),transparent 60%)}
.card:hover{border-color:var(--border-hover);transform:translateY(-3px);box-shadow:var(--shadow-2)}
.card:hover::before{opacity:1}
.card:focus-within{border-color:var(--accent)}
```

### Navigation
```css
.header{position:sticky;top:0;z-index:30;background:var(--surface);border-bottom:1px solid var(--border);transition:box-shadow .25s}
.header .wrap{height:68px;transition:height .25s}
.header.scrolled{box-shadow:var(--shadow-2)}
.header.scrolled .wrap{height:60px}
.nav a{font-weight:500;color:var(--text);border-bottom:2px solid transparent;padding:6px 0}
.nav a:hover{border-bottom-color:var(--accent)}
.nav a:focus-visible{outline:3px solid var(--focus);outline-offset:2px}
```

### Links
```css
.link{color:inherit;text-decoration:none;background:linear-gradient(currentColor,currentColor) 0 100%/0 1px no-repeat;transition:background-size .25s}
.link:hover{background-size:100% 1px}
.link:focus-visible{outline:3px solid var(--focus);outline-offset:2px}
```

### Tags / Badges
```css
.tag{font:600 12px/1 var(--font-body);letter-spacing:.12em;text-transform:uppercase;color:var(--accent)}
.filters button{min-height:44px;padding:0 16px;border:1px solid var(--border);background:var(--surface);color:var(--text);border-radius:var(--radius)}
.filters button:hover{border-color:var(--border-hover)}
.filters button[aria-pressed="true"]{background:var(--text);border-color:var(--text);color:var(--on-dark)}
.filters button:focus-visible{outline:3px solid var(--focus);outline-offset:2px}
```

### Form fields
```css
.field input,.field select,.field textarea{border:1px solid var(--border);border-radius:var(--radius);background:var(--surface-hover);color:var(--text);padding:12px;min-height:48px}
.field input:hover,.field select:hover,.field textarea:hover{border-color:var(--border-hover)}
.field input:focus,.field select:focus,.field textarea:focus{outline:2px solid var(--accent);border-color:var(--accent)}
.field [aria-invalid="true"]{border-color:var(--error)}
.field input:disabled{background:var(--surface-alt);color:var(--text-tertiary)}
```

### Slider controls
Round 46px buttons on `rgba(var(--dark-rgb),.55)`, hover `.85`; 30×4px progress dots, active dot `--on-dark`.

## 5. Layout Principles

**Container:** max width 1200px; padding 24px (16px under 560px); text-heavy blocks max 62ch.

**Spacing Scale:** 4 / 8 / 12 / 16 / 24 / 32 / 48 / 72 / 96. Section padding 88px desktop, 56px mobile. Component gap 20–24px. Card padding 22px.

**Grid:**
```css
.bento{display:grid;grid-template-columns:repeat(4,1fr);gap:20px}
.bento .card.wide{grid-column:span 2}              /* JH6 flagship */
@media (max-width:1080px){.bento{grid-template-columns:repeat(2,1fr)}}
@media (max-width:620px){.bento{grid-template-columns:1fr}.bento .card.wide{grid-column:auto}}
```
Bento with the flagship spanning two columns: each filter (all / tractors / dump & cargo) still fills whole rows.

`--radius: 2px` everywhere — angular, industrial; only slider buttons are round.

## 6. Depth & Elevation

| Level | Treatment | Use |
|-------|-----------|-----|
| Flat | border 1px `--border`, no shadow | cards at rest, filters, form |
| Subtle | `--shadow-1: 0 1px 2px rgba(var(--dark-rgb),.06)` | header at rest |
| Elevated | `--shadow-2: 0 10px 30px -12px rgba(var(--dark-rgb),.28)` | hovered card, scrolled header |
| Band | full-width `--surface-dark` | depth through light/dark section contrast, not shadows |

## 7. Animation & Interaction

**Motion Philosophy**: Road-speed, not fireworks — transform and opacity only, one moving background, everything stops for reduced motion.
**Tier**: L2

### Dependencies
None (vanilla). Motion patterns inspired by vue-bits / reactbits by DavidHDev (MIT), rewritten in vanilla JS.

### Signature moments
| Category | Effect | Where |
|----------|--------|-------|
| Hero H1 text | SplitText-style word mask reveal on load | hero band H1 |
| Section H2 text | Words rise with 50ms stagger when in view (ScrollFloat-like) | every H2 |
| Body / label text | ScrambleText decode on eyebrows | hero + section eyebrows |
| Element-level | Magnet pull on primary CTAs; wheel spin on card hover | CTAs, model cards |
| Interactive component | SpotlightCard (cursor-tracking glow) + bento layout + banner slider | catalog, top |
| Background | Canvas road-light streaks (Hyperspeed-lite) | hero band |
| Extra L2 | banner parallax, Ken Burns, count-up stats, model-name marquee, nav scrolled state, scroll progress bar | — |

Hero wow: Ken Burns banner + H1 mask reveal over road streaks. First-scroll hook: giant outline marquee of model names + count-up. List: bento + spotlight. Clever detail: hovering a model card spins its drawn wheels.

### Entrance Animation
```css
.split .w{display:inline-block;overflow:hidden;vertical-align:top;padding-bottom:.06em}
.split .w>span{display:inline-block;transform:translateY(105%);transition:transform .8s cubic-bezier(.2,.7,.2,1)}
.split.in .w>span{transform:none}
.rv-pending{opacity:0;transform:translateY(28px)}
.rv{transition:opacity .7s ease,transform .7s cubic-bezier(.2,.7,.2,1)}
```

### Scroll Behavior
```js
const io = new IntersectionObserver(es => es.forEach(e => {
  if (e.isIntersecting) { e.target.classList.add('in'); e.target.classList.remove('rv-pending'); io.unobserve(e.target); }
}), { rootMargin: '0px 0px -10% 0px' });
// Only elements below the fold at load get .rv-pending, so the first screen is complete at rest.
// Parallax: slider inner translateY(scrollY * .3) inside overflow:hidden, rAF-throttled.
// Header: .scrolled when scrollY > 10. Progress bar: scaleX(scrollY / (scrollHeight - innerHeight)).
```

### Hover & Focus States
```css
a:focus-visible,button:focus-visible,select:focus-visible{outline:3px solid var(--focus);outline-offset:2px}
.card:hover .t-wheel{animation:spin .9s linear infinite}
.t-wheel{transform-box:fill-box;transform-origin:center}
@keyframes spin{to{transform:rotate(360deg)}}
```

### Special Effects
- Magnet: `pointermove` (rAF) moves CTA up to 25% of the pointer offset; only under `(hover:hover)`.
- Spotlight: card sets `--mx/--my` from pointer position (rAF).
- Canvas streaks pause via IntersectionObserver and `visibilitychange`; 40 streaks desktop, 16 under 640px.

### Reduced Motion
```css
@media (prefers-reduced-motion: reduce){
  html{scroll-behavior:auto}
  *,*::before,*::after{animation:none!important;transition:none!important}
  .split .w>span{transform:none}
  .rv-pending{opacity:1;transform:none}
  .marquee-track{transform:none}
}
```
JS also checks `matchMedia('(prefers-reduced-motion: reduce)')`: no autoplay, no scramble, no magnet, no parallax, canvas draws one still frame.

## 8. Do's and Don'ts

### Do
- Let the user's banner photography carry the emotion; keep UI chrome quiet around it.
- Keep blue for actions only, so every blue thing is clickable.
- Show specs in mono with tabular numerals; note that specs depend on configuration.
- Keep every interactive target ≥ 44×44px.
- Keep the first screen complete at rest: nothing above the fold waits on scroll.
- Write every label in TM / RU / EN through the `T` dictionary.

### Don't
- ❌ Hex values inside component CSS or JS — tokens only.
- ❌ Rounded pill buttons or radius > 2px on cards (breaks the angular system).
- ❌ More than one moving background (the hero canvas is the only one).
- ❌ `filter: blur()` on moving elements or `backdrop-filter` over large areas.
- ❌ Gradient or glowing headline text.
- ❌ Emoji as icons; use inline SVG line icons.
- ❌ Invented specs, prices, warranty terms or "official" claims not confirmed by Shanly Kerwen.
- ❌ Solid-colour placeholder blocks where a photo or truck drawing belongs.
- ❌ Scroll-jacking (Lenis / pinning) — this is a dealer site; native scroll only.
- ❌ Cropping baked-in text off the user's banners.

## 9. Responsive Behavior

**Breakpoints:**
| Name | Width | Key Changes |
|------|-------|-------------|
| Desktop | > 1080px | bento 4 columns, hero band 2 columns, services 4 columns |
| Tablet | 621–1080px | bento 2 columns, hero band stacks, services 2×2, nav collapses below 1180px |
| Mobile | ≤ 620px | 1 column, 16px gutters, stats stack, form fields stack, slider arrows 36px |

**Touch Targets:** minimum 44×44px (filters, nav links in drawer, slider dots get 44px hit area).
**Collapsing Strategy:** nav → hamburger drawer under the header at 1180px (Turkmen labels are long); no header CTA, the top bar carries the phones; language switch stays visible.

```css
@media (max-width:1080px){.bento{grid-template-columns:repeat(2,1fr)}.hero-band{grid-template-columns:1fr}}
@media (max-width:860px){.menu-btn{display:flex}.nav{display:none}.nav.open{display:flex}}
@media (max-width:620px){.wrap{padding:0 16px}.bento{grid-template-columns:1fr}.stats{grid-template-columns:1fr}}
```
