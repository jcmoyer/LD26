local mathex = require('mathex')
local portal = require('portal')
local world = {}

function world.new(name)
  local data = require(name)
  -- Build a world object from the data
  local instance = setmetatable({}, { __index = world })
  instance.background = data.background or { 0, 0, 0 }
  instance.name    = name
  instance.lines   = data.lines
  instance.portals = {}
  -- Create actual portal objects from the data
  for i,p in ipairs(data.portals) do
    instance.portals[i] = portal.new(instance, p.x, p.destination, p.dx)
  end

  return instance
end

function world:y(x)
  -- traverse lines
  for i = 1, #self.lines - 3, 2 do
    local x1 = self.lines[i]
    local y1 = self.lines[i + 1] 
    local x2 = self.lines[i + 2]
    local y2 = self.lines[i + 3]
    if x >= x1 and x <= x2 then
      -- determine how far into the line we are
      local d = (x - x1) / (x2 - x1)
      -- calculate the slope of the line
      local m = (y1 - y2) / (x1 - x2)
      -- calculate the base of the line
      local b = mathex.lerp(y1, y2, d)
      -- y = mx + b
      return m * d + b
    end
  end
end

function world:left()
  return self.lines[1]
end

function world:right()
  return self.lines[#self.lines - 1]
end

function world:draw()
  local g = love.graphics
  --g.setColor(255, 255, 255)
  g.setColor(self:oppositeColor())
  g.line(self.lines)

  for i,p in ipairs(self.portals) do
    p:draw()
  end
end

function world:portalAt(x)
  local y = self:y(x)
  for i,p in ipairs(self.portals) do
    if p:contains(x) then return p end
  end
end

function world:oppositeColor()
  local c = self.background
  return { 255 - c[1], 255 - c[2], 255 - c[3] }
end

return world
