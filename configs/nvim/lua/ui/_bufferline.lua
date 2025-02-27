local utils = require('utils')
local palette = utils.get_palette(vim.g.colorscheme.name, vim.g.colorscheme.theme)

local function get_highlights(_palette)
    if vim.g.colorscheme.vanilla then return {} end
    -- local colors        = require('bufferline.colors')
    -- local hex           = colors.get_color
    -- local tint          = colors.shade_color

    local fill_bg       = vim.g.colors.dark_bg
    local error_fg      = _palette.red
    local hint_fg       = _palette.blue
    local comment_fg    = vim.g.colors.comment
    local visible_fg    = vim.g.colors.comment
    local string_fg     = _palette.green
    local normal_bg     = vim.g.colors.bg
    local sep_fg        = _palette.surface0
    local selected_fg   = _palette.pink

    return {
        fill = {
            bg = fill_bg,
        },
        offset_separator = {
            bg = fill_bg,
        },
        background = {
            -- fg = '<colour-value-here>',
            bg = fill_bg,
        },
        -- tab = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>',
        -- },
        -- tab_selected = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>',
        -- },
        -- tab_separator = {
        --   fg = '<colour-value-here>',
        --   bg = '<colour-value-here>',
        -- },
        -- tab_separator_selected = {
        --   fg = '<colour-value-here>',
        --   bg = '<colour-value-here>',
        --   sp = '<colour-value-here>',
        --   underline = '<colour-value-here>',
        -- },
        -- tab_close = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>',
        -- },
        close_button = {
            fg = comment_fg,
            bg = fill_bg,
        },
        close_button_visible = {
            fg = visible_fg,
            bg = fill_bg,
        },
        -- close_button_selected = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>',
        -- },
        buffer_visible = {
            fg = visible_fg,
            bg = fill_bg,
        },
        buffer_selected = {
            fg = selected_fg,
            bg = normal_bg,
            bold = false,
            italic = false,
        },
        numbers = {
            fg = comment_fg,
            bg = fill_bg,
        },
        numbers_visible = {
            fg = visible_fg,
            bg = fill_bg,
        },
        -- numbers_selected = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>',
        --     bold = true,
        --     italic = true,
        -- },
        diagnostic = {
            -- fg = '<colour-value-here>',
            bg = fill_bg,
        },
        diagnostic_visible = {
            -- fg = '<colour-value-here>',
            bg = fill_bg,
        },
        -- diagnostic_selected = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>',
        --     bold = true,
        --     italic = true,
        -- },
        hint = {
            fg = comment_fg,
            bg = fill_bg,
            sp = hint_fg,
        },
        hint_visible = {
            fg = visible_fg,
            bg = fill_bg,
        },
        -- hint_selected = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>',
        --     sp = '<colour-value-here>',
        --     bold = true,
        --     italic = true,
        -- },
        hint_diagnostic = {
            -- fg = '<colour-value-here>',
            -- sp = '<colour-value-here>',
            bg = fill_bg,
        },
        hint_diagnostic_visible = {
            -- fg = '<colour-value-here>',
            bg = fill_bg,
        },
        -- hint_diagnostic_selected = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>',
        --     sp = '<colour-value-here>',
        --     bold = true,
        --     italic = true,
        -- },
        info = {
            -- fg = '<colour-value-here>',
            -- sp = '<colour-value-here>',
            bg = fill_bg,
        },
        info_visible = {
            -- fg = '<colour-value-here>',
            bg = fill_bg,
        },
        -- info_selected = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>',
        --     sp = '<colour-value-here>',
        --     bold = true,
        --     italic = true,
        -- },
        info_diagnostic = {
            -- fg = '<colour-value-here>',
            -- sp = '<colour-value-here>',
            bg = fill_bg,
        },
        info_diagnostic_visible = {
            -- fg = '<colour-value-here>',
            bg = fill_bg,
        },
        -- info_diagnostic_selected = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>',
        --     sp = '<colour-value-here>',
        --     bold = true,
        --     italic = true,
        -- },
        warning = {
            -- fg = '<colour-value-here>',
            -- sp = '<colour-value-here>',
            bg = fill_bg,
        },
        warning_visible = {
            -- fg = '<colour-value-here>',
            bg = fill_bg,
        },
        -- warning_selected = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>',
        --     sp = '<colour-value-here>',
        --     bold = true,
        --     italic = true,
        -- },
        warning_diagnostic = {
            -- fg = '<colour-value-here>',
            -- sp = '<colour-value-here>',
            bg = fill_bg,
        },
        warning_diagnostic_visible = {
            -- fg = '<colour-value-here>',
            bg = fill_bg,
        },
        -- warning_diagnostic_selected = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>',
        --     sp = '<colour-value-here>',
        --     bold = true,
        --     italic = true,
        -- },
        error = {
            -- fg = error_fg,
            sp = error_fg,
            bg = fill_bg,
        },
        error_visible = {
            -- fg = error_fg,
            bg = fill_bg,
        },
        error_selected = {
            fg = error_fg,
            -- bg = '<colour-value-here>',
            -- sp = '<colour-value-here>',
            -- bold = true,
            -- italic = true,
        },
        error_diagnostic = {
            -- fg = '<colour-value-here>',
            -- sp = '<colour-value-here>',
            bg = fill_bg,
        },
        error_diagnostic_visible = {
            -- fg = '<colour-value-here>',
            bg = fill_bg,
        },
        -- error_diagnostic_selected = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>',
        --     sp = '<colour-value-here>',
        --     bold = true,
        --     italic = true,
        -- },
        modified = {
            fg = string_fg,
            bg = fill_bg,
        },
        modified_visible = {
            fg = string_fg,
            bg = fill_bg,
        },
        -- modified_selected = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>',
        -- },
        -- duplicate_selected = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>',
        --     italic = true,
        -- },
        duplicate_visible = {
            fg = comment_fg,
            bg = fill_bg,
            italic = true,
        },
        duplicate = {
            fg = comment_fg,
            bg = fill_bg,
            italic = true,
        },
        separator_selected = {
            fg = sep_fg,
            bg = normal_bg,
        },
        separator_visible = {
            fg = sep_fg,
            bg = fill_bg,
        },
        separator = {
            fg = sep_fg,
            bg = fill_bg,
        },
        indicator_visible = {
            -- fg = '<colour-value-here>',
            bg = fill_bg,
        },
        -- indicator_selected = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>',
        -- },
        pick_selected = {
            fg = error_fg,
            bg = normal_bg,
            bold = true,
            italic = true,
        },
        pick_visible = {
            fg = error_fg,
            bg = fill_bg,
            bold = true,
            italic = true,
        },
        pick = {
            fg = error_fg,
            bg = fill_bg,
            bold = true,
            italic = true,
        },
        -- trunc_marker = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>',
        -- }
      }
