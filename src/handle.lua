-- matrix_bridge/src/handle.lua
-- Handle matrix-side events
--[[
    This Source Code Form is subject to the terms of the Mozilla Public
    License, v. 2.0. If a copy of the MPL was not distributed with this
    file, You can obtain one at https://mozilla.org/MPL/2.0/.
]]

-- Matrix Chat Messages
matrix_bridge.register_event_handler("matrix_chat_message", function(event)
    --[[
        {
            type         = "matrix_chat_message",
            identifier   = "@username:example.com",
            nickname     = "FooBar",
            chat_message = "Hello World!"
        }
    ]]

    local identifier = event.identifier
    local message    = event.chat_message

    -- Trim away any injected sequences
    message = minetest.strip_colors(message)
    message = minetest.get_translated_string("en", message)

    minetest.chat_send_all(minetest.format_chat_message(identifier, message))
end)


-- Matrix user join
matrix_bridge.register_event_handler("matrix_user_join", function(event)
    --[[
        {
            type       = "matrix_user_join",
            identifier = "@username:example.com",
            nickname   = "FooBar"
        }
    ]]

    local identifier = event.identifier

    minetest.chat_send_all("*** " .. identifier .. " joined the matrix chatroom.")
end)


-- Matrix user leave
matrix_bridge.register_event_handler("matrix_user_leave", function(event)
    --[[
        {
            type       = "matrix_user_leave",
            identifier = "@username:example.com",
            nickname   = "FooBar"
        }
    ]]

    local identifier = event.identifier

    minetest.chat_send_all("*** " .. identifier .. " left the matrix chatroom.")
end)