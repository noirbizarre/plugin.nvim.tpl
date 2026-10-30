# plugin.nvim.tpl

A batteries-included [git-tpl](https://github.com/noirbizarre/git-tpl) template for Lua Neovim plugins.
Inspired by [ensure.nvim](https://github.com/noirbizarre/ensure.nvim), Neovim's Lua plugin authoring guide,
and the release/development conventions in [rust.tpl](https://github.com/noirbizarre/rust.tpl).

## Create a plugin

Install git-tpl 0.15.0 or newer, then:

```sh
git tpl init https://github.com/noirbizarre/plugin.nvim.tpl my-plugin.nvim --init
```

Answer the identity questions and select the supported Neovim versions: **0.12**, **nightly**, or both (the default).
At least one version is required. CI checks every selected version; nightly is not an allowed failure.
A nightly-only project declares a development-build requirement.

For noninteractive generation:

```sh
git tpl init https://github.com/noirbizarre/plugin.nvim.tpl my-plugin.nvim --init \
  --answer plugin_name=my-plugin.nvim --answer owner=my-name \
  --answer author='My Name' --answer 'neovim_versions=["0.12","nightly"]' \
  --defaults --strict-answers
```

## Included

- Small runtime entrypoint with deferred Lua loading, optional typed setup, and no runtime dependencies.
- Validated configuration, example command/Lua API, native health check, and clean reproduction config.
- Lux-managed Busted/nlua tests inside isolated Neovim.
- mise tasks, Lux formatting/linting/type checking, and prek hooks.
- README-driven Vim help generated on commit through panvimdoc's official prek hook, with PR drift checks.
- GitHub Actions tests, linting, issue forms, and contributor documentation.
- Standard gh-ship releases: Conventional Commits, git-cliff changelog, release PRs, and SemVer tags.
- Parameterized MIT license and author/year.

Generated projects document installation with both `vim.pack` and lazy.nvim.
Plugin setup only overrides configuration; commands work with defaults immediately.
Replace the example greeting with your own behavior and update README.md.
Generated CONTRIBUTING.md explains development prerequisites and GitHub App release setup.

## Updating a generated plugin

```sh
git tpl update --defaults
git tpl diff
git tpl merge
```

Resolve conflicts using ordinary Git tools and run the generated project's checks.
Template rendering does not execute scripts or install tools.

## Developing this template

The manifest is `template.toml`; only `template/` is rendered.
`data/neovim.toml` owns version metadata and deterministic matrix ordering.
Add future version choices there and extend the rendering cases.
Lua module names are string namespaces: even Lua keywords work, without generating bare identifiers.

```sh
mise trust
mise install
mise run lint
mise run test
```

Tests are ordinary `git tpl test` cases asserting rendered paths, contents, snapshots, and invalid answers.
The default case also runs the generated plugin's Busted specs, Lux lint, and workflow validation
using git-tpl's built-in command checks.
The default case records a complete snapshot; single-version, custom-name, and invalid-answer cases cover variations.
First-time tests require network access, a C compiler, and make. Development tooling is validated on Linux.
Lux's Lua source build also needs readline development headers (`libreadline-dev` on Debian/Ubuntu).
Lux's Neovim test backend currently documents limitations on macOS and Windows.
Tool declarations use `latest`; the committed `mise.lock` provides reproducibility for template development.
Generated projects create their own `mise.lock` and `lux.lock` when installing tools and running tests.

After changing the template, update its snapshots and run the suite:

```sh
mise run test:write
mise run test
```

Snapshot recording does not run tests: always run the ordinary suite afterwards.
Vim help is generated in the resulting project, rather than stored in the template.
The official panvimdoc hook is a fixer: when it updates help it exits 1, asking you to stage the result and rerun.

To inspect a rendering, use `mise run render custom` (or set `OUT` to choose its directory).
The template's own CI and documentation stay outside generated projects.
