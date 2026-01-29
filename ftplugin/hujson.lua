if vim.b.did_ftplugin_hujson then
    return
end

vim.b.did_ftplugin_hujson = true

-- Inherit most settings from jsonc.
vim.cmd("runtime! ftplugin/jsonc.vim")
vim.cmd("runtime! indent/jsonc.vim")

vim.bo.formatprg = "hujsonfmt"
vim.bo.expandtab = false

-- We anyway use the json parser for jsonc, this replicates the logic for
-- hujson.
vim.treesitter.language.register("json", "hujson")

vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("HuJSONFormat", {clear = true}),
    desc = "Format HuJSON",
    buffer = 0,
    callback = function()
        -- In case the formatprg is overridden to include flags or something,
        -- take only the head.
        if vim.fn.executable(vim.fn.split(vim.bo.formatprg, " ")[1]) == 1 then
            local view = vim.fn.winsaveview()
            vim.cmd("silent keepjumps normal! gggqG")
            vim.fn.winrestview(view)
        end
    end
})
