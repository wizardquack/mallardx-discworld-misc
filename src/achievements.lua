-- Achievement gain announcements — make the character name and the
-- achievement name clickable.
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
