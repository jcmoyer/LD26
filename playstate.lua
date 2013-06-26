local player = require('player')
local world = require('world')
local camera = require('core.camera')
local message = require('message')
local gamecontext = require('gamecontext')
local sound = require('sound')
local gameoverstate = require('gameoverstate')
local playmenustate = require('playmenustate')

local gamestate = require('core.gamestate')
local playstate = setmetatable({}, { __index = gamestate })

function playstate:changeworld(name)
  self.world = world.new(name, self.context)
  self.world:onEnter(self.context)
end

function playstate:makecontext()
  local ctx = gamecontext.new()
  function ctx.showMessage(text, duration)
    local m = self.message
    self.message = message.new(text, duration, m.x, m.y)
  end
  function ctx.changeWorld(name, x)
    local p = self.player
    local w = self.world
    local c = self.camera
    p.x = x or p.x
    if name ~= w.name then
      self:changeworld(name)
      w = self.world
      p.x = math.clamp(p.x, w:left(), w:right())
      p.y = w:y(p.x)
      c:center(p.x, p.y)
    end
  end
  function ctx.addPortal(name, x, d, dx, silent)
    if not silent then
      sound.restart(sound.portal)
    end
    self.world:addPortal(name, x, d, dx)
  end
  function ctx.removePortal(name)
    self.world:removePortal(name)
  end
  function ctx.addRegion(name, x, width)
    self.world:addRegion(name, x, width)
  end
  function ctx.y(x)
    return self.world:y(x)
  end
  function ctx.preferredColor()
    return self.world:oppositeColor()
  end
  function ctx.getSwitchStatus(name)
    return self.world:getSwitchStatus(name)
  end
  function ctx.setSwitchStatus(name, status)
    self.world:setSwitchStatus(name, status)
  end
  function ctx.win(text)
    self:sm():pop()
    self:sm():push(gameoverstate.new(text))
  end
  function ctx.playSwitchSound()
    sound.restart(sound.switch)
  end
  function ctx.shakeCamera(d, m)
    sound.tryPlay(sound.pickShiftingSound(m))
    self.camera:shake(d, m)
  end
  function ctx.playerX()
    return self.player.x
  end
  function ctx.left()
    return self.world:left()
  end
  function ctx.right()
    return self.world:right()
  end
  function ctx.setBackground(rgb)
    self.world.background = rgb
  end
  function ctx.setForeground(rgb)
    self.world.foreground = rgb
  end
  return ctx
end

function playstate.new()
  local instance = {
    player = player.new(),
    world = nil,
    camera = camera.new(love.graphics.getWidth(), love.graphics.getHeight()),
    message = message.new(),
    lastregion = nil,
    context = nil
  }
  return setmetatable(instance, { __index = playstate })
end

function playstate:onEnter(old)
  if getmetatable(old) ~= playmenustate.mt then
    self.context = self:makecontext()
    self:changeworld('start')
    self.camera:center(self.player.x, self.player.y)
  end
end

function playstate:keypressed(key, unicode)
  local p = self.player
  local w = self.world
  local c = self.camera
  local context = self.context
  
  if key == 'escape' then
    self:sm():push(playmenustate.new())
  end
  
  if key == 'up' then
    local portal = w:portalAt(p.x)
    if portal then
      if not w:onEnterPortal(context, portal) then return end
      p.x = portal.dx
      if portal.destination ~= w.name then
        self:changeworld(portal.destination)
        w = self.world
        
        -- Instant pan when the world is different
        p.x = math.clamp(p.x, w:left(), w:right())
        p.y = w:y(p.x)
        c:center(p.x, p.y)
      end
    end
  end
end

function playstate:update(dt)
  local p = self.player
  local w = self.world
  local c = self.camera
  local m = self.message
  local context = self.context
  
  local k = love.keyboard
  if k.isDown('left') then
    p.x = p.x - 300 * dt
  end
  if k.isDown('right') then
    p.x = p.x + 300 * dt
  end
  p.x = math.clamp(p.x, w:left(), w:right())
  p.y = w:y(p.x)

  local r = w:regionAt(p.x)
  if r ~= self.lastregion then
    -- if r is nil then we've left a region
    if r then
      w:onEnterRegion(context, r)
    end
    self.lastregion = r
  end

  -- activate switches at the player's location
  if w:activateAt(p.x, context) then
    sound.restart(sound.switch)
  end

  -- check for death conditions
  if w:enemyAt(p.x) then
    sound.restart(sound.death)
    w:onPlayerDeath(context)
  end
  
  m:setDestination(p.x - m:getWidth() / 2, p.y - p.h - m:getHeight() - 8)
  m:update(dt)

  w:update(dt)
  w:scriptUpdate(context, dt)

  c:update(dt)
  c:panCenter(p.x, p.y, dt)
end

function playstate:draw()
  local g = love.graphics
  local p = self.player
  local w = self.world
  local c = self.camera
  local m = self.message
  
  g.setBackgroundColor(w.background)
  g.clear()

  g.translate(c:calculatedX(), c:calculatedY())
  w:draw()

  p.color = w:oppositeColor()
  p:draw()

  if (m and m:visible()) then
    m.color = w:oppositeColor()
    m:draw()
  end

  w:scriptDraw(self.context)
end

return playstate