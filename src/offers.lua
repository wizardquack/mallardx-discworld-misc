-- Item-offer announcements — make the suggested command clickable.
--
-- Source line shape (one full line):
--   Deckhand Dilbo offers you a smuggler's longcoat for inspection.  Use "show accept offer from dilbo" to view it.
--
-- The quoted command → suppressed send of that command verbatim.
--
-- We capture the line in three spans — the prefix up to and including
-- the opening quote, the command itself, and the closing quote plus
-- trailing text — so the original wording and whitespace are replayed
-- untouched and only the command becomes clickable.

mud.replace(
  [[^(.+ for inspection\.\s+Use ")(.+)(" to view it\.)$]],
  function(m)
    return mud.span(m[1])
      .. mud.span(m[2], { send = m[2] })
      .. mud.span(m[3])
  end
)
