local log = require("smart-flow.util.log")
local state = require("smart-flow.state")

local config = {}

--- Defaults SmartFlow options by merging user provided options with the default plugin values.
---
---@param options table Module config table. See |SmartFlow.options|.
---
---@private
function config.evaluate(options)
    log.debug("user options: " .. vim.inspect(options))

    assert(
        options.debug == nil or type(options.debug) == "boolean",
        "`debug` must be a boolean (`true` or `false`)."
    )
    state.debug = options.debug or state.debug

    assert(
        options.autosave == nil or type(options.autosave) == "boolean",
        "`autosave` must be a boolean (`true` or `false`)."
    )
    state.autosave = options.autosave or state.autosave

    assert(
        options.debounce_time == nil or type(options.debounce_time) == "number",
        "`debounce_time` must be a number (in milliseconds)."
    )
    state.debounce_time = options.debounce_time or state.debounce_time

    log.debug("final state: " .. vim.inspect(state))
end

--- Define your smart-flow setup.
---
---@param options table Module config table. See |SmartFlow.options|.
---
---@usage `require("smart-flow").setup()` (add `{}` with your |SmartFlow.options| table)
function config.setup(options)
    config.evaluate(options or {})
end

return config
