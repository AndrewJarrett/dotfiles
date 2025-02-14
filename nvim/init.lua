local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ "ellisonleao/gruvbox.nvim",         priority = 1000,      config = true,  opts = ... },
	{ "voldikss/vim-floaterm", },
	{ "williamboman/mason.nvim",          lazy = false },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "neovim/nvim-lspconfig",            lazy = false },
	{ "folke/neodev.nvim",                opts = {} },
	{ "folke/persistence.nvim",           event = "BufReadPre", opts = {} },
	{ "mrcjkb/rustaceanvim",              version = "^3",       ft = { "rust" } },
	{ "mfussenegger/nvim-dap" },
	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "nvim-treesitter/nvim-treesitter" },
	{ "nvim-treesitter/nvim-treesitter-textobjects" },
	{ "nvim-treesitter/playground" },
	{ "HiPhish/nvim-ts-rainbow2" },
	{
		'cameron-wags/rainbow_csv.nvim',
		config = true,
		ft = {
			'csv',
			'tsv',
			'csv_semicolon',
			'csv_whitespace',
			'csv_pipe',
			'rfc_csv',
			'rfc_semicolon'
		},
		cmd = {
			'RainbowDelim',
			'RainbowDelimSimple',
			'RainbowDelimQuoted',
			'RainbowMultiDelim'
		}
	},
	{ "windwp/nvim-ts-autotag" },
	{ "tikhomirov/vim-glsl" },
	{ 'timtro/glslView-nvim',             ft = 'glsl' },
	{
		"Zeioth/compiler.nvim",
		cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
		dependencies = { "stevearc/overseer.nvim" },
		opts = {},
	},
	{
		"stevearc/overseer.nvim",
		commit = "400e762648b70397d0d315e5acaf0ff3597f2d8b",
		cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
		opts = {
			task_list = {
				direction = "bottom",
				min_height = 25,
				max_height = 25,
				default_detail = 1
			},
		},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {}
	},
	{
		"nvim-telescope/telescope.nvim", tag = "0.1.5", dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			require("plenary.filetype").add_file("sf_type")
		end
	},
	{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	--{
	--	'huggingface/llm.nvim',
	--	opts = {
	--		api_token = nil, -- cf Install paragraph
	--		model = "codellama:7b", -- the model ID, behavior depends on backend
	--		backend = "ollama", -- backend ID, "huggingface" | "ollama" | "openai" | "tgi"
	--		url = "http://localhost:11434/api/generate", -- the http url of the backend
	--		--tokens_to_clear = { "<|endoftext|>" }, -- tokens to remove from the model's output
	--		tokens_to_clear = { "EOT" }, -- tokens to remove from the model's output
	--		-- parameters that are added to the request body, values are arbitrary, you can set any field:value pair here it will be passed as is to the backend
	--		request_body = {
	--			parameters = {
	--				max_new_tokens = 60,
	--				temperature = 0.2,
	--				top_p = 0.95,
	--			},
	--		},
	--		-- set this if the model supports fill in the middle
	--		fim = {
	--			enabled = true,
	--			prefix = "<PRE> ",
	--			middle = " <MID>",
	--			suffix = " <SUF>",
	--		},
	--		-- fim = {
	--		-- 	enabled = true,
	--		-- 	prefix = "<fim_prefix>",
	--		-- 	middle = "<fim_middle>",
	--		-- 	suffix = "<fim_suffix>",
	--		-- },
	--		debounce_ms = 150,
	--		accept_keymap = "<Tab>",
	--		dismiss_keymap = "<S-Tab>",
	--		tls_skip_verify_insecure = false,
	--		-- llm-ls configuration, cf llm-ls section
	--		lsp = {
	--			bin_path = vim.api.nvim_call_function("stdpath", { "data" }) .. "/mason/bin/llm-ls",
	--			host = "localhost",
	--			port = "11434",
	--			version = "0.5.2",
	--		},
	--		tokenizer = nil, -- cf Tokenizer paragraph
	--		context_window = 8192, -- max number of tokens for the context window
	--		enable_suggestions_on_startup = true,
	--		enable_suggestions_on_files = "*", -- pattern matching syntax to enable suggestions on specific files, either a string or a list of strings
	--	}
	--},
})

vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

vim.opt.shellcmdflag = "-c"

if (vim.loop.os_uname().sysname == "Windows_NT") then 
	vim.opt.shellslash = true
end

-- Mason
require("mason").setup()
require("mason-lspconfig").setup()

-- Neodev
require("neodev").setup()

-- Telescope
require("telescope").setup {
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		}
	},
}
require("telescope").load_extension('fzf')

-- nvm-cmp
require("cmp").setup({
	sources = {
		{ name = "nvim_lsp" }
	}
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- LSP
local lspconfig = require("lspconfig")

-- Lua LS
lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace"
			},
			diagnostics = {
				globals = { "vim" }
			},
		}
	},
	capabilities = capabilities,
})

