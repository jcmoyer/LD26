local color = require('hug.color')
local player = {}
local mt = { __index = player }

local setmetatable = setmetatable
local graphics = love.graphics
local setColor = graphics.setColor
local rectangle = graphics.rectangle

function player.new()
  local instance = {
    x = 0,
    y = 0,
    w = 32,
    h = 64,
    color = color.fromrgba(1, 1, 1)
  }
  return setmetatable(instance, mt)
end

function player:draw()
  setColor(self.color)
  rectangle('fill', self.x - self.w / 2, self.y - self.h, self.w, self.h)
end

return player
