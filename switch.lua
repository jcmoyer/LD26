local switch = {}
local mt = { __index = switch }

local setmetatable = setmetatable
local graphics = love.graphics
local rectangle = graphics.rectangle
local abs = math.abs

function switch.new(owner, name, x, ud, gvar)
  local instance = {
    owner  = owner,
    name   = name,
    x      = x,
    y      = owner:y(x),
    w      = 16,
    ud     = ud,
    gvar   = gvar,
    status = false
  }
  return setmetatable(instance, mt)
end

function switch:draw()
  local h = self.status and 2 or 8
  rectangle('fill', self.x - self.w / 2, self.y - h, self.w, h)
end

function switch:contains(x)
  local hw = self.w / 2
  return x >= self.x - hw and x <= self.x + hw
end

function switch:overlaps(x, r)
  local d = abs(self.x - x)
  return d < r + self.w / 2
end

return switch
