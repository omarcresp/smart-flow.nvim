if _G.SmartFlowLoaded then
    return
end

_G.SmartFlowLoaded = true

vim.api.nvim_create_user_command("SmartFlow", function()
    require("smart-flow").toggle()
end, {})
