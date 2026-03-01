-- TEMPLATE JOKER CODE --
-- To copy and paste when adding a new Joker

-- SMODS.Joker({
--     key = "KEY",

--     loc_vars = function(self, info_queue, card)
--                 return {
--                     vars = {
--                     }
--                 }
--     end,
--     cost = 1,
--     rarity = 1,
--     blueprint_compat = false,
--     eternal_compat = true,
--     unlocked = true,
--     discovered = true,
--     atlas = 'jokers',
--     pos = {
--         x = 4,
--         y = 0
--     },
-- 	config = {
--         extra = {
--         }
--     },

--     calculate = function(self, card, context)
--         return true
--     end,

    -- set_badges = create_badge_tengoku,

    -- credit = {
    --     art = "",
    --     code = "",
    --     concept = ""
    -- }
-- })


-- ======================

-- Samurai Drummer
SMODS.Joker({
    key = "samurai_drummer",

    loc_vars = function(self, info_queue, card)
                return {
                    vars = {
                        card.ability.extra.bonus_chips,
                        (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.flow or 0)*card.ability.extra.bonus_chips
                    }
                }
    end,
    cost = 6,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'jokers',
    pos = {
        x = 1,
        y = 0
    },
	config = {
        extra = {
            bonus_chips = 25
        }
    },

    calculate = function(self, card, context)
        
        if context.joker_main and context.cardarea == G.jokers then
            return {
                chips = (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.flow or 0) * card.ability.extra.bonus_chips,
                sound = "rh_text_gba",
                pitch = 1
            }
        end

        if not context.blueprint then
            -- Check if flow card has been used
            if context.using_consumeable then
                if context.consumeable.ability.set == "Flow" then
                    return {
                        message = "+" .. card.ability.extra.bonus_chips,
                        colour = G.C.BLUE,
                    }
                end
            end
        end

    end,

    set_badges = create_badge_tengoku,

    credit = {
        art = "missingnumber",
        code = "NoahAmp",
        concept = "missingnumber"
    }
})

-- Hairy Onion
SMODS.Joker({
    key = "onion",

    loc_vars = function(self, info_queue, card)
                return {
                    vars = {
                        card.ability.extra.n_draw,
                        card.ability.extra.can_draw
                    }
                }
    end,
    cost = 4,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'jokers',
    pos = {
        x = 2,
        y = 1
    },
	config = {
        extra = {
            n_draw = 1,
            can_draw = false
        }
    },

    calculate = function(self, card, context)
        -- Not blueprint compatible
        if context.blueprint then
            return
        end

        -- When discarding, check if we're gonna be below max hand size after discard, if so, we can draw afterwards
        if context.pre_discard and not card.ability.extra.can_draw
        then
            if #G.hand.cards - #G.hand.highlighted < G.hand.config.card_limit then
                card.ability.extra.can_draw = true
            end
            return true
        end

        -- After drawing next hand after discard, draw an extra card
        if context.hand_drawn and card.ability.extra.can_draw
        then
            G.E_MANAGER:add_event(Event({
                func = function()
                    -- play_sound("rh_pluck", math.random(0.5,1.5) , 0.5)
                    G.FUNCS.draw_from_deck_to_hand(card.ability.extra.n_draw)
                    return true
            end}))

            card.ability.extra.can_draw = not card.ability.extra.can_draw

            return {
                message = "Pluck!",
                sound = "rh_pluck",
                pitch = math.random(0.1,1.5)
            }
        end
    end,

    set_badges = create_badge_tengoku,

    credit = {
        art = "Nate Candles",
        code = "NoahAmp",
        concept = "Nate Candles"
    }
})

