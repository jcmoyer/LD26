local mathex = require('mathex')
local portal = require('portal')
local world = {}

function world.new(name)
  -- this is probably scary
  local instance = require(name)
  instance.name = name
  local worldinst = setmetatable(instance, { __index = world }) 

  worldinst.portalData = {}
  for i,p in ipairs(worldinst.portals) do
    worldinst.portalData[i] = portal.new(worldinst, p.x, p.destination, p.dx)
  end

  return worldinst
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
  g.setColor(255, 255, 255)
  g.line(self.lines)

  for i,p in ipairs(self.portalData) do
    p:draw()
  end
end

function world:portalAt(x)
  local y = self:y(x)
  for i,p in ipairs(self.portalData) do
    if p:contains(x) then return p end
  end
end

return world
