-- Follow requests — make the suggested command clickable.
--
-- Source line shapes (each one full line), per session logs:
--   Lyna is requesting to be able to follow you.  Use 'follow accept lyna'.
--   Terrible Kiki totally is requesting to be able to follow you.  Use "follow accept kiki".
--   Captain Visk Shtick invites you to follow him.  Use "follow accept visk" to accept.
--
-- The quoted command → suppressed send of that command verbatim.
-- The server has emitted both single and double quotes around the
-- command over time (logs show singles through early 2026, doubles
-- from spring 2026), so we accept either; the inviter-initiated
-- variant additionally appends " to accept".
--
-- We capture the line in three spans — the prefix up to and including
-- the opening quote, the command itself, and the closing quote plus
-- trailing text — so the original wording and whitespace are replayed
-- untouched and only the command becomes clickable.

mud.replace(
  [[^(.+ (?:is requesting to be able to follow you|invites you to follow (?:him|her|it|them))\.\s+Use ['"])(follow accept \w+)(['"](?: to accept)?\.)$]],
  function(m)
    return mud.span(m[1])
      .. mud.span(m[2], { send = m[2] })
      .. mud.span(m[3])
  end
)