-- Sneaky Spirit
SMODS.Joker({
    key = "sneaky_spirit",

    loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
                return {
                    vars = {
                        card.ability.extra.rounds,
                        card.ability.extra.max_rounds
                    }
                }
    end,
    cost = 6,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'jokers',
    pos = {
        x = 3,
        y = 1
    },
	config = {
        extra = {
            rounds = 0,
            max_rounds = 2
        }
    },

    calculate = function(self, card, context)

        -- Not compatible with blueprint, can't be retriggered
        if context.blueprint and context.retrigger_joker then return end


        -- At the end of each round, tick one if it's still inactive
        if context.end_of_round and context.cardarea == G.jokers
        then
            if card.ability.extra.rounds >= card.ability.extra.max_rounds then return end -- Don't do anything if we already reached the goal

            card.ability.extra.rounds = card.ability.extra.rounds + 1

            local display_message = card.ability.extra.rounds .. "/"..card.ability.extra.max_rounds
            if card.ability.extra.rounds >= card.ability.extra.max_rounds then
                local eval = function(card) return card.ability.extra.rounds >= card.ability.extra.max_rounds end
                juice_card_until(card, eval, true)
                display_message = localize("k_active_ex")
            end

            return {
                sound = "rh_spirit_move",
                message = display_message
            }
        end

        -- When card is sold and waited enough rounds, trigger effect
        if context.selling_self and card.ability.extra.rounds >= card.ability.extra.max_rounds
        then
                -- Inspired by Invis. Joker.
                -- Set up the joker pool that excludes itself and does not already have an edition
                local jokers = {}
                for i=1, #G.jokers.cards do 

                    local c = G.jokers.cards[i]

                    if c ~= card and c.edition == nil then
                        sendDebugMessage("Adding negative to " .. G.jokers.cards[i].ability.name, "rhSneakySpirit")
                        jokers[#jokers+1] = c
                    end
                    
                end

                if #jokers > 0
                then
                    local to_add_neg = pseudorandom_element(jokers, pseudoseed('sneaky_spirit'))

                    to_add_neg:set_edition({negative = true}, true)
                end

                play_sound("rh_spirit_hit")
        end
        
    end,

    set_badges = create_badge_tengoku,

    credit = {
        art = "missingnumber",
        code = "NoahAmp",
        concept = "Casseddiez"
    }
})

-- Virus
SMODS.Joker({
    key = "sick_beats",

    loc_vars = function(self, info_queue, card)
                return {
                    vars = {
                        card.ability.extra.to_keep,
                    }
                }
    end,
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'jokers',
    pos = {
        x = 5,
        y = 0
    },
	config = {
        extra = {
            to_keep = 2
        }
    },

    calculate = function(self, card, context)
        if context.before then
            if not G.GAME.current_round.viruses_keep then
                G.GAME.current_round.viruses_keep = 0
            end
            G.GAME.current_round.viruses_keep = G.GAME.current_round.viruses_keep + card.ability.extra.to_keep
        end
        if context.after then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    if to_big(G.GAME.chips) - to_big(G.GAME.blind.chips) < to_big(0) and G.GAME.current_round.viruses_keep > 0 then
                        rh_conditional_return_to_hand(false)
                        local pitch = pseudorandom(pseudoseed('virus'), 5, 10)/10
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("k_rh_virus_miss"), sound="rh_virus", pitch = pitch})
                    else
                        rh_conditional_return_to_hand(true)
                    end
                    G.GAME.current_round.viruses_keep = 0
                    return true
                end
            }))
        end
    end,

    set_badges = create_badge_tengoku,

    credit = {
        art = "missingnumber",
        code = "TheAltDoc",
        concept = "patataofcourse"
    }
})

-- Space Gramps (common)
SMODS.Joker({
    key = "space_gramp",
    loc_vars = function(self, info_queue, card)
                return {
                    vars = {
                        card.ability.extra.mult_mod,
                        localize('Flush', 'poker_hands'),
                        card.ability.extra.mult
                    }
                }
    end,
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'jokers',
    pos = {
        x = 0,
        y = 1
    },
	config = { extra = { mult = 0, mult_mod = 4 }},

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.before then
            if next(context.poker_hands['Flush']) and not context.blueprint then
                if  (context.scoring_hand[1].base.suit == "Spades" or context.scoring_hand[1].base.suit == "Clubs") and
                    (context.scoring_hand[2].base.suit == "Spades" or context.scoring_hand[2].base.suit == "Clubs") then
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                    return {
                        sound = rh_localize_sfx('rh_space_gramp_pose'),
                        pitch = 1.0,
                        message = localize('k_upgrade_ex'),
                        colour = G.C.MULT
                    }
                end
            end
        end
        if context.joker_main then
            if card.ability.extra.mult > 0 then
                return {
                    message = localize({ type = "variable", key = "a_mult", vars = {
                        card.ability.extra.mult,
                    }}),
                    mult_mod = card.ability.extra.mult,
                    colour = G.C.MULT
                }
            end
        end
    end,

    set_badges = create_badge_tengoku,

    credit = {
        art = "missingnumber",
        code = "TheAltDoc",
        concept = "TheAltDoc"
    }
})

