-- General-purpose spam gags — port of the world-side block at the top
-- of tt_dw's ~/code/3p/tt_dw/scripts/misc/gags.tin (everything above
-- the `#nop sparkle spam` comment).
--
-- The character-specific tintin++ aliases and tintin runtime artefacts
-- (`Queued command: alias wc wc`, `Rows changed from X to Y`, …) are
-- intentionally skipped — they can't fire in Mallard.
--
-- Gags use `mud.gag(pattern)`; span strips (where the gag has to delete
-- only a substring from a multi-critter line) use `mud.replace(pattern, "")`.
-- The MWLC / UPDD / fireflies blocks deliberately keep three separate
-- patterns rather than `mud.gag_substring`: the standalone-line variant
-- starts with a capital "A", but in a mid-list context Discworld emits
-- lowercase "a small blue light is zipping about". The substring helper
-- escapes a single canonical text into all three positions, so it can't
-- model the case asymmetry — we'd lose either the gag-alone match
-- (lowercase form) or the strip-back match (capital form).

-- ───────────────────────────────────────────────────────────────
-- Pet / summon movement spam.
--
-- Upstream builds a giant case-insensitive regex out of three pieces:
-- a list of known pet names, a list of known summons/spell-effects,
-- and a list of movement verbs. The full pattern fires when a line
-- starts with one-or-more of those critters followed by a movement
-- verb. Reproduced here as Lua string concatenation for readability.
-- ───────────────────────────────────────────────────────────────

local pet = [[\w+ the mynah bird|an? (?:astonished chicken|battered old owl|intelligent black raven|proud black duck|young goose|[\w-]+(?: [\w-]+)? (?:moon|swamp) dragon|deadly fluffy hawk|scrawny tabby cat)]]
local summon = [[\w+ cabbages|an? (?:tiny .+ moth|cabbage|[\w-]+(?: [\w-]+)? cloud|small blue light|swarm of fireflies|skeleton warrior|\w+ spectre|\w+ salamander)]]
local critter = "(?:" .. pet .. "|" .. summon .. ")"
local critters = "(?:" .. critter .. "(?:, | and )?)+"
local movements = [[(?:trot|emerge|swim|flutter|succeed|arrive|journey|precede|follow|float)s?(?: you in)?]]

mud.gag("(?i)^" .. critters .. " " .. movements)

-- ───────────────────────────────────────────────────────────────
-- Standalone sneaking notice.
-- ───────────────────────────────────────────────────────────────

mud.gag([[^You continue sneaking\.$]])

-- ───────────────────────────────────────────────────────────────
-- MWLC — "magic-weapon light cloud" spell-effect spam.
-- Standalone line gagged outright; first-of-list and last-of-list
-- variants get their fragment stripped so the rest of the line
-- (other critters) survives.
-- ───────────────────────────────────────────────────────────────

mud.gag    ([[^A small blue light is zipping about\.$]])
mud.replace([[^A small blue light is zipping about(?:,| and) ]],  "")
mud.replace([[(?: and|,) a small blue light is zipping about]],   "")

-- ───────────────────────────────────────────────────────────────
-- UPDD — undirected pest-distraction display (tiny moth).
-- ───────────────────────────────────────────────────────────────

mud.gag    ([[^A tiny .+ moth is flittering about\.$]])
mud.replace([[^A tiny .+ moth is flittering about(?:,| and) ]],   "")
mud.replace([[(?: and|,) a tiny .+ moth is flittering about]],    "")

-- ───────────────────────────────────────────────────────────────
-- Hag's-blessing fireflies.
-- ───────────────────────────────────────────────────────────────

mud.gag    ([[^A swarm of fireflies is buzzing around\.$]])
mud.replace([[^A swarm of fireflies is buzzing around(?:,| and) ]], "")
mud.replace([[(?: and|,) a swarm of fireflies is buzzing around]],  "")

-- ───────────────────────────────────────────────────────────────
-- "rtfm list all" discussion-items reminder — global notice, gagged.
-- ───────────────────────────────────────────────────────────────

mud.gag([[^There are discussion items you have not voted for, use "rtfm list all" for a list\.$]])
