---@class example.Config
---@field greeting string Greeting used by the example action

---@class (partial) example.SetupOpts: example.Config

local M = {}

---@type example.Config
local defaults = { greeting = "Hello" }
local config = vim.deepcopy(defaults)

---@param opts? example.SetupOpts
function M.setup(opts)
    vim.validate("opts", opts, "table", true)
    opts = opts or {}
    for key in pairs(opts) do
        if defaults[key] == nil then
            error("example.nvim: unknown option " .. tostring(key))
        end
    end
    vim.validate("greeting", opts.greeting, "string", true)
    config = vim.tbl_deep_extend("force", vim.deepcopy(defaults), vim.deepcopy(opts))
end

---@return example.Config
function M.get()
    return vim.deepcopy(config)
end

return M
