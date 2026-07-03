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
	"https://github.com/stevearc/conform.nvim", -- Formatters, LSPs, Linters
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

-- Formatters, LSPs, Linters
local langs = {
	ansible = { lsp = "ansiblels", linter = "ansible-lint" },
	c = { lsp = "clangd", formatters = { "clang-format" } },
	css = { lsp = "cssls", formatters = { "prettierd" } },
	hcl = { lsp = "terraformls", formatters = { "terraform_fmt" } },
	html = { lsp = "html", formatters = { "prettierd" } },
	hypr = { lsp = "hyprls" },
	java = { lsp = "jdtls", formatters = { "google-java-format" } },
	javascript = { lsp = "prettierd", formatters = { "prettierd" } },
	jinja = { lsp = "jinja_lsp", formatters = { "djlint" } },
	json = { lsp = "jsonls", formatters = { "prettier" } },
	lua = { lsp = "lua_ls", formatters = { "stylua" } },
	python = { lsp = "pyright", formatters = { "isort", "black" } },
	sh = { lsp = "bashls", formatters = { "shellharden", "shfmt" }, linter = "shellcheck" },
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
local formatters_by_ft, ensure_installed = {}, {}
for lang, lang_data in pairs(langs) do -- Populate tables
	formatters_by_ft[lang] = lang_data.formatters
	table.insert(ensure_installed, lang_data.lsp)
	if lang_data.formatters then
		for _, formatter in ipairs(lang_data.formatters) do
			local mason_name = mason_aliases[formatter] or formatter
			table.insert(ensure_installed, mason_name)
		end
	end
	if lang_data.linter then
		table.insert(ensure_installed, lang_data.linter)
	end
end
require("conform").setup({
	formatters_by_ft = formatters_by_ft,
	format_on_save = {},
})
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
	ensure_installed = ensure_installed,
	auto_update = true,
})

-- Tree-sitter
require("tree-sitter-manager").setup({
	auto_install = true,
})

-- Navigation
require("telescope").setup({ pickers = { find_files = { hidden = true } }, extensions = { fzf = {} } })
require("telescope").load_extension("fzf")
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

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
		end)
		map("n", "[h", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[h", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end)
		-- Actions
		map("n", "<leader>hp", gitsigns.preview_hunk)
		map("n", "<leader>hi", gitsigns.preview_hunk_inline)
		map("n", "<leader>hb", function()
			gitsigns.blame_line({ full = true })
		end)
		map("n", "<leader>hd", gitsigns.diffthis)
		map("n", "<leader>hD", function()
			gitsigns.diffthis("~")
		end)
		-- Toggles
		map("n", "<leader>tw", gitsigns.toggle_word_diff)
	end,
})
