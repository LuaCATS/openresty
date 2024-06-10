---@meta

---@class resty.websocket.server : resty.websocket
---
---@field _VERSION string
---
---@field send_masked boolean
local server = {}

---@class resty.websocket.server.new.opts : resty.websocket.new.opts
---@field send_masked? boolean  # send masked WebSocket frames. Default: `false`.

---Performs the websocket handshake process on the server side and returns a WebSocket server object.
---
---In case of error, it returns nil and a string describing the error.
---@param  opts?                   resty.websocket.server.new.opts
---@return resty.websocket.server? server
---@return string?                 error
function server:new(opts) end

---Send a continuation frame
---@param  data?    string
---@return integer? bytes
---@return string?  error
function server:send_continue(data) end

return server
