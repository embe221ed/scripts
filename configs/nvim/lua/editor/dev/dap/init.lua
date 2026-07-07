-- config
vim.fn.sign_define('DapStopped',    { text='⏵', texthl='DapStopped', numhl= 'DapStopped' })
vim.fn.sign_define('DapBreakpoint', { text='●', texthl='DapBreakpoint', numhl='DapBreakpoint' })

require('editor.dev.dap.adapters')
require('editor.dev.dap.configs')

require('dapui').setup()

-- open/close the DAP UI automatically around a debug session
-- (lets nvim-dap-ui load with dap instead of at startup)
local dap, dapui = require('dap'), require('dapui')
dap.listeners.before.attach.dapui_config = function() dapui.open() end
dap.listeners.before.launch.dapui_config = function() dapui.open() end
dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
