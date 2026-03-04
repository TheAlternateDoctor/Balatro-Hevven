SMODS.ConsumableType({
    key='Flow',
    primary_colour=HEX('FFFFFF'),
    secondary_colour=HEX('FFAFFB'),
    shop_rate=1
})
SMODS.UndiscoveredSprite({
	key = "Flow",
	atlas = "flow",
	path = "flow.png",
	pos = { x = 4, y = 2 },
	px = 71,
	py = 95,
})

-- Try Again
SMODS.Consumable({
    key = "try_again",
    set = 'Flow',
    cost = 3,
    atlas = 'flow',
    pos = {
        x = 1,
        y = 0
    },

    use = function(self, card, area, copier)
        if (G.STATE == G.STATES.SPECTRAL_PACK or 
        G.STATE == G.STATES.TAROT_PACK or
        G.STATE == G.STATES.PLANET_PACK or
        G.STATE == G.STATES.SMODS_BOOSTER_OPENED) then
            local card_t = {
                set = "Flow",
                area = G.consumeables,
                key = "c_rh_try_again"
            }
            local card = SMODS.create_card(card_t)
            G.consumeables:emplace(card)
        else
            local to_discard = {}
            for k, v in ipairs(G.hand.cards) do
                    to_discard[#to_discard+1] = v
            end
            for k, v in ipairs(to_discard) do
                G.hand:add_to_highlighted(v, true)
                G.FUNCS.discard_cards_from_highlighted(nil, true)
                G.hand:remove_from_highlighted(v, true)
            end
        end
    end,

    can_use = function(self, card)
        if G.STATE == G.STATES.SELECTING_HAND then
            return true
        else 
            return (G.STATE == G.STATES.SPECTRAL_PACK or 
            G.STATE == G.STATES.TAROT_PACK or
            G.STATE == G.STATES.PLANET_PACK or
            G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and G.consumeables.config.card_limit > #G.consumeables.cards
        end
	end,

    credit = {
        art = "missingnumber",
        code = "TheAltDoc",
        concept = "patataofcourse"
    }
})

-- OK
SMODS.Consumable({
    key = "ok",
    set = 'Flow',
    cost = 3,
    atlas = 'flow',
    pos = {
        x = 2,
        y = 0
    },

    use = function(self, card, area, copier)   
        if (G.STATE == G.STATES.SPECTRAL_PACK or 
        G.STATE == G.STATES.TAROT_PACK or
        G.STATE == G.STATES.PLANET_PACK or
        G.STATE == G.STATES.SMODS_BOOSTER_OPENED) then
            local card_t = {
                set = "Flow",
                area = G.consumeables,
                key = "c_rh_ok"
            }
            local card = SMODS.create_card(card_t)
            G.consumeables:emplace(card)
        else     
            G.E_MANAGER:add_event(Event({
                func = function() 
                    local any_selected = nil
                    local to_discard = {}
                    for k, v in ipairs(G.hand.cards) do
                        if v.highlighted ==false then
                            to_discard[#to_discard+1] = v
                            any_selected = true
                        end
                    end
                    G.hand:unhighlight_all()
                    for k, v in ipairs(to_discard) do
                        G.hand.highlighted[#G.hand.highlighted+1] = v
                        v:highlight(true)
                    end
                    if any_selected then
                        G.FUNCS.discard_cards_from_highlighted(nil, true)
                        G.STATE = G.STATES.DRAW_TO_HAND
                        G.E_MANAGER:add_event(Event({
                            func = function() 
                                G.STATE_COMPLETE = false
                                return true 
                            end 
                        }))
                    end 
                    return true 
                end 
            }))   
        end
    end,

    can_use = function(self, card)
        if G.STATE == G.STATES.SELECTING_HAND then
            return #G.hand.highlighted > 0
        else 
            return (G.STATE == G.STATES.SPECTRAL_PACK or 
            G.STATE == G.STATES.TAROT_PACK or
            G.STATE == G.STATES.PLANET_PACK or
            G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and G.consumeables.config.card_limit > #G.consumeables.cards
        end
	end,

    credit = {
        art = "missingnumber",
        code = "TheAltDoc",
        concept = "patataofcourse"
    }
})

-- Superb
SMODS.Consumable({
    key = "superb",
    set = 'Flow',
    cost = 5,
    atlas = 'flow',
    pos = {
        x = 3,
        y = 0
    },

    use = function(self, card, area, copier)   
        if (G.STATE == G.STATES.SPECTRAL_PACK or 
        G.STATE == G.STATES.TAROT_PACK or
        G.STATE == G.STATES.PLANET_PACK or
        G.STATE == G.STATES.SMODS_BOOSTER_OPENED) then
            local card_t = {
                set = "Flow",
                area = G.consumeables,
                key = "c_rh_superb"
            }
            local card = SMODS.create_card(card_t)
            G.consumeables:emplace(card)
        else
            local to_discard = {}
            local highlighted_cards = {}
            for k, v in ipairs(G.hand.cards) do
                if v.highlighted ==false then
                    to_discard[#to_discard+1] = v
                else 
                    highlighted_cards[#highlighted_cards+1] = v
                end
            end
            for i=1, #G.hand.highlighted do
                local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function() 
                        G.hand.highlighted[i]:flip()
                        play_sound('card1', percent)
                        G.hand.highlighted[i]:juice_up(0.3, 0.3)
                        return true 
                    end 
                }))   
            end
            for i=1, #G.hand.highlighted do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function() 
                        G.hand.highlighted[i]:set_ability(SMODS.poll_enhancement({guaranteed = true, type_key = "superb"}))
                        return true 
                    end 
                }))        
            end
            for i=1, #G.hand.highlighted do
                local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function() 
                        G.hand.highlighted[i]:flip()
                        play_sound('tarot2', percent, 0.6)
                        G.hand.highlighted[i]:juice_up(0.3, 0.3)
                        return true 
                    end 
                }))
            end
            G.E_MANAGER:add_event(Event({
                blocking = false,
                func = function() 
                    if G.STATE == G.STATES.SELECTING_HAND then
                        G.FUNCS.play_cards_from_highlighted()
                        return true
                    end
                    return false
                end
            }))
            local hands_played_before = G.GAME.hands_played
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 1.2,
                blocking = false,
                func = function() 
                    if G.GAME.hands_played > hands_played_before then
                        G.hand:unhighlight_all()  
                        for k, v in ipairs(to_discard) do
                            G.hand.highlighted[#G.hand.highlighted+1] = v
                        end
                        G.FUNCS.discard_cards_from_highlighted(nil, true)
                        return true 
                    end
                    return false
                end 
            })) 
        end
    end,

    calculate = function(self, card, context)
    end,

    can_use = function(self, card)
        if G.STATE == G.STATES.SELECTING_HAND then
            return #G.hand.highlighted > 0
        else 
            return (G.STATE == G.STATES.SPECTRAL_PACK or 
            G.STATE == G.STATES.TAROT_PACK or
            G.STATE == G.STATES.PLANET_PACK or
            G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and G.consumeables.config.card_limit > #G.consumeables.cards
        end
	end,

    credit = {
        art = "missingnumber",
        code = "TheAltDoc",
        concept = "patataofcourse"
    }
})

