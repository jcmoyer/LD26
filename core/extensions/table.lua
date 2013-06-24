local extensions = {}

function extensions.clone(t)
  local r = {}
  for k,v in pairs(t) do
    r[k] = v
  end
  return setmetatable(r, getmetatable(t))
end

return extensions