-- Inline currency conversion — port of tt_dw's
-- ~/code/3p/tt_dw/scripts/misc/money.tin.
--
-- Annotates every Discworld-currency price with its Ankh-Morpork value
-- (e.g. "5Gc" → "5Gc (A$0.03)"). Upstream uses `#sub` to wrap the match
-- in colour codes plus a computed annotation; Mallard's function-form
-- `mud.replace(pattern, function(m) return "%0 (...)" end, { fg = ... })`
-- is a direct fit — `%0` preserves the original styled span, and the
-- literal " (A$...)" annotation picks up `opts.fg`.
--
-- Every pattern wraps the currency token in a top-level capture group and
-- passes `capture = 1`. `mud.replace`'s default target is `WholeLine` —
-- without an explicit capture target, the engine would replace the entire
-- line with the template output, dropping any text on either side of the
-- price. `capture = 1` confines the rewrite to just the captured span.
--
-- Upstream's `@option{money}` toggle isn't ported — Mallard's per-plugin
-- enable/disable handles that. The `@money_with_AM` helper (used by
-- upstream to post-process arbitrary text rather than match lines) has
-- no caller in this plugin port.
--
-- All conversions normalize to "beads" (1 AM cent = 4 beads), then
-- `beads_to_AM` formats. Ratios are upstream's:
--   1 Gc  (Genuan centavo)     =   3 beads
--   1 Lp  (Lancre penny)       =  12 beads (3 = farthing, 6 = ha'penny)
--   1 de  (Ephebe denarius)    =   2 beads
--   1 s   (Agatean s)          =   4 beads
--   1 DjToon                   = 200 beads
--   1 Klatch dinar             = 500 beads

local FG = "#808080"  -- annotation tint; upstream uses xterm 238 (dark grey).

local function beads_to_AM(beads)
  beads = math.floor(beads + 0.5)
  local dollars = math.floor(beads / 400)
  local cents = math.floor((beads % 400) / 4)
  if cents == 0 then return string.format("A$%d", dollars) end
  return string.format("A$%d.%02d", dollars, cents)
end

local function annotate(beads)
  return "%0 (" .. beads_to_AM(beads) .. ")"
end

-- ───────────────────────────────────────────────────────────────
-- Ankh-Morpork money — highlight only, no conversion needed.
-- The pennies pattern fires on any `\d{1,2}p` token; that has the
-- same false-positive risk as upstream (e.g. plurals on a count
-- ending in p), which we accept for parity.
-- ───────────────────────────────────────────────────────────────

mud.style([[\b(A\$\d+(?:\.\d\d)?)\b]], { capture = 1, fg = FG })
mud.style([[\b(\d{1,2}p)\b]],          { capture = 1, fg = FG })

-- ───────────────────────────────────────────────────────────────
-- Genuan: ascending denominations Gc < Gl < Gf < Gd, comma-separated
-- digit groups within the multi-denomination tokens.
-- ───────────────────────────────────────────────────────────────

mud.replace([[\b((\d+)Gc)\b]], function(m)
  return annotate(m[2] * 3)
end, { capture = 1, fg = FG })

mud.replace([[\b((\d+),(\d+)Gl)\b]], function(m)
  return annotate(m[2] * 300 + m[3] * 3)
end, { capture = 1, fg = FG })

mud.replace([[\b((\d+),(\d+),(\d+)Gf)\b]], function(m)
  return annotate(m[2] * 3000 + m[3] * 300 + m[4] * 3)
end, { capture = 1, fg = FG })

mud.replace([[\b((\d+),(\d+),(\d+),(\d+)Gd)\b]], function(m)
  return annotate(m[2] * 30000 + m[3] * 3000 + m[4] * 300 + m[5] * 3)
end, { capture = 1, fg = FG })

-- ───────────────────────────────────────────────────────────────
-- Lancre: pre-decimal hierarchy with optional farthings + ha'pennies.
-- Five denomination prefixes Lp / Ls / LC / LSov / LH; each higher
-- prefix prepends one more pipe-separated field.
--
-- Mirrors upstream's two-step `beads_from_Lancre`: strip the trailing
-- fraction (matching either " X/D" attached to the last integer or
-- "|X/D" as a separate field), then parse the residual pipe-separated
-- integer fields. "-" stands in for 0 in upstream's serialisation.
-- ───────────────────────────────────────────────────────────────

local LANCRE_LEVELS = { Lp = 1, Ls = 2, LC = 3, LSov = 4, LH = 5 }
local LANCRE_FACTORS = { 12, 144, 1728, 20736, 248832 }

local function strip_lancre_fraction(body)
  local frac = 0
  local pre, n = body:match("^(.-)[ |]?(%d+)/4$")
  if pre and n then frac = frac + tonumber(n) * 3; body = pre end
  pre, n = body:match("^(.-)[ |]?(%d+)/2$")
  if pre and n then frac = frac + tonumber(n) * 6; body = pre end
  return frac, body
end

local function parse_lancre_integer(prefix, body)
  if body == "" then return 0 end
  local levels = LANCRE_LEVELS[prefix]
  local parts = {}
  for p in (body .. "|"):gmatch("([^|]*)|") do parts[#parts + 1] = p end
  if #parts < levels then return 0 end
  local beads = 0
  for i = 1, levels do
    local p = parts[i]
    local v = (p == "-") and 0 or (tonumber(p) or 0)
    beads = beads + v * LANCRE_FACTORS[levels - i + 1]
  end
  return beads
end

local function lancre_annot(prefix)
  return function(m)
    local frac, residual = strip_lancre_fraction(m:raw(2))
    return annotate(frac + parse_lancre_integer(prefix, residual))
  end
end

mud.replace([[\b(Lp (\d+ \d/[24]|\d/[24]|\d+))\b]],
  lancre_annot("Lp"), { capture = 1, fg = FG })

mud.replace([[\b(Ls (\d+\|(?:-|\d+)(?:(?: \d)?/[24])?))\b]],
  lancre_annot("Ls"), { capture = 1, fg = FG })

mud.replace([[\b(LC (\d+\|(?:-|\d+)\|(?:-|\d+)(?:(?: \d)?/[24])?))\b]],
  lancre_annot("LC"), { capture = 1, fg = FG })

mud.replace([[\b(LSov (\d+\|(?:-|\d+)\|(?:-|\d+)\|(?:-|\d+)(?:(?: \d)?/[24])?))\b]],
  lancre_annot("LSov"), { capture = 1, fg = FG })

mud.replace([[\b(LH (\d+\|(?:-|\d+)\|(?:-|\d+)\|(?:-|\d+)\|(?:-|\d+)(?:(?: \d)?/[24])?))\b]],
  lancre_annot("LH"), { capture = 1, fg = FG })

-- ───────────────────────────────────────────────────────────────
-- Ephebe: optional minas (NM), optional silvers (SN|), then denarii
-- (Nde). 1 mina = 50 silvers = 4800 de; 1 silver = 96 de.
-- ───────────────────────────────────────────────────────────────

mud.replace([[\b((?:\d+M )?(?:S\d{1,2}\|)?\d{1,2}de)\b]], function(m)
  local s = m:raw(1)
  local beads = 0
  local mina = s:match("^(%d+)M ")
  if mina then beads = beads + tonumber(mina) * 9600 end
  local silver = s:match("S(%d+)|")
  if silver then beads = beads + tonumber(silver) * 192 end
  local denarii = s:match("(%d+)de$")
  if denarii then beads = beads + tonumber(denarii) * 2 end
  return annotate(beads)
end, { capture = 1, fg = FG })

-- ───────────────────────────────────────────────────────────────
-- Agatean (Bes Pelargic): "NRh" or "NRh Ns". Upstream deliberately
-- excludes the bare "Ns" form ("too many false positives, see #69").
-- ───────────────────────────────────────────────────────────────

mud.replace([[\b(\d+Rh \d{1,3}s|\d+Rh)\b]], function(m)
  local s = m:raw(1)
  local beads = 0
  local rh = s:match("^(%d+)Rh")
  if rh then beads = beads + tonumber(rh) * 480 end
  local sm = s:match(" (%d+)s$")
  if sm then beads = beads + tonumber(sm) * 4 end
  return annotate(beads)
end, { capture = 1, fg = FG })

-- ───────────────────────────────────────────────────────────────
-- Djelian: "DjToon X.YZ" — 1 DjToon = 200 beads. Upstream does
-- `&1.&2 * 200` (dotted-pair → decimal multiply), which is a plain
-- decimal multiplication on the captured number.
-- ───────────────────────────────────────────────────────────────

mud.replace([[\b(DjToon (\d+\.\d\d))\b]], function(m)
  return annotate(tonumber(m:raw(2)) * 200)
end, { capture = 1, fg = FG })

-- ───────────────────────────────────────────────────────────────
-- Klatch: "N dr" or "N,DD dr" (comma as decimal separator). 1 dinar
-- = 500 beads.
-- ───────────────────────────────────────────────────────────────

mud.replace([[\b((\d+(?:,\d\d)?) dr)\b]], function(m)
  local raw = m:raw(2):gsub(",", ".")
  return annotate(tonumber(raw) * 500)
end, { capture = 1, fg = FG })
