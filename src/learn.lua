-- Command-teaching offers — make the suggested command clickable.
--
-- Source line shape (one full line, follows an `… offers to teach you
-- the command "…".` line):
--   Type "learn steal from kordane" to learn the command.
--
-- The quoted command → suppressed send of that command verbatim.
--
-- Only the command-teaching variant is handled here: it is the one
-- where the server spells out the full `learn <cmd> from <teacher>`
-- command. Skill-teaching offers instead end with a bare
-- `Use "learn" to learn the skill.` hint, and bare `learn` is NOT a
-- valid command (`learn <skill/command> from <living>` is the only
-- syntax) — linkifying that line would need the skill and teacher
-- reconstructed from the preceding offer line, which we deliberately
-- don't attempt.
--
-- We capture the line in three spans — the prefix up to and including
-- the opening quote, the command itself, and the closing quote plus
-- trailing text — so the original wording and whitespace are replayed
-- untouched and only the command becomes clickable.

mud.replace(
  [[^(Type ")(learn \w+ from \w+)(" to learn the command\.)$]],
  function(m)
    return mud.span(m[1])
      .. mud.span(m[2], { send = m[2] })
      .. mud.span(m[3])
  end
)
