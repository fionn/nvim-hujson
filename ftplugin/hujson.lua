if vim.b.did_ftplugin_hujson then
    return
end

vim.b.did_ftplugin_hujson = true

-- Inherit most settings from jsonc.
vim.cmd("runtime! ftplugin/jsonc.vim")
vim.cmd("runtime! indent/jsonc.vim")

-- We anyway use the json parser for jsonc, this replicates the logic for
-- hujson.
vim.treesitter.language.register("json", "hujson")

vim.bo.expandtab = false

if vim.fn.executable("hujsonfmt") == 1 then
    vim.bo.formatprg = "hujsonfmt"
end

vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("HuJSONFormat", {clear = true}),
    desc = "Format HuJSON",
    buffer = 0,
    callback = function()
        if vim.bo.formatprg ~= "" then
            local view = vim.fn.winsaveview()
            vim.cmd("silent keepjumps normal! gggqG")
            vim.fn.winrestview(view)
        end
    end
})