-- Cosmic Girl (common)
SMODS.Joker({
    key = "cosmic_girl",
    loc_vars = function(self, info_queue, card)
                return {
                    vars = {
                        card.ability.extra.mult_mod,
                        localize('Flush', 'poker_hands'),
                        card.ability.extra.mult
                    }
                }
    end,
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'jokers',
    pos = {
        x = 1,
        y = 1
    },
	config = { extra = { mult = 0, mult_mod = 4 }},

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.before then
            if next(context.poker_hands['Flush']) and not context.blueprint then
                if  context.scoring_hand[1].base.suit == "Hearts" or context.scoring_hand[1].base.suit == "Diamonds" and
                    context.scoring_hand[2].base.suit == "Hearts"  or context.scoring_hand[2].base.suit == "Diamonds"  then
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                    return {
                        sound = rh_localize_sfx('rh_cosmic_girl_pose'),
                        pitch = 1.0,
                        message = localize('k_upgrade_ex'),
                        colour = G.C.MULT
                    }
                end
            end
        end
        if context.joker_main then
            if card.ability.extra.mult > 0 then
                return {
                    message = localize({ type = "variable", key = "a_mult", vars = {
                        card.ability.extra.mult,
                    }}),
                    mult_mod = card.ability.extra.mult,
                    colour = G.C.MULT
                }
            end
        end
    end,

    set_badges = create_badge_tengoku,

    credit = {
        art = "missingnumber",
        code = "TheAltDoc",
        concept = "TheAltDoc"
    }
})

-- Widget (uncommon)
SMODS.Joker({
    key = "widget",
    loc_vars = function(self, info_queue, card)
                return {
                    vars = {
                        card.ability.extra.retriggers
                    }
                }
    end,
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'jokers',
    pos = {
        x = 0,
        y = 0
    },
	config = {
        extra = {
            retriggers = 2
        }
    },

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card == context.scoring_hand[5] then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retriggers,
                card = card,
                sound = "rh_widget",
                pitch = 1
            }
        end
    end,

    set_badges = create_badge_ds,

    credit = {
        art = "TheAltDoc",
        code = "TheAltDoc",
        concept = "patataofcourse"
    }
})

-- Conductor
SMODS.Joker({
    key = "glee_club",

    loc_vars = function(self, info_queue, card)
                return {
                    vars = {
                        card.ability.extra.xmult
                    }
                }
    end,
    cost = 8,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'jokers',
    pos = {
        x = 1,
        y = 5
    },
	config = {
        extra = {
            xmult = 1.5,
            xmult_shout = 5,
            position = -1,
            enable = false,
            is_shouting = false,
            affected_cards = {}
        }
    },

    calculate = function(self, card, context)
        -- Before doing anything, we grab the position
        if context.pre_joker then
            for k, v in ipairs(G.jokers.cards) do
                if v == card then
                    card.ability.extra.position = k
                    if k <= #G.jokers.cards-3 then
                        card.ability.extra.enable = true
                        card.ability.extra.affected_cards[1] = G.jokers.cards[k+1]
                        card.ability.extra.affected_cards[2] = G.jokers.cards[k+2]
                        card.ability.extra.affected_cards[3] = G.jokers.cards[k+3]
                        card.ability.extra.is_shouting = pseudorandom(pseudoseed('conductor'), 1, 100) > 80
                    end
                end
            end
        end
        if context.other_joker and card.ability.extra.enable == true then
            
            for k, v in ipairs(G.jokers.cards) do
                if not card.ability.extra.is_shouting then
                    if v == context.other_joker and (k > card.ability.extra.position and k <= card.ability.extra.position+3) then
                        return {
                            xmult = card.ability.extra.xmult,
                            sound = "rh_glee_club_a_"..(k - card.ability.extra.position),
                            remove_default_message = true,
                            message = "x"..card.ability.extra.xmult.." Mult",
                            pitch = 1,
                            colour = G.C.MULT,
                            message_card = context.other_joker
                        }
                    end
                else
                    if context.other_joker == card.ability.extra.affected_cards[3] then
                        return {
                            xmult = card.ability.extra.xmult_shout,
                            sound = "rh_glee_club_shout",
                            remove_default_message = true,
                            message = "x"..card.ability.extra.xmult_shout.." Mult",
                            pitch = 1,
                            colour = G.C.MULT,
                        }
                    end
                end
            end
        end
    end,
    
    set_badges = create_badge_ds,

    credit = {
        art = "Nate Candles",
        code = "TheAlternateDoctor",
        concept = ""
    }
})

