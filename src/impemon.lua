-- Sourcery imp-name highlights — port of tt_dw's
-- ~/code/3p/tt_dw/scripts/misc/impemon.tin.
--
-- Upstream uses `#foreach { name1; name2; ... } imp { #high {\b$imp\b} {color} }`
-- to fan out a colour across a list of imp names. Expanded inline here
-- because the cardinality is small (one mud.style per imp) and that
-- makes searching for a specific imp name straightforward.

-- Cyan tier.
for _, name in ipairs({ "basilimp", "dryimp", "Impa Yaga", "medusimp", "vimpyre" }) do
  mud.style([[\b(]] .. name .. [[)\b]], { capture = 1, fg = "cyan" })
end

-- Yellow tier.
for _, name in ipairs({ "banshimp", "dragimp", "grimpyn", "himpogryph", "Imp Nac Feegle", "would nimph" }) do
  mud.style([[\b(]] .. name .. [[)\b]], { capture = 1, fg = "yellow" })
end

-- Bold-only tier (no colour swap; upstream uses {Bold}).
for _, name in ipairs({ "centimp", "Dr Frankenimp", "Frankenimp's monster", "grimp reaper" }) do
  mud.style([[\b(]] .. name .. [[)\b]], { capture = 1, bold = true })
end

-- Red tier.
for _, name in ipairs({ "impicorn", "impubus", "phoenimp", "sphimpx" }) do
  mud.style([[\b(]] .. name .. [[)\b]], { capture = 1, fg = "red" })
end

-- Magenta tier.
for _, name in ipairs({ "impotaur", "Lancre Ness impster", "mermimp", "sirimp" }) do
  mud.style([[\b(]] .. name .. [[)\b]], { capture = 1, fg = "magenta" })
end
