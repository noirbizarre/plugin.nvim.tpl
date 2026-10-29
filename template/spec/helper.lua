-- nlua starts a clean Neovim; add the checkout without loading the runtime entrypoint.
vim.opt.runtimepath:prepend(assert(vim.uv.cwd()))
