local color = require('core.color')
local projectile = {}
local mt = { __index = projectile }

local setmetatable = setmetatable
local graphics = love.graphics
local setColor = graphics.setColor
local rectangle = graphics.rectangle

function projectile.new(x, y, vx, vy)
  local instance = {
    x = x,
    y = y,
    vx = vx,
    vy = vy,
    color = color.new(255, 0, 0),
    size = 8,
  }
  return setmetatable(instance, mt)
end

function projectile:update(dt)
  self.x = self.x * self.vx * dt
  self.y = self.y * self.vy * dt
end

function projectile:draw()
  local hs = self.size / 2
  
  setColor(self.color)
  rectangle('fill', self.x - hs, self.y - hs, self.size, self.size)
end

return projectile