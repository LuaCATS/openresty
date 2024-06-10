---@meta

---@class resty.websocket.server : resty.websocket
---
---@field _VERSION string
local server = {}

---Performs the websocket handshake process on the server side and returns a WebSocket server object.
---
---In case of error, it returns nil and a string describing the error.
---@param  opts?                   resty.websocket.new.opts
---@return resty.websocket.server? server
---@return string?                 error
function server:new(opts) end

return server
