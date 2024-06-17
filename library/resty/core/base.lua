---@meta

---@class resty.core.base
---
---@field version string
---
---@field FFI_OK          0
---@field FFI_NO_REQ_CTX  -100
---@field FFI_BAD_CONTEXT -101
---@field FFI_ERROR       -1
---@field FFI_AGAIN       -2
---@field FFI_BUSY        -3
---@field FFI_DONE        -4
---@field FFI_DECLINED    -5
---@field FFI_ABORT       -6
local base = {}

---@param ... string
function base.allows_subsystem(...) end

---@param t table
function base.clear_tab(t) end

---@return userdata
function base.get_errmsg_ptr() end

---@return userdata
function base.get_request() end

---@return userdata
function base.get_size_ptr() end

---@param size number
---@param must_alloc? boolean
---@return userdata
function base.get_string_buf(size, must_alloc) end

---@return number
function base.get_string_buf_size() end

---@param narr number
---@param nrec number
---@return table
function base.new_tab(narr, nrec) end

---@param tb table
---@param key any
---@return any
function base.ref_in_table(tb, key) end

---@param size number
function base.set_string_buf_size(size) end

return base
