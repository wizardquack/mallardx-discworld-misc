-- General highlights — port of tt_dw's
-- ~/code/3p/tt_dw/scripts/misc/high.tin.
--
-- Covers everything in upstream's highlight class EXCEPT the slices
-- carved out elsewhere:
--   - aliased-highlighting wrappers (`^#high %1 %w$` etc.) — tintin-only
--     alias plumbing; no Mallard equivalent.
--   - journey / `@shorten_journey` — relies on tintin's `@dirs_arrow`,
--     `@numberize`, `@color_arrows` text helpers.
--   - magic / portal-failures / octograving — moved to
--     discworld-magic/src/high.lua (they're magic-domain feedback that
--     happens to live in misc/high.tin upstream).
--   - movement-arrives block at the bottom — character-specific (only
--     triggers on a hardcoded list of nicks).
--   - the two `#gag` lines under `misc stuff` — tintin runtime
--     artifacts (alias-change notices).
--   - upstream's `Queued command:` / `Removed queue.` highlights —
--     also tintin runtime artifacts that can't fire in Mallard.
--
-- Color mapping:
-- - ANSI palette names (red/green/yellow/blue/magenta/cyan/white,
--   plus their `light X` variants, `pink`, `orange`, `light orange`)
--   map 1:1. Tintin's `silver` and extended `<NNN>` codes do not have
--   direct Mallard equivalents — we approximate with the closest named
--   palette entry and document any deliberate deviation inline.
-- - Tintin `bold X` → `{ fg = X, bold = true }`.
-- - Tintin `X b Y` → `{ fg = X, bg = Y }`.
-- - Tintin `b Y` (bg only) → `{ bg = Y }`.
--
-- Pattern translation (matches the discworld-sailing / discworld-misc
-- convention):
-- - %* → .*  ;  %1, %2, … → (.+?) capture groups  ;  %w → \w+  ;
--   {a|b|c} → (?:a|b|c)  ;  %. → \.  ;  ^…$ stays ^…$.

-- ───────────────────────────────────────────────────────────────
-- Combat / death feedback.
-- ───────────────────────────────────────────────────────────────

mud.style([[(already hunting)]],                            { capture = 1, fg = "red", bold = true })
mud.style([[.+ (?:kills?|deals the death blow) .+]],        { fg = "red" })
mud.style([[.+ dies\.$]],                                   { fg = "red" })
mud.style([[moves aggressively towards you!$]],             { fg = "red", bold = true })

