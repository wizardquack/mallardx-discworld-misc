-- Copied from discworld-teaching (6e1ce5a, src/learner.lua). Plugins can't share code,
-- so this is a copy: refresh it from there, don't edit it here.
--
-- Learner identity — turn a display name into a login name.
--
-- Teaching lines name the learner the way the MUD renders a player
-- anywhere else: pre-titles, then the login name, then post-titles.
--
--   Deckhand Dilbo                 -> Dilbo        (achievement pre-title)
--   Terrible Kiki totally          -> Kiki         (pre-title + post-title)
--   Paranoid Kiki totally          -> Kiki         (a different pre-title)
--   Plump Arroz con Pollo          -> Arroz        (wizard pre-title)
--   Mr Invictus                    -> Invictus
--   brodiepops                     -> brodiepops   (no titles at all)
--
-- Resolving matters because pre-titles are not stable: achievement titles
-- appear as players earn achievements, guild titles change with guild
-- level, and court / duelling titles expire after a day. Keyed on the raw
-- display name, one player becomes several learners — Kiki above is a
-- single person who has taught under at least two names.
--
-- The algorithm is asymmetric, and deliberately so:
--
--   * Pre-titles are matched against an inventory (src/titles.lua,
--     generated from the Discworld wiki). Longest match first, repeatedly,
--     so a multi-word title beats the shorter title that prefixes it, and
--     stacked titles ("Wicked Old Nanny Esme") all come off.
--
--   * Post-titles need no inventory: whatever follows the login name is
--     one. That is what makes the whole thing tractable, because
--     post-titles can be arbitrary — "totally" and "con Pollo" above are
--     not documented titles at all, they come from title-changer items.
--
-- So: strip known pre-titles, and the first remaining token is the name.
--
-- Two guards keep it honest:
--
--   * Stripping never consumes the last remaining token, so a player
--     whose login name happens to BE a title ("Old", "Fingers",
--     "Champion" are all real titles) still resolves to themselves.
--
--   * The raw display name is stored alongside the resolved one and
--     reports can show it, so a missing or wrong inventory entry is
--     visible and fixable — `/teach alias` overrides any resolution
--     retroactively, since aliases are applied at query time.

local titles = require("titles")

local M = {}

-- Split on runs of whitespace. Display names are single-spaced in practice;
-- this is just defensive against a double space sneaking through.
local function tokenize(s)
  local out = {}
  for word in s:gmatch("%S+") do out[#out + 1] = word end
  return out
end

local function join(tokens, from, to)
  local parts = {}
  for i = from, to do parts[#parts + 1] = tokens[i] end
  return table.concat(parts, " ")
end

-- resolve(display) -> name, prefix, postfix
--
--   name    — the login name (never nil for a non-empty input)
--   prefix  — the pre-titles that were stripped, or nil
--   postfix — everything after the name, or nil
function M.resolve(display)
  if type(display) ~= "string" then return nil end
  local tokens = tokenize(display)
  if #tokens == 0 then return nil end

  local i = 1
  while true do
    -- Never strip the last token: it is the name by elimination, even when
    -- it is spelled like a title.
    local room = #tokens - i
    if room < 1 then break end
    local matched = nil
    for n = math.min(titles.MAX_WORDS, room), 1, -1 do
      if titles.PREFIX[join(tokens, i, i + n - 1):lower()] then
        matched = n
        break
      end
    end
    if not matched then break end
    i = i + matched
  end

  local prefix  = (i > 1) and join(tokens, 1, i - 1) or nil
  local postfix = (i < #tokens) and join(tokens, i + 1, #tokens) or nil
  return tokens[i], prefix, postfix
end

-- Convenience: just the name.
function M.name_of(display)
  local name = M.resolve(display)
  return name or display
end

return M
