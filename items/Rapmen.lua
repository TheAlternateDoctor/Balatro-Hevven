
SMODS.Joker({
    key = "rapmen",

    loc_vars = function(self, info_queue, card)
                return {
                    vars = {
                    }
                }
    end,
    cost = 1,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'jokers',
    pos = {
        x = 0,
        y = 6
    },
    flipbook_anim_states = {
        add_to_deck = {
            anim = {
                { xrange = {first = 2, last = 5}, y = 6, t = 0.3 },
                { xrange = {first = 0, last = 3}, y = 7, t = 0.3 },
                {x = 0, y = 6, t = 1},
            },
            loop = false
        },
        idle = {
            anim = {
                {x = 0, y = 6, t = 1}
            },
            loop = false
        }
    },
    flipbook_anim_current_state = "idle",
	config = {
        extra = {
        }
    },
    add_to_deck = function(self, card, from_debuff)
        if SMODS.Mods.GSFlipbook and not SMODS.Mods.GSFlipbook.disabled then
            card:flipbook_set_anim_state("add_to_deck")
        end
        for _, v in pairs(G.jokers.cards) do
            rh_manipulate_food_jokers(false, v)
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        for _, v in pairs(G.jokers.cards) do
            rh_revert_food_jokers(false, v)
        end
    end,

    calculate = function(self, card, context)
        if context.card_added then
            rh_manipulate_food_jokers(false, context.card)
        end
        if context.selling_card then
            if context.card.config.center.key == "j_diet_cola" then
                local soda_config = {set = "Joker", area = G.jokers, key = "j_rh_half_soda", stickers = context.card.config.center.stickers}
                if context.card.edition then
                    soda_config.edition = context.card.edition.key
                else 
                    soda_config.no_edition = true
                end
                local card = SMODS.create_card(soda_config)
                card:add_to_deck()
                card:start_materialize()
                G.jokers:emplace(card)
                return true
            end
        end
    end,

    set_badges = create_badge_tengoku,

    credit = {
        art = "Nate Candles",
        code = "TheAltDoc",
        concept = "Nate Candles"
    }
})

SMODS.Joker({
    key = "rapwomen",

    loc_vars = function(self, info_queue, card)
                return {
                    vars = {
                    }
                }
    end,
    cost = 1,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'jokers',
    pos = {
        x = 0,
        y = 8
    },
    flipbook_anim_states = {
        add_to_deck = {
            anim = {
                { xrange = {first = 2, last = 5}, y = 8, t = 0.3 },
                { xrange = {first = 0, last = 2}, y = 9, t = 0.3 },
                {x = 2, y = 9, t = 1},
                {x = 0, y = 8, t = 1},
            },
            loop = false
        },
        idle = {
            anim = {
                {x = 0, y = 8, t = 1}
            },
            loop = false
        }
    },
    flipbook_anim_current_state = "idle",
	config = {
        extra = {
        }
    },
    add_to_deck = function(self, card, from_debuff)
        if SMODS.Mods.GSFlipbook and not SMODS.Mods.GSFlipbook.disabled then
            card:flipbook_set_anim_state("add_to_deck")
        end
        for _, v in pairs(G.jokers.cards) do
            rh_manipulate_food_jokers(true, v)
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        for _, v in pairs(G.jokers.cards) do
            rh_revert_food_jokers(true, v)
        end
    end,

    calculate = function(self, card, context)
        if context.card_added then
            rh_manipulate_food_jokers(true, context.card)
        end
        if context.repetition and context.cardarea == G.play and #SMODS.find_card("j_selzer") >0 then
            return {
                repetitions = #SMODS.find_card("j_selzer"),
            }
        end
        if context.selling_card and context.card.config.center.key == "j_diet_cola" then
            G.E_MANAGER:add_event(Event({
                func = (function()
                    add_tag(Tag('tag_double'))
                    play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                    return true
                end)
            }))
            return nil, true
        end
    end,

    set_badges = create_badge_tengoku,

    credit = {
        art = "Nate Candles",
        code = "TheAltDoc",
        concept = "Nate Candles"
    }
})

