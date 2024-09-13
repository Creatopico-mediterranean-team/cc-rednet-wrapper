local rednet_wrapper = require('rednet-wrapper')


function coords_func(x, y, z)
    print("My coords is: "..x..", "..y..", "..z..";")
end

rednet_wrapper:register("coords", coords_func)
rednet_wrapper:host():init("mediterranean-team-test", "server")

local message = {}
message.coords = {}
message.coords.x = 100
message.coords.y = 200
message.coords.z = 300

repeat
    rednet_wrapper:host().coords(1, 2, 3)
    sleep(1)
until false