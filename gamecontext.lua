local gamecontext = {}

function gamecontext.new()
  local instance = {}
  local vartable = {}
  -- do nothing by default
  function instance.showMessage(text, duration)
  end
  function instance.changeWorld(name, x)
  end
  function instance.addPortal(x, d, dx)
  end
  function instance.addRegion(name, x, w)
  end
  function instance.getVar(name)
    return vartable[name]
  end
  function instance.setVar(name, value)
    vartable[name] = value
  end
  return setmetatable(instance, { __index = gamecontext })
end

return gamecontext
