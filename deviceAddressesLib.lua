-- Definitions

-- Module
local devices = {}

-- Dynamic address table
local dynamic_project_devices = storage.get('dynamic_project_device_list') or {}

-- Static address table
local static_project_devices = storage.get('static_project_device_list') or {}


-- Definitions
-- ---------------------------------------------------------------------------------
-- Static

-- Getter function for a inital device list
function devices.get_static_list(project)
    return static_project_devices[project]
end

-- Creates or updates a static device lsit
function devices.add_static_list(project, list)
    
    if not static_project_devices[project] then
        static_project_devices[project] = {}
    end

    for i, addr in ipairs(list) do
        if not findIndex(static_project_devices[project], addr) then
            table.insert(static_project_devices[project], addr)
        end
    end

    storage.set('static_project_device_list', static_project_devices)

end

-- Deletes a static device list if it exists
function devices.clear_static_list(project)
    
    if static_project_devices[project] then

        static_project_devices[project] = nil
        storage.set('static_project_device_list', static_project_devices)
       
    end

end

-- Static
-- ---------------------------------------------------------------------------------
-- Utility functions


-- Pings addresses from a static project device list and returns / stores the results
function devices.ping(project)

    if not static_project_devices[project] then
        log('Error, there is no static device list called: ' .. project)
        return nil
    end

    local newProjectName = project .. '_pinged'

    if not dynamic_project_devices[newProjectName] then
        dynamic_project_devices[newProjectName] = {}
    end

    for i, addr in ipairs(get_static_list(project)) do
        local result = knxlib.ping(addr)

        if result == true then
            table.insert(dynamic_project_devices[newProjectName], addr)
        end

        os.sleep(3)
    
    end

    if #dynamic_project_devices[newProjectName] > 0 then

        storage.set('dynamic_project_device_list', dynamic_project_devices)
        return dynamic_project_devices[newProjectName]

    else

        return nil

    end


end


-- Restarts every device in the choosen dynamic device list and returns either nil (When project doesn't exist), false (If 1 or more device didn't restart) or true (If every device was restarted)
function devices.restart(project)
    local failedAttempts = {}
    
    if not dynamic_project_devices[project] then
        return nil
    end

    for i, addr in ipairs(dynamic_project_devices[project]) do
        local result = knxlib.restart(addr)

        if result == false then
            table.insert(failedAttempts, addr)
        end

        os.sleep(3)

    end

    if #failedAttempts > 0 then
        return false
    end

    return true

end


-- Find index of specified value in a list
local function findIndex(list, value)

    for i, v in ipairs(list) do
        
        if v == value then
            return i
        end

    end

    return nil

end



-- Scans every possible address and adds every successfull ping to list and then stores it locally
-- NOTE: The os.sleep time alone is almost 54 hours, so make sure this is the only logic executed in a script when used.

function devices.scan_all_devices()
    
    local project_names = {
        area_0 = {},
        area_1 = {},
        area_2 = {},
        area_3 = {},
        area_4 = {},
        area_5 = {},
        area_6 = {},
        area_7 = {},
        area_8 = {},
        area_9 = {},
        area_10 = {},
        area_11 = {},
        area_12 = {},
        area_13 = {},
        area_14 = {},
        area_15 = {}

    }

    for i = 0, 15 do -- For each Area

        local area = project_names[i]

        for line = 0, 15 do -- For each line

            for device = 0, 255 do -- For each device

                local address = i .. '.' .. line .. '.' .. device

                local result = knxlib.ping(address)

                if result then
                    table.insert(area, address)
                end

                os.sleep(3)

            end
        end
    end


    for key, project in pairs(project_names) do
        
        if #project > 0 then
            local projectName = key .. '_pinged'
            
            devices.add_list(projectName, project)

        end

    end


end

