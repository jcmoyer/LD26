local extensions = {}

function extensions.lerp(v0, v1, t)
  return v0 + (v1 - v0) * t
end

function extensions.clamp(x, min, max)
  if x < min then return min end
  if x > max then return max end
  return x
end

function extensions.install()
  local target = math
  if not target then
    error('no global table named "math" to install to')
  end
  for k,v in pairs(extensions) do
    if target[k] then
      error('(math) duplicate key: "' .. k .. '"')
    end
    if k ~= 'install' then
      target[k] = v
    end
  end
end

return extensions
