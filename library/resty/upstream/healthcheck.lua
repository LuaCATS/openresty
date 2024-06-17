---@meta

---@class resty.upstream.healthcheck
---
---@field _VERSION string
local healthcheck = {}

--- Generates a detailed status report for all the upstreams defined in the current NGINX server.
---
--- One typical output is
---
--- ```
--- Upstream foo.com
---     Primary Peers
---         127.0.0.1:12354 UP
---         127.0.0.1:12355 DOWN
---     Backup Peers
---         127.0.0.1:12356 UP
---
--- Upstream bar.com
---     Primary Peers
---         127.0.0.1:12354 UP
---         127.0.0.1:12355 DOWN
---         127.0.0.1:12357 DOWN
---     Backup Peers
---         127.0.0.1:12356 UP
--- ```
---
--- If an upstream has no health checkers, then it will be marked by (NO checkers), as in
---
--- ```
--- Upstream foo.com (NO checkers)
---     Primary Peers
---         127.0.0.1:12354 UP
---         127.0.0.1:12355 UP
---     Backup Peers
---         127.0.0.1:12356 UP
--- ```
---
--- If you indeed have spawned a healthchecker in `init_worker_by_lua*`, then you should really check out the NGINX error log file to see if there is any fatal errors aborting the healthchecker threads.
---
---@return string status
function healthcheck.status_page() end

---@return string
function healthcheck.prometheus_status_page() end

---@class resty.upstream.healthcheck.spawn.opts
---
---@field shm             string
---@field upstream        string
---@field type            "http"|"https"
---@field http_req        string
---@field port?           integer
---@field timeout?        integer # milliseconds
---@field interval?       number  # milliseconds
---@field valid_statuses? integer[]
---@field concurrency?    integer
---@field fall?           integer
---@field rise?           integer
---@field ssl_verify?     boolean
---@field host?           string

--- Spawns background timer-based "light threads" to perform periodic healthchecks on the specified NGINX upstream group with the specified shm storage.
---
--- The healthchecker does not need any client traffic to function. The checks are performed actively and periodically.
---
--- This method call is asynchronous and returns immediately.
---
--- Returns true on success, or nil and a string describing an error otherwise.
---
---@param opts resty.upstream.healthcheck.spawn.opts
---@return boolean? ok
---@return string? error
function healthcheck.spawn_checker(opts) end

return healthcheck