-- ───────────────────────────────────────────────────────────────
-- Item handoff (give / slips), holy-glow lifecycle, drop / theft
-- mishaps (high-contrast black-on-red so they're impossible to miss).
-- ───────────────────────────────────────────────────────────────

mud.style([[.+ (?:gives|slips) .+ to you\.$]],              { fg = "magenta", bold = true })
mud.style([[.+ glows with holy light\.$]],                  { fg = "magenta" })
mud.style([[^Your .+ stops glowing\.$]],                    { fg = "magenta", bold = true })

mud.style([[^Whoops! .*$]],                                 { fg = "black", bg = "red" })
mud.style([[^Oops, butterfingers, .*$]],                    { fg = "black", bg = "red" })
mud.style([[^Your fading strength makes you drop .*$]],     { fg = "black", bg = "red" })
mud.style([[^.*grabs your .* and makes a run for it\.$]],   { fg = "red", bg = "blue" })
mud.style([[^.* (?:is|are) left on the floor for you\.$]],  { fg = "black", bg = "red" })
mud.style([[^With a slurping noise your .*$]],              { fg = "black", bg = "red" })
mud.style([[^.*juggles around .* and fumbles.*$]],          { fg = "black", bg = "yellow" })
mud.style([[^.+ drops .+ under strain\.$]],                 { fg = "black", bg = "yellow" })
mud.style([[^.+ the giant fruitbat tries to get .+, but can't quite manage\.$]],
  { fg = "blue", bg = "yellow" })
mud.style([[.+ seems to grab the .+ and yank it out of your grasp\.]],
  { fg = "black", bg = "red" })
mud.style([[^Your .+ arm goes out of control and drops .+]], { fg = "black", bg = "red" })
mud.style([[.+ suddenly grabs .+ from you and makes a run for it\.]],
  { fg = "black", bg = "red" })

-- ───────────────────────────────────────────────────────────────
-- Standalone phrase highlights — gills, towel, distortion, dagger,
-- book, passout, frisbee, "Our Kenneth" (KOF carrot incantation).
-- ───────────────────────────────────────────────────────────────

mud.style([[(lungs)]],                                      { capture = 1, fg = "cyan", bold = true })
mud.style([[^Despite your best efforts, your weight drags you down\.$]],
  { fg = "cyan", bold = true })
mud.style([[(sapphire blue towel)]],                        { capture = 1, fg = "blue" })
mud.style([[(distortion)]],                                 { capture = 1, fg = "magenta", bold = true })
mud.style([[^.+ ignites the tip of the red-hilted dagger\.$]], { fg = "red" })
mud.style([[^There are no papers left in the book\.$]],     { fg = "magenta" })
mud.style([[^The world goes black\.  You have passed out\.$]], { fg = "blue", bg = "red" })
mud.style([[(black frisbee\.)]],                            { capture = 1, fg = "red" })
mud.style([[(Our Kenneth\.)]],                              { capture = 1, fg = "red" })

-- ───────────────────────────────────────────────────────────────
-- Follower / identify acknowledgements (cyan tone, approximating
-- upstream's `<029>`).
-- ───────────────────────────────────────────────────────────────

mud.style([[(accepts the follow request from you\.)$]],     { capture = 1, fg = "cyan" })
mud.style([[(follows you)]],                                { capture = 1, fg = "cyan" })
mud.style([[(is already following you)]],                   { capture = 1, fg = "cyan" })

-- "X may now be identified as Y." — capture the new identifier (Y) so
-- it stands out. Upstream colours X in `<838>` (yellow) and Y in
-- `<158>` (cyan-ish); we keep just the high-signal capture.
mud.style([[^.+ may now be identified as "(.+)"\.$]], { capture = 1, fg = "cyan" })

-- ───────────────────────────────────────────────────────────────
-- Memo timeouts — high-contrast black-on-yellow so the warning lands
-- whether you're paying attention or not.
-- ───────────────────────────────────────────────────────────────

mud.style([[^Time has run up for memo .+\.  Removing it\.$]],
  { fg = "black", bg = "yellow" })
mud.style([[^Memo \(use "memo stop" to turn off\):$]],
  { fg = "black", bg = "yellow" })

-- ───────────────────────────────────────────────────────────────
-- Inventory / counting (`X Y with a total of N items`). Upstream
-- recolours three separate captures in `<148>` (yellow); we degrade to
-- a uniform yellow whole-line tint — the per-capture split adds little
-- once the line is already monochrome.
-- ───────────────────────────────────────────────────────────────

mud.style([[\w+ \w+ with a total of .+ item]], { fg = "yellow" })

-- ───────────────────────────────────────────────────────────────
-- AM houses — plaque attribution. Recolours just the captured family
-- (or owner) name.
-- ───────────────────────────────────────────────────────────────

mud.style([[A plaque by .+ indicates that it belongs to the (.+) family\.$]],
  { capture = 1, fg = "magenta", bold = true })
mud.style([[A plaque by .+ indicates that it belongs to (.+)\.$]],
  { capture = 1, fg = "magenta", bold = true })
mud.style([[A plaque indicates that it belongs to (.+)\.$]],
  { capture = 1, fg = "magenta", bold = true })

-- ───────────────────────────────────────────────────────────────
-- Item condition descriptors (`... in <state> condition.$` and `...
-- a complete wreck.$`). Colour escalates pristine → wrecked.
-- ───────────────────────────────────────────────────────────────

mud.style([[ in (excellent condition\.)$]],     { capture = 1, fg = "green", bold = true })
mud.style([[ in (very good condition\.)$]],     { capture = 1, fg = "green" })
mud.style([[ in (good condition\.)$]],          { capture = 1, fg = "yellow" })
mud.style([[ in (decent condition\.)$]],        { capture = 1, fg = "yellow" })
mud.style([[ in (fairly good condition\.)$]],   { capture = 1, fg = "yellow", bold = true })
mud.style([[ in (fairly poor condition\.)$]],   { capture = 1, fg = "yellow", bold = true })
mud.style([[ in (poor condition\.)$]],          { capture = 1, fg = "red" })
mud.style([[ in (really poor condition\.)$]],   { capture = 1, fg = "red" })
mud.style([[ in (very poor condition\.)$]],     { capture = 1, fg = "red" })
mud.style([[ in (atrocious condition\.)$]],     { capture = 1, fg = "red", bold = true })
mud.style([[ a (complete wreck\.)$]],           { capture = 1, fg = "red", bold = true })

-- ───────────────────────────────────────────────────────────────
-- Finesmithing feedback — progress (green) vs already-done (orange).
-- ───────────────────────────────────────────────────────────────

mud.style([[^You finish working at the goldsmith's workbench and set down your tools\.$]],
  { fg = "green" })
mud.style([[^You finish sculpting details on .+ and put your tools away neatly\.  It still needs polishing, however\.$]],
  { fg = "green" })
mud.style([[^You finish polishing .+ and put your tools away neatly\.  It could still use a final polishing with a cloth, however\.$]],
  { fg = "green" })
mud.style([[^You finish polishing .+ with the jeweller's polishing cloth\.$]],
  { fg = "green", bold = true })
mud.style([[^Attempting to bring out any more detail from .+ would only end up ruining it\.$]],
  { fg = "orange" })
mud.style([[^.+ has already been polished with files and now needs to be polished with a cloth\.$]],
  { fg = "orange" })
mud.style([[^.+ has already been polished to a gleaming sheen\.$]],
  { fg = "orange" })

-- ───────────────────────────────────────────────────────────────
-- Charm bracelets — recolour the charm + bracelet colour fragments via
-- the shared-style `captures = {N, M}` form. Upstream uses `<039>`
-- (blue-cyan), approximated as cyan.
-- ───────────────────────────────────────────────────────────────

mud.style([[^You remove the \w+ (\w+) charm from the (\w+) charm bracelet\.$]],
  { captures = {1, 2}, fg = "cyan" })
mud.style([[^You remove the \w+ (\w+) charm from one of the (\w+) charm bracelets\.$]],
  { captures = {1, 2}, fg = "cyan" })
mud.style([[^You carefully attach the \w+ (\w+) charm to the (\w+) charm bracelet\.$]],
  { captures = {1, 2}, fg = "cyan" })
mud.style([[^You carefully attach the \w+ (\w+) charm to one of the (\w+) charm bracelets\.$]],
  { captures = {1, 2}, fg = "cyan" })
mud.style([[^The \w+ (\w+) charm .*is in the (\w+) charm bracelet]],
  { captures = {1, 2}, fg = "cyan" })

-- ───────────────────────────────────────────────────────────────
-- Watch alarm — `<410><188>` = yellow bg + bold; approximated as
-- bold yellow.
-- ───────────────────────────────────────────────────────────────

mud.style([[^You feel a slight vibration coming from your slim black watch as an alarm goes off\.$]],
  { fg = "yellow", bold = true })

-- ───────────────────────────────────────────────────────────────
-- Ritual failure — `your god's attention is elsewhere`.
-- ───────────────────────────────────────────────────────────────

mud.style([[^You sense that \w+'s attention is elsewhere\.$]], { fg = "magenta" })

-- ───────────────────────────────────────────────────────────────
-- Warpaint (Wee Mad Arthur — primal beast rage).
-- ───────────────────────────────────────────────────────────────

mud.style([[^The beast stirs within you, and you feel the urge to let loose a scream\.$]],
  { fg = "green" })
mud.style([[^You try to paint a scary design on your face, but it all goes wrong\.$]],
  { fg = "red" })
mud.style([[^The paint on your face has all but faded away, and what is left is smudged with sweat and dirt\.  Your mood returns to normal\.$]],
  { fg = "red" })
mud.style([[^A primal instinct adds extra weight to your cry\.$]], { fg = "green" })

-- ───────────────────────────────────────────────────────────────
-- Feather-hat warm-up end.
-- ───────────────────────────────────────────────────────────────

mud.style([[^The feathers around you swirl, blow away and vanish suddenly\.$]],
  { fg = "cyan", bold = true })

-- ───────────────────────────────────────────────────────────────
-- Blight feedback (vulnerability + haggard appearance).
-- ───────────────────────────────────────────────────────────────

mud.style([[^.+ appears to be more vulnerable now\.$]], { fg = "magenta" })
mud.style([[^\w+ looks haggard and aged\.$]],            { fg = "magenta" })

-- Highly Illegal Greatsword bleed effect (any subject).
mud.style([[^\w+ is bleeding .+ from .+\.$]], { fg = "magenta" })

-- ───────────────────────────────────────────────────────────────
-- Modify Memento / Remember Place — faith failure + success.
-- ───────────────────────────────────────────────────────────────

mud.style([[^You do not have sufficient faith to convince.*$]], { fg = "red" })
mud.style([[^You will now remember .+ with the aid of .+]],     { fg = "green" })

-- ───────────────────────────────────────────────────────────────
-- See Alignment / See Foo rituals — vision deepen / fade.
-- ───────────────────────────────────────────────────────────────

mud.style([[^Your vision seems to deepen in some undefined way\.$]], { fg = "magenta" })
mud.style([[^Something tells you that your vision has become limited in some way again\.$]],
  { fg = "magenta" })

-- ───────────────────────────────────────────────────────────────
-- Celestial Anchor.
-- ───────────────────────────────────────────────────────────────

mud.style([[^You are tethered to the Disc by the power of .+\.$]], { fg = "red" })
mud.style([[^Your divine tethers are unravelling\.$]],             { fg = "green" })
mud.style([[^Your divine tethers shimmer and vanish\.$]],          { fg = "green" })

-- ───────────────────────────────────────────────────────────────
-- Clarify.
-- ───────────────────────────────────────────────────────────────

mud.style([[^Your vision blurs as thousands of letters, glyphs and symbols dance in front of your eyes, but somehow, you manage to derive the meaning of each of them\.$]],
  { fg = "green" })
mud.style([[^The letters fade away, leaving you feeling somewhat disoriented\.$]],
  { fg = "red" })

-- ───────────────────────────────────────────────────────────────
-- Moonlit market — full-moon detection.
-- ───────────────────────────────────────────────────────────────

mud.style([[(the moon is in its full phase)]],     { capture = 1, fg = "cyan", bold = true })
mud.style([[(There is a full moon\.)]],            { capture = 1, fg = "cyan", bold = true })
mud.style([[(Tonight there will be a full moon\.)]], { capture = 1, fg = "cyan", bold = true })

-- ───────────────────────────────────────────────────────────────
-- Breathe Underwater — gills phases. The final "gills disappear" line
-- uses upstream's bold-red-on-blue so it's impossible to miss when
-- you're about to drown.
-- ───────────────────────────────────────────────────────────────

mud.style([[^You feel a tingling sensation around your neck as you grow gills\.]],
  { fg = "cyan", bold = true })
mud.style([[^Your neck tingles as your gills are strengthened\.$]],
  { fg = "cyan", bold = true })
mud.style([[^You feel your gills twitch slightly as they begin to fade\.$]],
  { fg = "cyan", bold = true })
mud.style([[^Your gills flicker for a moment, then disappear\.$]],
  { fg = "red", bg = "blue", bold = true })

-- ───────────────────────────────────────────────────────────────
-- Rare mission items — colour-coded so a single mention in a long room
-- description / loot dump catches the eye. Order mirrors upstream so
-- future syncs diff cleanly.
-- ───────────────────────────────────────────────────────────────

local RARE_ITEMS = {
  { "kogake tabi",                        { fg = "magenta", bold = true } },
  { "clump of golden chains",             { fg = "yellow", bold = true } },
  { "bright copper armband",              { fg = "yellow" } },
  { "small ruby ring",                    { fg = "red", bold = true } },
  { "sapphire ring",                      { fg = "cyan", bold = true } },
  { "filigree hairpin",                   { fg = "green", bold = true } },
  { "freshwater pearl bracelet",          { fg = "magenta" } },
  { "palm frond hat",                     { fg = "yellow", bold = true } },
  { "gold-trimmed obi",                   { fg = "yellow", bold = true } },
  { "newt bangle",                        { fg = "green" } },
  { "stout vest",                         { fg = "green", bold = true } },
  { "curved sword",                       { fg = "cyan", bold = true } },
  { "greasy white apron",                 { fg = "white", bold = true } },
  { "push-up breastplate",                { fg = "yellow", bold = true } },
  { "yellow braces",                      { fg = "yellow", bold = true } },
  { "white cotton bodice",                { fg = "white", bold = true } },
  { "white Djelian loincloth",            { fg = "white", bold = true } },
  { "beaded belly chain",                 { fg = "blue", bold = true } },
  { "pirate's shirt",                     { fg = "red", bold = true } },
  { "old trousers",                       { fg = "light black", bold = true } },
  { "rough hessian trousers",             { fg = "red" } },
  { "lacy bloomers",                      { fg = "magenta", bold = true } },
  { "green glass shard",                  { fg = "green" } },
  { "okobo",                              { fg = "green", bold = true } },
  { "sickly yellow robe",                 { fg = "yellow" } },
  { "grey woollen gown",                  { fg = "light black", bold = true } },
  { "grey pleated skirt",                 { fg = "light black", bold = true } },
  { "abacus",                             { fg = "red" } },
  { "old worn cane",                      { fg = "red" } },
  { "yellow smock",                       { fg = "yellow" } },
  { "old green cloak",                    { fg = "green" } },
  { "ripped shirt",                       { fg = "red" } },
  { "brown felt hat",                     { fg = "red" } },
  { "torn trousers",                      { fg = "red" } },
  { "rubber apron",                       { fg = "light black", bold = true } },
  { "aikuchi dagger",                     { fg = "cyan", bold = true } },
  { "hessian robe",                       { fg = "red" } },
  { "blue kerchief",                      { fg = "blue", bold = true } },
  { "oyster knife",                       { fg = "cyan", bold = true } },
  { "leaf-bladed dagger",                 { fg = "red" } },
  { "green smock",                        { fg = "green" } },
  { "plain white cotton blouse",          { fg = "white", bold = true } },
  { "dark blue tricorn",                  { fg = "blue" } },
  { "bright copper necklet",              { fg = "yellow" } },
  { "green wool shirt",                   { fg = "green", bold = true } },
  { "dark skirt",                         { fg = "light black", bold = true } },
  { "horsehair-crested bronze helm",      { fg = "yellow" } },
  { "leather protective",                 { fg = "yellow" } },
  { "dark green obi",                     { fg = "green" } },
  { "huge fruit covered hat",             { fg = "magenta", bold = true } },
  { "black lace shawl",                   { fg = "light black", bold = true } },
  { "blue obi",                           { fg = "blue", bold = true } },
  { "lamb skin cape",                     { fg = "white", bold = true } },
  { "jiann",                              { fg = "cyan", bold = true } },
  { "yellow ribbon",                      { fg = "yellow", bold = true } },
  { "fancy thobe",                        { fg = "magenta" } },
  { "startling green dress",              { fg = "green", bold = true } },
  { "sexy white linen loincloth",         { fg = "white", bold = true } },
  { "shiny blue ribbon",                  { fg = "blue", bold = true } },
  { "short-sleeved white cotton shirt",   { fg = "white", bold = true } },
  { "black cotton dress",                 { fg = "light black", bold = true } },
  { "old shirt",                          { fg = "red" } },
  { "red and green spotted mushroom",     { fg = "green", bold = true } },
  { "dentist's trousers",                 { fg = "cyan" } },
  { "plain white thobe",                  { fg = "white", bold = true } },
  { "peach pumps",                        { fg = "magenta", bold = true } },
  { "frayed trousers",                    { fg = "red" } },
  { "hot fudge sundae",                   { fg = "magenta", bold = true } },
  { "rubber chicken",                     { fg = "yellow" } },
  { "dirty grey robe",                    { fg = "light black", bold = true } },
  { "laced sandals",                      { fg = "yellow", bold = true } },
  { "dusty blue himation",                { fg = "blue" } },
  { "plain linen kilt",                   { fg = "green" } },
  { "purple-black trousers",              { fg = "magenta" } },
  { "black silk zubon",                   { fg = "light black", bold = true } },
  { "black sowrong",                      { fg = "light black", bold = true } },
  { "green linen gown",                   { fg = "green" } },
}
-- Upstream lists `white smock` twice with different colours (`bold
-- magenta` first, then `bold white` later); the second declaration
-- wins in tintin too, so we register only the final colour and skip
-- the dead first entry.
mud.style([[(white smock)]], { capture = 1, fg = "white", bold = true })
for _, item in ipairs(RARE_ITEMS) do
  item[2].capture = 1
  mud.style("(" .. item[1] .. ")", item[2])
end

-- ───────────────────────────────────────────────────────────────
-- DJB bazaar stalls — bazaar tents are intentionally vague-looking
-- ("a mustard yellow tent posing noticeably here"); upstream injects a
-- colour-coded purpose label so you can tell at a glance what each one
-- actually sells.
--
-- Two flavours:
-- - *Stationary* (guild-affiliated) stalls — fixed location. Upstream
--   uses `<fca>` (yellow-ish); we approximate with yellow.
-- - *Random* / rotating stalls — show up anywhere. Upstream uses
--   `<029>` (blue-cyan); we approximate with cyan.
--
-- The stationary lines have a natural split point (we wrap the
-- inserted label between two captures so the original line text
-- preserves its styling). The random-stall descriptions are uniform
-- prose with no clean split — for those we prepend a bracketed
-- `[label]` to the line.
-- ───────────────────────────────────────────────────────────────

local STALL_GUILD_FG  = "yellow"
local STALL_RANDOM_FG = "cyan"

mud.replace([[^(A small) (stall is propped up on the north side of the road\.)$]],
  "%1 mending %2", { fg = STALL_GUILD_FG })
mud.replace([[(the haughty-looking) (stall here which is still lit up and trading, even at night\.)]],
  "%1 mending %2", { fg = STALL_GUILD_FG })
mud.replace([[(A large white) (tent stall has been pitched here\.  The dust and debris surrounding it suggests that it hasn't moved for some time\.)]],
  "%1 doctor %2", { fg = STALL_GUILD_FG })
mud.replace([[(A large white) (tent has been pitched here, and appears to still be open during the dark hours\.)]],
  "%1 doctor %2", { fg = STALL_GUILD_FG })
mud.replace([[^(One of these) (stalls, a jolly-looking blue one, has been pitched here\.)$]],
  "%1 foreign curiosities %2", { fg = STALL_RANDOM_FG })
mud.replace([[^(One such) (stall is pitched here, a blue tent that is dimly lit and appears to still be trading, even at this hour\.)$]],
  "%1 foreign curiosities %2", { fg = STALL_RANDOM_FG })

local STALL_RANDOM = {
  { label = "desserts",      desc = [[^A large cream-coloured tent has been set here\.  The scent of sugar and chocolate drifts from it periodically\.$]] },
  { label = "coffee",        desc = [[^A roughly hewn brown tent is lurking here\.  Strong smells of coffee emanate from it at regular intervals\.$]] },
  { label = "ink",           desc = [[^A simple canvas stall has been carefully set up here\.  It is a calming eye-rest amongst the colourful madness that is the bazaar\.$]] },
  { label = "odds and ends", desc = [[^A grubby grey-brown tent is squatting here\.$]] },
  { label = "junk",          desc = [[^A dusty stall has been erected here\.$]] },
  { label = "crockery",      desc = [[^A mustard yellow tent is posing noticeably here\.  It's really rather an eyesore\.$]] },
  { label = "wedding",       desc = [[^A fancy looking stall has been set up here, in heavy white fabric\.  It is serene and self-important compared to the riot of colour that is the rest of the bazaar\.$]] },
  { label = "perfume",       desc = [[^A sultry red tent has been erected here, almost decadent in its posture\.$]] },
  { label = "groceries",     desc = [[^A large tent stall made predominantly of some sort of earthy brown hessian has been set up here\.$]] },
  { label = "souvenir",      desc = [[^A tent stall in the shape of a pyramid has been set up here\.$]] },
  { label = "jewellery",     desc = [[^An expensive-looking stall has been set up here, self-importantly dark and heavy against the riot of colour of the rest of the bazaar\.$]] },
  { label = "leather",       desc = [[^A little brown stall sits comfortably amongst the crowds\.  The smell of freshly worked leather goods wafts out from it\.$]] },
  { label = "bakery",        desc = [[^The glorious scent of fresh bread hangs in the air\.  It seems to come from a large pale tent standing just here\.$]] },
  { label = "ivory",         desc = [[^A heavily embroidered tent is standing proudly here\.$]] },
  { label = "spices",        desc = [[^A small stall has been set up here in the form of a scarlet tent\.  The scent of spices and herbs occasionally drifts from it\.$]] },
  { label = "papyrus",       desc = [[^A stall with thick, light beige canvas has been set up here\.$]] },
  { label = "wallpaper",     desc = [[^A plain brown tent has been set up here\.  Curious customers gravitate towards it\.$]] },
  { label = "fish",          desc = [[^A khaki tent sprawls here\.  Every so often the stench of fish wafts from it\.$]] },
  { label = "unknown",       desc = [[^A brightly coloured tent stall has been set up just here\.$]] },
  { label = "embroidery",    desc = [[^An eye-catching burgundy tent sits boldly here\.$]] },
  { label = "engraver's",    desc = [[^A dark and musty stall appears to be trying to hide away from the noise\.$]] },
  { label = "pet",           desc = [[^A light green tent fills this space\.  Chirps and other chatters emit from it randomly\.$]] },
  { label = "charm",         desc = [[^A pristine white stall sprouts out of the ground here\.  Tourists wander in and out of it frequently\.$]] },
  { label = "music",         desc = [[^An earthy green tent sprouts out of the ground here\.  Strange noises come from inside of it - they almost sound like music\.]] },
  { label = "model",         desc = [[^A rickety stall has been set up here, evidently without any real care\.]] },
  { label = "clothing",      desc = [[^A dull tan coloured tent has been constructed here\.$]] },
}
for _, stall in ipairs(STALL_RANDOM) do
  mud.replace(stall.desc, "[" .. stall.label .. "] %0", { fg = STALL_RANDOM_FG })
end
