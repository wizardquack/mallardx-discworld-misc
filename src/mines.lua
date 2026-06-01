-- Dwarven-mines hazard highlights — port of tt_dw's
-- ~/code/3p/tt_dw/scripts/misc/mines.tin.
--
-- Upstream pairs each `#high` with a `/speak` call (TTS for
-- screen-reader users). Mallard has no equivalent yet (`ui.notify` is
-- too disruptive for hazard cadence), so this port covers the visual
-- channel only. Deferred for a possible TTS-friendly notification
-- primitive later.

-- Falling rocks.
mud.style([[^Somewhere above you, you hear the rumble of falling rock\.$]], { fg = "red", bold = true })
mud.style([[^Heavy rocks rain down from above on your head!$]],             { fg = "red", bold = true })
mud.style([[^The rockfall peters off\.$]],                                  { fg = "red" })

-- Stinkdamp gas.
mud.style([[^Something doesn't smell right\.  You take a sniff but the faint odour of rotten eggs makes you cough\.$]],         { fg = "yellow", bold = true })
mud.style([[^You can't smell it any more, but you're getting a dizzy sort of headache\.  Maybe you should get out of here\.$]], { fg = "yellow", bold = true })
mud.style([[^You suddenly feel like you can't breathe\.$]],                                                                    { fg = "yellow", bold = true })
mud.style([[^You collapse on the ground, your muscles spasming uncontrollably\.$]],                                            { fg = "yellow" })
mud.style([[^You collapse on the ground, your muscles still spasming uncontrollably\.$]],                                      { fg = "yellow" })
