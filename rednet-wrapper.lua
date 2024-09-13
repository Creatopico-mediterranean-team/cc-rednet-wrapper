local Wrapper = {}
Wrapper.regs = {}
Wrapper.regs.params = {}
Wrapper.regs.functions = {}

function Wrapper.regs:init(name, protocol)  
  Wrapper.protocol = protocol
  Wrapper.host = name
  rednet.host(protocol, name)
end

function getArgs(fun)
  local args = {}
  local hook = debug.gethook()

  local argHook = function( ... )
    local info = debug.getinfo(3)
    if 'pcall' ~= info.name then return end

    for i = 1, math.huge do
      local name, value = debug.getlocal(2, i)
      if '(*temporary)' == name then
        debug.sethook(hook)
        error('')
        return
      end
      table.insert(args,name)
    end
  end

  debug.sethook(argHook, "c")
  pcall(fun)
  
  return args
end


function Wrapper:host()
  return Wrapper.regs
end


function Wrapper:client(name, protocol)

end


function check_param_length(def, inp)
  return #def == #inp
end


function Wrapper:register(name, func)
  Wrapper.regs.functions[name] = func
  Wrapper.regs["params"][name] = {}
  Wrapper.regs["params"][name] = getArgs(func)

  Wrapper.regs[name] = (
    function (...)
      if #Wrapper.regs["params"][name] == select('#', ...) then
        local message = {}
        message.wrapper_package = {}
        message.wrapper_package[name] = {}
        for i, param_name in pairs(Wrapper.regs["params"][name]) do
          message.wrapper_package[name][param_name] = select(i,...)
        end
        rednet.broadcast(message, Wrapper.protocol)
      end 
    end
  )
  print("New wrapper registered="..name)
end


return Wrapper