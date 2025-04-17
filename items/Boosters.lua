SMODS.Booster({
    key='flow_pack_1',
    kind = "Flow",
    atlas = "boosters",
    pos = {
        x = 1,
        y = 0
    },
    config = { extra = 2, choose = 1 },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra } }
	end,
    select_card = "consumeables",
    create_card = function(self, card)
		return create_card("Flow", G.pack_cards, nil, nil, true, true, nil, "rh_flow")
	end,
	ease_background_colour = function(self)
		ease_colour(G.C.DYN_UI.MAIN, G.C.SECONDARY_SET.Flow)
		ease_background_colour({ new_colour = G.C.SECONDARY_SET.Flow, special_colour = G.C.BLACK, contrast = 2 })
	end,
    in_pool = function()
		return G.GAME.used_vouchers.v_rh_gatekeeper_deal
	end,
	group_key = "k_rh_flow_pack",
})

SMODS.Booster({
    key='flow_pack_2',
    kind = "Flow",
    atlas = "boosters",
    pos = {
        x = 1,
        y = 0
    },
    config = { extra = 2, choose = 1 },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra } }
	end,
    select_card = "consumeables",
    create_card = function(self, card)
		return create_card("Flow", G.pack_cards, nil, nil, true, true, nil, "rh_flow")
	end,
	ease_background_colour = function(self)
		ease_colour(G.C.DYN_UI.MAIN, G.C.SECONDARY_SET.Flow)
		ease_background_colour({ new_colour = G.C.SECONDARY_SET.Flow, special_colour = G.C.BLACK, contrast = 2 })
	end,
    in_pool = function()
		return G.GAME.used_vouchers.v_rh_gatekeeper_deal
	end,
	group_key = "k_rh_flow_pack",
})

SMODS.Booster({
    key='flow_jumbo',
    kind = "Flow",
    atlas = "boosters",
    pos = {
        x = 2,
        y = 0
    },
    config = { extra = 4, choose = 1 },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra } }
	end,
    select_card = "consumeables",
    create_card = function(self, card)
		return create_card("Flow", G.pack_cards, nil, nil, true, true, nil, "rh_flow")
	end,
	ease_background_colour = function(self)
		ease_colour(G.C.DYN_UI.MAIN, G.C.SECONDARY_SET.Flow)
		ease_background_colour({ new_colour = G.C.SECONDARY_SET.Flow, special_colour = G.C.BLACK, contrast = 2 })
	end,
    in_pool = function()
		return G.GAME.used_vouchers.v_rh_gatekeeper_deal
	end,
	group_key = "k_rh_flow_pack",
})

SMODS.Booster({
    key='flow_mega',
    kind = "Flow",
    atlas = "boosters",
    pos = {
        x = 3,
        y = 0
    },
    config = { extra = 4, choose = 2 },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra } }
	end,
    select_card = "consumeables",
    create_card = function(self, card)
		return create_card("Flow", G.pack_cards, nil, nil, true, true, nil, "rh_flow")
	end,
	ease_background_colour = function(self)
		ease_colour(G.C.DYN_UI.MAIN, G.C.SECONDARY_SET.Flow)
		ease_background_colour({ new_colour = G.C.SECONDARY_SET.Flow, special_colour = G.C.BLACK, contrast = 2 })
	end,
    in_pool = function()
		return G.GAME.used_vouchers.v_rh_gatekeeper_deal
	end,
	group_key = "k_rh_flow_pack",
})

SMODS.Booster({
    key='legendary',
    kind = "Joker",
    atlas = "boosters",
    pos = {
        x = 0,
        y = 1
    },
    config = { extra = 2, choose = 1 },
    weight = 0,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra } }
	end,
    -- select_card = "joker",
    create_card = function(self, card)
		return create_card("Joker", G.pack_cards, true, nil, true, true, nil, "rh_flow")
	end,
	ease_background_colour = function(self)
		ease_colour(G.C.DYN_UI.MAIN, G.C.SECONDARY_SET.Spectral)
		ease_background_colour({ new_colour = G.C.SECONDARY_SET.Spectral, special_colour = G.C.BLACK, contrast = 2 })
	end,
    in_pool = function()
		return false
	end,
	group_key = "k_rh_legendary",
})
