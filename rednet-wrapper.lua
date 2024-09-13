local Wrapper = {}
Wrapper.regs = {}
Wrapper.regs.params = {}


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


function Wrapper:client()

end


function Wrapper:register(name, func)
  print("name="..name)
  print(textutils.serialise(getArgs(func)))
  Wrapper.regs[name] = func
  Wrapper.regs["params"][name] = {}
  Wrapper.regs["params"][name] = getArgs(func)
end


return Wrapper