function rh_manipulate_food_jokers(gender, card)
    if not gender then -- RAPMEN
        if(card.config.center.key == "j_ice_cream") then
            card.ability.extra.chip_mod = card.ability.extra.chip_mod/2
        elseif(card.config.center.key == "j_turtle_bean") then
            card.ability.extra.h_mod = card.ability.extra.h_mod/2
        elseif(card.config.center.key == "j_cavendish") then
            card.ability.extra.odds = card.ability.extra.odds*2
        elseif(card.config.center.key == "j_gros_michel") then
            card.ability.extra.odds = card.ability.extra.odds*2
        elseif(card.config.center.key == "j_popcorn") then
            card.ability.extra = card.ability.extra/2
        elseif(card.config.center.key == "j_ramen") then
            card.ability.extra = card.ability.extra/2
        elseif(card.config.center.key == "j_selzer") then
            card.ability.extra = card.ability.extra*2
        end
    else -- RAPWOMEN
        if(card.config.center.key == "j_ice_cream") then
            card.ability.extra.chip_mod = card.ability.extra.chip_mod*4
            card.ability.extra.chips = card.ability.extra.chips*2
        elseif(card.config.center.key == "j_turtle_bean") then
            card.ability.extra.h_mod = card.ability.extra.h_mod*4
            G.hand:change_size(card.ability.extra.h_size)
            card.ability.extra.h_size = card.ability.extra.h_size*2
        elseif(card.config.center.key == "j_cavendish") then
            card.ability.extra.odds = card.ability.extra.odds/2
            card.ability.extra.Xmult = card.ability.extra.Xmult*2
        elseif(card.config.center.key == "j_gros_michel") then
            card.ability.extra.odds = card.ability.extra.odds/2
            card.ability.extra.mult = card.ability.extra.mult*2
        elseif(card.config.center.key == "j_popcorn") then
            card.ability.mult = card.ability.mult*2
            card.ability.extra = card.ability.extra*4
        elseif(card.config.center.key == "j_ramen") then
            card.ability.extra = card.ability.extra*4
            card.ability.x_mult = card.ability.x_mult*2
            card.ability.Xmult = card.ability.Xmult*2
        elseif(card.config.center.key == "j_selzer") then
            card.ability.extra = card.ability.extra/2
        elseif(card.config.center.key == "j_egg") then
            card.ability.extra = card.ability.extra*2
        end
    end
end

function rh_revert_food_jokers(gender, card)
    if not gender then -- RAPMEN
        if(card.config.center.key == "j_ice_cream") then
            card.ability.extra.chip_mod = card.ability.extra.chip_mod*2
        elseif(card.config.center.key == "j_turtle_bean") then
            card.ability.extra.h_mod = card.ability.extra.h_mod*2
        elseif(card.config.center.key == "j_cavendish") then
            card.ability.extra.odds = card.ability.extra.odds/2
        elseif(card.config.center.key == "j_gros_michel") then
            card.ability.extra.odds = card.ability.extra.odds/2
        elseif(card.config.center.key == "j_popcorn") then
            card.ability.extra = card.ability.extra*2
        elseif(card.config.center.key == "j_ramen") then
            card.ability.extra = card.ability.extra*2
        elseif(card.config.center.key == "j_selzer") then
            card.ability.extra = card.ability.extra/2
        end
    else -- RAPWOMEN
        if(card.config.center.key == "j_ice_cream") then
            card.ability.extra.chip_mod = card.ability.extra.chip_mod/4
            card.ability.extra.chips = card.ability.extra.chips/2
        elseif(card.config.center.key == "j_turtle_bean") then
            card.ability.extra.h_mod = card.ability.extra.h_mod/4
            card.ability.extra.h_size = card.ability.extra.h_size/2
            G.hand:change_size(-card.ability.extra.h_size)
        elseif(card.config.center.key == "j_cavendish") then
            card.ability.extra.odds = card.ability.extra.odds*4
            card.ability.extra.Xmult = card.ability.extra.Xmult/2
        elseif(card.config.center.key == "j_gros_michel") then
            card.ability.extra.odds = card.ability.extra.odds*4
            card.ability.extra.mult = card.ability.extra.mult/2
        elseif(card.config.center.key == "j_popcorn") then
            card.ability.mult = card.ability.mult/2
            card.ability.extra = card.ability.extra/4
        elseif(card.config.center.key == "j_ramen") then
            card.ability.extra = card.ability.extra/4
            card.ability.x_mult = card.ability.x_mult/2
            card.ability.Xmult = card.ability.Xmult/2
        elseif(card.config.center.key == "j_selzer") then
            card.ability.extra = card.ability.extra*2
        elseif(card.config.center.key == "j_egg") then
            card.ability.extra = card.ability.extra/2
        end
    end
end