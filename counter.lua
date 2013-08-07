local fontpool = require('core.fontpool')

local counter = {}
local mt = { __index = counter }

local setmetatable = setmetatable
local abs = math.abs
local graphics = love.graphics
local setColor, setFont = graphics.setColor, graphics.setFont
local rectangle, triangle, print = graphics.rectangle, graphics.triangle, graphics.print

local counterFont = fontpool.get(16)
local counterMidY = 96 / 2

function counter.new(owner, name, x, min, max, value)
  local instance = {
    owner = owner,
    name = name,
    x = x,
    min = min,
    max = max,
    value = value or min
  }
  return setmetatable(instance, mt)
end

function counter:up()
  local target = self.value + 1
  if target > self.max then
    return false
  else
    self.value = target
    return true
  end
end

function counter:down()
  local target = self.value - 1
  if target < self.min then
    return false
  else
    self.value = target
    return true
  end
end

function counter:draw(bg, fg)
  local x = self.x
  local y = self.owner:y(x)
  
  setColor(bg)
  rectangle('fill', x - 16, y - 96 + 32, 32, 32)
  
  -- up arrow
  triangle('fill',
    x - 8, y - 48 - 16 - 8,
    x + 8, y - 48 - 16 - 8,
    x    , y - 48 - 16 - 8 - 16)
  
  -- down arrow
  triangle('fill',
    x - 8, y - 48 + 16 + 8,
    x + 8, y - 48 + 16 + 8,
    x    , y - 48 + 16 + 8 + 16)
  
  setFont(counterFont)
  setColor(fg)
  
  local tw = counterFont:getWidth(self.value)
  local th = counterFont:getHeight()
  
  love.graphics.print(self.value, x - tw / 2, y - counterMidY - th / 2)
end

function counter:overlaps(x, r)
  local w = 32
  local d = abs(self.x - x)
  return d < r + w / 2
end

return counter