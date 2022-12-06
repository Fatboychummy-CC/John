local expect = require "cc.expect".expect

local running_directory = fs.getDir(shell.getRunningProgram())

package.path = package.path .. ";lib/?.lua;lib/?/init.lua"
require "john_globals" -- initialize the `john` global variable.

---@class module_handler Handles module interactions.
---@field tasks {[integer]:fun()} The loaded tasks.
---@field modules {[string]:specced_module} The loaded module identifiers and names.
local module_handler = {
  tasks = {},
  modules = {},
}

--- Runs all the tasks that have been loaded.
function module_handler.run()
  ---@TODO The coroutine handling code
end

--- Load a single module.
---@param name string The name of the module to be loaded.
---@return boolean loaded If the module was loaded.
---@return string? error If the module failed to load, return friendly reason why.
---@return string? more_info More information about the error, if there is any.
function module_handler.load_module(name)
  expect(1, name, "string")

  local folder = fs.combine(running_directory, name)
  local require_string = string.format("modules.%s", name)

  -- Ensure the expected files exist.
  if not fs.isDir(folder) then
    return false, string.format("Could not find folder '%s'", folder)
  end
  if not fs.exists(fs.combine(folder, "spec.lua")) then
    return false, "Spec does not exist in folder."
  end

  ---@type specced_module
  local module_data = { active = true }

  -- Temporarily overwrite the package path.
  local old_path = package.path
  package.path = string.format(
    "%s;/%s/?.lua;/%s/?/init.lua",
    package.path,
    folder,
    folder
  )

  -- Try to load the module
  local ok, loaded_module = pcall(require, require_string)
  package.path = old_path -- revert package path.
  if not ok then
    return false, "Failed to require module.", loaded_module
  end

  -- Pass the module handler to the core module.
  if name == "core" then
    loaded_module.handler = module_handler
  end

  module_data.module = loaded_module

  -- Try to load the spec
  local ok, loaded_spec = pcall(require, string.format("%s.spec", require_string))
  if not ok then
    return false, "Failed to require module spec", loaded_spec
  end
  module_data.spec = loaded_spec

  -- Module loaded, store it.
  module_handler.modules[name] = module_data

  return true
end

--- Returns a list of the modules available.
---@return {[integer]:{[1]:module_identifier,[2]:module_name}}
function module_handler.list_modules()
  local data = {} ---@type {[integer]:{[1]:module_identifier,[2]:module_name}}

  for identifier, module_data in pairs(module_handler.modules) do
    data[#data + 1] = { identifier, module_data.spec.name }
  end

  return data
end

return module_handler
