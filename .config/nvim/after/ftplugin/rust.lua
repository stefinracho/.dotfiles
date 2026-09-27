local bufnr = vim.api.nvim_get_current_buf()

vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = bufnr,
    callback = function()
        vim.lsp.buf.format({ bufnr = bufnr })
    end,
})

vim.keymap.set("n", "<leader>ee", function()
    vim.cmd.RustLsp({ "explainError", "current" })
end, { silent = true, buffer = bufnr, desc = "Rust: Explain error" })

vim.keymap.set("n", "K", function()
    vim.cmd.RustLsp({ "hover", "actions" })
end, { silent = true, buffer = bufnr, desc = "Rust: Hover actions" })

vim.keymap.set("n", "<C-W>d", function()
    vim.cmd.RustLsp({ "renderDiagnostic", "current" })
end, { silent = true, buffer = bufnr, desc = "Rust: Render diagnostic" })

vim.keymap.set("n", "<leader>ca", function()
    vim.cmd.RustLsp("codeAction")
end, { silent = true, buffer = bufnr, desc = "Rust: Code actions" })

vim.keymap.set("n", "<leader>r", function()
    vim.cmd.RustLsp("run")
end, { silent = true, buffer = bufnr, desc = "Rust: Run target" })

vim.keymap.set("n", "<leader>R", function()
    vim.ui.input({ prompt = "[ARG ...]: " }, function(input)
        if input == nil then
            return
        end
        local args = vim.split(input, "%s+", { trimempty = true })
        vim.cmd.RustLsp({ "runnables", unpack(args) })
    end)
end, { desc = "Rust: Runnables [ARG ...]" })

vim.keymap.set("n", "<leader>t", function()
    vim.ui.input({ prompt = "[ARG ...]: " }, function(input)
        if input == nil then
            return
        end
        local args = vim.split(input, "%s+", { trimempty = true })
        vim.cmd.RustLsp({ "testables", unpack(args) })
    end)
end, { silent = true, buffer = bufnr, desc = "Rust: Testables [ARG ...]" })
