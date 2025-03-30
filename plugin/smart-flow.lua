-- You can use this loaded variable to enable conditional parts of your plugin.
if _G.SmartFlowLoaded then
    return
end

_G.SmartFlowLoaded = true

-- Useful if you want your plugin to be compatible with older (<0.7) neovim versions
if vim.fn.has("nvim-0.7") == 0 then
    vim.cmd("command! SmartFlow lua require('smart-flow').toggle()")
else
    vim.api.nvim_create_user_command("SmartFlow", function()
        require("smart-flow").toggle()
    end, {})
end
