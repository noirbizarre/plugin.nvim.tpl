<!-- panvimdoc-ignore-start -->

# example.nvim

A delightful Neovim plugin

[![CI](https://github.com/your-name/example.nvim/actions/workflows/ci.yaml/badge.svg)](https://github.com/your-name/example.nvim/actions/workflows/ci.yaml)

<!-- panvimdoc-ignore-end -->

## Requirements

```text
Neovim >= 0.12.0
```

No runtime dependencies. Selected nightly builds are required to pass CI.

## Installation

With Neovim's built-in package manager:

```lua
vim.pack.add({ "https://github.com/your-name/example.nvim" })
```

With lazy.nvim:

```lua
{ "your-name/example.nvim", main = "example", opts = {} }
```

Setup is optional. Commands load their implementation only when invoked.

## Configuration

The complete default configuration:

```lua
require("example").setup({
    greeting = "Hello",
})
```

Setup replaces the configuration with fresh defaults plus your options. Unknown
options and invalid types are rejected without changing the current configuration.

## Usage

Try the example command, optionally providing a name:

```vim
:Example
:Example Lua
```

The same action is available from Lua. It shows a notification and returns its text:

```lua
local message = require("example").greet("Lua")
```

Assign your own mappings if desired; the plugin does not create default mappings.

## Troubleshooting

```vim
:checkhealth example
:help example.txt
```

Reproduce problems with a clean configuration from the plugin repository root:

```sh
nvim --clean -u scripts/minimal_init.lua
```

## Development

See CONTRIBUTING.md for tooling, tests, documentation generation, and releases.
README.md is the source for the committed Vim help. After editing it, run:

```sh
mise run docs
mise run test
mise run lint
```

## License

MIT. See LICENSE.