-- Double Sided (common)
SMODS.Joker({
    key = "lockstep",
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.message,
                card.ability.extra.chips,
                card.ability.extra.mult
            }
        }
    end,
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'jokers',
    pos = {
        x = 2,
        y = 0
    },
	config = { extra = { parity = 0, chips = 20, mult = 2, message = localize("rh_even") }},

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if (context.other_card:get_id() <= 10 and
            context.other_card:get_id() >= 0 and
            context.other_card:get_id()%2 == card.ability.extra.parity)
            then
                return {
                    chips = card.ability.extra.chips,
                    mult = card.ability.extra.mult,
                }
            end
            -- I can't be bothered to write it better right now...
            if context.other_card:get_id() == 14 and card.ability.extra.parity == 1 then
                return {
                    chips = card.ability.extra.chips,
                    mult = card.ability.extra.mult,
                }
            end
        end
        if context.end_of_round and context.cardarea == G.jokers then
            local sound = ""
            if card.ability.extra.parity == 1 then
                card.ability.extra.parity = 0
                card.ability.extra.message = localize("rh_even")
                sound = "rh_lockstep_to_on"
            else 
                card.ability.extra.parity = 1
                card.ability.extra.message = localize("rh_odd")
                sound = "rh_lockstep_to_off"
            end
            return {
                sound = sound,
                pitch = 1,
                message = localize('k_reset')
            }
        end
    end,

    set_badges = create_badge_ds,

    set_ability = function(self, card, initial, delay_sprites)
        card.ability.extra.message = localize("rh_even")
    end,
    credit = {
        art = "patataofcourse",
        code = "TheAltDoc",
        concept = "TheAltDoc"
    }
})

-- Monkey
SMODS.Joker({
    key = "monkey",

    loc_vars = function(self, info_queue, card)
                return {
                    vars = {
                        card.ability.extra.repetitions
                    }
                }
    end,
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'jokers',
    pos = {
        x = 3,
        y = 0
    },
	config = {
        extra = {
            repetitions = 1
        }
    },

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.repetitions,
                card = card,
                sound = "rh_monkey"
            }
        end
    end,

    set_badges = create_badge_fever,

    credit = {
        art = "missingnumber",
        code = "NoahAmp",
        concept = "TheAltDoc"
    }
})

