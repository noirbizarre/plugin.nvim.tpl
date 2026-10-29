local assert = assert --[[@as PluginTestAssert]]

describe("runtime entrypoint", function()
    local saved = {}
    local notify

    before_each(function()
        for _, name in ipairs({ "example", "example.config" }) do
            saved[name] = package.loaded[name]
            package.loaded[name] = nil
        end
        vim.g.loaded_example = nil
        pcall(vim.api.nvim_del_user_command, "Example")
        notify = stub(vim, "notify")
    end)

    after_each(function()
        notify:revert()
        for _, name in ipairs({ "example", "example.config" }) do
            package.loaded[name] = saved[name]
        end
    end)

    it("loads lazily, works without setup, and can be sourced twice", function()
        vim.cmd("runtime plugin/example.lua")
        vim.cmd("runtime plugin/example.lua")
        assert.is_nil(package.loaded["example"])
        assert.is_nil(package.loaded["example.config"])
        vim.cmd("Example")
        assert.stub(notify).was_called_with("Hello, Neovim!", vim.log.levels.INFO, { title = "example.nvim" })
        require("example").setup({ greeting = "Hi" })
        vim.cmd("Example Lua")
        assert.stub(notify).was_called_with("Hi, Lua!", vim.log.levels.INFO, { title = "example.nvim" })
    end)
end)
