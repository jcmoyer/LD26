local enemy = {}
local mt = { __index = enemy }

local setmetatable = setmetatable
local graphics = love.graphics
local polygon = graphics.polygon
local abs = math.abs
local mathex = require('hug.extensions.math')
local clamp = mathex.clamp

local function calculatePixelSize(e)
  return e.size * 32, e.size * 32
end

function enemy.new(owner, x, patrol, size, speed)
  local instance = {
    owner = owner,
    x = x,
    size = size or 1,
    speed = speed or 50,
    patrol = patrol,
    direction = 'right'
  }
  return setmetatable(instance, mt)
end

function enemy:update(dt)
  if self.patrol == nil then return end
  if self.direction == 'right' then
    self.x = self.x + dt * self.speed
    if self.x >= self.patrol.right then
      self.direction = 'left'
    end
  elseif self.direction == 'left' then
    self.x = self.x - dt * self.speed
    if self.x <= self.patrol.left then
      self.direction = 'right'
    end
  end
  self.x = clamp(self.x, self.patrol.left, self.patrol.right)
end

function enemy:draw()
  local y = self.owner:y(self.x)
  local w, h = calculatePixelSize(self)
  local hw = w / 2
  polygon('fill', self.x, y, self.x - hw, y - h, self.x + hw, y - h)
end

function enemy:contains(x)
  local w, _ = calculatePixelSize(self)
  return x >= self.x - w / 2 and x <= self.x + w / 2
end

function enemy:overlaps(x, r)
  local w, _ = calculatePixelSize(self)
  local d = abs(self.x - x)
  return d < r + w / 2
end

return enemy
