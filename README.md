# Discworld Misc

An opinionated plugin porting some bits of tt_dw's `scripts/misc/`:

| Module           | Source            | What it does |
|------------------|-------------------|--------------|
| `src/mines.lua`  | `mines.tin`       | Hazard highlights for dwarven-mines rockfall + stinkdamp gas. |
| `src/ratfarm.lua`| `ratfarm.tin`     | Trap highlights for the rat farm — boulder, arrow-slits, trapdoor, tripwire, loot crates. |
| `src/impemon.lua`| `impemon.tin`     | Colour-codes Sourcery-event imp names by tier (cyan / yellow / bold / red / magenta). |
| `src/djinn.lua`  | `djinn.tin`       | Recolours captured flame-colour words at the willing well and on flame-weapon invocations; static red/green highlights for invocation success/failure. |
| `src/gags.lua`   | `gags.tin` (top)  | Gags world-side pet/summon movement spam, sneaking notice, MWLC/UPDD/Hag's-blessing critter spam, and the rtfm-list-all discussion notice. |
| `src/money.lua`  | `money.tin`       | Inline currency conversion — annotates every Discworld-currency price with its Ankh-Morpork value (`5Gc` → `5Gc (A$0.03)`). Covers Genuan, Lancre, Ephebe, Agatean, Djelian, Klatch; AM dollars + pennies get a static highlight. |
| `src/high.lua`   | `high.tin`        | General gameplay highlights — combat / death, item handoff, drop / theft mishaps, condition descriptors, finesmithing, charm bracelets, ritual failures, warpaint, blight, Celestial Anchor, Breathe Underwater, moonlit-market full moon, rare mission items, DJB bazaar stall labels. (Magic / portal / octograving blocks of `high.tin` are ported in `discworld-magic` instead.) |
