---@class ap_chat_compat: chat_compat
local chat = { silent = false }

---@type chat_compat_setup
function chat.setup()
  local chatbox = peripheral.find("chatBox")

  if not chatbox then
    return false, "No Advanced Peripherals chatbox found."
  end

  chat.wrap = chatbox

  return true
end

---@type chat_compat_say
function chat.say(message, player_name)
  if chat.silent then
    return chat.tell(message, player_name)
  end
  chat.wrap.sendMessage(message, "<John> ")
end

---@type chat_compat_tell
function chat.tell(message, player_name)
  chat.wrap.sendMessageToPlayer(message, player_name, "<John> ")
end

---@type chat_compat_listen
function chat.listen()
  local username, message = os.pullEvent "chat"

  return username, message
end

---@type chat_compat_silence
function chat.silence(silence)
  chat.silent = silence
end

return chat
