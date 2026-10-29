if vim.g.loaded_example then
    return
end
vim.g.loaded_example = true

-- Keep implementation modules unloaded until the command is used.
vim.api.nvim_create_user_command("Example", function(opts)
    require("example").greet(opts.args ~= "" and opts.args or nil)
end, { nargs = "?", desc = "Show an example greeting" })
