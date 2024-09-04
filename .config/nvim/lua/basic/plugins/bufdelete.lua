return {
	"famiu/bufdelete.nvim",
	keys = {
		{ "<leader>qb", function () require('bufdelete').bufdelete(0, false) end, desc = "Close [b]uffer" },
	},
	event = "VeryLazy",
}
