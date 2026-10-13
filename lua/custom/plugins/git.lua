-- Git / jj tooling. Everything lives under <leader>g, conflict resolution under <leader>c.

-- Floating TUI terminals (lazygit, jjui) share toggleterm
local tuis = {}
local function toggle_tui(cmd)
  return function()
    if not tuis[cmd] then
      tuis[cmd] = require('toggleterm.terminal').Terminal:new {
        cmd = cmd,
        direction = 'float',
        hidden = true, -- keep out of the regular <c-`> terminal rotation
        float_opts = { border = 'rounded', width = math.floor(vim.o.columns * 0.9), height = math.floor(vim.o.lines * 0.9) },
        on_open = function(term)
          -- global <Esc><Esc> would make every single <Esc> in the TUI wait out timeoutlen
          vim.keymap.set('t', '<Esc>', '<Esc>', { buffer = term.bufnr, nowait = true })
        end,
      }
    end
    tuis[cmd]:toggle()
  end
end

return {
  { -- Magit-style status buffer: stage, commit, rebase, push/pull
    'NeogitOrg/neogit',
    cmd = 'Neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'nvim-telescope/telescope.nvim',
    },
    opts = {},
    keys = {
      { '<leader>gg', '<cmd>Neogit<cr>', desc = 'Neo[g]it status' },
      { '<leader>gc', '<cmd>Neogit commit<cr>', desc = 'Git [c]ommit' },
    },
  },

  { -- whole-repo diffs, file history and 3-way merge view
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
    keys = {
      {
        '<leader>gd',
        function()
          if next(require('diffview.lib').views) == nil then
            vim.cmd 'DiffviewOpen'
          else
            vim.cmd 'DiffviewClose'
          end
        end,
        desc = 'Toggle [d]iffview',
      },
      { '<leader>gm', '<cmd>DiffviewOpen origin/HEAD...HEAD<cr>', desc = 'Diff branch against [m]ain (PR view)' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'File [h]istory' },
      { '<leader>gH', '<cmd>DiffviewFileHistory<cr>', desc = 'Repo [H]istory' },
      { '<leader>gh', ":'<,'>DiffviewFileHistory<cr>", mode = 'v', desc = 'Selection [h]istory' },
    },
    opts = {},
  },

  { -- inline conflict marker highlighting + pick ours/theirs
    'akinsho/git-conflict.nvim',
    version = '*',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      -- defaults (co/ct/cb/c0, ]x/[x) shadow change-operator motions and the treesitter number move
      default_mappings = {
        ours = '<leader>co',
        theirs = '<leader>ct',
        both = '<leader>cb',
        none = '<leader>c0',
        next = ']n',
        prev = '[n',
      },
    },
  },

  { -- nvim as jj's diff editor (jj split / squash -i); wired up in ~/.config/jj/config.toml
    'julienvincent/hunk.nvim',
    cmd = 'DiffEditor',
    dependencies = { 'MunifTanjim/nui.nvim', 'nvim-tree/nvim-web-devicons' },
    opts = {},
  },

  { -- floating lazygit / jjui
    'akinsho/toggleterm.nvim',
    lazy = false, -- adding `keys` would otherwise lazy-load it and break the <c-`> open_mapping
    keys = {
      { '<leader>gl', toggle_tui 'lazygit', desc = '[l]azygit' },
      { '<leader>gj', toggle_tui 'jjui', desc = '[j]jui' },
    },
  },
}
