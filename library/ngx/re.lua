---@meta

---@class ngx.re
---
---@field version string
local re = {}

--- Allows changing of regex settings. Currently, it can only change the `jit_stack_size` of the PCRE engine, like so:
---
---```nginx
---  init_by_lua_block { require "ngx.re".opt("jit_stack_size", 200 * 1024) }
---
---  server {
---      location /re {
---          content_by_lua_block {
---              -- full regex and string are taken from https://github.com/JuliaLang/julia/issues/8278
---              local very_long_string = [[71.163.72.113 - - [30/Jul/2014:16:40:55 -0700] ...]]
---              local very_complicated_regex = [[([\d\.]+) ([\w.-]+) ([\w.-]+) (\[.+\]) ...]]
---              local from, to, err = ngx.re.find(very_long_string, very_complicated_regex, "jo")
---
---              -- with the regular jit_stack_size, we would get the error 'pcre_exec() failed: -27'
---              -- instead, we get a match
---              ngx.print(from .. "-" .. to) -- prints '1-1563'
---          }
---      }
---  }
---```
---
--- The `jit_stack_size` cannot be set to a value lower than PCRE's default of 32K.
---
---@param option string|"jit_stack_size"
---@param value any
function re.opt(option, value) end

--- Splits the subject string using the Perl compatible regular expression regex with the optional options.
---
--- This function returns a Lua (array) table (with integer keys) containing the split values.
---
--- In case of error, `nil` will be returned as well as a string describing the error.
---
--- When regex contains a sub-match capturing group, and when such a match is found, the first submatch capture will be inserted in between each split value, like so:
---
---```lua
--- local ngx_re = require "ngx.re"
---
--- local res, err = ngx_re.split("a,b,c,d", "(,)")
--- -- res is now {"a", ",", "b", ",", "c", ",", "d"}
---```
---
--- When regex is empty string "", the subject will be split into chars, like so:
---
---```lua
--- local ngx_re = require "ngx.re"
---
--- local res, err = ngx_re.split("abcd", "")
--- -- res is now {"a", "b", "c", "d"}
---```
---
--- The optional max argument is a number that when specified, will prevent `split()` from adding more than max matches to the res array:
---
---```lua
--- local ngx_re = require "ngx.re"
---
--- local res, err = ngx_re.split("a,b,c,d", ",", nil, nil, 3)
--- -- res is now {"a", "b", "c,d"}
---```
---
--- Specifying max <= 0 disables this behavior, meaning that the number of results won't be limited.
---
--- The optional 6th argument res can be a table that `split()` will re-use to hold the results instead of creating a new one, which can improve performance in hot code paths. It is used like so:
---
---```lua
--- local ngx_re = require "ngx.re"
---
--- local my_table = {"hello world"}
---
--- local res, err = ngx_re.split("a,b,c,d", ",", nil, nil, nil, my_table)
--- -- res/my_table is now {"a", "b", "c", "d"}
---```
---
--- When provided with a res table, `split()` won't clear the table for performance reasons, but will rather insert a trailing `nil` value when the split is completed:
---
---```lua
--- local ngx_re = require "ngx.re"
---
--- local my_table = {"W", "X", "Y", "Z"}
---
--- local res, err = ngx_re.split("a,b", ",", nil, nil, nil, my_table)
--- -- res/my_table is now {"a", "b", nil, "Z"}
---```
---
--- When the trailing `nil` is not enough for your purpose, you should clear the table yourself before feeding it into the split function.
---
---@param  subj      string
---@param  regex     string
---@param  opts?     ngx.re.options
---@param  ctx?      ngx.re.ctx
---@param  max?      number
---@param  res?      string[]
---@return string[]? res
---@return string?   error
function re.split(subj, regex, opts, ctx, max, res) end

return re
