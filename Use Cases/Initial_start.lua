-- Adds a list a list to a project called my_project in the static_project_devices list and stores it locally.

devices = require('user.deviceAddressesLib')

local static_project_name = 'my_project'

local list = {}

-- Creates a address list for area 5, containing: line 0-10, devices 0-255
for line = 0, 10 do
    for device = 0, 255 do
        table.insert(list, '5.' .. line .. '.' .. device)
    end
end

devices.add_static_list(static_project_name, list)