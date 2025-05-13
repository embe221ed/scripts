-- config
vim.fn.sign_define('DapBreakpoint', { text='●', texthl='DapBreakpoint', numhl='DapBreakpoint' })

require('editor.dev.dap.adapters')
require('editor.dev.dap.configs')

require('dapui').setup()
