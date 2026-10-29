local assert = assert --[[@as PluginTestAssert]]

local function version(text)
    return vim.version.parse(text) --[[@as vim.Version]]
end

describe("health", function()
    local health = require("example.health")

    it("checks the declared version policy", function()
        assert.is_false(health.supported(version("0.11.9")))
        assert.is_true(health.supported(version("0.12.0")))
        assert.is_true(health.supported(version("0.13.0-dev")))
    end)

    it("reports unsupported versions and configuration without requiring setup", function()
        local version_stub = stub(vim, "version", function()
            return { major = 0, minor = 11, patch = 0 }
        end)
        local checks = {}
        for _, method in ipairs({ "start", "ok", "error", "info" }) do
            checks[method] = stub(vim.health, method)
        end
        local ok, err = pcall(health.check)
        version_stub:revert()
        for _, check in pairs(checks) do
            check:revert()
        end
        assert.is_true(ok, tostring(err))
        assert.stub(checks.error).was_called_with("Requires Neovim >= 0.12.0")
        assert.stub(checks.ok).was_called_with("Configuration loaded (setup is optional)")
    end)
end)
