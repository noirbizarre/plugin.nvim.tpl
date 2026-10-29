local M = {}
local version_ge = vim.version.ge

---@param version vim.Version
---@return boolean
function M.supported(version)
    return version_ge(version, "0.12.0")
end

function M.check()
    vim.health.start("example.nvim")
    local current_version = vim.version --[[@as fun(): vim.Version]]
    if M.supported(current_version()) then
        vim.health.ok("Neovim >= 0.12.0")
    else
        vim.health.error("Requires Neovim >= 0.12.0")
    end
    local ok, config = pcall(require, "example.config")
    if ok then
        vim.health.ok("Configuration loaded (setup is optional)")
        vim.health.info(vim.inspect(config.get()))
    else
        vim.health.error("Unable to load configuration: " .. tostring(config))
    end
end

return M
