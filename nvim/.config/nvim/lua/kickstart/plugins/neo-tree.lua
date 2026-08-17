-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
  init = function()
    -- Called via `nvim -c NeotreeOnStartup` to show the sidebar on launch.
    -- Deferred past VimEnter so it doesn't race with the dashboard plugin
    -- for the initial window.
    vim.api.nvim_create_user_command('NeotreeOnStartup', function()
      vim.api.nvim_create_autocmd('VimEnter', {
        once = true,
        callback = function()
          vim.defer_fn(function()
            require('neo-tree.command').execute { action = 'show' }
          end, 50)
        end,
      })
    end, {})
  end,
}
