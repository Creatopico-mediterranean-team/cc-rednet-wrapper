-- Общий код
function MyFunc(x, y, z)
end

Wrapper.register("coords", MyFunc)

-- Код хоста
Wrapper.host.coords(1, 2, 3)

-- Код клиента
-- Ничего, потому что он ждет когда ему прилетит сообщение и сам запускает функцию MyFunc, которая уже зарегана
-- То есть код клиента примерно такой

local MY_REGISTED_COMMANDS = {}
local id, message
repeat
    id, message = rednet.receive()
    if message["command"] == 'coords':
        MY_REGISTED_COMMANDS['coords'](message['param.x'], message['param.y'], message['param.z'])
until true

print(message)