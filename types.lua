---@meta

---@alias tokenised {[integer]:token}

---@alias token string A single part of a command, like a word.

---@alias pattern string A lua pattern.

---@class module
---@field task fun()? If the module requires something to constantly run, lob it here.
---@field task_error string? If the module has a task and throws an error, this will be sent to the user.
local module = {}

--- Main runner function for modules.
---@param capture pattern The pattern that was captured and used to run this.
---@param message tokenised The tokenised input from the user.
---@param rude boolean Whether or not the user was 'rude'
---@param command_position integer? The position in the command queue that this command is at.
---@param queue_length integer? The length of the command queue.
function module.run(capture, message, rude, command_position, queue_length) end

---@alias module_runner fun(capture:string, message:tokenised, rude:boolean, command_position:integer?, queue_length:integer?)

--- Test if this module is the module that should be run
---@param message tokenised The tokenised input from the user.
---@return integer sureness How sure the module is that this module should be selected.
function module.test(message) return 0 end

---@alias module_tester fun(message:tokenised):integer

---@class module_spec
---@field commands {[integer]:pattern} The patterns that this module listens for.
---@field name string The friendly name of this module.
---@field description string The description of this module.

---@alias specced_module {spec:module_spec,module:module,active:boolean} A specced module.

---@alias module_identifier string The identifier of the module
---@alias module_name string The name of the module

---@class chat_compat Compatability module for chat system
---@field setup fun(): ok:boolean, error_message:string? Setup the chat system.
---@field say fun(message:string, player_name:string) Say something to the user. Should follow silence rules (call tell instead)
---@field tell fun(message:string, player_name:string) Tell something to the user.
---@field listen fun(): username:string, message:string Return a message from the user.
---@field silence fun(silence:boolean) Silence the system.
---@field silent boolean If the system is silenced.
---@field prefix string The prefix set by the system. This will be set directly after `setup()` is called, but before any messages are parsed.

---@alias chat_compat_setup fun(): ok:boolean, error_message:string? Setup the chat system.
---@alias chat_compat_say fun(message:string, player_name:string) Say something to the user. Should follow silence rules (call tell instead)
---@alias chat_compat_tell fun(message:string, player_name:string) Tell something to the user.
---@alias chat_compat_listen fun(): username:string, message:string Return a message from the user.
---@alias chat_compat_silence fun(silence:boolean) Silence the system.
