-- Adds a KNX address from an event to a project in the dynamic_project_devices list and stores it locally.

devices = require('user.deviceAddressesLib')

local uintValue = event.getvalue()
local knxAddress = devices.byte4_uint_to_address(uintValue)
local result = knxlib.ping(knxAddress)

if result then
  local projectName = 'my_project'
  local projectExists = devices.dynamic_project_exists(projectName)
  
  if projectExists then
  	devices.add_dynamic_address(projectName, knxAddress)
  end
  
end