-- Group invitation lines — make the suggested `group join <name>`
-- command clickable so accepting an invite is a single click.
--
-- Source line shape (one full line):
--   You have been invited by Terrible Kiki totally to join her group
--   called 'boatboat'.  You have 120 seconds to join the group before
--   the invitation is withdrawn.  Use "group join kiki" to join.
--
-- `group join kiki` (inside the double quotes) → suppressed send of
-- the same command verbatim.

mud.replace(
  [[^(.+Use ")(group join \w+)(" to join\.)$]],
  function(m)
    return mud.span(m[1])
      .. mud.span(m[2], { send = m[2] })
      .. mud.span(m[3])
  end
)
