local mathex = require('mathex')
local color = require('color')

local message = {}
local defaultFont = love.graphics.newFont(18)

function message.new(text, duration, x, y)
  local instance = {
    text = text or '',
    duration = duration or 0,
    color = color.new(255, 255, 255),
    x = x or 0,
    y = y or 0,
    dx = x or 0,
    dy = y or 0,
    font = defaultFont
  }
  return setmetatable(instance, { __index = message })
end

function message:update(dt)
  self.duration = self.duration - dt
  self.x = mathex.lerp(self.x, self.dx, dt * 10)
  self.y = mathex.lerp(self.y, self.dy, dt * 10)
end

function message:draw()
  local g = love.graphics
  local ic = -self.color
  ic[4] = 128 -- add an alpha component

  local w = self.font:getWidth(self.text)
  local h = self.font:getHeight()

  g.setColor(ic)
  -- inflate rectangle 2px on each side
  g.rectangle('fill', self.x - 2, self.y - 2, w + 4, h + 4)

  g.setColor(self.color)
  g.setFont(self.font)
  g.print(self.text, self.x, self.y)
end

function message:visible()
  return self.duration > 0
end

function message:setDestination(x, y)
  self.dx = x
  self.dy = y
end

function message:getWidth()
  return self.font:getWidth(self.text)
end

function message:getHeight()
  return self.font:getHeight()
end

return message
