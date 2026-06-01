-- Djinn / willing-well flame highlights — port of tt_dw's
-- ~/code/3p/tt_dw/scripts/misc/djinn.tin.
--
-- Upstream uses `@color_code{%1}` to dynamically map a captured colour
-- word to its ANSI code. Mallard's `mud.style` takes a static `fg`, so
-- we fan each pattern out across the rainbow palette below. Lines with
-- a flame colour outside this set will still display correctly — they
-- just won't be recoloured. Add a new entry to FLAME_COLORS if you spot
-- one.
--
-- Upstream's `#act` bookkeeping (tracking which weapons currently have
-- flames in a `djinn[flame][...]` variable) is not ported — that state
-- has no consumer in this plugin.

-- Mallard palette names approximating the willing-well rainbow. No
-- portable name for indigo/violet, so magenta covers the cool end.
local FLAME_COLORS = { "red", "orange", "yellow", "green", "blue", "magenta" }

-- (pattern, capture-index) pairs — one mud.style per (pattern, colour).
-- The pattern must contain a single literal-colour capture group; the
-- `%s` slot is filled with each FLAME_COLORS entry in turn.
local PATTERNS = {
  { [[^The willing well swirls its contents into a small whirlpool, changing them (%s) in the process\.$]],          1 },
  { [[^A deep pool of (%s) liquid ripples within the willing well\.$]],                                              1 },
  { [[^The faintest of (%s) flames can be seen washing over the surface\.]],                                         1 },
  { [[crackles with energy and (%s) flames flare across]],                                                           1 },
  { [[^(?:.+?) crackles with energy and (%s) flames flare across its surface\.$]],                                   1 },
}

for _, pc in ipairs(PATTERNS) do
  local pat_tpl, capture = pc[1], pc[2]
  for _, color in ipairs(FLAME_COLORS) do
    mud.style(pat_tpl:format(color), { capture = capture, fg = color })
  end
end

-- Static highlights — flame state, invocation success/failure, cooldown.
mud.style([[You will be able to invoke them again once you've recovered a little more of your strength from the previous usage\.$]], { fg = "red" })
mud.style([[^Despite your best efforts, you can't seem to invoke the power of .+? and you feel you have poured rather too much of your vitality into the attempt\.$]], { fg = "red" })
mud.style([[^The crackling flames around .* die down\.$]],                                                       { fg = "red", bold = true })
mud.style([[^Without .+? in your hands, your connection is too weak and the flames around it die out\.$]],       { fg = "red", bold = true })
mud.style([[^The flames around .+? sputter for a moment, looking a little less fierce\.$]],                      { fg = "red" })
mud.style([[^You (?:successfully )?invoke .+?, leaving you a little drained as a result\.$]],                    { fg = "green", bold = true })
mud.style([[^You feel you have regained enough strength to invoke a flame weapon again\.$]],                     { fg = "green", bold = true })
