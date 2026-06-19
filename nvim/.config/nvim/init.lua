-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.opt.updatetime = 150

-- Auto-reload files changed on disk
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  command = "checktime",
})

-- Basic options
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.signcolumn     = "yes"
vim.opt.termguicolors  = true
vim.opt.mouse          = "a"
vim.opt.clipboard      = "unnamedplus"
vim.opt.splitright     = true
vim.opt.splitbelow     = true
vim.opt.fillchars      = { eob = " " }
vim.g.mapleader        = " "

-- Plugins
require("lazy").setup({
  -- Colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false, priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "frappe",
        transparent_background = true,
        integrations = {
          bufferline = true,
          neotree = true,
          gitsigns = true,
          treesitter = true,
          telescope = { enabled = true },
          mason = true,
        },
        highlight_overrides = {
          all = function()
            return {
              NeoTreeTabSeparatorActive   = { bg = "NONE" },
              NeoTreeTabSeparatorInactive = { bg = "NONE" },
              NeoTreeNormal               = { bg = "NONE" },
              NeoTreeNormalNC             = { bg = "NONE" },
              NeoTreeEndOfBuffer          = { bg = "NONE" },
              BufferLineFill              = { bg = "NONE" },
            }
          end,
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- File explorer with git status
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        hide_root_node = true,
        sources = { "filesystem", "buffers", "git_status" },
        source_selector = {
          winbar = true,
          separator = "",
          sources = {
            { source = "filesystem",  display_name = " 󰉓 Files"   },
            { source = "buffers",     display_name = " 󰈚 Buffers" },
            { source = "git_status",  display_name = " 󰊢 Git"     },
          },
        },
        window = {
          width = 32,
          mappings = {
            ["<Tab>"]   = "next_source",
            ["<S-Tab>"] = "prev_source",
          },
        },
        filesystem = {
          filtered_items = { hide_dotfiles = false, hide_gitignored = false },
          follow_current_file = { enabled = true },
          use_libuv_file_watcher = true,
        },
        git_status = { symbols = {
          added     = "✚",
          modified  = "",
          deleted   = "✖",
          renamed   = "󰁕",
          untracked = "★",
          ignored   = "◌",
          unstaged  = "󰄱",
          staged    = "",
          conflict  = "",
        }},
      })
    end,
  },

  -- Git change indicators in the gutter
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = "▎" },
          change       = { text = "▎" },
          delete       = { text = "" },
          topdelete    = { text = "" },
          changedelete = { text = "▎" },
        },
        current_line_blame = true,
      })
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = { theme = "auto" },
        extensions = { "neo-tree" },
      })
    end,
  },

  -- Diff viewer for all changed files (C)
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("diffview").setup()
    end,
  },

  -- Fuzzy finder with live file preview (D)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          layout_strategy = "horizontal",
          layout_config = { preview_width = 0.55 },
        },
      })
    end,
  },

  -- LSP: installer + configs
  { "williamboman/mason.nvim",          build = ":MasonUpdate" },
  { "williamboman/mason-lspconfig.nvim" },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "pyright", "marksman" },
        automatic_installation = true,
      })

      local on_attach = function(_, bufnr)
        local bmap = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
        end
        bmap("n", "gd", vim.lsp.buf.definition,      "Go to definition")
        bmap("n", "gD", vim.lsp.buf.declaration,     "Go to declaration")
        bmap("n", "gr", vim.lsp.buf.references,      "Go to references")
        bmap("n", "gi", vim.lsp.buf.implementation,  "Go to implementation")
        bmap("n", "K",  vim.lsp.buf.hover,           "Hover docs")
        vim.api.nvim_create_autocmd("CursorHold", {
          buffer = bufnr,
          callback = vim.lsp.buf.hover,
        })
        bmap("n", "<leader>rn", vim.lsp.buf.rename,  "Rename symbol")
        bmap("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
      end

      vim.lsp.config('pyright',   { on_attach = on_attach, capabilities = capabilities, settings = {
        python = { venvPath = ".", venv = ".venv" },
      }})
      vim.lsp.config('marksman',  { on_attach = on_attach, capabilities = capabilities })
      vim.lsp.enable({ 'pyright', 'marksman' })
    end,
  },

  -- Minimap
  {
    "Isrothy/neominimap.nvim",
    lazy = false,
    init = function()
      vim.g.neominimap = {
        auto_enable = true,
        minimap_width = 15,
        buf_filter = function(bufnr)
          return vim.bo[bufnr].filetype ~= "markdown"
        end,
      }
    end,
  },

  -- Buffer tabs
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
          show_buffer_close_icons = true,
          show_close_icon = false,
          separator_style = "thin",
        },
      })
    end,
  },

  -- Terminal toggle
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<leader>t]],
        direction    = "horizontal",
        size         = 15,
      })
      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({
        cmd = "lazygit",
        direction = "float",
        float_opts = { border = "rounded" },
        hidden = true,
      })
      vim.keymap.set("n", "<leader>lg", function() lazygit:toggle() end, { silent = true, desc = "Lazygit" })
    end,
  },

  -- Treesitter (required by render-markdown)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      vim.filetype.add({ extension = { md = "markdown" } })
      require("nvim-treesitter").setup({
        ensure_installed = { "markdown", "markdown_inline", "python", "lua", "bash", "json", "yaml" },
      })
      vim.api.nvim_create_autocmd("FileType", {
        callback = function() pcall(vim.treesitter.start) end,
      })
    end,
  },

  -- In-buffer markdown rendering (E)
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    config = function()
      require("render-markdown").setup()
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"]     = cmp.mapping.abort(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<Tab>"]     = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"]   = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- Comment toggle
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- Auto-format on save
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          python = { "ruff_format" },
          lua    = { "stylua" },
        },
        format_on_save = { timeout_ms = 2000, lsp_fallback = true },
      })
    end,
  },

  -- Auto-pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({ check_ts = true })
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- Which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup()
    end,
  },

  -- Project-wide diagnostics list
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup()
    end,
  },

  -- Session persistence (auto-saves and restores on reopen)
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    config = function()
      require("persistence").setup()
      -- Auto-restore session when nvim opened with no args
      vim.api.nvim_create_autocmd("VimEnter", {
        nested = true,
        callback = function()
          if vim.fn.argc() == 0 then
            require("persistence").load()
          end
        end,
      })
    end,
  },
})

