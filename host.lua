local protocol = "mediterranean-team-test"
local host_name = "ligr_host"
local host = rednet.host(protocol, host_name)

local message = {}
message.coords = {}
message.coords.x = 100
message.coords.y = 200
message.coords.z = 300

repeat
    print(textutils.serialise(message))
    rednet.broadcast(coords, protocol)
    sleep(1)
until false