local color = require('color')
local projectile = {}

function projectile.new(x, y, vx, vy)
  local instance = {
    x = x,
    y = y,
    vx = vx,
    vy = vy,
    color = color.new(255, 0, 0),
    size = 8,
  }
  return setmetatable(instance, { __index = projectile })
end

function projectile:update(dt)
  self.x = self.x * self.vx * dt
  self.y = self.y * self.vy * dt
end

function projectile:draw()
  local g = love.graphics
  local hs = self.size / 2
  
  g.setColor(self.color)
  g.rectangle('fill', self.x - hs, self.y - hs, self.size, self.size)
end

return projectile