local compatabilities = fs.list(fs.combine(
  fs.getDir(shell.getRunningProgram()),
  "lib/john_globals/chat_compat"
))

local issues = {}

for _, compat in ipairs(compatabilities) do
  local module = require("john_globals.chat_compat." .. compat)

  local ok, err = module.setup()

  if ok then
    return module
  else
    table.insert(issues, err)
  end
end

error(string.format("Failed to start chat module:\n%s", table.concat(issues, "\n")))
