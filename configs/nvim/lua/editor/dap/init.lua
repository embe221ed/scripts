-- config
vim.fn.sign_define('DapBreakpoint', { text='●', texthl='DapBreakpoint', numhl='DapBreakpoint' })

require('editor.dap.adapters')
require('editor.dap.configs')

require('dapui').setup()
