---@class plethora_chat_compat: chat_compat
local chat = { silent = false }

---@type chat_compat_setup
function chat.setup()
  local manipulators = table.pack(peripheral.find("manipulator"))

  if #manipulators == 0 then
    return false, "No Plethora manipulators found."
  end

  for i = 1, #manipulators do
    if manipulators[i].hasModule("plethora:chat") or manipulators[i].hasModule("plethora:chat_creative") then
      chat.wrap = manipulators[i]
      return true
    end
  end

  return false, "Plethora manipulators are attached, but no chat module found."
end

---@type chat_compat_say
function chat.say(message, player_name)
  if chat.silent then
    return chat.tell(message, player_name)
  end
  chat.wrap.say(message)
end

---@type chat_compat_tell
function chat.tell(message, player_name)
  chat.wrap.tell(message)
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
