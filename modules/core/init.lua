local messages = require "messages"

local captures = {
  reboot = "reboot",
  restart = "reboot",
  shutdown = "shutdown",
  ["shut down"] = "shutdown",
  ["shut-down"] = "shutdown"
}

---@class core_module: module
local core = {}

---@type module_runner
function core.run(capture, message, rude, command_position, queue_length)
  if captures[capture] then
    ---@TODO implement globals for say and whatnot
    say(messages.generate(captures[capture] == "shutdown", rude))
    os[captures[capture]]()
  end
end

---@type module_tester
function core.test(message)

  return 0
end

return core
