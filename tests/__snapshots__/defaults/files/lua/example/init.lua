local M = {}

---@param opts? example.SetupOpts
function M.setup(opts)
    require("example.config").setup(opts)
end

---An example action. Replace this with your plugin's public API.
---@param name? string
---@return string
function M.greet(name)
    local config = require("example.config").get()
    local message = ("%s, %s!"):format(config.greeting, name or "Neovim")
    vim.notify(message, vim.log.levels.INFO, { title = "example.nvim" })
    return message
end

return M
