return {
	"nvim-telescope/telescope.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"BurntSushi/ripgrep",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	config = function()
		require("telescope").setup({ pickers = { find_files = { hidden = true } }, extensions = { fzf = {} } })
		require("telescope").load_extension("fzf")
	end,
	keys = {
		{
			"<leader>ff",
			function()
				require("telescope.builtin").find_files({ no_ignore = true })
			end,
			desc = "Telescope find files",
		},
		{
			"<leader>fg",
			function()
				require("telescope.builtin").live_grep()
			end,
			desc = "Telescope live grep",
		},
		{
			"<leader>fb",
			function()
				require("telescope.builtin").builtin()
			end,
			desc = "Telescope list Built-in pickers",
		},
	},
}
