-- Achievements — clickable names on gain announcements and on the
-- `achievement details <name>` report.

-- ---------------------------------------------------------------
-- Gain announcements
-- ---------------------------------------------------------------
--
-- Source line shape (one full line):
--   [Kettu has gained the huge achievement Numberchasing Nirvana]
--
-- Character name → suppressed send of `finger <name>`.
-- Achievement name → suppressed send of `achievement details <name>`.
--
-- The size adjective ("huge" in the example) varies — small, modest,
-- impressive, huge, etc. — so we capture it and replay it verbatim
-- between the two clickable spans.

mud.replace(
  [[^\[(\w+) has gained the (\w+) achievement (.+)\]$]],
  function(m)
    return mud.span("[")
      .. mud.span(m[1], { send = "finger " .. m[1] })
      .. mud.span(" has gained the " .. m[2] .. " achievement ")
      .. mud.span(m[3], { send = "achievement details " .. m[3] })
      .. mud.span("]")
  end
)

-- ---------------------------------------------------------------
-- `achievement details <name>` — category list
-- ---------------------------------------------------------------
--
-- Source line shapes (label and value separated by column padding,
-- the label pluralised to match the count):
--   Achievement Category     Bes Pelargic
--   Achievement Category     Guilds and Spells
--   Achievement Categories   Guilds, Fencing and Wealth
--
-- Each category → suppressed send of `achievement list category <x>`,
-- lowercased with internal spaces kept (`Bes Pelargic` →
-- `achievement list category bes pelargic`).
--
-- The list is comma-separated with a bare `and` before the final
-- entry and no Oxford comma, so we walk it separator by separator and
-- replay each separator verbatim between the clickable spans. A
-- category whose own name contained ` and ` would be split in two —
-- no such category exists, and the list grammar gives us nothing to
-- tell the two apart anyway.

-- `mud.span` rejects empty text, and the trailing-padding capture is
-- empty whenever the value runs to the end of the line, so append it
-- only when there is something to append.
local function append_padding(out, padding)
  if padding == "" then
    return out
  end
  return out .. mud.span(padding)
end

-- Split a rendered list into alternating value / separator pieces:
-- odd indices are categories, even indices the separators between
-- them, so concatenating the lot reproduces the input exactly.
local function split_list(list)
  local pieces = {}
  local rest = list

  while true do
    local comma_s, comma_e = rest:find(",%s+")
    local and_s, and_e = rest:find("%s+and%s+")

    local sep_s, sep_e
    if comma_s and (not and_s or comma_s < and_s) then
      sep_s, sep_e = comma_s, comma_e
    else
      sep_s, sep_e = and_s, and_e
    end

    if not sep_s then
      pieces[#pieces + 1] = rest
      return pieces
    end

    pieces[#pieces + 1] = rest:sub(1, sep_s - 1)
    pieces[#pieces + 1] = rest:sub(sep_s, sep_e)
    rest = rest:sub(sep_e + 1)
  end
end

mud.replace(
  [[^(Achievement Categor(?:y|ies)\s+)(.*\S)(\s*)$]],
  function(m)
    local out = mud.span(m[1])

    for i, piece in ipairs(split_list(m[2])) do
      if i % 2 == 1 then
        out = out
          .. mud.span(piece, {
            send = "achievement list category " .. piece:lower(),
          })
      else
        out = out .. mud.span(piece)
      end
    end

    return append_padding(out, m[3])
  end
)

-- ---------------------------------------------------------------
-- `achievement details <name>` — record holders
-- ---------------------------------------------------------------
--
-- Source line shapes:
--   First Achieved By        Noshoes
--   Last Achieved By         Noshoes
--   First Achieved By        No One Yet...
--
-- Player name → suppressed send of `finger <name>`.
--
-- An unearned achievement reports `No One Yet...` here, and very old
-- records are credited to `Great A'Tuin` rather than to a player.
-- Both are left plain: the value is only linkified when it is a lone
-- capitalised word, which is the only shape a real character name can
-- take (creation rejects spaces and punctuation), so anything the
-- game splices in as a stand-in falls through untouched.

mud.replace(
  [[^((?:First|Last) Achieved By\s+)([A-Z][a-z]+)(\s*)$]],
  function(m)
    return append_padding(
      mud.span(m[1]) .. mud.span(m[2], { send = "finger " .. m[2] }),
      m[3]
    )
  end
)
