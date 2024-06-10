---@meta

---@class resty.core.response
---
---@field version string
local response = {}

---@param tb           any
---@param key          string
---@param value?       string|string[]
---@param no_override? boolean
function response.set_resp_header(tb, key, value, no_override) end

return response
