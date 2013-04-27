local mathex = require('mathex')
local portal = require('portal')
local region = require('region')
local world = {}

function world.new(name)
  local data = require(name)
  -- Build a world object from the data
  local instance = setmetatable({}, { __index = world })
  instance.background = data.background or { 0, 0, 0 }
  instance.name    = name
  instance.lines   = data.lines
  instance.portals = {}
  instance.triggers = data.triggers
  instance.regions = {}
  instance.switches = {}
  -- Create actual portal objects from the data
  for i,p in ipairs(data.portals or {}) do
    instance.portals[i] = portal.new(instance, p.x, p.destination, p.dx)
  end
  for i,r in ipairs(data.regions or {}) do
    instance.regions[i] = region.new(r.name, r.x, r.w)
  end
  for i,s in ipairs(data.switches or {}) do
    instance.switches[i] = switch.new(s.name, s.x, s.ud)
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

function world:update(dt)
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

function world:scriptUpdate(context, dt)
  local t = self.triggers or {}
  if t.onUpdate then
    t.onUpdate(context, dt)
  end
end

function world:scriptDraw(context)
  local t = self.triggers or {}
  if t.onDraw then
    t.onDraw(context)
  end
end

function world:portalAt(x)
  local y = self:y(x)
  for i,p in ipairs(self.portals) do
    if p:contains(x) then return p end
  end
end

function world:regionAt(x)
  for i,r in ipairs(self.regions) do
    if r:contains(x) then return r end
  end
end

function world:addPortal(x, destination, dx)
  self.portals[#self.portals + 1] = portal.new(self, x, destination, dx)
end

function world:addRegion(name, x, w)
  self.regions[#self.regions + 1] = region.new(name, x, w)
end

function world:oppositeColor()
  local c = self.background
  return { 255 - c[1], 255 - c[2], 255 - c[3] }
end

function world:onEnter(context)
  local t = self.triggers or {}
  if t.onEnter then
    t.onEnter(context)
  end
end

function world:onEnterRegion(context, r)
  local t = self.triggers or {}
  if t.onEnterRegion then
    t.onEnterRegion(context, r)
  end
end

return world
