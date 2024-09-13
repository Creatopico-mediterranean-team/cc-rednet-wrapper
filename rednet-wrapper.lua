local Wrapper = {}
Wrapper.rednet = {}
Wrapper.rpc_call = {}
Wrapper.regs = {}
Wrapper.regs.params = {}
Wrapper.regs.functions = {}


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


function Wrapper:host(protocol, name)
  Wrapper.rednet.protocol = protocol
  Wrapper.rednet.name = name
  return Wrapper.rpc_call
end


function Wrapper:client(protocol, name)
  Wrapper.rednet.protocol = protocol
  Wrapper.rednet.name = name
  rednet.host(protocol, name)
end


function call_reg_func(name, ...)
  if #Wrapper.regs["params"][name] == select('#', ...) then
    local message = {}
    message.rpc = {}
    message.rpc[name] = {}
    for i, param_name in pairs(Wrapper.regs["params"][name]) do
      message.rpc[name][param_name] = select(i,...)
    end
    rednet.broadcast(message, Wrapper.rednet.protocol)
    print("call func name = "..name)
    print(textutils.serialise(message))
  end 
end


function Wrapper:register(name, func)
  Wrapper.regs.functions[name] = func
  Wrapper.regs["params"][name] = getArgs(func)

  Wrapper.rpc_call[name] = (
    function (...) 
      call_reg_func(name, ...)
    end
  )
  print("New wrapper registered="..name)
end


return Wrapper