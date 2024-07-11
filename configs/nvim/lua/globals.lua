local function determine_theme()
  local result = os.execute("defaults read -g AppleInterfaceStyle &> /dev/null")
  if result == 256 then
    return "latte"
  else
    return "macchiato"
    -- return "frappe"
  end
end

local globals = {
  current_theme = determine_theme(),
}

return globals
