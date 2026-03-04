-- Since we're autogenerating these, it's better to have the localization here
local loc_txt = {
    ['en-us'] = {
        name = 'Endless Remix',
        text = {
            "This {C:attention}Joker{} transforms into",
            "another {C:attention}Joker{} of the same",
            "rarity at the end of {C:attention}every round",
        }
    },
    ['fr'] = {
        name = 'Remix infini',
        text = {
            "Ce {C:attention}Joker{} se transforme",
            "en un autre {C:attention}Joker{} de même",
            "rareté à la fin de {C:attention}chaque manche",
        }
    },
}

local credit = {
    art = "missingnumber",
    code = "TheAltDoc",
    concept = "TheAltDoc"
}


-- Endless Remix (Common)
SMODS.Joker({
    key = "endless_common",
    cost = 2,
    rarity = 1,
    loc_txt = loc_txt,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'jokers',
    credit = credit,
    pos = {
        x = 0,
        y = 4
    },
    soul_pos = {
        x = 1,
        y = 4
    },
	config = {
        extra = {
        }
    },
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not card.ability.rh_remix_sticker then
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
                    local remixed_config = {set = card_info.set, stickers = card_info.stickers, rarity=0.6, skip_materialize = false}
                    if card.edition then
                        remixed_config.edition = card.edition.key
                    else 
                        remixed_config.no_edition = true
                    end
                    local remixed = rh_create_card_silent(remixed_config)
                    local pos = remixed.T
                    pos.x = 1000
                    pos.y = 1000
                    pos.w = 0
                    pos.h = 0
                    remixed.T = pos
                    remixed.CT = pos
                    remixed.VT = pos
                    remixed:add_sticker('rh_remix_sticker_joker', true)
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
        end
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('k_rh_endless'), HEX('cd00cd'), HEX('FEE500'), 1.2 )
        badges[#badges+1] = create_badge(localize('k_rh_wii_badge'), HEX('e0001a'), HEX('ffffff'), 1.2 )
    end,
})

-- Endless Remix (Uncommon)
SMODS.Joker({
    key = "endless_uncommon",
    cost = 4,
    rarity = 2,
    loc_txt = loc_txt,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'jokers',
    credit = credit,
    pos = {
        x = 0,
        y = 4
    },
    soul_pos = {
        x = 2,
        y = 4
    },
	config = {
        extra = {
        }
    },
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not card.ability.rh_remix_sticker then
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
                    local remixed_config = {set = card_info.set, stickers = card_info.stickers, rarity=0.75, skip_materialize = false}
                    if card.edition then
                        remixed_config.edition = card.edition.key
                    else 
                        remixed_config.no_edition = true
                    end
                    local remixed = rh_create_card_silent(remixed_config)
                    local pos = remixed.T
                    pos.x = 1000
                    pos.y = 1000
                    pos.w = 0
                    pos.h = 0
                    remixed.T = pos
                    remixed.CT = pos
                    remixed.VT = pos
                    remixed:add_sticker('rh_remix_sticker_joker', true)
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
        end
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('k_rh_endless'), HEX('cd00cd'), HEX('FEE500'), 1.2 )
        badges[#badges+1] = create_badge(localize('k_rh_wii_badge'), HEX('e0001a'), HEX('ffffff'), 1.2 )
    end,
})

-- Endless Remix (Rare)
SMODS.Joker({
    key = "endless_rare",
    cost = 6,
    rarity = 3,
    loc_txt = loc_txt,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'jokers',
    credit = credit,
    pos = {
        x = 0,
        y = 4
    },
    soul_pos = {
        x = 3,
        y = 4
    },
	config = {
        extra = {
        }
    },
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not card.ability.rh_remix_sticker then
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
                    local remixed_config = {set = card_info.set, stickers = card_info.stickers, rarity=1, skip_materialize = false}
                    if card.edition then
                        remixed_config.edition = card.edition.key
                    else 
                        remixed_config.no_edition = true
                    end
                    local remixed = rh_create_card_silent(remixed_config)
                    local pos = remixed.T
                    pos.x = 1000
                    pos.y = 1000
                    pos.w = 0
                    pos.h = 0
                    remixed.T = pos
                    remixed.CT = pos
                    remixed.VT = pos
                    remixed:add_sticker('rh_remix_sticker_joker', true)
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
        end
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('k_rh_endless'), HEX('cd00cd'), HEX('FEE500'), 1.2 )
        badges[#badges+1] = create_badge(localize('k_rh_wii_badge'), HEX('e0001a'), HEX('ffffff'), 1.2 )
    end,
})