-- Perfect
SMODS.Consumable({
    key = "perfect",
    set = 'Flow',
    cost = 7,
    atlas = 'flow',
    pos = {
        x = 4,
        y = 0
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_foil
        info_queue[#info_queue + 1] = G.P_CENTERS.e_holographic
        info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
        return {
            vars = {
                card.ability.extra.base_chance* G.GAME.probabilities.normal,
                card.ability.extra.max_chance,
            }
        }
    end,
    config = {
        extra = {
            base_chance = 2,
            max_chance = 3
        }
    },

    use = function(self, card, area, copier)   
        if (G.STATE == G.STATES.SPECTRAL_PACK or 
        G.STATE == G.STATES.TAROT_PACK or
        G.STATE == G.STATES.PLANET_PACK or
        G.STATE == G.STATES.SMODS_BOOSTER_OPENED) then
            local card_t = {
                set = "Flow",
                area = G.consumeables,
                key = "c_rh_perfect"
            }
            local card = SMODS.create_card(card_t)
            G.consumeables:emplace(card)
        else
            local to_discard = {}
            local highlighted_cards = {}
            for k, v in ipairs(G.hand.cards) do
                if (v.highlighted or false) == false then
                    to_discard[#to_discard+1] = v
                else 
                    highlighted_cards[#highlighted_cards+1] = v
                end
            end
            for i=1, #G.hand.highlighted do
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    local enhancement_type = pseudorandom(pseudoseed("perfect"))
                    local aura_card = G.hand.highlighted[i]
                    if enhancement_type > (G.GAME.probabilities.normal*card.ability.extra.base_chance)/card.ability.extra.max_chance then 
                        local edition = poll_edition('perfect', nil, true, true)
                        if not aura_card.edition then
                            aura_card:set_edition(edition, true)
                            aura_card:juice_up(0.3, 0.5)
                        end
                    else
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4,blocking = false, blockable = false, func = function()
                            attention_text({
                                text = localize('k_nope_ex'),
                                scale = 1.3, 
                                hold = 1.4,
                                major = aura_card,
                                backdrop_colour = G.C.SECONDARY_SET.Tarot,
                                align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and 'tm' or 'cm',
                                offset = {x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and -0.2 or 0},
                                silent = true
                                })
                                aura_card.edition = nil
                                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                                    play_sound('tarot2', 0.76, 0.4);return true end}))
                                play_sound('tarot2', 1, 0.4)
                                aura_card:juice_up(0.3, 0.5)
                        return true end }))
                        aura_card.edition = nil
                    end
                return true end }))      
            end
            G.E_MANAGER:add_event(Event({
                trigger = "after", 
                delay = 1.2, 
                blocking = false,
                func = function() 
                    if G.STATE == G.STATES.SELECTING_HAND then
                        G.FUNCS.play_cards_from_highlighted()
                        return true
                    end
                    return false
                end
            }))
            local hands_played_before = G.GAME.hands_played
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 1.2,
                blocking = false,
                func = function() 
                    if G.GAME.hands_played > hands_played_before then
                        local perfected = {}
                        for k, v in ipairs(to_discard) do
                            table.insert(perfected, v)
                            if v.ability.name == 'Glass Card' then 
                                v:shatter()
                            else
                                v:start_dissolve(nil, false)
                            end
                        end
                        if #perfected > 0 then
                            SMODS.calculate_context({remove_playing_cards = true, removed = perfected})
                        end
                        return true 
                    end
                    
                    return false
                end 
            })) 
        end
    end,

    can_use = function(self, card)
        if G.STATE == G.STATES.SELECTING_HAND then
            return #G.hand.highlighted > 0
        else 
            return (G.STATE == G.STATES.SPECTRAL_PACK or 
            G.STATE == G.STATES.TAROT_PACK or
            G.STATE == G.STATES.PLANET_PACK or
            G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and G.consumeables.config.card_limit > #G.consumeables.cards
        end
	end,

    credit = {
        art = "missingnumber",
        code = "TheAltDoc",
        concept = "patataofcourse"
    }
})

