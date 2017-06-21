local fontpool = require('fontpool')
local color = require('hug.color')
local textrender = require('textrender')

local counter = {}
local mt = { __index = counter }

local setmetatable = setmetatable
local abs = math.abs
local graphics = love.graphics
local setColor, setFont = graphics.setColor, graphics.setFont
local rectangle, polygon = graphics.rectangle, graphics.polygon

local counterFont = fontpool:get(22)
local counterMidY = 96 / 2

function counter.new(owner, name, x, min, max, value, interactive, bgcolor)
  local instance = {
    owner = owner,
    name = name,
    x = x,
    y = owner:y(x),
    min = min,
    max = max,
    value = value or min,
    interactive = interactive or true
  }
  -- sets valuew and valueh on instance
  counter.calculateValueSize(instance)
  -- sets backcolor and forecolor
  counter.setColor(instance, bgcolor or color.fromrgba(255, 255, 255))
  
  return setmetatable(instance, mt)
end

function counter:up()
  if self.interactive == false then
    return false
  end
  
  local target = self.value + 1
  if target > self.max then
    return false
  else
    self.value = target
    self:calculateValueSize()
    return true
  end
end

function counter:down()
  if self.interactive == false then
    return false
  end
  
  local target = self.value - 1
  if target < self.min then
    return false
  else
    self.value = target
    self:calculateValueSize()
    return true
  end
end

function counter:draw()
  local x = self.x
  local y = self.y
  
  setColor(self.backcolor)
  rectangle('fill', x - 16, y - 96 + 32, 32, 32)
  
  if self.interactive == true then
    -- up arrow
    polygon('fill',
      x - 8, y - 48 - 16 - 8,
      x + 8, y - 48 - 16 - 8,
      x    , y - 48 - 16 - 8 - 16)
    
    -- down arrow
    polygon('fill',
      x - 8, y - 48 + 16 + 8,
      x + 8, y - 48 + 16 + 8,
      x    , y - 48 + 16 + 8 + 16)
  end
  
  setFont(counterFont)
  setColor(self.forecolor)
  textrender.print(self.value, x - self.valuew / 2, y - counterMidY - self.valueh / 2)
end

function counter:overlaps(x, r)
  local w = 32
  local d = abs(self.x - x)
  return d < r + w / 2
end

function counter:calculateValueSize()
  self.valuew = counterFont:getWidth(self.value)
  self.valueh = counterFont:getHeight()
end

function counter:setColor(bg, fg)
  self.backcolor = bg
  if fg ~= nil then
    self.forecolor = fg
  else
    self.forecolor = -bg
  end
end

return counter