-- Rust LS
lspconfig.rust_analyzer.setup {
	settings = {
		['rust-analyzer'] = {},
	},
}
--[[
]]

-- Apex LS
lspconfig.apex_ls.setup {
	filetypes = { "apex", "soql", "sosl", "apexcode" },
	apex_jar_path = vim.fn.stdpath("data") .. "/mason/share/apex-language-server/apex-jorje-lsp.jar",
	apex_enabled_semantic_errors = false,
}

-- Clang
lspconfig.clangd.setup {
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
	capabilities = capabilities,
}

-- Zig
lspconfig.zls.setup{}

-- Java
lspconfig.java_language_server.setup {
	filetypes = { "java" },
	capabilities = capabilities,
}

-- Azure Pipelines LS
lspconfig.azure_pipelines_ls.setup{
  settings = {
      yaml = {
          schemas = {
              ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
                  "/azure-pipeline*.y*l",
                  "/*.azure*",
                  "Azure-Pipelines/**/*.y*l",
                  "Pipelines/*.y*l",
              },
          },
      },
  },
}

-- Bash
lspconfig.bashls.setup{}

-- JSON
--Enable (broadcasting) snippet capability for completion
--local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.jsonls.setup {
  capabilities = capabilities,
}

-- LWC
lspconfig.lwc_ls.setup{}

-- VisualForce
lspconfig.visualforce_ls.setup{}

-- RobotFramework
lspconfig.robotframework_ls.setup{}

-- Python
lspconfig.pyright.setup{}

-- Go
lspconfig.gopls.setup{}

-- SQL
lspconfig.sqlls.setup{}

-- YAML
lspconfig.yamlls.setup{}

-- WGSL
lspconfig.wgsl_analyzer.setup{}

-- Typos
lspconfig.typos_lsp.setup{}

-- GLSL Analyzer
lspconfig.glsl_analyzer.setup{}

-- HTML
--Enable (broadcasting) snippet capability for completion
--local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.html.setup {
  capabilities = capabilities,
}

-- Which Key Mappings
local wk = require("which-key")
-- Telescope
wk.add({
	{ "<leader>f", group = "file" },
	{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File" },
	{ "<leader>fn", desc = "New File" },
	{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Open Recent File" },
})
-- Vim Diagnostics
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
wk.add({
	{ "<space>e", "function() vim.diagnostic.open_float end", desc = "Open Diagnostics" },
	{ "<space>q", "function() vim.diagnostic.setloclist end", desc = "Set Local List" },
	{ "[d", "function() vim.diagnostic.goto_prev end", desc = "Go to Previous Diagnostic" },
	{ "]d", "function() vim.diagnostic.goto_next end", desc = "Go to Next Diagnostic" },
})
-- Floatterm Keymappings
wk.add({
	{ "<leader>t", group = "floaterm", mode = { "n", "t", }},
	{ "<leader>tn", "<cmd>FloatermNext<cr>", desc = "Go to Next Floaterm", mode = { "n", "t", }},
	{ "<leader>to", "<cmd>FloatermNew<cr>", desc = "Open Floaterm", mode = { "n", "t", }},
	{ "<leader>tp", "<cmd>FloatermPrev<cr>", desc = "Go to Previous Floaterm", mode = { "n", "t", }},
	{ "<leader>tt", "<cmd>FloatermToggle<cr>", desc = "Toggle Floaterm", mode = { "n", "t", }},
}, { mode = "t" })
-- Persistence
wk.add({
	{ "<leader>q", group = "persistence" },
	{ "<leader>qd", '<cmd>lua require("persistence").stop()<cr>', desc = "Stop session save on exit" },
	{ "<leader>ql", '<cmd>lua require("persistence").load({ last = true })<cr>', desc = "Restore the last session" },
	{ "<leader>qs", '<cmd>lua require("persistence").load()<cr>', desc = "Restore session for current directory" },
})

-- Terminal Mappings
--wk.register({
--	-- Floaterm Terminal mappings
--	["<leader>t"] = {
--		name = "floaterm",
--		o = { "<C-\\><C-n><cmd>FloatermNew<cr>", "Open Floaterm" },
--		n = { "<C-\\><C-n><cmd>FloatermNext<cr>", "Go to Next Floaterm" },
--		p = { "<C-\\><C-n><cmd>FloatermPrev<cr>", "Go to Previous Floaterm" },
--		t = { "<C-\\><C-n><cmd>FloatermToggle<cr>", "Toggle Floaterm" },
--	}
--}, { mode = "t" })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
		vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set('n', '<space>wl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
		vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
		vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		vim.keymap.set('n', '<space>f', function()
			vim.lsp.buf.format { async = true }
		end, opts)
	end,
})

local cfg = require('rustaceanvim.config')
-- Update this path
local extension_path = vim.env.HOME .. '/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/'
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = extension_path .. 'lldb/lib/liblldb'
local this_os = vim.loop.os_uname().sysname;

-- The path is different on Windows
if this_os:find "Windows" then
	codelldb_path = extension_path .. "adapter\\codelldb.exe"
	liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
else
	-- The liblldb extension is .so for Linux and .dylib for MacOS
	liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
end

vim.g.rustaceanvim = {
	dap = {
		adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
	},
}

-- LLDB / DAP
require("dap").adapters.codelldb = {
	type = "server",
	port = "${port}",
	host = "127.0.0.1",
	executable = {
		command = codelldb_path,
		args = { "--liblldb", liblldb_path, "--port", "${port}" },
	},
	name = "codelldb"
}

local codelldb = {
	name = "Launch codelldb",
	type = "codelldb", -- matches the adapter
	request = "launch", -- could also attach to a currently running process
	program = function()
		vim.fn.jobstart('cargo build')
		return vim.fn.input({
			prompt = "Path to executable: ",
			default = vim.fn.getcwd() .. "\\target\\debug\\",
			completion = "file"
		})
	end,
	cwd = "${workspaceFolder}",
	stopOnEntry = false,
	args = {},
	runInTerminal = false,
}

require('dap').configurations.rust = {
	codelldb -- different debuggers or more configurations can be used here
}

-- DAP Key bindings
vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
vim.keymap.set('n', '<Leader>lp',
	function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
	require('dap.ui.widgets').hover()
end)
vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
	require('dap.ui.widgets').preview()
end)
vim.keymap.set('n', '<Leader>df', function()
	local widgets = require('dap.ui.widgets')
	widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<Leader>ds', function()
	local widgets = require('dap.ui.widgets')
	widgets.centered_float(widgets.scopes)
end)


