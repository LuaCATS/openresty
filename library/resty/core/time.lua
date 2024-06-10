---@meta

---@class resty.core.time
---
---@field version string
local time = {}

--- Returns the elapsed time in milliseconds from the machine boot for the current time stamp from the Nginx cached time (no syscall involved unlike Lua's date library).
---
--- ```lua
--- local cur_msec = require "resty.core.time".monotonic_msec
--- ngx.say(cur_msec())
--- ```
---@return number
function time.monotonic_msec() end

--- Returns a floating-point number for the elapsed time in seconds (including milliseconds as the decimal part) from the machine boot for the current time stamp from the Nginx cached time (no syscall involved unlike Lua's date library).
---
--- ```lua
--- local cur_time = require "resty.core.time".monotonic_time
--- ngx.say(cur_time())
--- ```
---
---@return number
function time.monotonic_time() end

return time