-- Huebird
SMODS.Joker({
    key = "flockstep",

    loc_vars = function(self, info_queue, card)
                return {
                    vars = {
                        card.ability.extra.create_flow
                    }
                }
    end,
    cost = 5,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'jokers',
    pos = {
        x = 5,
        y = 1
    },
	config = {
        extra = {
            create_flow = 1
        }
    },

    calculate = function(self, card, context)
        if context.joker_main and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + card.ability.extra.create_flow
            local suits = {
                ['Hearts'] = 0,
                ['Diamonds'] = 0,
                ['Spades'] = 0,
                ['Clubs'] = 0
            }
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i].ability.name ~= 'Wild Card' then
                    if context.scoring_hand[i]:is_suit('Hearts', true) and suits["Hearts"] == 0 then suits["Hearts"] = suits["Hearts"] + 1
                    elseif context.scoring_hand[i]:is_suit('Diamonds', true) and suits["Diamonds"] == 0  then suits["Diamonds"] = suits["Diamonds"] + 1
                    elseif context.scoring_hand[i]:is_suit('Spades', true) and suits["Spades"] == 0  then suits["Spades"] = suits["Spades"] + 1
                    elseif context.scoring_hand[i]:is_suit('Clubs', true) and suits["Clubs"] == 0  then suits["Clubs"] = suits["Clubs"] + 1 end
                end
            end
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i].ability.name == 'Wild Card' then
                    if context.scoring_hand[i]:is_suit('Hearts') and suits["Hearts"] == 0 then suits["Hearts"] = suits["Hearts"] + 1
                    elseif context.scoring_hand[i]:is_suit('Diamonds') and suits["Diamonds"] == 0  then suits["Diamonds"] = suits["Diamonds"] + 1
                    elseif context.scoring_hand[i]:is_suit('Spades') and suits["Spades"] == 0  then suits["Spades"] = suits["Spades"] + 1
                    elseif context.scoring_hand[i]:is_suit('Clubs') and suits["Clubs"] == 0  then suits["Clubs"] = suits["Clubs"] + 1 end
                end
            end
            if suits["Hearts"] > 0 and
            suits["Diamonds"] > 0 and
            suits["Spades"] > 0 and
            suits["Clubs"] > 0 then      
                local created = G.consumeables.config.card_limit - #G.consumeables.cards
                if created > card.ability.extra.create_flow then
                    created = card.ability.extra.create_flow
                end
                return {
                    extra = {focus = card, message = localize{type='variable',key='k_rh_plus_flow',vars={created}}, func = function()
                        G.E_MANAGER:add_event(Event({
                            trigger = 'before',
                            delay = 0.0,
                            func = (function()
                                    for i=1, card.ability.extra.create_flow do
                                        if #G.consumeables.cards < G.consumeables.config.card_limit then
                                            local flow = create_card('Flow',G.consumeables, nil, nil, nil, nil, nil, 'flockstep')
                                            flow:add_to_deck()
                                            G.consumeables:emplace(flow)
                                        end
                                    end
                                    G.GAME.consumeable_buffer = 0
                                    play_sound("rh_flockstep_jump")
                                return true
                            end)}))
                    end},
                    colour = G.C.SECONDARY_SET.Flow,
                    card = card,
                }
            end
        end
    end,

    set_badges = create_badge_fever,

    credit = {
        art = "missingnumber",
        code = "TheAltDoc",
        concept = "NoahAmp"
    }
})

-- Two Player
SMODS.Joker({
    key = "two_players",

    loc_vars = function(self, info_queue, card)
                return {
                    vars = {
                    }
                }
    end,
    cost = 6,
    rarity = 3,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'jokers',
    pos = {
        x = 0,
        y = 5
    },
	config = {
        extra = {
        }
    },

	calculate = function(self, card, context)
		if (context.joker_main and not context.debuffed_hand) or context.forcetrigger then
            local played_cards_key = {}
            local paired_cards_key = {}
            local paired = false
            for k, _ in ipairs(context.scoring_hand) do
                played_cards_key[#played_cards_key+1] = k
            end
            for k, v in ipairs(played_cards_key) do
                for jk, jv in ipairs(played_cards_key) do
                    if context.scoring_hand[v]:get_id() == context.scoring_hand[jv]:get_id() and v ~= jv then
                        local is_paired = false
                        for pk, pv in ipairs(paired_cards_key) do
                            if pv == v or pv == jv then 
                                is_paired = true
                            end
                        end
                        if not is_paired then
                            for pk, pv in ipairs(played_cards_key) do
                                if pv == v or pv == jv then 
                                    paired_cards_key[#paired_cards_key+1] = pk
                                end
                            end
                        end
                    end
                end
            end
            if #paired_cards_key == #context.scoring_hand then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound("rh_2player_balance")
                        return true
                    end}))
                return {
                    balance = true,
                }
            end
		end
	end,

    set_badges = create_badge_fever,

    credit = {
        art = "missingnumber",
        code = "TheAltDoc",
        concept = "patataofcourse"
    }
})

--Putting the Endless Remixes in the middle of the pool
SMODS.load_file("items/EndlessRemix.lua")()

