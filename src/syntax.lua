-- Command-syntax hint — make the suggested command clickable.
--
-- Source line shape (one full line), emitted whenever you type a
-- command with input the parser doesn't recognise:
--   See "syntax eat" for the input patterns.
--   See "syntax turn" for the input patterns.
--   See "syntax s" for the input patterns.
--
-- The quoted `syntax <command>` → suppressed send of that command
-- verbatim, so clicking pulls up the parser's accepted input patterns
-- for whatever verb you just fumbled. The command name is a single
-- word (the game only ever splices one verb in here, `syntax` itself
-- included, e.g. `syntax syntax`).
--
-- We capture the line in three spans — the prefix up to and including
-- the opening quote, the command itself, and the closing quote plus
-- trailing text — so the original wording and whitespace are replayed
-- untouched and only the command becomes clickable.

mud.replace(
  [[^(See ")(syntax \w+)(" for the input patterns\.)$]],
  function(m)
    return mud.span(m[1])
      .. mud.span(m[2], { send = m[2] })
      .. mud.span(m[3])
  end
)
