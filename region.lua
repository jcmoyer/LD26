local region = {}

function region.new(name, x, w)
  local instance = {
    name = name,
    x = x,
    w = w
  }
  return setmetatable(instance, { __index = region })
end

function region:contains(x)
  local hw = self.w / 2
  return x >= self.x - hw and x <= self.x + hw
end

return region
