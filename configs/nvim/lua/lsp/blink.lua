return {
  'saghen/blink.cmp',
  lazy = false, -- lazy loading handled internally
  -- optional: provides snippets for the snippet source
  dependencies = {
    { 'rafamadriz/friendly-snippets' },
    { 'L3MON4D3/LuaSnip', version = 'v2.*' },
  },

  -- use a release tag to download pre-built binaries
  version = 'v0.*',
  -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  ---@diagnostic disable: missing-fields
  opts = {
    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- see the "default configuration" section below for full documentation on how to define
    -- your own keymap.
    keymap = {
      preset          = 'none',
      ['<C-space>']   = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-e>']       = { 'hide', 'fallback' },
      ['<CR>']        = { 'accept', 'fallback' },

      ['<C-p>']       = { 'select_prev', 'fallback' },
      ['<C-n>']       = { 'select_next', 'fallback' },

      ['<C-b>']       = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>']       = { 'scroll_documentation_down', 'fallback' },

      ['<Tab>']       = { 'select_next', 'fallback' },
      ['<S-Tab>']     = { 'select_prev', 'fallback' },
      ['<C-L>']       = { 'snippet_forward', 'fallback' },
      ['<C-H>']       = { 'snippet_backward', 'fallback' },
    },

    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- will be removed in a future release
      use_nvim_cmp_as_default = false,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono'
    },
    snippets = {
      expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
      active = function(filter)
        if filter and filter.direction then
          return require('luasnip').jumpable(filter.direction)
        end
        return require('luasnip').in_snippet()
      end,
      jump = function(direction) require('luasnip').jump(direction) end,
    },

    -- default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, via `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    completion = {
      list = {
        selection = { preselect = false, auto_insert = true, }
      },
      menu = {
        -- scrollbar = false,
        draw = {
          gap = 2,
          treesitter = { 'lsp' },
          -- columns = {
          --   { "label", "label_description", gap = 3 },
          --   { "kind_icon", "kind", gap = 1 },
          -- },
        }
      },
      documentation = {
        auto_show = true,
        window = {
          min_width = 10,
          max_width = 150,
          max_height = 40,
          winhighlight = 'Normal:NoicePopup,FloatBorder:NoicePopup,CursorLine:BlinkCmpDocCursorLine,Search:None',
        },
      },
    },

    -- experimental signature help support
    -- signature = { enabled = true }
  },
  ---@diagnostic enable: missing-fields
  -- allows extending the providers array elsewhere in your config
  -- without having to redefine it
  opts_extend = { "sources.default" }
}
