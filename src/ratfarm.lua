-- Rat-farm trap highlights — port of tt_dw's
-- ~/code/3p/tt_dw/scripts/misc/ratfarm.tin.
--
-- Same shape as mines.lua: pure colour, no TTS/notification.

-- Falling-boulder trap.
mud.style([[^A small, unassuming stone depresses with a click as you put your weight on it\.$]], { fg = "red", bold = true })
mud.style([[^A huge rolling boulder falls in from above\.$]],                                    { fg = "red", bold = true })

-- Arrow-slit trap.
mud.style([[^Several small slits in the walls slide open\.$]],     { fg = "red", bold = true })
mud.style([[^Arrows fire out of the slits at you!]],               { fg = "red", bold = true })
mud.style([[^The arrow slits slide shut again\.$]],                { fg = "green" })

-- Trapdoor trap.
mud.style([[^A small, unassuming half-brick depresses with a click as you put your weight on it\.$]], { fg = "red", bold = true })
mud.style([[^The floor creaks ominously\.$]],                                                         { fg = "red", bold = true })
mud.style([[^A trapdoor opens under your feet!$]],                                                    { fg = "red" })

-- Tripwire — case-insensitive in the upstream (`%i`), preserved here
-- so the exit direction matches in any case.
mud.style([[(?i)A tripwire is stretched across the .* exit at around knee height]], { fg = "red" })

-- Loot crates.
mud.style([[(?i)Several large crates are stacked in a corner]], { fg = "green", bold = true })
