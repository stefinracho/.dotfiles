--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------
vim.g.mapleader = " " -- Globals
vim.opt.shiftwidth = 4 -- Conformity
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.relativenumber = true -- Visuals
vim.opt.cursorline = true
vim.opt.colorcolumn = "80"

--------------------------------------------------------------------------------
-- Plugins
--------------------------------------------------------------------------------
vim.pack.add({
	"https://github.com/rebelot/kanagawa.nvim", -- Colorscheme
	"https://github.com/saghen/blink.cmp", -- Auto-completion
	"https://github.com/saghen/blink.lib",
	"https://github.com/rafamadriz/friendly-snippets",
	"https://github.com/stevearc/conform.nvim", -- Formatters, Linters, LSPs
	"https://github.com/mfussenegger/nvim-lint",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/romus204/tree-sitter-manager.nvim", -- Tree-sitter
	"https://github.com/nvim-telescope/telescope.nvim", -- Navigation
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-telescope/telescope-fzf-native.nvim",
	"https://github.com/m4xshen/hardtime.nvim",
	"https://github.com/mrcjkb/rustaceanvim", -- Rust
	"https://github.com/lewis6991/gitsigns.nvim", -- Git
	"https://github.com/kylechui/nvim-surround", -- Text editing
	"https://github.com/meanderingprogrammer/render-markdown.nvim", -- Markdown
})

-- Colorscheme
require("kanagawa").setup({ background = { dark = "dragon" } })
vim.cmd("colorscheme kanagawa")

-- Auto-completion
local cmp = require("blink.cmp")
cmp.build():pwait()
cmp.setup({ signature = { enabled = true } })

-- Formatters, Linters, LSPs
local langs = {
	ansible = { lsp = "ansiblels", linters = { "ansible-lint" } },
	c = { lsp = "clangd", formatters = { "clang-format" } },
	css = { lsp = "cssls", formatters = { "prettierd" } },
	hcl = { lsp = "terraformls", formatters = { "terraform_fmt" } },
	html = { lsp = "html", formatters = { "prettierd" } },
	hypr = { lsp = "hyprls" },
	java = { lsp = "jdtls", formatters = { "google-java-format" } },
	javascript = { lsp = "prettierd", formatters = { "prettierd" } },
	jinja = { lsp = "jinja_lsp", formatters = { "djlint" } },
	json = { lsp = "jsonls", formatters = { "prettier" } },
	lua = { lsp = "lua_ls", formatters = { "stylua" }, linters = { "selene" } },
	python = { lsp = "ty", formatters = { "ruff" } },
	sh = { lsp = "bashls", formatters = { "shellharden", "shfmt" }, linters = { "shellcheck" } },
	sql = { lsp = "sqlls", formatters = { "sql_formatter" } },
	tailwindcss = { lsp = "tailwindcss" },
	terraform = { lsp = "terraformls", formatters = { "terraform_fmt" } },
	["terraform-vars"] = { lsp = "terraformls", formatters = { "terraform_fmt" } },
	typescript = { lsp = "ts_ls", formatters = { "prettierd" } },
	typescriptreact = { lsp = "ts_ls", formatters = { "prettier" } },
	yaml = { lsp = "yamlls", formatters = { "prettierd" } },
}
local mason_aliases = {
	terraform_fmt = "terraform",
	sql_formatter = "sql-formatter",
}
local ensure_installed, formatters_by_ft, linters_by_ft = {}, {}, {}
for lang, lang_data in pairs(langs) do -- Populate tables
	table.insert(ensure_installed, lang_data.lsp)
	if lang_data.formatters then
		for _, formatter in ipairs(lang_data.formatters) do
			local mason_name = mason_aliases[formatter] or formatter
			table.insert(ensure_installed, mason_name)
		end
	end
	if lang_data.linters then
		for _, linter in ipairs(lang_data.linters) do
			table.insert(ensure_installed, linter)
		end
	end
	formatters_by_ft[lang] = lang_data.formatters
	linters_by_ft[lang] = lang_data.linters
end
require("conform").setup({ -- Formatters
	formatters_by_ft = formatters_by_ft,
	format_on_save = {},
})
require("lint").linters_by_ft = linters_by_ft -- Linters
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
	callback = function()
		require("lint").try_lint()
	end,
})
require("mason").setup()
require("mason-lspconfig").setup() -- LSPs
require("mason-tool-installer").setup({
	ensure_installed = ensure_installed,
	auto_update = true,
})

-- Tree-sitter
require("tree-sitter-manager").setup({
	auto_install = true,
})

-- Navigation
require("telescope").setup({ extensions = { fzf = {} } })
require("telescope").load_extension("fzf")
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "Telescope: Current buffer fuzzy find" })
vim.keymap.set("n", "<leader>?", builtin.keymaps, { desc = "Telescope: Normal mode keymappings" })
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope: Find files" })
vim.keymap.set("n", "<leader>fF", function()
	builtin.find_files({ hidden = true, no_ignore = true })
end, { desc = "Telescope: Find files (hidden/ignored)" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope: Live grep current working directory" })
vim.keymap.set("n", "<leader>fG", function()
	builtin.live_grep({ hidden = true, no_ignore = true })
end, { desc = "Telescope: Live grep current working directory (hidden/ignored)" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope: Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope: Help tags" })
vim.keymap.set("n", "<leader>fm", builtin.man_pages, { desc = "Telescope: Man pages" })
vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Telescope: Git status" })

require("hardtime").setup()

-- Git
require("gitsigns").setup({
	on_attach = function(bufnr)
		local gitsigns = require("gitsigns")
		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end
		-- Navigation
		map("n", "]h", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]h", bang = true })
			else
				gitsigns.nav_hunk("next")
			end
		end, { desc = "Gitsigns: Next hunk" })
		map("n", "[h", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[h", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end, { desc = "Gitsigns: Previous hunk" })
		-- Actions
		map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Gitsigns: Preview hunk" })
		map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Gitsigns: Preview hunk inline" })
		map("n", "<leader>hb", function()
			gitsigns.blame_line({ full = true })
		end, { desc = "Gitsigns: Blame line" })
		map("n", "<leader>hd", gitsigns.diffthis, { desc = "Gitsigns: Split window comparison" })
		map("n", "<leader>hD", function()
			gitsigns.diffthis("~")
		end, { desc = "Gitsigns: Split window comparison~" })
		map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Gitsigns: Stage hunk" })
		map("v", "<leader>hs", function()
			gitsigns.stage_hunk({ vim.fn.line("'<"), vim.fn.line("'>") })
		end, { desc = "Gitsigns: Stage selected lines" })
		-- Toggles
		map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "Gitsigns: Toggle word diff" })
	end,
})