end

local bufferline  = require('bufferline')

local style_preset = {
    bufferline.style_preset.no_italic,
    bufferline.style_preset.no_bold,
}
if vim.g.colorscheme.vanilla then
    style_preset = {
        bufferline.style_preset.no_italic,
        bufferline.style_preset.no_bold,
        bufferline.style_preset.minimal,
    }
end

bufferline.setup {
    highlights = get_highlights(palette),
    options = {
        style_preset = style_preset,
        separator_style = { "∣", "∣" },
        diagnostics = "nvim_lsp",
        buffer_close_icon = "×",
        get_element_icon = function(element)
          -- element consists of {filetype: string, path: string, extension: string, directory: string}
          -- This can be used to change how bufferline fetches the icon
          -- for an element e.g. a buffer or a tab.
          -- e.g.
          local icon, hl = require('nvim-web-devicons').get_icon_by_filetype(element.filetype, { default = true })
          if vim.g.symbol_font then icon = icon .. " " end
          return icon, hl
        end,
        indicator = {
          -- icon = '▎', -- this should be omitted if indicator style is not 'icon'
          style = 'underline',
        },
        offsets = {
            {
                filetype = "NvimTree",
                text = " EXPLORER",
                separator = false,
                text_align = "left",
                highlight = "BufferLineBackground",
            },
            {
                filetype = "Outline",
                text = " › OUTLINE",
                text_align = "left",
                separator = "▏",
                highlight = "BufferLineBackground",
            },
        },
        numbers = function(opts)
            ---@diagnostic disable-next-line: undefined-field
            return string.format('%s', opts.raise(opts.id))
        end,
        custom_filter = function(buf_number, _)
            -- filter out by buffer name
            if vim.fn.bufname(buf_number) ~= "" then
                return true
            end
            return false
        end,
        custom_areas = {
            right = function()
                local result = {}
                local seve = vim.diagnostic.severity
                local error = #vim.diagnostic.get(0, { severity = seve.ERROR })
                local warn = #vim.diagnostic.get(0, { severity = seve.WARN })
                local info = #vim.diagnostic.get(0, { severity = seve.INFO })
                local hint = #vim.diagnostic.get(0, { severity = seve.HINT })

                local error_text = ""
                if error ~= 0 then error_text = "  " .. error .. " " end
                table.insert(result, { text = error_text, fg = "#EC5241" })

                local warn_text = ""
                if warn ~= 0 then warn_text = "  " .. warn .. " " end
                table.insert(result, { text = warn_text, fg = "#EFB839" })

                local hint_text = ""
                if hint ~= 0 then hint_text = "  " .. hint .. " " end
                table.insert(result, { text = hint_text , fg = "#A3BA5E" })


                local info_text = ""
                if info ~= 0 then info_text = "  " .. info .. " " end
                table.insert(result, { text = info_text, fg = "#7EA9A7" })

                return result
            end,
        }
    }
}