-- Goat
SMODS.Joker({
    key = "goat",

    loc_vars = function(self, info_queue, card)
                return {
                    vars = {
                        card.ability.extra.small_payout,
                        card.ability.extra.medium_payout,
                        card.ability.extra.big_payout,
                    }
                }
    end,
    cost = 8,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'jokers',
    pos = {
        x = 4,
        y = 1
    },
	config = {
        extra = {
            small_payout = 5,
            medium_payout = 15,
            big_payout = 50
        }
    },

    calc_dollar_bonus = function(self, card, context)
        local d100 = pseudorandom(pseudoseed('goat'), 1, 100)
        
        sendDebugMessage("Rolled a ".. d100,"rhGoat")
        -- Payouts
        if d100 <= 60 then
            play_sound("rh_goat_one", 1, 0.5)
            card:juice_up(0.1, 0.5)
            return card.ability.extra.small_payout
        end

        if d100 > 60 and d100 <= 95 then
            play_sound("rh_goat_two", 1, 0.5)
            card:juice_up(0.3, 0.5)
            return card.ability.extra.medium_payout
        end

        if d100 > 95 then
            play_sound("rh_goat_three", 1, 0.5)
            card:juice_up(0.5, 0.5)
            return card.ability.extra.big_payout
        end

        -- How did you even reach here??
        return 1

    end,

    set_badges = create_badge_megamix,

    credit = {
        art = "missingnumber",
        code = "NoahAmp",
        concept = "NoahAmp"
    }
})

-- Bear
SMODS.Joker({
    key = "lumbearjack",

    loc_vars = function(self, info_queue, card)
                return {
                    vars = {
                        card.ability.extra.new_cards,
                    }
                }
    end,
    cost = 8,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'jokers',
    pos = {
        x = 4,
        y = 0
    },
	config = {
        extra = {
            new_cards = 2,
        }
    },

    calculate = function(self, card, context)
        if context.before and context.cardarea == G.jokers and #G.play.cards == 1 and G.GAME.current_round.hands_played == 0 then
            local suit_prefix = string.sub(context.scoring_hand[1].base.suit, 1, 1)..'_'
            local rank_suffix = math.min(context.scoring_hand[1].base.id, 14)
            local sound = "rh_bear_small"
            if rank_suffix > 10 then
                sound = "rh_bear_large"
            elseif rank_suffix > 5 then
                sound = "rh_bear_medium"
            end
            local base_rank = rank_suffix
            rank_suffix = math.ceil(rank_suffix/2)
            local halved_rank = rank_suffix
            for i=1, card.ability.extra.new_cards do
                local new_rank = halved_rank
                if base_rank > halved_rank then
                    base_rank = base_rank - halved_rank
                else
                    new_rank = base_rank
                    base_rank = base_rank + halved_rank
                end
                if new_rank == 1 then rank_suffix = 'A'
                elseif new_rank < 10 then rank_suffix = tostring(new_rank)
                elseif new_rank == 10 then rank_suffix = 'T'
                elseif new_rank == 11 then rank_suffix = 'J'
                elseif new_rank == 12 then rank_suffix = 'Q'
                elseif new_rank == 13 then rank_suffix = 'K'
                end
                sendDebugMessage("Creating a "..suit_prefix..rank_suffix, "rhLumbearjack")
                local _card = copy_card(context.scoring_hand[1], nil, nil, G.playing_card)
                _card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
                _card:add_to_deck()
                G.deck.config.card_limit = G.deck.config.card_limit + 1
                G.hand:emplace(_card)
                _card.states.visible = nil
                table.insert(G.playing_cards, _card)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        _card:start_materialize()
                        return true
                    end
                })) 
            end
            return {
                message = localize("rh_lumbearjack_axed"),
                colour = G.C.CHIPS,
                sound = sound,
                pitch = 1,
                playing_cards_created = {true}
            }
        elseif context.scoring_hand and #G.play.cards == 1 and context.destroying_card == context.scoring_hand[1] and G.GAME.current_round.hands_played == 0 and not context.blueprint then
            return {
                remove = true
            }
        elseif context.setting_blind then
            local eval = function(card) return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
        end
    end,

    set_badges = create_badge_megamix,
    
    credit = {
        art = "missingnumber",
        code = "TheAltDoc",
        concept = "TheAltDoc"
    }
})

