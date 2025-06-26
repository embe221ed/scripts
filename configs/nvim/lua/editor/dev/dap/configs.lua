local function ui_select_sync(items, opts)
  local co = coroutine.running()

  vim.ui.select(items, opts, function(choice)
    coroutine.resume(co, choice)
  end)

  return coroutine.yield()
end

local dap = require('dap')

-- python
dap.configurations.python = {
  {
    -- The first three options are required by nvim-dap
    type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = 'launch';
    name = "Launch file";

    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
    program = "${file}"; -- This configuration will launch the current file if used.
    pythonPath = function()
      -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
      -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
      -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
      local cwd = vim.fn.getcwd()
      if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
        return cwd .. '/venv/bin/python3'
      elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
        return cwd .. '/.venv/bin/python3'
      else
        return '/usr/bin/python3'
      end
    end;
  },
}

-- Rust
dap.configurations.rust = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      -- Get metadata (includes target_directory)
      local metadata_output = vim.fn.system("cargo metadata --format-version=1 --no-deps")

      if vim.v.shell_error ~= 0 then
        error("Failed to get cargo metadata")
      end

      local metadata = vim.fn.json_decode(metadata_output)
      local target_dir = metadata.target_directory

      -- Find binary targets
      local binaries = {}
      for _, package in ipairs(metadata.packages) do
        for _, target in ipairs(package.targets) do
          if vim.tbl_contains(target.kind, "bin") then
            table.insert(binaries, target.name)
          end
        end
      end

      -- Select binary
      local binary_name
      if #binaries == 0 then
        error("No binary targets found")
      elseif #binaries == 1 then
        binary_name = binaries[1]
      else
        binary_name = ui_select_sync(
          binaries,
          {
            prompt = "Select binary:",
            format_item = function(item) return item end,
          }
        )
      end

      -- Use target_directory from metadata
      local profile = vim.fn.input('Profile (debug/release): ', 'debug')
      local binary_path = target_dir .. "/" .. profile .. "/" .. binary_name

      return binary_path
    end,
    args = function()
      local args_string = vim.fn.input('Program arguments: ')
      return args_string == "" and {} or vim.split(args_string, " ")
    end,
    cwd = function()
      local metadata = vim.fn.json_decode(vim.fn.system("cargo metadata --format-version=1 --no-deps"))

      local options = {
        { name = "Current directory", path = vim.fn.getcwd() },
        { name = "Project root", path = metadata.workspace_root },
        { name = "Binary location", path = metadata.target_directory .. "/debug" },
        { name = "Custom path", path = nil }
      }

      local selected = ui_select_sync(
        options,
        {
          prompt = "Select working directory:",
          format_item = function(item)
            return item.name .. " (" .. (item.path or "custom") .. ")"
          end,
        }
      )

      if selected.path then
        return selected.path
      else
        -- Custom path
        return vim.fn.input('Custom directory: ', vim.fn.getcwd(), 'dir')
      end
    end,
    stopOnEntry = false,
  },
}
