local extensions = {}

local getmetatable, setmetatable, pairs = getmetatable, setmetatable, pairs

function extensions.clone(t)
  local r = {}
  for k,v in pairs(t) do
    r[k] = v
  end
  return setmetatable(r, getmetatable(t))
end

return extensions