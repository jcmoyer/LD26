local switch = {}

function switch.new(name, x, ud)
  local instance = {
    name   = name,
    x      = x,
    ud     = ud,
    status = false
  }
  return setmetatable(instance, { __index = switch })
end

return switch
