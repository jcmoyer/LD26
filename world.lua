local mathex = require('mathex')
local portal = require('portal')
local region = require('region')
local switch = require('switch')
local world = {}

function world.new(name, context)
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
    instance.switches[i] = switch.new(instance, s.name, s.x, s.ud, s.gvar)
    if s.gvar then
      local status = context.getVar(s.gvar)
      instance.switches[i].status = status or false
    end
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

  for i,s in ipairs(self.switches) do
    s:draw()
  end

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

function world:activateAt(x, context)
  local r = false
  for i,s in ipairs(self.switches) do
    if s:contains(x) then
      if not s.status then
        r = true
        s.status = true
        self:onSwitchChanged(context, s)
      end
    end
  end
  return r
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

function world:setSwitchStatus(name, status)
  for i,s in ipairs(self.switches) do
    if s.name == name then s.status = status end
  end
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

-- A script should return false to disable standard portal processing
-- True means the portal operates as normal after the trigger returns
function world:onEnterPortal(context, p)
  local t = self.triggers or {}
  if t.onEnterPortal then
    return t.onEnterPortal(context, p)
  end
  return true
end

function world:onSwitchChanged(context, s)
  -- update the global variable this switch is linked to
  if s.gvar then
    context.setVar(s.gvar, s.status)
  end

  local t = self.triggers or {}
  if t.onSwitchChanged then
    t.onSwitchChanged(context, s)
  end
end

return world
