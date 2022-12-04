---@meta

---@alias tokenised {[integer]:token}

---@alias token string A single part of a command, like a word.

---@alias pattern string A lua pattern.

---@class module
---@field task fun()? If the module requires something to constantly run, lob it here.
---@field task_error string? If the module has a task and throws an error, this will be sent to the user.
local module = {}

--- Main runner function for modules.
---@param message tokenised The tokenised input from the user.
---@param rude boolean Whether or not the user was 'rude'
---@param command_position integer? The position in the command queue that this command is at.
---@param queue_length integer? The length of the command queue.
function module.run(message, rude, command_position, queue_length) end

--- Test if this module is the module that should be run
---@param message tokenised The tokenised input from the user.
---@return integer sureness How sure the module is that this module should be selected.
function module.test(message) return 0 end

---@class module_spec
---@field commands {[integer]:pattern} The patterns that this module listens for.
---@field name string The friendly name of this module.
---@field identifier string The identifier of this module.
---@field description string The description of this module.

---@alias specced_module {spec:module_spec,module:module} A specced module.
