-- Teaching offers — make the suggested `learn` command clickable.
--
-- Command-teaching offers spell out the whole command on one line, so
-- the quoted text is sent verbatim:
--   Type "learn steal from kordane" to learn the command.
--
-- Skill-teaching offers only hint at it, across two lines:
--   Quantum Quow Bell offers to teach you 38 levels of crafts.husbandry.animal.grooming for 1006261 xp.
--   Use "learn" to learn the skill.
--
-- Bare `learn` is NOT a valid command (`learn <skill/command> from
-- <living>` is the only syntax), so the link on the hint line has to be
-- rebuilt from the offer line before it. The teacher appears there as a
-- display name, and learner.lua reduces that to the single-word character
-- name the command needs (`Quantum Quow Bell` → `quow`).
--
-- We capture each hint line in three spans so the original wording and
-- whitespace are replayed untouched and only the command becomes
-- clickable.

local learner = require("learner")

mud.replace(
  [[^(Type ")(learn \w+ from \w+)(" to learn the command\.)$]],
  function(m)
    return mud.span(m[1])
      .. mud.span(m[2], { send = m[2] })
      .. mud.span(m[3])
  end
)

-- The command for the most recent skill offer, spent by the hint line
-- that follows it.
local pending_learn = nil

mud.trigger(
  [[^(.+) offers to teach you \d+ levels? of (\S+) for \d+ xp\.$]],
  function(m)
    pending_learn = "learn " .. m[2] .. " from " .. learner.name_of(m[1]):lower()
  end
)

mud.replace(
  [[^(Use ")(learn)(" to learn the skill\.)$]],
  function(m)
    local command = pending_learn
    pending_learn = nil
    if not command then
      return mud.span(m[1] .. m[2] .. m[3])
    end
    return mud.span(m[1])
      .. mud.span(m[2], { send = command })
      .. mud.span(m[3])
  end
)
