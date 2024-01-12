-- matrix_bridge/src/bridge.lua
-- Bridge codes
--[[
    This Source Code Form is subject to the terms of the Mozilla Public
    License, v. 2.0. If a copy of the MPL was not distributed with this
    file, You can obtain one at https://mozilla.org/MPL/2.0/.
]]

local internal_share = ...
local http = internal_share.http

local function do_registerations()
    local t = {}
    local function reg(key, func)
        t[key] = func
    end
    return t, reg
end

matrix_bridge.registered_event_handlers, matrix_bridge.register_event_handler = do_registerations()

local pending_send = {}

function matrix_bridge.send_event(event)
    pending_send[#pending_send + 1] = event
end


local local_server = minetest.settings:get("matrix_bridge.local_server")
if local_server == "" then
    error("matrix_bridge.local_server not set in minetest.conf.")
end


local do_request
do_request = function()
    local data
    if #pending_send >= 1 then
        data = minetest.write_json(pending_send)
    else
        data = "[]"
    end
    pending_send = {}

    http.fetch({
        url = local_server,
        method = "POST",
        data = data,
        user_agent = "Minetest_Matrix_Bridge",
        extra_headers = {
            "Content-Type: application/json",
        }
    }, function(result)
        if result.succeeded then
            local events = minetest.parse_json(result.data)
            for i, event in ipairs(events) do
                if matrix_bridge.registered_event_handlers[event.type] then
                    matrix_bridge.registered_event_handlers[event.type](events)
                else
                    minetest.log("warning", "[matrix_bridge] received invalid event type: " .. event.type)
                end
            end
        end

        do_request()
    end)
end

do_request()

function matrix_bridge.force_request()
    local data
    if #pending_send >= 1 then
        data = minetest.write_json(pending_send)
    else
        data = "{}"
    end
    pending_send = {}

    http.fetch({
        url = local_server,
        method = "POST",
        data = data,
        user_agent = "Minetest_Matrix_Bridge",
        extra_headers = {
            "Content-Type: application/json",
        }
    }, function() end)
end
