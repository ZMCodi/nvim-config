-- Icons are looked up by extension/filename, not filetype, so .slurm needs its own entry.
return {
  'nvim-tree/nvim-web-devicons',
  enabled = vim.g.have_nerd_font,
  config = function()
    local devicons = require 'nvim-web-devicons'
    local sh = devicons.get_icons().sh
    devicons.set_icon {
      slurm = { icon = sh.icon, color = sh.color, cterm_color = sh.cterm_color, name = 'Slurm' },
    }
  end,
}
