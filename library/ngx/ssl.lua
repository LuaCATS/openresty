---@meta

---@class ngx.ssl
---
---@field version string
---
---@field SSL3_VERSION   ngx.ssl.SSL3_VERSION
---@field TLS1_VERSION   ngx.ssl.TLS1_VERSION
---@field TLS1_1_VERSION ngx.ssl.TLS1_1_VERSION
---@field TLS1_2_VERSION ngx.ssl.TLS1_2_VERSION
---@field TLS1_3_VERSION ngx.ssl.TLS1_3_VERSION
local ssl = {}

---@alias ngx.ssl.SSL3_VERSION   768
---@alias ngx.ssl.TLS1_VERSION   769
---@alias ngx.ssl.TLS1_1_VERSION 770
---@alias ngx.ssl.TLS1_2_VERSION 771
---@alias ngx.ssl.TLS1_3_VERSION 772

---@alias ngx.ssl.tls_version.integer
---| ngx.ssl.SSL3_VERSION
---| ngx.ssl.TLS1_VERSION
---| ngx.ssl.TLS1_1_VERSION
---| ngx.ssl.TLS1_2_VERSION
---| ngx.ssl.TLS1_3_VERSION

---@alias ngx.ssl.tls_version.string
---| "SSLv3"
---| "TLSv1"
---| "TLSv1.1"
---| "TLSv1.2"
---| "TLSv1.3"

--- Sets the DER-formatted prviate key for the current SSL connection.
---
--- Returns true on success, or a nil value and a string describing the error otherwise.
---
--- Usually, the private keys are encoded in the PEM format. You can either use the priv_key_pem_to_der function to do the PEM to DER conversion or just use the openssl command-line utility offline, like below
---
--- openssl rsa -in key.pem -outform DER -out key.der
---
---@param der_priv_key string
---@return boolean ok
---@return string? error
function ssl.set_der_priv_key(der_priv_key) end

--- Converts the PEM-formatted SSL private key data into an opaque cdata pointer (for later uses in the set_priv_key function, for example).
---
--- In case of failures, returns nil and a string describing the error.
---
--- This function can be called in any context.
---
---@param pem_priv_key string
---@return ffi.cdata*? priv_key
---@return string? error
function ssl.parse_pem_priv_key(pem_priv_key) end

--- Returns the TLS 1.x version number used by the current SSL connection. Returns nil and a string describing the error otherwise.
---
--- Typical return values are:
---
---     0x0300 (768) SSLv3
---     0x0301 (769) TLSv1
---     0x0302 (770) TLSv1.1
---     0x0303 (771) TLSv1.2
---     0x0304 (772) TLSv1.3
---
--- This function can be called in any context where downstream https is used.
---@return ngx.ssl.tls_version.integer? version
---@return string? error
function ssl.get_tls1_version() end

--- Sets the SSL certificate chain opaque pointer returned by the parse_pem_cert function for the current SSL connection.
---
--- Returns true on success, or a nil value and a string describing the error otherwise.
---
--- Note that this set_cert function will run slightly faster, in terms of CPU cycles wasted, than the set_der_cert variant, since the first function uses opaque cdata pointers which do not require any additional conversion needed to be performed by the SSL library during the SSL handshake.
---
---@param cert_chain ffi.cdata*
---@return boolean ok
---@return string? error
function ssl.set_cert(cert_chain) end


--- Sets the SSL private key opaque pointer returned by the parse_pem_priv_key function for the current SSL connection.
---
--- Returns true on success, or a nil value and a string describing the error otherwise.
---
--- Note that this set_priv_key function will run slightly faster, in terms of CPU cycles wasted, than the set_der_priv_key variant, since the first function uses opaque cdata pointers which do not require any additional conversion needed to be performed by the SSL library during the SSL handshake.
---
---@param priv_key ffi.cdata*
---@return boolean ok
---@return string? error
function ssl.set_priv_key(priv_key) end

--- Returns the raw server address actually accessed by the client in the current SSL connection.
---
--- The first two return values are strings representing the address data and the address type, respectively. The address values are interpreted differently according to the address type values:
---
---     unix : The address data is a file path for the UNIX domain socket.
---     inet : The address data is a binary IPv4 address of 4 bytes long.
---     inet6 : The address data is a binary IPv6 address of 16 bytes long.
---
--- Returns two nil values and a Lua string describing the error.
---
--- The following code snippet shows how to print out the UNIX domain socket address and the IPv4 address as human-readable strings:
---
---```lua
--- local ssl = require "ngx.ssl"
--- local byte = string.byte
---
--- local addr, addrtyp, err = ssl.raw_server_addr()
--- if not addr then
---     ngx.log(ngx.ERR, "failed to fetch raw server addr: ", err)
---     return
--- end
---
--- if addrtyp == "inet" then  -- IPv4
---     ip = string.format("%d.%d.%d.%d", byte(addr, 1), byte(addr, 2),
---                        byte(addr, 3), byte(addr, 4))
---     print("Using IPv4 address: ", ip)
---
--- elseif addrtyp == "unix" then  -- UNIX
---     print("Using unix socket file ", addr)
---
--- else  -- IPv6
---     -- leave as an exercise for the readers
--- end
---```
---
--- This function can be called in any context where downstream https is used.
---
---@return string?            addr_data
---@return ngx.ssl.addr_type? addr_type
---@return string?            error
function ssl.raw_server_addr() end