-- Simple Tap
SMODS.Consumable({
    key = "simple_tap",
    set = 'Flow',
    cost = 7,
    
    atlas = 'flow',
    pos = {
        x = 1,
        y = 1
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'active_flow', set = 'Other'}
        return {}
    end,

    use = function(self, card, area, copier)   
        if (G.STATE == G.STATES.SPECTRAL_PACK or 
        G.STATE == G.STATES.TAROT_PACK or
        G.STATE == G.STATES.PLANET_PACK or
        G.STATE == G.STATES.SMODS_BOOSTER_OPENED) then
            local card_t = {
                set = "Flow",
                area = G.consumeables,
                key = "c_rh_simple_tap"
            }
            local card = SMODS.create_card(card_t)
            G.consumeables:emplace(card)
        else
            add_flow_tag(Tag('tag_rh_simple_tap'))
            play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
            play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
            G.GAME.current_round.rh_flow_simple_tap = true
        end
    end,

    can_use = function(self, card)
		if G.STATE == G.STATES.SELECTING_HAND then
            return not G.GAME.current_round.rh_flow_used
        else 
            return (G.STATE == G.STATES.SPECTRAL_PACK or 
            G.STATE == G.STATES.TAROT_PACK or
            G.STATE == G.STATES.PLANET_PACK or
            G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
            G.consumeables.config.card_limit > #G.consumeables.cards
        end 
	end,

    credit = {
        art = "missingnumber",
        code = "TheAltDoc",
        concept = "patataofcourse"
    }
})

-- New Record
SMODS.Consumable({
    key = "new_record",
    set = 'Flow',
    cost = 5,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'active_flow', set = 'Other'}
        info_queue[#info_queue+1] = {key = 'tag_rare', set = 'Tag'}
        return {
            vars = {G.GAME.round_scores['hand'].amt or 0}
        }
    end,
    atlas = 'flow',
    pos = {
        x = 1,
        y = 2
    },

    use = function(self, card, area, copier)   
        if (G.STATE == G.STATES.SPECTRAL_PACK or 
        G.STATE == G.STATES.TAROT_PACK or
        G.STATE == G.STATES.PLANET_PACK or
        G.STATE == G.STATES.SMODS_BOOSTER_OPENED) then
            local card_t = {
                set = "Flow",
                area = G.consumeables,
                key = "c_rh_new_record"
            }
            local card = SMODS.create_card(card_t)
            G.consumeables:emplace(card)
        else
            G.GAME.current_round.rh_flow_new_record = true
            G.GAME.current_round.rh_flow_new_record_to_beat = G.GAME.round_scores['hand'].amt
            add_flow_tag(Tag('tag_rh_new_record'))
            play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
            play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
        end
    end,

    can_use = function(self, card)
		if G.STATE == G.STATES.SELECTING_HAND then
            return not G.GAME.current_round.rh_flow_used
        else 
            return (G.STATE == G.STATES.SPECTRAL_PACK or 
            G.STATE == G.STATES.TAROT_PACK or
            G.STATE == G.STATES.PLANET_PACK or
            G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
            G.consumeables.config.card_limit > #G.consumeables.cards 
        end 
	end,

    credit = {
        art = "missingnumber",
        code = "TheAltDoc",
        concept = "patataofcourse"
    }
})

-- Pity Skip
SMODS.Consumable({
    key = "pity_skip",
    set = 'Flow',
    cost = 3,
    atlas = 'flow',
    pos = {
        x = 2,
        y = 1
    },

    use = function(self, card, area, copier)   
        if (G.STATE == G.STATES.SPECTRAL_PACK or 
        G.STATE == G.STATES.TAROT_PACK or
        G.STATE == G.STATES.PLANET_PACK or
        G.STATE == G.STATES.SMODS_BOOSTER_OPENED) then
            local card_t = {
                set = "Flow",
                area = G.consumeables,
                key = "c_rh_pity_skip"
            }
            local card = SMODS.create_card(card_t)
            G.consumeables:emplace(card)
        else
            G.E_MANAGER:add_event(
			Event({
                trigger = "immediate",
                func = function()
                    if G.STATE ~= G.STATES.SELECTING_HAND then
                        return false
                    end
                    G.GAME.current_round.rh_flow_pity_skip = true
                    local host = pseudorandom(pseudoseed("pity_skip"))
                    if host > 0.25 then 
                        G.GAME.current_round.rh_flow_pity_skip_host = "_barista"
                    else
                        G.GAME.current_round.rh_flow_pity_skip_host = "_rupert"
                    end
                    G.STATE = G.STATES.HAND_PLAYED
                    G.STATE_COMPLETE = true
                    end_round()
                    return true
                end,
                }),
                "other"
            )
        end
    end,

    can_use = function(self, card)
		if G.STATE == G.STATES.SELECTING_HAND then
            return true
        else 
            return (G.STATE == G.STATES.SPECTRAL_PACK or 
            G.STATE == G.STATES.TAROT_PACK or
            G.STATE == G.STATES.PLANET_PACK or
            G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
            G.consumeables.config.card_limit > #G.consumeables.cards and 
            not G.GAME.blind.boss
        end 
	end,

    credit = {
        art = "missingnumber",
        code = "The Cryptid mod",
        concept = "The Cryptid mod"
    }
})

-- Some Good Parts
SMODS.Consumable({
    key = "some_good_parts",
    set = 'Flow',
    cost = 5,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'active_flow', set = 'Other'}
        return {
            vars= {
                card.ability.extra.percentage,
                G.GAME and G.GAME.probabilities.normal or 1,
                card.ability.extra.chances
            }
        }
    end,

    config = {extra = {percentage=60,chances=8}},
    atlas = 'flow',
    pos = {
        x = 3,
        y = 1
    },

    use = function(self, card, area, copier)   
        if (G.STATE == G.STATES.SPECTRAL_PACK or 
        G.STATE == G.STATES.TAROT_PACK or
        G.STATE == G.STATES.PLANET_PACK or
        G.STATE == G.STATES.SMODS_BOOSTER_OPENED) then
            local card_t = {
                set = "Flow",
                area = G.consumeables,
                key = "c_rh_some_good_parts"
            }
            local card = SMODS.create_card(card_t)
            G.consumeables:emplace(card)
        else
            G.GAME.current_round.rh_flow_good_parts = true
            G.GAME.current_round.rh_flow_good_parts_chances = card.ability.extra.chances
            G.GAME.current_round.rh_flow_good_parts_percentage = card.ability.extra.percentage
            add_flow_tag(Tag('tag_rh_some_good_parts'))
            play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
            play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
        end
    end,

    can_use = function(self, card)
		if G.STATE == G.STATES.SELECTING_HAND then
            return not G.GAME.current_round.rh_flow_used
        else 
            return (G.STATE == G.STATES.SPECTRAL_PACK or 
            G.STATE == G.STATES.TAROT_PACK or
            G.STATE == G.STATES.PLANET_PACK or
            G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
            G.consumeables.config.card_limit > #G.consumeables.cards
        end
	end,

    credit = {
        art = "missingnumber",
        code = "TheAltDoc",
        concept = "TheAltDoc"
    }
})
-- Rewritting vanilla evaluate_round somewhat to make Pity Skip and Some Good Parts work
local gfer = G.FUNCS.evaluate_round
function G.FUNCS.evaluate_round()
    if G.GAME.current_round.rh_flow_pity_skip or G.GAME.current_round.rh_flow_good_parts_saved then
        add_round_eval_row({ dollars = 0, name = "blind1", pitch = 0.95, saved = true })
        G.E_MANAGER:add_event(Event({
            trigger = "before",
            delay = 1.3 * math.min(G.GAME.blind.dollars + 2, 7) / 2 * 0.15 + 0.5,
            func = function()
                G.GAME.blind:defeat()
                return true
            end,
        }))
        delay(0.2)
        add_round_eval_row({ name = "bottom", dollars = 0 })
    else
        return gfer()
    end
end

-- You (card)
SMODS.Consumable({
    key = "you",
    set = 'Flow',
    cost = 5,
    atlas = 'flow',
    pos = {
        x = 4,
        y = 1
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'active_flow', set = 'Other'}
        info_queue[#info_queue+1] = {key = 'rh_you_sticker', set = 'Other'}
        return {}
    end,

    use = function(self, card, area, copier)   
        if (G.STATE == G.STATES.SPECTRAL_PACK or 
        G.STATE == G.STATES.TAROT_PACK or
        G.STATE == G.STATES.PLANET_PACK or
        G.STATE == G.STATES.SMODS_BOOSTER_OPENED) then
            local card_t = {
                set = "Flow",
                area = G.consumeables,
                key = "c_rh_you"
            }
            local card = SMODS.create_card(card_t)
            G.consumeables:emplace(card)
        else
            add_flow_tag(Tag('tag_rh_you'))
            play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
            play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
            G.hand.highlighted[1]:add_sticker("rh_you_sticker", true)
            G.hand.highlighted[1].ability.forced_selection = true
        end
    end,

    can_use = function(self, card)
        if G.STATE == G.STATES.SELECTING_HAND then
            return #G.hand.highlighted == 1 and not G.GAME.current_round.rh_flow_used
        else
            return (G.STATE == G.STATES.SPECTRAL_PACK or 
            G.STATE == G.STATES.TAROT_PACK or
            G.STATE == G.STATES.PLANET_PACK or
            G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
            G.consumeables.config.card_limit > #G.consumeables.cards
        end
	end,

    credit = {
        art = "missingnumber",
        code = "TheAltDoc",
        concept = "TheAltDoc"
    }
})

-- Extra Life
SMODS.Consumable({
    key = "extra_life",
    set = 'Flow',
    cost = 3,
    config = {extra = {hands=1,discards=1}},
    loc_vars = function(self, info_queue, card)
        return {
            vars= {
                card.ability.extra.hands,
                (card.ability.extra.hands>1) and "s" or "",
                card.ability.extra.discards,
                (card.ability.extra.discards>1) and "s" or "",
            }
        }
    end,
    atlas = 'flow',
    pos = {
        x = 0,
        y = 2
    },

    use = function(self, card, area, copier)
        if (G.STATE == G.STATES.SPECTRAL_PACK or 
        G.STATE == G.STATES.TAROT_PACK or
        G.STATE == G.STATES.PLANET_PACK or
        G.STATE == G.STATES.SMODS_BOOSTER_OPENED) then
            local card_t = {
                set = "Flow",
                area = G.consumeables,
                key = "c_rh_extra_life"
            }
            local card = SMODS.create_card(card_t)
            G.consumeables:emplace(card)
        else
            G.E_MANAGER:add_event(Event({func = function()
                ease_discard(card.ability.extra.discards)
                ease_hands_played(card.ability.extra.hands)
            return true end }))
        end
    end,

    can_use = function(self, card)
        if G.STATE == G.STATES.SELECTING_HAND then
            return true
        else 
            return (G.STATE == G.STATES.SPECTRAL_PACK or 
            G.STATE == G.STATES.TAROT_PACK or
            G.STATE == G.STATES.PLANET_PACK or
            G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and G.consumeables.config.card_limit > #G.consumeables.cards
        end
	end,

    credit = {
        art = "missingnumber",
        code = "TheAltDoc",
        concept = "missingnumber"
    }
})

-- Skill Star
SMODS.Consumable({
    key = "skill_star",
    set = 'Flow',
    cost = 7,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'active_flow', set = 'Other'}
        return {
            vars= {
                card.ability.extra.percentage,
                card.ability.extra.base_money,
                card.ability.extra.max_money
            }
        }
    end,
    config = {extra = {
        percentage = 5,
        base_money = 1,
        max_money = 40,
    }},
    atlas = 'flow',
    pos = {
        x = 0,
        y = 1
    },

    use = function(self, card, area, copier)
        if (G.STATE == G.STATES.SPECTRAL_PACK or 
        G.STATE == G.STATES.TAROT_PACK or
        G.STATE == G.STATES.PLANET_PACK or
        G.STATE == G.STATES.SMODS_BOOSTER_OPENED) then
            local card_t = {
                set = "Flow",
                area = G.consumeables,
                key = "c_rh_skill_star"
            }
            local card = SMODS.create_card(card_t)
            G.consumeables:emplace(card)
        else
            add_flow_tag(Tag('tag_rh_skill_star'))
            G.GAME.current_round.skill_star = card.ability.extra
            play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
            play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
        end
    end,

    can_use = function(self, card)
        if G.STATE == G.STATES.SELECTING_HAND then
            return not G.GAME.current_round.rh_flow_used
        else 
            return (G.STATE == G.STATES.SPECTRAL_PACK or 
            G.STATE == G.STATES.TAROT_PACK or
            G.STATE == G.STATES.PLANET_PACK or
            G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and G.consumeables.config.card_limit > #G.consumeables.cards
        end
	end,

    credit = {
        art = "missingnumber",
        code = "TheAltDoc",
        concept = "TheAltDoc"
    }
})

-- Remix
SMODS.Consumable({
    key = "remix",
    set = 'Spectral',
    soul_set = 'Flow',
    atlas = 'flow',
    pos = {
        x = 2,
        y = 2
    },
    soul_pos = {
        x = 3,
        y = 2
    },
    cost = 20,
    hidden = true,    
    use = function(self, card, area, copier)
        if (G.STATE == G.STATES.SPECTRAL_PACK or 
        G.STATE == G.STATES.TAROT_PACK or
        G.STATE == G.STATES.PLANET_PACK or
        G.STATE == G.STATES.SMODS_BOOSTER_OPENED) then
            local card_t = {
                set = "Spectral",
                area = G.consumeables,
                key = "c_rh_remix"
            }
            local card = SMODS.create_card(card_t)
            G.consumeables:emplace(card)
        else
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.4,
                func = function()
                    play_sound("tarot1")
                    card:juice_up(0.3, 0.5)
                    return true
                end,
            }))
            for i = 1, #G.hand.cards do
                local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
                G.E_MANAGER:add_event(Event({
                    trigger = "after",
                    delay = 0.15,
                    func = function()
                        G.hand.cards[i]:flip()
                        play_sound("card1", percent)
                        G.hand.cards[i]:juice_up(0.3, 0.3)
                        return true
                    end,
                }))
            end
                G.E_MANAGER:add_event(Event({
            		func = function()
                        for k, v in pairs(G.hand.cards) do
                            -- First we erase all upgrades to the card
                            v.edition = nil
                            v:set_ability(G.P_CENTERS.c_base, nil, true)
                            v.seal = nil
                            -- Then we poll the new upgrades
                            enhancement  = SMODS.poll_enhancement({guaranteed = true, type_key = "remix"})
                            seal = SMODS.poll_seal({guaranteed = true, type_key = "remix"})
                            edition = poll_edition("remix", nil, true, true)
                            -- Finally, we add to the card
                            v:set_ability(G.P_CENTERS[enhancement], nil, true)
                            v:set_seal(seal, true, true)
                            v:set_edition(edition, true, true)
                        end
                        return true
            		end,
            	}))
            delay(0.2)
            for i = 1, #G.hand.cards do
                local CARD = G.hand.cards[i]
                local percent = 0.85 + (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
                G.E_MANAGER:add_event(Event({
                    trigger = "after",
                    delay = 0.15,
                    func = function()
                        CARD:flip()
                        play_sound("tarot2", percent)
                        CARD:juice_up(0.3, 0.3)
                        return true
                    end,
                }))
            end

            --Then we play everything        
            G.E_MANAGER:add_event(Event({
                trigger = "after", 
                delay = 1.2, 
                blocking = false,
                func = function() 
                    if G.STATE == G.STATES.SELECTING_HAND then
                        for i = 1, #G.hand.cards do
                            local CARD = G.hand.cards[i]
                            G.hand.highlighted[#G.hand.highlighted+1] = CARD
                            CARD:highlight(true)
                        end
                        G.FUNCS.play_cards_from_highlighted()
                        return true
                    end
                    return false
                end
            }))
        end
	end,

    can_use = function (self, card)
        if G.STATE == G.STATES.SELECTING_HAND then
            return true
        else 
            return (G.STATE == G.STATES.SPECTRAL_PACK or 
            G.STATE == G.STATES.TAROT_PACK or
            G.STATE == G.STATES.PLANET_PACK or
            G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and G.consumeables.config.card_limit > #G.consumeables.cards
        end
	end,
    credit = {
        art = "missingnumber",
        code = "TheAltDoc",
        concept = "TheAltDoc"
    }
})
