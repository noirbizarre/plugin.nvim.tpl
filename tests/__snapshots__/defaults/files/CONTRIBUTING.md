# Contributing

## Development environment

Install [mise](https://mise.jdx.dev/), Git, a C compiler, and make.
[Lux](https://lux.lumen-labs.org/) manages Busted/nlua dependencies and runs tests inside a clean Neovim.
The first run needs internet access. Lux's project dependencies and isolated test environment live in the ignored `.lux/`.
The development/test toolchain is validated on Linux; Lux currently documents limitations for its
Neovim test backend on macOS and Windows.

```sh
mise trust
mise install
gh extension install noirbizarre/gh-ship --pin 0.6.0
mise exec -- prek install
mise run test
mise run lint
```

The selected Neovim versions are: 0.12, nightly. Every selected version must pass CI.
The local toolchain uses the latest stable Neovim, or the nightly channel for nightly-only projects.
To test another version without changing the project configuration:

```sh
mise exec github:neovim/neovim@nightly -- lx --no-luarc test
```

Use `mise run format` to run `lx fmt`. `mise run lint:lua` runs `lx lint` (luacheck), and `mise run check`
runs `lx check` (EmmyLua) with Neovim's annotations.
Only lint selects Lua 5.1 explicitly: Lux 0.52.2 otherwise uses the system Lua to run luacheck,
even when the project's Lua version is specified in `lux.toml`.
Tests live in `spec/`; add regression tests for behavior rather than snapshots of implementation details.
The template does not provide lockfiles. `mise install` creates `mise.lock`, and the first test run creates `lux.lock`.
Commit these generated files in your project for reproducibility; tool declarations use `latest`.
Review and commit lock changes when updating tools or dependencies. CI checks the project's existing Lux lock for drift.
Lux derives package versions from Git tags, falling back to dev.
The test task uses `--no-luarc` because installing dependencies would otherwise rewrite `.luarc.json`.
Formatting, workflow linting, Markdown checks, spelling, and basic file hygiene also run through prek.
Commit messages follow Conventional Commits; for example, `feat: add an action` or `fix: handle empty buffers`.

## Documentation

The template provides only a `doc/.gitkeep` placeholder. The official panvimdoc hook generates
`doc/example.txt` on commit, or explicitly through `mise run docs`.
Commit the generated help alongside README.md changes.
It updates help and exits 1 when files change: review/stage the changes, then rerun the hook to get a passing result.
PR CI uses the same hook and fails on missing or stale help with the diff and repair instructions.
The hook uses panvimdoc v6.0.0; `mise.lock` records the Pandoc version. Dates and version banners are disabled.
Help is committed before merge, so installations from specific commits have documentation available immediately.

## Releasing

Releases use [gh-ship](https://noirbizarre.github.io/gh-ship/) and git-cliff.
Versions exist in unprefixed SemVer tags and CHANGELOG.md, beginning at 0.1.0.
There is no separate Lua version file to keep in sync.

1. A push to main prepares or updates the `release/next` PR and changelog.
2. Review the generated changelog and wait for CI.
3. Squash-merge the PR, retaining its `chore(release): VERSION` title.
4. gh-ship tags the merge commit, creates a draft GitHub Release, validates the immutable checkout, then publishes it.

`mise run release` previews the next version. `mise run changelog` previews unreleased notes.
Release commits and dependency-only chores do not trigger another release.
The preparation workflow supports `dry_run`, producing its artifact without committing or pushing.

### Repository setup

Create a GitHub App installed on this repository with repository permissions:
**Contents: read/write**, **Pull requests: read/write**, **Issues: read/write**, and **Actions: read/write**.
Also grant **Workflows: read/write** if release history can contain workflow changes.
Create a GitHub environment named `release`, with variable `APP_CLIENT_ID` and secret `APP_PRIVATE_KEY`.
App tokens let release-branch pushes trigger CI; gh-ship renews its own tokens while waiting.
The workflow's default token only reads repository contents.

Configure squash merge titles from the PR title and blank squash bodies:
`squash_merge_commit_title: PR_TITLE`, `squash_merge_commit_message: BLANK`.
Create a `release` issue label. Protect main with the normal CI checks.
Validate changes to the release contract with `mise run ship:validate`.

## Template updates

git-tpl renders template updates into a Git ref. Incorporation is an ordinary merge:

```sh
git tpl update --defaults
git tpl diff
git tpl merge
```

Resolve conflicts using normal Git tools, then run tests and lint checks.
Keep project-specific task and hook additions below the marked sections to make updates easier to merge.
