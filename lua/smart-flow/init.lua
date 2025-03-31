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

    -- Set up autoadd functionality if enabled in config
    if state.autoadd then
        log.debug("Setting up autoadd")

        -- Create an autocommand group for autoadd
        local autoadd_augroup = api.nvim_create_augroup("SmartFlowAutoadd", { clear = true })

        api.nvim_create_autocmd({ "BufWritePre" }, {
            group = autoadd_augroup,
            pattern = "*",
            callback = function(args)
                local file_path = api.nvim_buf_get_name(args.buf)
                if file_path == "" then
                    return -- Ignore unnamed buffers
                end

                -- Check if inside a git repository
                local file_dir = vim.fn.fnamemodify(file_path, ":h")
                local git_check_cmd = "git -C " .. vim.fn.shellescape(file_dir) .. " rev-parse --is-inside-work-tree"
                local _, exit_code = vim.fn.system(git_check_cmd .. " > /dev/null 2>&1") -- Run silently

                if exit_code == 0 then
                    -- Inside a git repo, add all changes
                    local repo_dir = vim.fn.fnamemodify(file_path, ":h") -- Get directory of the file
                    -- Attempt to find the git root directory
                    local git_root_cmd = "git -C " .. vim.fn.shellescape(repo_dir) .. " rev-parse --show-toplevel"
                    local git_root = vim.fn.trim(vim.fn.system(git_root_cmd))

                    if vim.v.shell_error == 0 and git_root ~= "" then
                        -- Run git add . from the git root directory
                        local add_cmd = "git -C " .. vim.fn.shellescape(git_root) .. " add ."
                        log.debug("Autoadd running: " .. add_cmd)
                        vim.fn.system(add_cmd)
                        -- Optional error check
                        -- if vim.v.shell_error ~= 0 then
                        --     log.error("Autoadd (git add .) failed in repo: " .. git_root)
                        -- end
                    else
                        -- Fallback or error: Could not determine git root
                        log.warn("Could not determine git root directory for autoadd from: " .. file_path)
                        -- As a fallback, maybe just add the specific file?
                        -- local add_cmd = "git add " .. vim.fn.shellescape(file_path)
                        -- log.debug("Autoadd fallback running: " .. add_cmd)
                        -- vim.fn.system(add_cmd)
                    end
                else
                    log.debug("File not in git repo, skipping autoadd: " .. file_path)
                end
            end,
            desc = "Smart Flow: git add current file before saving",
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

    -- Clean up autoadd autocommands if they exist
    pcall(function()
        api.nvim_del_augroup_by_name("SmartFlowAutoadd")
        log.debug("Removed autoadd autocommands")
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