-- Songbird Egg
SMODS.Joker({
    key = "songbird_egg",

    loc_vars = function(self, info_queue, card)
                return {
                    vars = {
                        card.ability.extra.mult,
                        card.ability.extra.level,
                        card.ability.extra.max_level,
                    }
                }
    end,
    cost = 6,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'jokers',
    pos = {
        x = 1,
        y = 3
    },
	config = {
        extra = {
            mult = 10,
            level = 0,
            max_level = 4
        }
    },

    calculate = function(self, card, context)
        
        if context.joker_main and context.cardarea == G.jokers then
            return {
                mult = card.ability.extra.mult
            }
        end

        if not context.blueprint then
            -- Check if flow card has been used
            if context.using_consumeable then
                if context.consumeable.ability.set == "Flow" then
                    card.ability.extra.level = card.ability.extra.level + 1
                    if card.ability.extra.level >= card.ability.extra.max_level then 
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.15,
                            func = function() 
                                card:flip()
                                play_sound('card1')
                                card:juice_up(0.3, 0.3)
                                return true 
                            end 
                        }))   
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.1,
                            func = function() 
                                local card_info = card.config.center
                                local remixed_config = {"Joker", stickers = card_info.stickers, skip_materialize = false, key = "j_rh_songbird_bird"}
                                if card.edition then
                                    remixed_config.edition = card.edition.key
                                else 
                                    remixed_config.no_edition = true
                                end
                                local remixed = SMODS.create_card(remixed_config)
                                local pos = remixed.T
                                pos.x = 1000
                                pos.y = 1000
                                pos.w = 0
                                pos.h = 0
                                remixed.T = pos
                                remixed.CT = pos
                                remixed.VT = pos
                                rh_copy_card(remixed, card)
                                remixed:start_dissolve(nil,true)
                                return true 
                            end 
                        }))        
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.15,
                            func = function() 
                                card:flip()
                                play_sound('tarot2', 1, 0.6)
                                card:juice_up(0.3, 0.3)
                                return true 
                            end 
                        }))
                        return {
                            message = "SKRAW!",
                            sound = "rh_songbird_hatch",
                            pitch = 1
                        }
                    else
                        return {
                            message = card.ability.extra.level.."/"..card.ability.extra.max_level,
                        }
                    end
                end
            end
        end

    end,

    set_badges = create_badge_megamix,
    
    credit = {
        art = "missingnumber",
        code = "TheAltDoc",
        concept = "Casseddiez, NoahAmp"
    }
})

-- Songbird
SMODS.Joker({
    key = "songbird_bird",

    loc_vars = function(self, info_queue, card)
                return {
                    vars = {
                        card.ability.extra.xmult,
                    }
                }
    end,
    cost = 6,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'jokers',
    pos = {
        x = 2,
        y = 3
    },
    soul_pos = {
        x = 3,
        y = 3
    },
	config = {
        extra = {
            xmult = 3,
        }
    },
    in_pool = function(self, args)
        return false
    end,

    calculate = function(self, card, context)
        if context.joker_main and context.cardarea == G.jokers then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,

    set_badges = create_badge_megamix,
    
    credit = {
        art = "missingnumber",
        code = "TheAltDoc",
        concept = "Casseddiez, NoahAmp"
    }
})

