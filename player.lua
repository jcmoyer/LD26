local color = require('core.color')
local player = {}
local mt = { __index = player }

function player.new()
  local instance = {
    x = 0,
    y = 0,
    w = 32,
    h = 64,
    color = color.new(255, 255, 255)
  }
  return setmetatable(instance, mt)
end

function player:draw()
  local g = love.graphics
  g.setColor(self.color)
  g.rectangle('fill', self.x - self.w / 2, self.y - self.h, self.w, self.h)
end

return player
