---@class messages
local messages = {
  shutdown = "shutting down",
  reboot = "rebooting",
  messages = {
    [false] = {
      "Alright, %s.",
      "Okay, %s.",
      "Okie dokie, %s!",
      "Sounds good, %s.",
    },
    [true] = {
      "Wow, alright. I guess I'm %s then.",
      "Screw you too, %s.",
      "You can say things nicely you know? But alright, %s.",
      "%s."
    }
  }
}

--- Generate a new message about either shutting down or rebooting
---@param shutdown boolean If the request was to shutdown, `true`, otherwise `false`.
---@param rude boolean If the user was rude.
---@return string message The generated message.
function messages.generate(shutdown, rude)
  return string.format(
    messages.messages[rude][math.random(1, #messages.messages[rude])],
    shutdown and messages.shutdown or messages.reboot
  )
end

return messages
