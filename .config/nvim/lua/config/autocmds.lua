vim.filetype.add({
	pattern = {
		[".*%.j2"] = "jinja",
		[".*%.jinja"] = "jinja",
		[".*%.jinja2"] = "jinja",
		[".*%.ya?ml"] = function(path, buf)
			local content = vim.api.nvim_buf_get_lines(buf, 0, 15, false)
			for _, line in ipairs(content) do
				if line:match("hosts:") or line:match("tasks:") or line:match("roles:") then
					return "yaml.ansible"
				end
			end
			return "yaml"
		end,
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		pcall(vim.treesitter.start)
	end,
})
