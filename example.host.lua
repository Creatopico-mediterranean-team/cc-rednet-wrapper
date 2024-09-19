local rpc = require('rednet-wrapper')


function coords_func(x, y, z)
    print("My coords is: "..x..", "..y..", "..z..";")
end

local test_params = {100, 200, 300}

coords_func(unpack(test_params))


rpc:register("coords", coords_func)
local host = rpc:host("mediterranean-team-test", "server")

repeat
    print("Send message")
    host.coords(1, 2, 3)
    sleep(1)
until false