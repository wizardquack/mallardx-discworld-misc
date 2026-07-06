-- Follow requests — make the suggested command clickable.
--
-- Source line shape (one full line):
--   Lyna is requesting to be able to follow you.  Use 'follow accept lyna'.
--
-- The quoted command → suppressed send of that command verbatim.
-- Unlike item offers, the server quotes this command with single
-- quotes rather than double quotes.
--
-- We capture the line in three spans — the prefix up to and including
-- the opening quote, the command itself, and the closing quote plus
-- trailing text — so the original wording and whitespace are replayed
-- untouched and only the command becomes clickable.

mud.replace(
  [[^(.+ is requesting to be able to follow you\.\s+Use ')(follow accept \w+)('\.)$]],
  function(m)
    return mud.span(m[1])
      .. mud.span(m[2], { send = m[2] })
      .. mud.span(m[3])
  end
)