-- Endless Remix (Legendary)
SMODS.Joker({
    key = "endless_legendary",
    cost = 20,
    rarity = 4,
    loc_txt = loc_txt,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'jokers',
    credit = credit,
    pos = {
        x = 0,
        y = 4
    },
    soul_pos = {
        x = 4,
        y = 4
    },
	config = {
        extra = {
        }
    },
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not card.ability.rh_remix_sticker then
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
                    local remixed_config = {set = card_info.set, stickers = card_info.stickers, legendary = true, skip_materialize = false}
                    if card.edition then
                        remixed_config.edition = card.edition.key
                    else 
                        remixed_config.no_edition = true
                    end
                    local remixed = rh_create_card_silent(remixed_config)
                    local pos = remixed.T
                    pos.x = 1000
                    pos.y = 1000
                    pos.w = 0
                    pos.h = 0
                    remixed.T = pos
                    remixed.CT = pos
                    remixed.VT = pos
                    while G.GAME.blind.boss and remixed.ability.name == "Chicot" do
                        sendDebugMessage("Rolled into Chicot during a boss blind!", "rhRemixSticker")
                        remixed:start_dissolve(nil,true)
                        remixed = rh_create_card_silent(remixed_config)
                        sendDebugMessage("Rolled "..remixed.ability.name, "rhRemixSticker")
                        pos = remixed.T
                        pos.x = 1000
                        pos.y = 1000
                        pos.w = 0
                        pos.h = 0
                        remixed.T = pos
                        remixed.CT = pos
                        remixed.VT = pos
                    end
                    remixed:add_sticker('rh_remix_sticker_joker', true)
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
        end
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge(localize('k_rh_endless'), HEX('cd00cd'), HEX('FEE500'), 1.2 )
        badges[#badges+1] = create_badge(localize('k_rh_wii_badge'), HEX('e0001a'), HEX('ffffff'), 1.2 )
    end,
})

for k, v in pairs(SMODS.Rarities) do
    if k ~= "Common" and k ~= "Uncommon" and k ~= "Rare" and k ~= "Legendary" then
        SMODS.Joker({
            key = "endless_"..k,
            loc_txt = loc_txt,
            cost = 6,
            rarity = k,
            blueprint_compat = false,
            eternal_compat = true,
            unlocked = true,
            discovered = true,
            atlas = 'jokers',
            credit = credit,
            pos = {
                x = 0,
                y = 4
            },
            soul_pos = {
                x = 5,
                y = 4
            },
            config = {
                extra = {
                }
            },
            calculate = function(self, card, context)
                if context.end_of_round and context.main_eval and not card.ability.rh_remix_sticker then
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
                            local remixed_config = {set = card_info.set, stickers = card_info.stickers, rarity=k, skip_materialize = false}
                            if card.edition then
                                remixed_config.edition = card.edition.key
                            else 
                                remixed_config.no_edition = true
                            end
                            local remixed = rh_create_card_silent(remixed_config)
                            local pos = remixed.T
                            pos.x = 1000
                            pos.y = 1000
                            pos.w = 0
                            pos.h = 0
                            remixed.T = pos
                            remixed.CT = pos
                            remixed.VT = pos
                            remixed:add_sticker('rh_remix_sticker_joker', true)
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
                end
            end,
            set_badges = function(self, card, badges)
                badges[#badges+1] = create_badge(localize('k_rh_endless'), HEX('cd00cd'), HEX('FEE500'), 1.2 )
                badges[#badges+1] = create_badge(localize('k_rh_wii_badge'), HEX('e0001a'), HEX('ffffff'), 1.2 )
            end,
        })
    end
end