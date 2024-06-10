---@meta

---@class resty.upload
---
---@field _VERSION string
local upload = {}

---@param chunk_size?    integer  # default: 4096
---@param max_line_size? integer  # default: 512
---@param preserve_body? boolean  # default: false
---
---@return resty.upload? upload
---@return string?       error
function upload:new(chunk_size, max_line_size, preserve_body) end

---@alias resty.upload.chunk_type
---| "header"
---| "body"
---| "part_end"
---| "eof"

---@return resty.upload.chunk_type? type
---@return string?                  chunk
---@return string?                  error
function upload:read() end

---@param timeout number # milliseconds
function upload:set_timeout(timeout) end

return upload
