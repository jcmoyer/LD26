local gamecontext = {}

function gamecontext.new()
  local instance = {}
  -- do nothing by default
  function instance.showMessage(text, duration)
  end
  function instance.changeWorld(name, x)
  end
  return setmetatable(instance, { __index = gamecontext })
end

return gamecontext
