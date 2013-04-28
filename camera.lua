local mathex = require('mathex')
local camera = {}

function camera.new(width, height)
  local instance = {
    x = 0,
    y = 0,
    w = width,
    h = height
  }
  return setmetatable(instance, { __index = camera })
end

function camera:center(x, y)
  self.x = self.w / 2 - x
  self.y = self.h / 2 - y
end

function camera:panCenter(x, y, dt)
  local cx = self.x
  local cy = self.y
  self:center(x, y)
  self.x = mathex.lerp(cx, self.x, dt * 3)
  self.y = mathex.lerp(cy, self.y, dt * 3)
end

return camera
