local log = require("smart-flow.util.log")

local SmartFlow = {}

--- SmartFlow configuration with its default values.
---
---@type table
--- Default values:
---@eval return MiniDoc.afterlines_to_code(MiniDoc.current.eval_section)
SmartFlow.options = {
    -- Prints useful logs about what event are triggered, and reasons actions are executed.
    debug = false,
}

---@private
local defaults = vim.deepcopy(SmartFlow.options)

--- Defaults SmartFlow options by merging user provided options with the default plugin values.
---
---@param options table Module config table. See |SmartFlow.options|.
---
---@private
function SmartFlow.defaults(options)
    SmartFlow.options =
        vim.deepcopy(vim.tbl_deep_extend("keep", options or {}, defaults or {}))

    -- let your user know that they provided a wrong value, this is reported when your plugin is executed.
    assert(
        type(SmartFlow.options.debug) == "boolean",
        "`debug` must be a boolean (`true` or `false`)."
    )

    return SmartFlow.options
end

--- Define your smart-flow setup.
---
---@param options table Module config table. See |SmartFlow.options|.
---
---@usage `require("smart-flow").setup()` (add `{}` with your |SmartFlow.options| table)
function SmartFlow.setup(options)
    SmartFlow.options = SmartFlow.defaults(options or {})

    log.warn_deprecation(SmartFlow.options)

    return SmartFlow.options
end

return SmartFlow