---@alias ngx.ssl.addr_type
---| "unix"  # a file path for the UNIX domain socket.
---| "inet"  # a binary IPv4 address of 4 bytes long.
---| "inet6" # a binary IPv6 address of 16 bytes long.

--- Clears any existing SSL certificates and/or private keys set on the current SSL connection.
---
--- Returns true on success, or a nil value and a string describing the error otherwise.
---@return boolean ok
---@return string? error
function ssl.clear_certs() end

--- Returns the raw client address of the current SSL connection.
---
--- The first two return values are strings representing the address data and the address type, respectively. The address values are interpreted differently according to the address type values:
---
---     unix : The address data is a file path for the UNIX domain socket.
---     inet : The address data is a binary IPv4 address of 4 bytes long.
---     inet6 : The address data is a binary IPv6 address of 16 bytes long.
---
--- Returns two nil values and a Lua string describing the error.
---
--- The following code snippet shows how to print out the UNIX domain socket address and the IPv4 address as human-readable strings:
---
---```lua
--- local ssl = require "ngx.ssl"
--- local byte = string.byte
---
--- local addr, addrtyp, err = ssl.raw_client_addr()
--- if not addr then
---     ngx.log(ngx.ERR, "failed to fetch raw client addr: ", err)
---     return
--- end
---
--- if addrtyp == "inet" then  -- IPv4
---     ip = string.format("%d.%d.%d.%d", byte(addr, 1), byte(addr, 2),
---                        byte(addr, 3), byte(addr, 4))
---     print("Client IPv4 address: ", ip)
---
--- elseif addrtyp == "unix" then  -- UNIX
---     print("Client unix socket file ", addr)
---
--- else  -- IPv6
---     -- leave as an exercise for the readers
--- end
---```
---
--- This function can be called in any context where downstream https is used.
---
---@return string?            addr_data
---@return ngx.ssl.addr_type? addr_type
---@return string?            error
function ssl.raw_client_addr() end

--- Converts the PEM-formated SSL certificate chain data into an opaque cdata pointer (for later uses in the set_cert function, for example).
---
--- In case of failures, returns nil and a string describing the error.
---
--- You can always use libraries like lua-resty-lrucache to cache the cdata result.
---
--- This function can be called in any context.
---
---@param pem_cert_chain string
---@return ffi.cdata*? cert_chain
---@return string? error
function ssl.parse_pem_cert(pem_cert_chain) end

--- Returns the TLS SNI (Server Name Indication) name set by the client. Returns nil when the client does not set it.
---
--- In case of failures, it returns nil and a string describing the error.
---
--- Usually we use this SNI name as the domain name (like www.openresty.org) to identify the current web site while loading the corresponding SSL certificate chain and private key for the site.
---
--- Please note that not all https clients set the SNI name, so when the SNI name is missing from the client handshake request, we use the server IP address accessed by the client to identify the site. See the raw_server_addr method for more details.
---
--- This function can be called in any context where downstream https is used.
---
---@return string? server_name
---@return string? error
function ssl.server_name() end

--- Returns the server port. Returns nil when server dont have a port.
---
--- In case of failures, it returns nil and a string describing the error.
---
--- This function can be called in any context where downstream https is used.
---
---@return number? server_port
---@return string? error
function ssl.server_port() end

--- Sets the DER-formatted SSL certificate chain data for the current SSL connection. Note that the DER data is directly in the Lua string argument. No external file names are supported here.
---
--- Returns true on success, or a nil value and a string describing the error otherwise.
---
--- Note that, the SSL certificate chain is usually encoded in the PEM format. So you need to use the cert_pem_to_der function to do the conversion first.
---@param der_cert_chain string
---@return boolean ok
---@return string? error
function ssl.set_der_cert(der_cert_chain) end

--- Returns the TLS 1.x version string used by the current SSL connection. Returns nil and a string describing the error otherwise.
---
--- If the TLS 1.x version number used by the current SSL connection is not recognized, the return values will be nil and the string "unknown version".
---
--- Typical return values are:
---
---     SSLv3
---     TLSv1
---     TLSv1.1
---     TLSv1.2
---     TLSv1.3
---
--- This function can be called in any context where downstream https is used.
---
---@return ngx.ssl.tls_version.string? version
---@return string? error
function ssl.get_tls1_version_str() end

--- Converts the PEM-formatted SSL private key data into the DER format (for later uses in the set_der_priv_key function, for example).
---
--- In case of failures, returns nil and a string describing the error.
---
--- Alternatively, you can do the PEM to DER conversion offline with the openssl command-line utility, like below
---
--- openssl rsa -in key.pem -outform DER -out key.der
---
--- This function can be called in any context.
---
---@param  pem_priv_key string
---@return string?      der_priv_key
---@return string?      error
function ssl.priv_key_pem_to_der(pem_priv_key) end

