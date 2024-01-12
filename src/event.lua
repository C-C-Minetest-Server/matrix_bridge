-- matrix_bridge/src/event.lua
-- Send Minetest events to Matrix
--[[
    This Source Code Form is subject to the terms of the Mozilla Public
    License, v. 2.0. If a copy of the MPL was not distributed with this
    file, You can obtain one at https://mozilla.org/MPL/2.0/.
]]

-- Player list change
local function handle_player_list_change()
    local plist = minetest.get_connected_players()
    local pnames = {}

    for _, player in ipairs(plist) do
        pnames[#pnames+1] = player:get_player_name()
    end

    matrix_bridge.send_event({
        type = "player_list_change",
        player_list = pnames
    })
end

minetest.register_on_joinplayer(function(player)
    matrix_bridge.send_event({
        type = "joinplayer",
        player_name = player:get_player_name()
    })

    handle_player_list_change()
end)

minetest.register_on_leaveplayer(function(player)
    matrix_bridge.send_event({
        type = "leaveplayer",
        player_name = player:get_player_name()
    })

    handle_player_list_change()
end)


-- Chat send all
matrix_bridge.chat_send_all = minetest.chat_send_all
function minetest.chat_send_all(text)
    matrix_bridge.chat_send_all(text)
    matrix_bridge.send_event({
        type = "chat_send_all",
        chat_message = text
    })
end


-- Chat by player
minetest.register_on_mods_loaded(function()
    minetest.register_on_chat_message(function(name, message)
        if message:sub(1,1) == "/" then
            return
        end

        matrix_bridge.send_event({
            type = "chat_by_player",
            player_name = name,
            chat_message = message
        })
    end)
end)


-- Server state
minetest.register_on_mods_loaded(function()
    matrix_bridge.send_event({
        type = "server_state",
        state = "started"
    })
end)

minetest.register_on_shutdown(function()
    local plist = minetest.get_connected_players()
    local pnames = {}

    for _, player in ipairs(plist) do
        matrix_bridge.send_event({
            type = "leaveplayer",
            player_name = player:get_player_name()
        })
    end

    matrix_bridge.send_event({
        type = "player_list_change",
        player_list = {}
    })

    matrix_bridge.send_event({
        type = "server_state",
        state = "stopped"
    })

    matrix_bridge.force_request()
end)