-- Converts a 4 byte UINT value to a KNX device address.
function devices.byte4_uint_to_address(value)

    local stringValue = tostring(value)

    -- Adjusting the length of each address component by -1 because I'm stupid
    local mainLength, lineLength, deviceLength = tonumber(string.sub(stringValue, -3, -3)) - 1, tonumber(string.sub(stringValue, -2, -2)) - 1, tonumber(string.sub(stringValue, -1, -1)) - 1


    local totalLength = mainLength + lineLength + deviceLength + 3 -- Adding back the 3 that I removed in the previous step, because again I'm stupid.

    local addressPart = string.sub(stringValue, 1, -4) -- Removing the length components
    
    local mainStart = 1
    local mainEnd = mainStart + mainLength

    local lineStart = mainEnd + 1
    local lineEnd = lineStart + lineLength

    local deviceStart = lineEnd + 1
    local deviceEnd = deviceStart + deviceLength

    local main, line, device = string.sub(addressPart, mainStart, mainEnd), string.sub(addressPart, lineStart, lineEnd), string.sub(addressPart, deviceStart, deviceEnd)

    local addressLength = string.len(main) + string.len(line) + string.len(device)

    if addressLength < totalLength then
        main, line, device =  '0', string.sub(addressPart, lineStart - 1, lineEnd -1), string.sub(addressPart, deviceStart - 1, deviceEnd - 1)
    end

    if tonumber(main) > 15 or tonumber(line) > 15 or tonumber(device) > 255 then
        return nil
    end

    return main .. '.' .. line .. '.' .. device

end

-- Utility functions
-- ---------------------------------------------------------------------------------
-- Dynamic

-- Gets a list of projects
function devices.get_dynamic_projects()

    local keys = {}

    for project in pairs(dynamic_project_devices) do
        table.insert(keys, project)
    end

    return keys

end

-- Clears all stored dynamic project device list data (Use carefully)
function devices.clear_all_dynamic_data()

    for i, project in ipairs(dynamic_project_devices) do
        dynamic_project_devices[project] = nil
    end

    storage.set('dynamic_project_device_list', dynamic_project_devices)

end

-- Clears project specific device list data
function devices.clear_dynamic_data(project)

    if dynamic_project_devices[project] then

        dynamic_project_devices[project] = nil
        storage.set('dynamic_project_device_list', dynamic_project_devices)
       
    end

end

-- Checks if a device address exists in a project
function devices.dynamic_exists(project, address)
    local list = dynamic_project_devices[project]

    if not list then
        return false
    end

    return findIndex(list, address) ~= nil

end

-- Checks if specified project exists
function devices.dynamic_project_exists(project)
    if dynamic_project_devices[project] then
        return true
    end

    return false
end

-- Add a single device address to a project device list
function devices.add_dynamic_address(project, address)
    if not dynamic_project_devices[project] then
        dynamic_project_devices[project] = {}
    end

    if not findIndex(dynamic_project_devices[project], address) then

        table.insert(dynamic_project_devices[project], address)
        storage.set('dynamic_project_device_list', dynamic_project_devices)

    end

end

-- Removes a single device address from a project device list
function devices.remove_dynamic_address(project, address)
    if dynamic_project_devices[project] then
        local index = findIndex(dynamic_project_devices[project], address)
        if index then
            table.remove(dynamic_project_devices[project], index)
        end
    end
end

-- Add a list of addresses to a project device list
function devices.add_dynamic_list(project, list)
    if not dynamic_project_devices[project] then
        dynamic_project_devices[project] = {}
    end

    for i, addr in ipairs(list) do
        if not findIndex(dynamic_project_devices[project], addr) then
            table.insert(dynamic_project_devices[project], addr)
        end
    end

    storage.set('dynamic_project_device_list', dynamic_project_devices)
end

-- Get list of device addresses from a dynamic project device list
function devices.get_dynamic_list(project)
    return dynamic_project_devices[project]
end


-- Dynamic
-- ---------------------------------------------------------------------------------
-- Returning the module


return devices