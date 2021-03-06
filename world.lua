local portal = require('portal')
local region = require('region')
local switch = require('switch')
local enemy = require('enemy')
local counter = require('counter')
local timerpool = require('hug.timerpool')
local color = require('hug.color')
local lazy = require('hug.lazy')
local world = {}
local mt = { __index = world }

local dofile, setmetatable, pairs, ipairs = dofile, setmetatable, pairs, ipairs
local graphics = love.graphics
local setLineWidth, setColor = graphics.setLineWidth, graphics.setColor
local line = graphics.line
local mathex = require('hug.extensions.math')
local lerp = mathex.lerp

local function safeCallTrigger(tt, name, ...)
  if (tt and tt[name]) then
    return tt[name](...)
  end
end

local worldnames = lazy.new(function()
  local worldfiles = love.filesystem.getDirectoryItems('worlds')
  local names = {}
  for i = 1, #worldfiles do
    local _, _, name = worldfiles[i]:find('([%a%d_]+)%.lua$')
    if name then
      names[#names + 1] = name
    end
  end
  return names
end)

function world.getNames()
  return worldnames:get()
end

function world.new(name, context)
  local timerpool = timerpool.new()
  
  local chunk = love.filesystem.load('worlds/' .. name .. '.lua')
  
  local env = {timerpool = timerpool}
  for k,v in pairs(_G) do
    env[k] = v
  end
  
  setfenv(chunk, env)
  
  local data = chunk()

  -- Build a world object from the data
  local instance = setmetatable({}, mt)
  instance.timerpool = timerpool
  instance.background = color.fromtable(data.background or { 0, 0, 0 })
  instance.foreground = data.foreground and color.fromtable(data.foreground) or -instance.background
  instance.name    = name
  instance.lines   = data.lines
  instance.portals = {}
  instance.triggers = data.triggers
  instance.regions = {}
  instance.switches = {}
  instance.enemies = {}
  instance.projectiles = {}
  instance.counters = {}
  instance.linewidth = data.linewidth or 1
  -- Create actual portal objects from the data
  for i,p in ipairs(data.portals or {}) do
    instance.portals[p.name or i] = portal.new(instance, p.name, p.x, p.destination, p.dx, instance.foreground * 0.8)
  end
  for i,r in ipairs(data.regions or {}) do
    instance.regions[r.name or i] = region.new(r.name, r.x, r.w)
  end
  for i,s in ipairs(data.switches or {}) do
    local k = s.name or i
    instance.switches[k] = switch.new(instance, k, s.x, s.ud, s.gvar)
    if s.gvar then
      local status = context.getVar(s.gvar)
      instance.switches[k].status = status or false
    end
  end
  for i,e in ipairs(data.enemies or {}) do
    instance.enemies[i] = enemy.new(instance, e.x, e.patrol, e.size, e.speed)
  end
  for i,c in ipairs(data.counters or {}) do
    instance.counters[c.name or i] = counter.new(instance, c.name, c.x, c.min, c.max, nil, c.interactive, instance.foreground * 0.8)
  end

  return instance
end

function world:y(x)
  -- make sure there is enough data to work with and return the closest part
  -- of the world if x isn't within the bounds of the world
  if #self.lines < 4 then
    return x
  elseif x < self.lines[1] then
    return self.lines[2]
  elseif x > self.lines[#self.lines - 1] then
    return self.lines[#self.lines]
  end
  
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
      local b = lerp(y1, y2, d)
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
  self.timerpool:update(dt)
  
  for _,e in ipairs(self.enemies) do
    e:update(dt)
  end
  
  for _,p in ipairs(self.projectiles) do
    p:update(dt)
  end
end

function world:draw()
  setLineWidth(self.linewidth)
  setColor(self:oppositeColor())
  line(self.lines)

  for _,p in pairs(self.portals) do
    p:draw()
  end
  
  for _,c in pairs(self.counters) do
    c:draw()
  end

  for _,s in pairs(self.switches) do
    setColor(self:oppositeColor())
    s:draw()
  end

  for _,e in ipairs(self.enemies) do
    setColor(self:oppositeColor())
    e:draw()
  end
  
  for _,p in ipairs(self.projectiles) do
    p:draw()
  end
end

function world:scriptUpdate(context, dt)
  safeCallTrigger(self.triggers, 'onUpdate', context, dt)
end

function world:scriptDraw(context)
  safeCallTrigger(self.triggers, 'onDraw', context)
end

function world:portalAt(x)
  for _,p in pairs(self.portals) do
    if p:contains(x) then
      return p  
    end
  end
end

function world:regionAt(x)
  for _,r in pairs(self.regions) do
    if r:contains(x) then
      return r
    end
  end
end

function world:regionOverlaps(x, r)
  for _,reg in pairs(self.regions) do
    if reg:overlaps(x, r) then
      return reg
    end
  end
end

function world:enemyAt(x)
  for _,e in ipairs(self.enemies) do
    if e:contains(x) then
      return e
    end
  end
end

function world:counterAt(x, r)
  for _,c in pairs(self.counters) do
    if c:overlaps(x, r) then
      return c
    end
  end
end

function world:enemyOverlaps(x, r)
  for _,e in ipairs(self.enemies) do
    if e:overlaps(x, r) then
      return e
    end
  end
end

function world:activateAt(x, r, context)
  local result = false
  for _,s in pairs(self.switches) do
    if s.status == false and s:overlaps(x, r) then
      result = true
      s.status = true
      self:onSwitchChanged(context, s)
    end
  end
  return result
end

function world:addPortal(name, x, destination, dx)
  self.portals[name] = portal.new(self, name, x, destination, dx, self.foreground * 0.8)
end

function world:removePortal(name)
  self.portals[name] = nil
end

function world:addRegion(name, x, w)
  self.regions[name] = region.new(name, x, w)
end

function world:oppositeColor()
  return self.foreground
end

function world:getSwitchStatus(name)
  local s = self.switches[name]
  if s then
    return s.status
  else
    return false
  end
end

function world:setSwitchStatus(name, status)
  local s = self.switches[name]
  if s then
    s.status = status
  end
end

function world:getCounterValue(name)
  local c = self.counters[name]
  if c ~= nil then
    return c.value
  end
end

function world:onEnter(context)
  safeCallTrigger(self.triggers, 'onEnter', context)
end

function world:onEnterRegion(context, r)
  safeCallTrigger(self.triggers, 'onEnterRegion', context, r)
end

-- A script should return false to disable standard portal processing
-- True means the portal operates as normal after the trigger returns
function world:onEnterPortal(context, p)
  local r = safeCallTrigger(self.triggers, 'onEnterPortal', context, p)
  if r ~= nil then
    return r
  else
    return true  
  end
end

function world:onSwitchChanged(context, s)
  -- update the global variable this switch is linked to
  if s.gvar ~= nil then
    context.setVar(s.gvar, s.status)
  end
  safeCallTrigger(self.triggers, 'onSwitchChanged', context, s)
end

function world:onPlayerDeath(context)
  safeCallTrigger(self.triggers, 'onPlayerDeath', context)
end

function world:onCounterChanged(context, c)
  safeCallTrigger(self.triggers, 'onCounterChanged', context, c)
end

return world
