-- Give offers — make the suggested command clickable.
--
-- Source line shape (one full line, and note it arrives *before* the
-- `… offers to give … to you.` line it refers to):
--   Use the command "give accept from wait" to accept the offer.
--
-- The quoted command → suppressed send of that command verbatim.
--
-- The command is captured generically rather than pinned to
-- `give accept …`: `give` has a `slip` variant (`give accept slip
-- [things] [from] <living>`, per `syntax give`) and the offerer's
-- short name is whatever the server splices in, so anything the
-- server quotes inside this sentence frame is the command it wants
-- you to run.
--
-- We capture the line in three spans — the prefix up to and including
-- the opening quote, the command itself, and the closing quote plus
-- trailing text — so the original wording and whitespace are replayed
-- untouched and only the command becomes clickable.

mud.replace(
  [[^(Use the command ")([^"]+)(" to accept the offer\.)$]],
  function(m)
    return mud.span(m[1])
      .. mud.span(m[2], { send = m[2] })
      .. mud.span(m[3])
  end
)
