-- Discworld Misc — grab-bag of small ports from tt_dw's
-- ~/code/3p/tt_dw/scripts/misc/. Each concern is its own module
-- mirroring an upstream .tin so future syncs diff cleanly:
--
--   src/mines.lua     — dwarven-mines hazards (rockfall, stinkdamp).
--   src/ratfarm.lua   — rat-farm trap warnings.
--   src/impemon.lua   — Sourcery imp-name color codes.
--   src/djinn.lua     — flame-colour recoloring + static highlights.
--   src/gags.lua      — general-purpose spam gags from misc/gags.tin
--                       (only the world-side block above `#nop sparkle
--                       spam` — character-specific aliases and tintin
--                       runtime artifacts are intentionally skipped).
--   src/money.lua     — inline currency conversion (Genuan, Lancre,
--                       Ephebe, Agatean, Djelian, Klatch → A$).
--   src/high.lua      — general highlights port from misc/high.tin
--                       (combat, drops, charms, condition, finesmith,
--                       moonlit market, rare items, DJB stalls, …).
--                       Magic / portal / octograving rules live in
--                       discworld-magic/src/high.lua instead.
--   src/achievements.lua — clickable character name + achievement name
--                       on `[X has gained the … achievement Y]` lines.
--
-- All declarative — each `require` registers its host-API calls as
-- side effects, so this file just chains them.

require("mines")
require("ratfarm")
require("impemon")
require("djinn")
require("gags")
require("money")
require("high")
require("achievements")
