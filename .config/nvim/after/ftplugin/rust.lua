local bufnr = vim.api.nvim_get_current_buf()

vim.api.nvim_create_autocmd("BufWritePre", {
	buffer = bufnr,
	callback = function()
		vim.lsp.buf.format({ bufnr = bufnr })
	end,
})

vim.keymap.set("n", "<leader>ee", function()
	vim.cmd.RustLsp("explainError")
end, { silent = true, buffer = bufnr, desc = "Rust: Explain error" })

vim.keymap.set("n", "K", function()
	vim.cmd.RustLsp({ "hover", "actions" })
end, { silent = true, buffer = bufnr, desc = "Rust: Hover actions" })

vim.keymap.set("n", "<C-W>d", function()
	vim.cmd.RustLsp("renderDiagnostic")
end, { silent = true, buffer = bufnr, desc = "Rust: Render diagnostic" })

vim.keymap.set("n", "<leader>ca", function()
	vim.cmd.RustLsp("codeAction")
end, { silent = true, buffer = bufnr, desc = "Rust: Code actions" })
