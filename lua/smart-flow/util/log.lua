local state = require("smart-flow.state")

local log = {}

--- prints only if debug is true.
---
---@param str string: the formatted string.
---@param ... any: the arguments of the formatted string.
---@private
function log.debug(str, ...)
    return log.notify(vim.log.levels.DEBUG, false, str, ...)
end

--- prints only if debug is true.
---
---@param level string: the log level of vim.notify.
---@param verbose boolean: when false, only prints when config.debug is true.
---@param str string: the formatted string.
---@param ... any: the arguments of the formatted string.
---@private
function log.notify(level, verbose, str, ...)
    if not verbose and not state.debug then
        return
    end

    vim.notify(
        string.format("[smart-flow.nvim] %s", string.format(str, ...)),
        level,
        { title = "smart-flow.nvim" }
    )
end

return log
