---@class computronics_chat_compat: chat_compat
local chat = { silent = false }

---@type chat_compat_setup
function chat.setup()
  local chatbox = peripheral.find("chatbox")

  if not chatbox then
    return false, "No Computronics chatbox found."
  end

  chat.wrap = chatbox

  return true
end

---@type chat_compat_say
function chat.say(message, player_name)
  chat.wrap.say(message)
end

---@type chat_compat_tell
function chat.tell(message, player_name)
  chat.wrap.say(message) -- does computronics have tell?
end

---@type chat_compat_listen
function chat.listen()
  local username, message = os.pullEvent "chat_message"

  return username, message
end

---@type chat_compat_silence
function chat.silence(silence)
  chat.silent = silence
end

return chat
