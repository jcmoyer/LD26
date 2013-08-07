local gamecontext = {}
local mt = { __index = gamecontext }

local setmetatable = setmetatable

function gamecontext.new()
  local instance = {}
  local vartable = {}
  -- do nothing by default
  function instance.showMessage(text, duration)
  end
  function instance.changeWorld(name, x)
  end
  function instance.addPortal(name, x, d, dx, silent)
  end
  function instance.removePortal(name)
  end
  function instance.addRegion(name, x, width)
  end
  function instance.y(x)
  end
  function instance.preferredColor()
  end
  function instance.getSwitchStatus(name)
  end
  function instance.setSwitchStatus(name, status)
  end
  function instance.getCounterValue(name)
  end
  function instance.win(text)
  end
  function instance.playSwitchSound()
  end
  function instance.playSound(name)
  end
  function instance.shakeCamera(d, m)
  end
  function instance.playerX()
  end
  function instance.left()
  end
  function instance.right()
  end
  function instance.setBackground(rgb)
  end
  function instance.setForeground(rgb)
  end
  function instance.getVar(name)
    return vartable[name]
  end
  function instance.setVar(name, value)
    vartable[name] = value
  end
  return setmetatable(instance, mt)
end

return gamecontext
