-- Iterates through every device in a dynamic project called my_project_pinged.
-- If that project doesn't exist, it tries to ping every address in a project called my_project.
-- Then it tries to restart every address that it got a ping response from.

devices = require('user.deviceAddressesLib')

local staticProject = 'my_project'
project = staticProject .. '_pinged'

log('First restart attempt started')

result = devices.restart(project)
adresser = {}

if result == nil then
  log('Error, ' .. project .. " doesn't exist")
  
  adresser = devices.ping(staticProject)
  
  if not adresser then
    log("Error, couldn't ping any KNX devices")
  	return
  end
  
elseif result then
  log('All KNX devices has been restarted')
  return
elseif result == false then
  log("Error, there were some KNX devices that wasn't restarted")
  return
end

log('2nd restart attempt started')

result = devices.restart(project)

if not result then
  log("Error, couldn't create a new project, shutting down")
elseif result then
  log('All KNX devices has been restarted')
elseif result == false then
  log("Error, there were some KNX devices that wasn't restarted")
end