-- Munchy Monk
SMODS.Joker({
    key = "munchy_monk",
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.add_chips,
                card.ability.extra.add_mult,
                card.ability.extra.add_x_mult,
                (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.flow or 0)*card.ability.extra.add_chips,
                (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot or 0)*card.ability.extra.add_mult,
                card.ability.extra.x_mult,
            }
        }
    end,
    cost = 20,
    rarity = 4,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'jokers',
    pos = {
        x = 0,
        y = 2
    },
    soul_pos = {
        x = 1,
        y = 2
    },
	config = { extra = {
        add_chips = 50,
        add_mult = 1,
        add_x_mult = 0.1,
        chips = 0,
        mult = 0,
        x_mult = 1.0,
        monk_level = 0,
        soul_level = 0
    }},
    calculate = function(self, card, context)
        if
			context.using_consumeable
			and not context.consumeable.beginning_end
		then
			if context.consumeable.ability.set == "Planet" then
                card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.add_x_mult
                card.ability.extra.monk_level = card.ability.extra.monk_level +1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        if card.ability.extra.monk_level % 5 == 0 and card.ability.extra.monk_level < 21 then
                            card.ability.extra.soul_level = card.ability.extra.soul_level + 1
                            card.children.floating_sprite:set_sprite_pos({
                                x = card.ability.extra.soul_level + 1,
                                y = 2
                            })
                        end
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_xmult',vars={card.ability.extra.x_mult}}})
                        return true
                    end
                }))
            end
			if context.consumeable.ability.set == "Tarot" then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.add_mult
                card.ability.extra.monk_level = card.ability.extra.monk_level +1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        if card.ability.extra.monk_level % 5 == 0 and card.ability.extra.monk_level < 21 then
                            card.ability.extra.soul_level = card.ability.extra.soul_level + 1
                            card.children.floating_sprite:set_sprite_pos({
                                x = card.ability.extra.soul_level + 1,
                                y = 2
                            })
                        end
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.MULT})
                        return true
                    end
                }))
            end
			if context.consumeable.ability.set == "Flow" then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.add_chips
                card.ability.extra.monk_level = card.ability.extra.monk_level +1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        if card.ability.extra.monk_level % 5 == 0 and card.ability.extra.monk_level < 21 then
                            card.ability.extra.soul_level = card.ability.extra.soul_level + 1
                            card.children.floating_sprite:set_sprite_pos({
                                x = card.ability.extra.soul_level + 1,
                                y = 2
                            })
                        end
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.CHIPS})
                        return true
                    end}))
            end
            sendDebugMessage("Monk level: "..card.ability.extra.monk_level, "rh_j_munchy_monk")
            
            return
        end
        if context.joker_main then
            if
            card.ability.extra.x_mult ~= 1.0 or 
            card.ability.extra.mult ~= 0 or 
            card.ability.extra.chips ~= 0
            then 
                local sound = rh_localize_sfx("rh_monk_one")
                if card.ability.extra.monk_level > 2 then
                    sound = rh_localize_sfx("rh_monk_three")
                elseif card.ability.extra.monk_level > 0 then
                    sound = rh_localize_sfx("rh_monk_two")
                end
                return {
                    message = localize({ type = "variable", key = "a_mmoonk", vars = {
                        card.ability.extra.chips,
                        card.ability.extra.mult,
                        card.ability.extra.x_mult 
                    }}),
                    Xmult_mod = card.ability.extra.x_mult,
                    chip_mod = card.ability.extra.chips,
                    mult_mod = card.ability.extra.mult,
                    sound = sound,
                    pitch = 1
                }
            end
        end
    end,

    set_badges = create_badge_ds,
    
    credit = {
        art = "missingnumber",
        code = "TheAltDoc",
        concept = "TheAltDoc"
    }
})

-- Tibby
SMODS.Joker({
    key = "tibby",

    loc_txt = {
        name = "Tibby"
    },

    loc_vars = function(self, info_queue, card)
                return {
                    vars = {
                    }
                }
    end,
    cost = 20,
    rarity = 4,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'jokers',
    pos = {
        x = 4,
        y = 3
    },
    soul_pos = {
        x = 5,
        y = 3
    },
	config = {
        extra = {
        }
    },

    calculate = function(self, card, context)
        if context.before and context.cardarea == G.jokers and #G.play.cards == 1 then -- and G.GAME.current_round.hands_played == 0 then
            local hand_card = context.scoring_hand[1]
            local enhanced = false
            if hand_card.ability.set ~= "Enhanced" then
                enhanced = true
                hand_card:set_ability(G.P_CENTERS[SMODS.poll_enhancement({guaranteed = true, type_key = "tibby"})], nil, true)
            elseif not hand_card.seal then
                enhanced = true
                hand_card:set_seal(SMODS.poll_seal({guaranteed = true, type_key = "tibby"}), nil, true)
            elseif not hand_card.edition then
                enhanced = true
                hand_card:set_edition(poll_edition("tibby", nil, true, true), true)
            end
            if enhanced then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        hand_card:juice_up()
                        return true
                    end 
                }))
                return {
                    message = localize('k_rh_tibby'),
                    colour = G.C.SECONDARY_SET.FLOW,
                }
            end
        end
    end,

    set_badges = create_badge_megamix,

    credit = {
        art = "missingnumber",
        code = "TheAltDoc",
        concept = "TheAltDoc"
    }
})
