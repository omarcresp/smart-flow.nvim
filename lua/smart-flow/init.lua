local main = require("smart-flow.main")
local config = require("smart-flow.config")

local SmartFlow = {}

--- Toggle the plugin by calling the `enable`/`disable` methods respectively.
function SmartFlow.toggle()
    if _G.SmartFlow.config == nil then
        _G.SmartFlow.config = config.options
    end

    main.toggle("public_api_toggle")
end

--- Initializes the plugin, sets event listeners and internal state.
function SmartFlow.enable(scope)
    if _G.SmartFlow.config == nil then
        _G.SmartFlow.config = config.options
    end

    main.toggle(scope or "public_api_enable")
end

--- Disables the plugin, clear highlight groups and autocmds, closes side buffers and resets the internal state.
function SmartFlow.disable()
    main.toggle("public_api_disable")
end

-- setup SmartFlow options and merge them with user provided ones.
function SmartFlow.setup(opts)
    _G.SmartFlow.config = config.setup(opts)
end

_G.SmartFlow = SmartFlow

return _G.SmartFlow