--- Converts the PEM-formatted SSL certificate chain data into the DER format (for later uses in the set_der_cert function, for example).
---
--- In case of failures, returns nil and a string describing the error.
---
--- It is known that the openssl command-line utility may not convert the whole SSL certificate chain from PEM to DER correctly. So always use this Lua function to do the conversion. You can always use libraries like lua-resty-lrucache and/or ngx_lua APIs like lua_shared_dict to do the caching of the DER-formatted results, for example.
---
--- This function can be called in any context.
---
---@param  pem_cert_chain string
---@return string?        der_cert_chain
---@return string?        error
function ssl.cert_pem_to_der(pem_cert_chain) end

--- Requires a client certificate during TLS handshake.
---
--- Returns true on success, or a nil value and a string describing the error otherwise.
---
--- Note that TLS is not terminated when verification fails. You need to examine Nginx variable $ssl_client_verify later to determine next steps.
---
--- This function was first added in version 0.1.20.
---
---@param  ca_certs? ffi.cdata* # the CA certificate chain opaque pointer returned by the parse_pem_cert function for the current SSL connection. The list of certificates will be sent to clients. Also, they will be added to trusted store. If omitted, will not send any CA certificate to clients.
---@param  depth?  number verification depth in the client certificates chain. If omitted, will use the value specified by ssl_verify_depth.
---@return boolean ok
---@return string? error
function ssl.verify_client(ca_certs, depth) end

--- Retrieves the OpenSSL `SSL*` object for the current downstream connection.
---
--- Returns an FFI pointer on success, or a `nil` value and a string describing the error otherwise.
---
--- If you need to retain the pointer beyond the current phase then you will need to use OpenSSL's `SSL_up_ref` to increase the reference count.
--- If you do, ensure that your reference is released with `SSL_free`.
---
--- This function was first added in version `0.1.16`.
---
---@return ffi.cdata*? pointer
---@return string?     error
function ssl.get_req_ssl_pointer() end

--- Return a key derived from the SSL master secret.
---
--- As described in RFC8446 section 7.5 this function returns key material that is derived from the SSL master secret and can be used on the application level. The returned key material is of the given length. Label is mandatory and requires a special format that is described in RFC5705 section 4. Context is optional but note that in TLSv1.2 and below a zero length context is treated differently from no context at all, and will result in different keying material being returned. In TLSv1.3 a zero length context is that same as no context at all and will result in the same keying material being returned.
---
--- The following code snippet shows how to derive a new key that can be used on the application level.
---
--- ```lua
--- local ssl = require "ngx.ssl"
---
--- local key_length = 16
--- local label = "EXPERIMENTAL my label"
--- local context = "\x00\x01\x02\x03"
---
--- local key, err = ssl.export_keying_material(key_length, label, context)
--- if not key then
---     ngx.log(ngx.ERR, "failed to derive key ", err)
---     return
--- end
---
--- -- use key...
---
--- end
--- ```
---
--- This function can be called in any context where downstream https is used.
---
---@param  length   integer
---@param  label    string
---@param  context? string
---@return string?  key
---@return string?  error
function ssl.export_keying_material(length, label, context) end

--- Returns a key derived from the SSL early exporter master secret.
---
--- As described in RFC8446 section 7.5 this function returns key material that is derived from the SSL early exporter master secret and can be used on the application level. The returned key material is of the given length. Label is mandatory and requires a special format that is described in RFC5705 section 4. This function is only usable with TLSv1.3, and derives keying material using the early_exporter_master_secret (as defined in the TLS 1.3 RFC). For the client, the early_exporter_master_secret is only available when the client attempts to send 0-RTT data. For the server, it is only available when the server accepts 0-RTT data.
---
--- The following code snippet shows how to derive a new key that can be used on the application level.
---
--- ```lua
--- local ssl = require "ngx.ssl"
---
--- local key_length = 16
--- local label = "EXPERIMENTAL my label"
--- local context = "\x00\x01\x02\x03"
---
--- local key, err = ssl.export_keying_material_early(key_length, label, context)
--- if not key then
---     ngx.log(ngx.ERR, "failed to derive key ", err)
---     return
--- end
---
--- -- use key...
---
--- end
--- ```
---
--- This function can be called in any context where downstream https TLS1.3 is used.
---
---@param  length   integer
---@param  label    string
---@param  context? string
---@return string?  key
---@return string?  error
function ssl.export_keying_material_early(length, label, context) end

--- Returns the random value sent from the client to the server during the initial SSL/TLS handshake.
---
--- The `outlen` parameter indicates the maximum length of the client_random value returned.
--- If the `outlen` is zero, this function returns the total length of the client_random value.
--- If omitted, will use the value 32.
---
--- This function can be called in any context where downstream https is used, but in the context of [ssl_client_hello_by_lua*](https://github.com/openresty/lua-nginx-module/#ssl_client_hello_by_lua_block), it can not return the real client_random value, just a string filled with 0.
---
---@param  outlen?         integer
---@return string|integer? result
---@return string?         error
function ssl.get_client_random(outlen) end

return ssl
