-- matrix_bridge/init.lua
-- Bridge between Matrix and Minetest
--[[
    This Source Code Form is subject to the terms of the Mozilla Public
    License, v. 2.0. If a copy of the MPL was not distributed with this
    file, You can obtain one at https://mozilla.org/MPL/2.0/.
]]

matrix_bridge = {}

local MP = minetest.get_modpath("matrix_bridge")

local internal_share = {}

local http = minetest.request_http_api and minetest.request_http_api()
if not http then
    error("matrix_bridge not included in secure.http_mods.")
end
internal_share.http = http


for _, name in ipairs({
    "bridge",
    "event",
    "handle"
}) do
    assert(loadfile(MP .. "/src/" .. name .. ".lua"))(internal_share)
end