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

-- C/C++
dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    args = function()
      local args_string = vim.fn.input('Arguments: ')
      return args_string == "" and {} or vim.split(args_string, " ")
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
  {
    name = "Make and run",
    type = "codelldb",
    request = "launch",
    program = function()
      -- Build with make
      local make_target = vim.fn.input('Make target (empty for default): ')
      local make_cmd = make_target == "" and "make" or ("make " .. make_target)

      print("Building: " .. make_cmd)
      local result = vim.fn.system(make_cmd)

      if vim.v.shell_error ~= 0 then
        error("Build failed: " .. result)
      end

      -- Try to find the executable
      local executable_name = make_target == "" and vim.fn.input('Executable name: ') or make_target

      -- Common locations for make-built executables
      local possible_paths = {
        vim.fn.getcwd() .. "/" .. executable_name,
        vim.fn.getcwd() .. "/bin/" .. executable_name,
        vim.fn.getcwd() .. "/build/" .. executable_name,
        vim.fn.getcwd() .. "/out/" .. executable_name,
      }

      -- Find first existing executable
      for _, path in ipairs(possible_paths) do
        if vim.fn.executable(path) == 1 then
          print("Found executable: " .. path)
          return path
        end
      end

      -- Fallback to manual input
      return vim.fn.input('Executable path: ', vim.fn.getcwd() .. '/', 'file')
    end,
    args = function()
      local args_string = vim.fn.input('Program arguments: ')
      return args_string == "" and {} or vim.split(args_string, " ")
    end,
    -- cwd = function()
    --   return vim.fn.input('Working directory: ', vim.fn.getcwd(), 'dir')
    -- end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
  {
    name = "CMake build and run",
    type = "codelldb",
    request = "launch",
    program = function()
      -- Determine build directory
      local build_dir = vim.fn.input('Build directory: ', 'build', 'dir')
      local full_build_dir = vim.fn.getcwd() .. "/" .. build_dir

      -- Configure and build with CMake
      local config_cmd = string.format("cmake -B %s -S .", build_dir)
      local build_cmd = string.format("cmake --build %s", build_dir)

      print("Configuring: " .. config_cmd)
      local config_result = vim.fn.system(config_cmd)
      if vim.v.shell_error ~= 0 then
        error("CMake configure failed: " .. config_result)
      end

      print("Building: " .. build_cmd)
      local build_result = vim.fn.system(build_cmd)
      if vim.v.shell_error ~= 0 then
        error("CMake build failed: " .. build_result)
      end

      -- Find executables in build directory
      local find_cmd = string.format("find %s -type f -executable -not -name '*.so*' -not -name '*.a'", full_build_dir)
      local executables_output = vim.fn.system(find_cmd)
      local executables = {}

      for line in executables_output:gmatch("[^\r\n]+") do
        if line ~= "" and not line:match("CMakeFiles") then
          table.insert(executables, line)
        end
      end

      if #executables == 0 then
        return vim.fn.input('Executable path: ', full_build_dir .. '/', 'file')
      elseif #executables == 1 then
        print("Using executable: " .. executables[1])
        return executables[1]
      else
        -- Multiple executables found, let user choose
        local choices = {}
        for i, exe in ipairs(executables) do
          local basename = vim.fn.fnamemodify(exe, ':t')
          table.insert(choices, string.format("%d: %s", i, basename))
        end

        local choice = vim.fn.inputlist(vim.list_extend({"Select executable:"}, choices))
        if choice > 0 and choice <= #executables then
          return executables[choice]
        else
          error("Invalid selection")
        end
      end
    end,
    args = function()
      local args_string = vim.fn.input('Program arguments: ')
      return args_string == "" and {} or vim.split(args_string, " ")
    end,
    cwd = function()
      return vim.fn.input('Working directory: ', vim.fn.getcwd(), 'dir')
    end,
    stopOnEntry = false,
  },
  {
    name = "Build with custom command",
    type = "codelldb",
    request = "launch",
    program = function()
      -- Custom build command
      local build_cmd = vim.fn.input('Build command: ', 'gcc -g -o main main.c')

      print("Building: " .. build_cmd)
      local result = vim.fn.system(build_cmd)

      if vim.v.shell_error ~= 0 then
        error("Build failed: " .. result)
      end

      -- Try to extract executable name from build command
      local executable_name = build_cmd:match("-o%s+([%w_-]+)")
      if executable_name then
        local exe_path = vim.fn.getcwd() .. "/" .. executable_name
        if vim.fn.executable(exe_path) == 1 then
          print("Using executable: " .. exe_path)
          return exe_path
        end
      end

      -- Fallback to manual input
      return vim.fn.input('Executable path: ', vim.fn.getcwd() .. '/', 'file')
    end,
    args = function()
      local args_string = vim.fn.input('Program arguments: ')
      return args_string == "" and {} or vim.split(args_string, " ")
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
  {
    name = "Attach to process",
    type = "codelldb",
    request = "attach",
    pid = function()
      local process_name = vim.fn.input('Process name (or PID): ')

      -- If it's a number, assume it's a PID
      if process_name:match("^%d+$") then
        return tonumber(process_name)
      end

      -- Otherwise, try to find process by name
      local pgrep_cmd = "pgrep " .. process_name
      local pid_output = vim.fn.system(pgrep_cmd)

      if vim.v.shell_error == 0 then
        local pids = {}
        for line in pid_output:gmatch("[^\r\n]+") do
          if line ~= "" then
            table.insert(pids, tonumber(line))
          end
        end

        if #pids == 1 then
          return pids[1]
        elseif #pids > 1 then
          local choices = {}
          for i, pid in ipairs(pids) do
            table.insert(choices, string.format("%d: PID %d", i, pid))
          end

          local choice = vim.fn.inputlist(vim.list_extend({"Select process:"}, choices))
          if choice > 0 and choice <= #pids then
            return pids[choice]
          end
        end
      end

      error("Process not found: " .. process_name)
    end,
    cwd = '${workspaceFolder}',
  }
}

-- C uses the same configurations as C++
dap.configurations.c = dap.configurations.cpp
