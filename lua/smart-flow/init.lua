local log = require("smart-flow.util.log")
local state = require("smart-flow.state")
local config = require("smart-flow.config")
local api = vim.api

local main = {}

local function debounced_save()
    if state.save_timer then
        state.save_timer:stop()
        state.save_timer:close()
        state.save_timer = nil
    end

    state.save_timer = vim.loop.new_timer()

    state.save_timer:start(
        state.debounce_time,
        0,
        vim.schedule_wrap(function()
            if vim.api.nvim_get_current_buf() ~= 0 and vim.bo.modified then
                vim.cmd("silent! write")
                log.debug("Debounced autosave triggered")
            end

            if state.save_timer then
                state.save_timer:stop()
                state.save_timer:close()
                state.save_timer = nil
            end
        end)
    )
end

---@private
function main.toggle()
    if state.enabled then
        log.debug("smart-flow is now disabled!")

        return main.disable()
    end

    log.debug("smart-flow is now enabled!")

    main.enable()
end

--- Initializes the plugin, sets event listeners and internal state.
---@private
function main.enable()
    if state.enabled then
        log.debug("smart-flow is already enabled")

        return
    end

    state.enabled = true

    -- Set up autosave functionality if enabled in config
    if state.autosave then
        log.debug("Setting up autosave with debounce time: " .. state.debounce_time .. "ms")

        -- Create an autocommand group for our plugin
        local augroup = api.nvim_create_augroup("SmartFlowAutosave", { clear = true })

        api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
            group = augroup,
            pattern = "*",
            callback = function()
                debounced_save()
            end,
            desc = "Smart Flow: trigger debounced autosave after changes or leaving insert mode",
        })
    end
end

--- Disables the plugin for the given tab, clear highlight groups and autocmds, closes side buffers and resets the internal state.
---
---@private
function main.disable()
    if not state.enabled then
        log.debug("smart-flow is already disabled")

        return
    end

    state.enabled = false

    -- Clean up autosave autocommands if they exist
    pcall(function()
        api.nvim_del_augroup_by_name("SmartFlowAutosave")
        log.debug("Removed autosave autocommands")
    end)

    -- Clean up any existing timer
    if state.save_timer then
        state.save_timer:stop()
        state.save_timer:close()
        state.save_timer = nil
        log.debug("Stopped autosave timer")
    end
end

function main.setup(opts)
    config.setup(opts)

    main.enable()
end

return main
