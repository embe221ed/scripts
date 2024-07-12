local function determine_theme()
  local dark, light = "frappe", "latte"
  local out = os.execute("/opt/scripts/utils/determine_system.sh")
  -- not Darwin (MacOS), early return
  if out ~= 1 then return dark end
  local result = os.execute("defaults read -g AppleInterfaceStyle &> /dev/null")
  if result == 256 then
    return light
  else
    return dark
  end
end

local globals = {
  current_theme = determine_theme(),
}

return globals
