local region = {}
local mt = { __index = region }

local setmetatable = setmetatable
local abs = math.abs

function region.new(name, x, w)
  local instance = {
    name = name,
    x = x,
    w = w
  }
  return setmetatable(instance, mt)
end

function region:contains(x)
  local hw = self.w / 2
  return x >= self.x - hw and x <= self.x + hw
end

function region:overlaps(x, r)
  local d = abs(self.x - x)
  return d < r + self.w / 2
end

return region