-- Compiler keymappings
-- Open compiler
vim.api.nvim_set_keymap('n', '<F6>', "<cmd>CompilerOpen<cr>", { noremap = true, silent = true })

-- Redo last selected option
vim.api.nvim_set_keymap('n', '<S-F6>',
	"<cmd>CompilerStop<cr>" -- (Optional, to dispose all tasks before redo)
	.. "<cmd>CompilerRedo<cr>",
	{ noremap = true, silent = true })

-- Toggle compiler results
vim.api.nvim_set_keymap('n', '<S-F7>', "<cmd>CompilerToggleResults<cr>", { noremap = true, silent = true })

-- glslviewer
require('glslView').setup {
	viewer_path = 'glslViewer',
	args = { '-1' },
}

-- import nvim-treesitter plugin safely
local status, treesitter = pcall(require, "nvim-treesitter.configs")
if not status then
	return
end

-- configure treesitter
treesitter.setup({
	-- enable syntax highlighting
	highlight = {
		enable = true,
	},
	-- enable indentation
	indent = { enable = true },
	-- ensure these language parsers are installed
	ensure_installed = {
		"apex", "bash", "c", "css", "csv", "glsl", "go", "html", "java", "javascript",
		"json", --[["lua",--]] "markdown", "markdown_inline", "rust", "soql", "sosl", "toml",
		"typescript", "vim", "vimdoc", "wgsl", "wgsl_bevy", --"xml", -- This has some error right now
		"yaml",
	},
	-- auto install above language parsers
	auto_install = true,
})

-- Treesitter text object mappings
require("nvim-treesitter.configs").setup {
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["af"] = { query = "@function.outer", desc = "Select around the outside of a function" },
				["if"] = { query = "@function.inner", desc = "Select inner part of a function" },
				["ac"] = { query = "@class.outer", desc = "Select around the outside of a class" },
				["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
				["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
			},
			selection_modes = {
				['@parameter.outer'] = 'v', -- charwise
				['@function.outer'] = 'V', -- linewise
				['@class.outer'] = '<c-v>', -- blockwise
			},
			include_surrounding_whitespace = true,
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>a"] = "@parameter.inner",
			},
			swap_previous = {
				["<leader>A"] = "@parameter.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = { query = "@class.outer", desc = "Next class start" },
				["]o"] = "@loop.*",
				["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
				["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
			goto_next = {
				["]d"] = "@conditional.outer",
			},
			goto_previous = {
				["[d"] = "@conditional.outer",
			}
		},
		lsp_interop = {
			enable = true,
			border = 'none',
			floating_preview_opts = {},
			peek_definition_code = {
				["<leader>df"] = "@function.outer",
				["<leader>dF"] = "@class.outer",
			},
		},
	},
	autotag = { enable = true },
	playground = { enable = true },
	rainbow = { enable = true },
}

-- Floaterm
vim.g.floaterm_width = 0.8
vim.g.floaterm_height = 0.8

-- Editing
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.smarttab = true
vim.o.smartindent = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.number = true

vim.filetype = on

vim.filetype.add({
	extension = {
		cls = 'apex',
		apex = 'apex',
		trigger = 'apex',
		soql = 'soql',
		sosl = 'sosl',
	}
})
