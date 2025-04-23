# Device addresses library

**This library contains functions and maps for KNX devices**

### Definations

  <h6>static_project_devices:</h6> List of initial projects containing KNX Device Addresses.
  <h6>dynamic_project_devices:</h6> List of added projects containing KNX Device Addresses.

## List of functions:
### Utility functions:
___

<a name="scan_all_hdr"></a><h4>- [devices.scan_all_devices() => void](/README.md#scan_all)</h4>

  <p>Iterates through every valid KNX device address with 3 seconds intervals and pings it.<br>
  If there is a response, it's saved to a list and then stored.<br>The 3 second delay is choosen in order to decrease the load on the KNX bus, the bus load increases by about 8% while the scan is active.<br><br>
  
  Can be used to initialize the static_project_devices list.<br><br>

  **NOTE:** The total elapsed time between each ping alone is almost **54 hours**.
  Because of this, it's recommended to create a separate script for this function alone.</p>
___

<a name="convert_hdr"></a><h4>- [devices.byte4_uint_to_address(value) (4 byte UINT) => string / nil](/README.md#convert)</h4>

  <p>Takes 1 parameter (4 byte UNIT) and converts it into a valid KNX Device Address or nil (if the KNX Device Address is invalid).<br>
  The last 3 digits is used to specify how many digits there are for each address component (Area/Line/Device).<br><br>
  This function is meant to be used in a Event-based script, so that you can write the address value to an group address which will trigger the script.<br>
  For readability I recommend writing the address value as such: 15 15 255 2 2 3, instead of: 15152552223. ETS will automatically format the value.</p>
___

<a name="ping_hdr"></a><h4>- [devices.ping(project) (string) =>  table(string)](/README.md#ping)</h4>

  Pings every address from the choosen static project.
  Every successfull ping is added to a list.
  The list is saved as \<project\>_pinged.
  The list is also returned as a result.
___

<a name="restart_hdr"></a><h4>- [devices.restart(project) (string) => nil / boolean](/README.md#restart)</h4>

  Restarts every device in the choosen dynamic device list and returns either:<br>
  <p>
    <ul>
      <li>
        nil, if the project doesn't exist,
      </li>
      <li>
        false, if 1 or more device didn't restart
      </li>
      <li>
        true, if every device was restarted
      </li>
    </ul>
  </p>

### Static functions:
___

<a name="get_static_hdr"></a><h4>- [devices.get_static_list(project) (string) => table(string) / nil](/README.md#get_static)</h4>
  Takes 1 parameter (project name) and returns either a static list of device addresses or nil.
  
___
<a name="add_static_hdr"></a><h4>- [devices.add_static_list(project, list) (string, table(string)) => void](/README.md#add_static)</h4>
  Takes 2 parameters (project name, device address list) and creates / updates a static device list.
___
<a name="clear_static_hdr"></a><h4>- [devices.clear_static_list(project) (string) => void](/README.md#clear_static)</h4>
  Takes 1 parameter (project name) and removes that project from the static device list.

### Dynamic functions:
___
<a name="get_dynamic_hdr"></a><h4>- [devices.get_dynamic_projects() => table(string)](/README.md#get_dynamic)</h4>
  Returns a list containing every project in the dynamic device list.
___
<a name="chk_dynamic_prj_hdr"></a><h4>- [devices.dynamic_project_exists(project) (string) => boolean](/README.md#chk_dynamic_prj)</h4>
  Takes 1 parameter (project name) and returns a boolean based on if the project exists.
___
<a name="add_dynamic_adr_hdr"></a><h4>- [devices.add_dynamic_address(project, address) (string, string) => void](/README.md#add_dynamic_adr)</h4>
  Takes 2 parameters (project name, address).
  Creates a new project if it doesn't exist.
  Then the address is added if it doesn't already exist.
___
<a name="remove_dynamic_adr_hdr"></a><h4>- [devices.remove_dynamic_address(project, address) (string, string) => void](/README.md#remove_dynamic_adr)</h4>
  Takes 2 parameters (project name, address) and removes the address from the dynamic project list (If it exists)
___
<a name="add_dynamic_list_hdr"></a><h4>- [devices.add_dynamic_list(project, list) (string, table(string)) => void](/README.md#add_dynamic_list)</h4>
  <p>Takes 2 parameters (project name, list of addresses)<br> 
  Creates a new project if it doesn't exist.
  Then each address is added if they doesn't already exist.<p>
___

<a name="get_dynamic_list_hdr"></a><h4>- [devices.get_dynamic_list(project) (string) => table(string) / nil](/README.md#get_dynamic_list) </h4>
  Takes 1 parameter (project name) and returns either a list of dynamic device addresses or nil
___
<a name="chk_dynamic_dev_hdr"></a><h4>- [devices.dynamic_exists(project, address) (string, string) => boolean](/README.md#chk_dynamic_dev)</h4>
  Takes 2 parameters (project name, address) and returns a boolean based on if the address exists in that project.<br>
___
<a name="clear_dynamic_list_hdr"></a><h4>- [devices.clear_dynamic_data(project) (string) => void](/README.md#clear_dynamic_list)</h4>
  Takes 1 parameter (project name) and clears all addresses within that project.<br>
___
<a name="clear_all_dynamic_hdr"></a><h4>- [devices.clear_all_dynamic_data() => void](/README.md#clear_all_dynamic)</h4>
  Removes every project that isn't included in that static project list from the dynamic project list.
  Clears every address in those projects that are included in the static project list.<br>
___

## Initial Startup Guide

- [Here is a guide on how to get all of the KNX addresses from your project](./Initial%20startup%20guide.md)

## Use Cases:

- [Create a new static project list](./Use%20Cases/Initial_start.lua)

- [Add a KNX device to a dynamic project list](./Use%20Cases/Add_KNX_Address_From_Event.lua)

- [Restart devices from a dynamic device list](./Use%20Cases/Restart_Devices.lua)

## Examples:
***Required:***
  ```lua
  devices = require('user.deviceAddressesLib')
  ```

<a name="scan_all"></a><h3>[devices.scan_all_devices():](#scan_all_hdr)</h3>

___
  ```lua
  devices.scan_all_devices()
  ```

<a name="convert"></a><h4>[devices.byte4_uint_to_address(value):](/README.md#convert_hdr)</h4>

___
  ```lua
  -- You can't use whitespaces if you write the uint_addresses like this:
  local uint_address1 = 10103221
  local uint_address2 = 1515255223
  local uint_address3 = 0150112

  log(devices.byte4_uint_to_address(uint_address1))
  log(devices.byte4_uint_to_address(uint_address2))
  log(devices.byte4_uint_to_address(uint_address3))

  -- From a Event trigger:
  local unint_address = event.getvalue() -- Inputted value in ETS: 3 10 80 1 2 2, formatted value: 31080122
  local knxAddress = devices.byte4_uint_to_address(unint_address)

  log(knxAddress)

  devices.add_address('test', knxAddress)

  ```

  <h6>Note:</h6>
    
    uint_address1 (10 10 3 2 2 1): 
    2 2 1 specifies that: 
    The main component has 2 digits (10),
    the line component has 2 digits (10)
    and the device component has 1 digit (3)

    uint_address2 (15 15 255 2 2 3):
    2 2 3 specifies that:
    The main component has 2 digits (15),
    the line component has 2 digits (15)
    and the device component has 3 digits (255)

    uint_address3 (0 1 50 1 1 2):
    1 1 2 specifies that:
    The main component has 1 digit (0),
    the line component has 1 digit (1)
    and the device component has 2 digits (50)

    uint_address (3 10 80 1 2 2):
    1 2 2 specifies that:
    The main component has 1 digit (3),
    the line component has 2 digits (10)
    and the device component has 2 digits (80)

  <h6>Output:</h6>

    10.10.3
    15.15.255
    0.1.50
    3.10.80

<a name="ping"></a><h4>[devices.ping(project):](/README.md#ping_hdr)</h4>

___
  ```lua
  project = 'project2'
  addresses = devices.ping(project)

  if addresses then
    log(addresses)
  end
  ```

<h6>Output:</h6>
    
    '2.0.0',
    '2.1.0',
    '2.2.0'

<a name="restart"></a><h4>[devices.restart(project):](/README.md#restart_hdr)</h4>

___
  ```lua
  project = 'project2_pinged'
  result = devices.restart(project)

  if not result then
    log('Error, project doesnt exist')
  elseif result == true then
    log('All devices have been restarted')
  else
    log('Error, failed to restart some devices')
  end
  ```

<h6>Output:</h6>

    'Error, project doesn't exist' or
    'All devices have been restarted' or
    'Error, failed to restart some devices'

<a name="get_static"></a><h4>[devices.get_static_list(project):](/README.md#get_static_hdr)</h4>
  
  <h6>Static projects</h6>

    'project1' = {
      '1.0.0',
      '1.1.0',
      '1.2.0'
    },
    'project2' = {
      '2.0.0',
      '2.1.0',
      '2.2.0'
    },
    'project3' = {
      '3.0.0',
      '3.1.0',
      '3.2.0'
    }
    

  ```lua
  local static_project_1 = devices.get_static_list('project1')
  log(static_project_1)
  ```

  <h6>Output</h6>
    
    '1.0.0',
    '1.1.0',
    '1.2.0'

<a name="add_static"></a><h4>[devices.add_static_list(project, list):](/README.md#add_static_hdr)</h4>
  
  ```lua
  local projectName = 'project7'
  local deviceList = {}

  for i = 0, 2 do
    for j = 0, 10 do
        table.insert(deviceList, '7.' .. i .. '.' .. j)
    end
  end

  devices.add_static_list(projectName, deviceList)

  log(devices.get_static_list(projectName))

  ```

  <h6>Output:</h6>
    
    '7.0.0',
    '7.0.1',
    '7.0.2',
    '7.0.3',
    '7.0.4',
    '7.0.5',
    '7.0.6',
    '7.0.7',
    '7.0.8',
    '7.0.9',
    '7.0.10',
    '7.1.0',
    '7.1.1',
    '7.1.2',
    '7.1.3',
    '7.1.4',
    '7.1.5',
    '7.1.6',
    '7.1.7',
    '7.1.8',
    '7.1.9',
    '7.1.10',
    '7.2.0',
    '7.2.1',
    '7.2.2',
    '7.2.3',
    '7.2.4',
    '7.2.5',
    '7.2.6',
    '7.2.7',
    '7.2.8',
    '7.2.9',
    '7.2.10'

<a name="clear_static"></a><h4>[devices.clear_static_list(project):](/README.md#clear_static_hdr)</h4>
  
  ```lua
  local projectName = 'project7'
  devices.clear_static_list(projectName)

  log(devices.get_static_list(projectName))

  ```

  <h6>Output:</h6>

    nil

<a name="get_dynamic"></a><h4>[devices.get_dynamic_projects():](/README.md#get_dynamic_hdr)</h4>

___
  ```lua
  
  projects = devices.get_dynamic_projects()
  log(projects)
  ```
          
  <h6>Output:</h6>
      
    'project1',
    'project2',
    'project3',
    'project4',
    'project5',
    'project6'

<a name="chk_dynamic_prj"></a><h4>[devices.dynamic_project_exists():](/README.md#chk_dynamic_prj_hdr)</h4>

___
  ```lua
  myProject1 = 'project1'
  myProject2 = 'Test'

  log(devices.dynamic_project_exists(myProject1))
  log(devices.dynamic_project_exists(myProject2))
  ```

  <h6>Output:</h6>

    true
    false

<a name="add_dynamic_adr"></a><h4>[devices.add_dynamic_address():](/README.md#add_dynamic_adr_hdr)</h4>

___
  ```lua
  project = 'project2'
  address = '5.0.10'

  devices.add_dynamic_address(project, address)
  ```

<a name="remove_dynamic_adr"></a><h4>[devices.remove_dynamic_address():](/README.md#remove_dynamic_adr_hdr)</h4>

___
  ```lua
  project = 'project2'
  address = '5.0.10'

  devices.remove_dynamic_address(project, address)
  ```

<a name="add_dynamic_list"></a><h4>[devices.add_dynamic_list():](/README.md#add_dynamic_list_hdr)</h4>

___
  ```lua
  project = 'project2'  
  listOfAddresses = {
    '5.0.10',
    '5.0.11',
    '5.0.12',
    '5.0.13'
  }

  devices.add_dynamic_list(project, listOfAddresses)
  ```

<a name="get_dynamic_list"></a><h4>[devices.get_dynamic_list():](/README.md#get_dynamic_list_hdr)</h4>

___
  ```lua
  project = 'project2'
  listOfAddresses = get_dynamic_list(project)

  log(listOfAddresses)
  ```

<h6>Output</h6>

    '5.0.0',
    '5.0.5',
    '5.0.6',
    '5.0.1',
    '5.0.2',
    '5.0.3',
    '5.0.7',
    '5.0.8',
    '5.0.9',
    '5.0.10',
    '5.0.11',
    '5.0.12',
    '5.0.13'

<a name="chk_dynamic_dev"></a><h4>[devices.dynamic_exists():](/README.md#chk_dynamic_dev_hdr)</h4>

___
  ```lua
  projectName1 = 'project1'
  projectName1 = 'Test'
  
  deviceAddress1 = '1.1.0'
  deviceAddress2 = '20.1.0'

  log(devices.dynamic_exists(projectName1, deviceAddress1))
  log(devices.dynamic_exists(projectName1, deviceAddress2))
  log(devices.dynamic_exists(projectName2, deviceAddress1))
  log(devices.dynamic_exists(projectName2, deviceAddress2))
  ```
    
  <h6>Output:</h6>

    true
    false
    false
    false

<a name="clear_dynamic_list"></a><h4>[devices.clear_dynamic_data():](/README.md#clear_dynamic_list_hdr)</h4>

___
  ```lua
  project = 'project1'
  devices.clear_dynamic_data(project)
  ```

<a name="clear_all_dynamic"></a><h4>[devices.clear_all_dynamic_data():](/README.md#clear_all_dynamic_hdr)</h4>

___
  ```lua
  devices.clear_all_dynamic_data()
  ```
