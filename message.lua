local fontpool = require('fontpool')
local color = require('hug.color')
local textrender = require('textrender')

local message = {}
local mt = { __index = message }
local defaultFont = fontpool:get(18)

local setmetatable = setmetatable
local graphics = love.graphics
local setColor, setFont = graphics.setColor, graphics.setFont
local rectangle = graphics.rectangle
local mathex = require('hug.extensions.math')
local lerp = mathex.lerp

function message.new(text, duration, x, y)
  local instance = {
    -- now set below
    --text = text or '',
    duration = duration or 0,
    --color = color.new(255, 255, 255),
    x = x or 0,
    y = y or 0,
    dx = x or 0,
    dy = y or 0,
    w = 0,
    h = 0,
    font = defaultFont
  }
  message.setText(instance, text or '')
  message.setColor(instance, color.fromrgba(1, 1, 1))
  return setmetatable(instance, mt)
end

function message:update(dt)
  self.duration = self.duration - dt
  self.x = lerp(self.x, self.dx, dt * 10)
  self.y = lerp(self.y, self.dy, dt * 10)
end

function message:draw()
  setColor(self.backcolor)
  -- inflate rectangle 2px on each side
  rectangle('fill', self.x - 2, self.y - 2, self.w + 4, self.h + 4)

  setColor(self.forecolor)
  setFont(self.font)
  textrender.print(self.text, self.x, self.y)
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

function message:setText(text)
  self.w = self.font:getWidth(text)
  self.h = self.font:getHeight()
  self.text = text
end

function message:setColor(fg, bg)
  self.forecolor = fg
  if bg ~= nil then
    self.backcolor = bg
  else
    self.backcolor = -self.forecolor
  end
  -- add an alpha channel
  self.backcolor[4] = 0.5
end

return message
