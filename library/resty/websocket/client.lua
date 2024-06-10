---@meta

---@class resty.websocket.client : resty.websocket
---
---@field _VERSION string
---
---@field send_unmasked boolean
local client = {}

---@class resty.websocket.client.new.opts : resty.websocket.new.opts
---@field send_unmasked? boolean # send unmasked WebSocket frames. Default: `false`.

---Instantiates a WebSocket client object.
---
---In case of error, it returns nil and a string describing the error.
---
---An optional options table can be specified.
---
---@param  opts?                   resty.websocket.client.new.opts
---@return resty.websocket.client? client
---@return string?                 error
function client:new(opts) end

---Connects to the remote WebSocket service port and performs the websocket
---handshake process on the client side.
---
---Before actually resolving the host name and connecting to the remote backend,
---this method will always look up the connection pool for matched idle
---connections created by previous calls of this method.
---
---The third return value of this method contains the raw, plain-text response
---(status line and headers) to the handshake request. This allows the caller to
---perform additional validation and/or extract the response headers. When the
---connection is reused and no handshake request is sent, the string
---"connection reused" is returned in lieu of the response.
---
---@param  uri     string
---@param  opts?   resty.websocket.client.connect.opts
---@return boolean ok
---@return string? error
---@return string? response
function client:connect(uri, opts) end

--- Puts the current WebSocket connection immediately into the ngx_lua cosocket connection pool.
---
--- You can specify the max idle timeout (in ms) when the connection is in the pool and the maximal size of the pool every nginx worker process.
---
--- In case of success, returns 1. In case of errors, returns nil with a string describing the error.
---
--- Only call this method in the place you would have called the close method instead. Calling this method will immediately turn the current WebSocket object into the closed state. Any subsequent operations other than connect() on the current object will return the closed error.
----
---@param  max_idle_timeout number
---@param  pool_size        integer
---@return boolean          ok
---@return string?          error
function client:set_keepalive(max_idle_timeout, pool_size) end

---Closes the current WebSocket connection.
---
---If no close frame is sent yet, then the close frame will be automatically sent.
---
---@return boolean ok
---@return string? error
function client:close() end

--- Specifies all the subprotocols used for the current WebSocket session. This can be a Lua table holding all the subprotocol names or just a single Lua string.
---
---@alias resty.websocket.client.connect.opts.protocols string|string[]

--- Specifies the value of the `Origin` request header.
---@alias resty.websocket.client.connect.opts.origin string

--- Specifies a custom name for the connection pool being used. If omitted, then the connection pool name will be generated from the string template `<host>:<port>`.
---@alias resty.websocket.client.connect.opts.pool string

--- Specify the size of the connection pool.
---
--- If omitted and no backlog option was provided, no pool will be created. If omitted but backlog was provided, the pool will be created with a default size equal to the value of the `lua_socket_pool_size` directive. The connection pool holds up to `pool_size` alive connections ready to be reused by subsequent calls to connect, but note that there is no upper limit to the total number of opened connections outside of the pool. If you need to restrict the total number of opened connections, specify the `backlog` option. When the connection pool would exceed its size limit, the least recently used (kept-alive) connection already in the pool will be closed to make room for the current connection. Note that the cosocket connection pool is per Nginx worker process rather than per Nginx server instance, so the size limit specified here also applies to every single Nginx worker process. Also note that the size of the connection pool cannot be changed once it has been created. This option was first introduced in the v0.10.14 release.
---@alias resty.websocket.client.connect.opts.pool_size integer

--- If specified, this module will limit the total number of opened connections for this pool. No more connections than pool_size can be opened for this pool at any time. If the connection pool is full, subsequent connect operations will be queued into a queue equal to this option's value (the "backlog" queue). If the number of queued connect operations is equal to backlog, subsequent connect operations will fail and return nil plus the error string "too many waiting connect operations". The queued connect operations will be resumed once the number of connections in the pool is less than pool_size. The queued connect operation will abort once they have been queued for more than connect_timeout, controlled by settimeouts, and will return nil plus the error string "timeout". This option was first introduced in the v0.10.14 release.
---
---@alias resty.websocket.client.connect.opts.backlog integer

--- Specifies whether to perform SSL certificate verification during the SSL handshake if the wss:// scheme is used.
---
---@alias resty.websocket.client.connect.opts.ssl_verify boolean

--- Specifies custom headers to be sent in the handshake request. This must be an array-like table of strings.
---
--- Example:
---
--- ```lua
---   local headers = {
---     "X-My-Header: value",
---     "X-My-Other-Header: other value",
---   }
--- ```
---
---@alias resty.websocket.client.connect.opts.headers string[]

--- Specifies the value of the `Host` header sent in the handshake request. If not provided, the Host header will be derived from the hostname/address and port in the connection URI.
---@alias resty.websocket.client.connect.opts.host string

--- Specifies the server name (SNI) to use when performing the TLS handshake with the server. If not provided, the `host` value or the `<host/addr>:<port>` from the connection URI will be used.
---@alias resty.websocket.client.connect.opts.server_name string

--- Specifies the value of the `Sec-WebSocket-Key` header in the handshake request. The value should be a base64-encoded, 16 byte string conforming to the client handshake requirements of the WebSocket RFC. If not provided, a key is randomly generated.
---@alias resty.websocket.client.connect.opts.key string

--- Specifies a client certificate chain cdata object that will be used while TLS handshaking with remote server. These objects can be created using `ngx.ssl.parse_pem_cert()` function provided by lua-resty-core. Note that specifying the `client_cert` option requires corresponding `client_priv_key` be provided too.
---@alias resty.websocket.client.connect.opts.client_cert ffi.cdata*

--- Specifies a private key corresponds to the `client_cert` option. These objects can be created using `ngx.ssl.parse_pem_priv_key()` function provided by lua-resty-core.
---@alias resty.websocket.client.connect.opts.client_priv_key ffi.cdata*

---@class resty.websocket.client.connect.opts : table
---
---@field protocols?           resty.websocket.client.connect.opts.protocols
---@field origin?              resty.websocket.client.connect.opts.origin
---@field pool?                resty.websocket.client.connect.opts.pool
---@field pool_size?           resty.websocket.client.connect.opts.pool_size
---@field backlog?             resty.websocket.client.connect.opts.backlog
---@field ssl_verify?          resty.websocket.client.connect.opts.ssl_verify
---@field headers?             resty.websocket.client.connect.opts.headers
---@field host?                resty.websocket.client.connect.opts.host
---@field server_name?         resty.websocket.client.connect.opts.server_name
---@field key?                 resty.websocket.client.connect.opts.key
---@field client_cert?         resty.websocket.client.connect.opts.client_cert
---@field client_priv_key?     resty.websocket.client.connect.opts.client_priv_key

return client