-- Diagnostics display
vim.diagnostic.config({
  underline = true,
  signs = true,
  virtual_text = { prefix = "●" },
  update_in_insert = false,
})

-- Keymaps
local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

map("n", "<C-s>", ":w<CR>", "Save file")
map("n", "<leader>e", ":Neotree toggle<CR>", "Toggle file explorer")
map("i", "<C-s>", "<Esc>:w<CR>a", "Save file")
local neotree_git_open = false
map("n", "<leader>g", function()
  if neotree_git_open then
    vim.cmd("Neotree git_status close")
    neotree_git_open = false
  else
    vim.cmd("Neotree git_status show")
    neotree_git_open = true
  end
end, "Toggle git status")
map("n", "<leader>]", ":Gitsigns next_hunk<CR>",       "Next git hunk")
map("n", "<leader>[", ":Gitsigns prev_hunk<CR>",       "Prev git hunk")
map("n", "<leader>p", ":Gitsigns preview_hunk<CR>",    "Preview git hunk")

map("n", "<leader>dd", vim.diagnostic.open_float,        "Show diagnostic")
map("n", "]d",        vim.diagnostic.goto_next,          "Next diagnostic")
map("n", "[d",        vim.diagnostic.goto_prev,          "Prev diagnostic")

map("n", "<Tab>",   ":BufferLineCycleNext<CR>", "Next buffer")
map("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", "Prev buffer")
map("n", "<leader>x", function()
  local bufs = vim.fn.getbufinfo({ buflisted = 1 })
  if #bufs > 1 then
    vim.cmd("bp | bd #")
  else
    vim.cmd("enew | bd #")  -- open empty buffer instead of closing nvim
  end
end, "Close buffer")

-- diffview (C)
local diffview_open = false
map("n", "<leader>d", function()
  if diffview_open then
    vim.cmd("DiffviewClose")
    diffview_open = false
  else
    vim.cmd("DiffviewOpen")
    diffview_open = true
  end
end, "Toggle diff view")
map("n", "<leader>h", ":DiffviewFileHistory %<CR>",    "File git history")

-- telescope (D)
map("n", "<leader>f", ":Telescope find_files<CR>",     "Find files")
map("n", "<leader>s", ":Telescope live_grep<CR>",      "Search in files")
map("n", "<leader>b", ":Telescope buffers<CR>",        "Browse buffers")

-- trouble
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",        "Toggle diagnostics (project)")
map("n", "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", "Toggle diagnostics (buffer)")

-- Soft wrap for markdown
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})
