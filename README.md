# Discworld Misc

A grab-bag plugin porting small slices of tt_dw's `scripts/misc/`:

| Module           | Source            | What it does |
|------------------|-------------------|--------------|
| `src/mines.lua`  | `mines.tin`       | Hazard highlights for dwarven-mines rockfall + stinkdamp gas. |
| `src/ratfarm.lua`| `ratfarm.tin`     | Trap highlights for the rat farm — boulder, arrow-slits, trapdoor, tripwire, loot crates. |
| `src/impemon.lua`| `impemon.tin`     | Colour-codes Sourcery-event imp names by tier (cyan / yellow / bold / red / magenta). |
| `src/djinn.lua`  | `djinn.tin`       | Recolours captured flame-colour words at the willing well and on flame-weapon invocations; static red/green highlights for invocation success/failure. |
| `src/gags.lua`   | `gags.tin` (top)  | Gags world-side pet/summon movement spam, sneaking notice, MWLC/UPDD/Hag's-blessing critter spam, and the rtfm-list-all discussion notice. |
| `src/money.lua`  | `money.tin`       | Inline currency conversion — annotates every Discworld-currency price with its Ankh-Morpork value (`5Gc` → `5Gc (A$0.03)`). Covers Genuan, Lancre, Ephebe, Agatean, Djelian, Klatch; AM dollars + pennies get a static highlight. |
| `src/high.lua`   | `high.tin`        | General gameplay highlights — combat / death, item handoff, drop / theft mishaps, condition descriptors, finesmithing, charm bracelets, ritual failures, warpaint, blight, Celestial Anchor, Breathe Underwater, moonlit-market full moon, rare mission items, DJB bazaar stall labels. (Magic / portal / octograving blocks of `high.tin` are ported in `discworld-magic` instead.) |

`[worlds] match = ["discworld.starturtle.net:*"]` — auto-enabled when connected to Discworld, no-op elsewhere. No `[permissions]` needed: declarative-only, no sends, no GMCP.

## Translation conventions (same as `discworld-sailing`)

| Tintin token  | Rust regex                                  |
|---------------|---------------------------------------------|
| `%*`          | `.*`                                        |
| `{a\|b\|c}`   | `(?:a\|b\|c)`                               |
| `%1`, `%2`, … | `(.+?)` capture groups (left-to-right)      |
| `%i…`         | inline `(?i)` flag                          |
| `\b`          | stays `\b` (works in Lua `[[long]]` strings)|

## Notable trade-offs vs upstream

- **No TTS / desktop notification** for mines & ratfarm hazards. Upstream calls `/speak` (TTS for screen-reader users); Mallard's only analog is `ui.notify`, which is too disruptive for the cadence of hazard lines. Colour + bold conveys the alert visually. To revisit when there's a quieter notification primitive.
- **`djinn.lua` enumerates flame colours.** The upstream `@color_code{%1}` trick (capture the colour name, apply *that* colour) was originally fanned out across `red / orange / yellow / green / blue / magenta` because `mud.style`'s `fg` was a static string. Function-valued `fg` (shipped 2026-05-29 with the match-object API) now makes a single dynamic-colour call site expressible; the existing fan-out still works and was not migrated as part of the API redesign. Unrecognised colours still display, just without the recolour.
- **Most of `gags.tin` is not ported.** Only the top block (above `#nop sparkle spam`) is portable as general-purpose — the rest gags echoes of character-specific tintin aliases (`gm`, `pamper`, `lootcloud`, `og`, `s2d`, FNP, memo …) and tintin runtime artefacts (`Queued command: alias wc wc`, `Rows changed from X to Y`) that can't fire in Mallard.

## Not (yet) ported from `misc/`

| Source            | Why deferred |
|-------------------|--------------|
| `urls.tin`        | URL collector + open alias. Self-contained but introduces state + a launch-URL host call; punt to a possible v0.2. |
| `followers.tin`   | Dynamic gag-list rebuilding from a runtime followers var; needs a small state machine. v0.2 candidate. |
| `burden.tin`      | Heavy use of tintin format primitives (`#format`, `#switch`) for inline weight bars. Doable but verbose; v0.2 candidate. |
| `afterinventory.tin` | Elegant-ring login spam — small, but specific to one ring/character. Not generally useful. |
| `spellingcheck.tin` | Input-line spellcheck; needs a keypress event hook Mallard doesn't expose. |
| `alias.tin`       | Defines `/x` slash-shortcuts that route to other tintin slash-commands — no clean target on Mallard. |
| `chat.tin`        | Already covered by `discworld-chat`. |
| `combat.tin`, `high.tin`, `notes.tin`, `sts.tin`, `actions.tin`, `targets.tin`, `keymap.tin`, `help.tin`, `horse.tin`, `autocols.tin`, `switch_user.tin`, `config.tin` | Out of scope for a small "misc" port (size, character-specificity, or already covered elsewhere). |

## Dev rebuild

```sh
bash scripts/reinstall.sh
```

## Changelog

### v0.3.0
Add `high.lua` — port of the general-purpose highlight rules from `misc/high.tin` (combat, drops, condition, finesmithing, charm bracelets, blight, ritual failure, Celestial Anchor, Clarify, Breathe Underwater, moonlit market, ~80 rare mission items, ~30 DJB bazaar stall labels, …). The magic / portal-failure / octograving subsections of `high.tin` move to `discworld-magic/src/high.lua` since they're magic-domain feedback.

### v0.2.0
Add `money.lua` — inline currency conversion for Genuan, Lancre, Ephebe, Agatean, Djelian, and Klatch coins, plus a static highlight for Ankh-Morpork dollars and pennies. Unblocks the previously-deferred `money.tin` row now that `mud.replace` supports function-form templates.

### v0.1.0
Initial port: mines + ratfarm hazards, impemon flavor, djinn flame recolours, general-purpose `gags.tin` top block.
