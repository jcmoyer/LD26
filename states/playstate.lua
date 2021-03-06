local player = require('player')
local world = require('world')
local camera = require('hug.camera')
local message = require('message')
local gamecontext = require('gamecontext')
local sound = require('sound')
local time = require('time')
local gameoverstate = require('states.gameoverstate')
local playmenustate = require('states.playmenustate')
local fontpool = require('fontpool')
local textrender = require('textrender')

local gamestate = require('hug.gamestate')

local setmetatable, getmetatable = setmetatable, getmetatable
local graphics = love.graphics
local setBackgroundColor, clear, translate = graphics.setBackgroundColor, graphics.clear, graphics.translate
local push, pop, getWidth, getHeight = graphics.push, graphics.pop, graphics.getWidth, graphics.getHeight
local setFont, setColor = graphics.setFont, graphics.setColor
local isDown = love.keyboard.isDown
local mathex = require('hug.extensions.math')
local lerp, clamp = mathex.lerp, mathex.clamp

local playstate = setmetatable({}, { __index = gamestate })
local mt = { __index = playstate }

local scorefont = fontpool:get(18)

function playstate:changeworld(name)
  self.world = world.new(name, self.context)
  self.world:onEnter(self.context)
  
  if self.bgcolor == nil then
    self.bgcolor = self.world.background
  end
end

function playstate:makecontext()
  local ctx = gamecontext.new()
  function ctx.showMessage(text, duration)
    local m = self.message
    m.duration = duration
    m:setText(text)
  end
  function ctx.changeWorld(name, x)
    local p = self.player
    local w = self.world
    local c = self.camera
    p.x = x or p.x
    if name ~= w.name then
      self:changeworld(name)
      w = self.world
      p.x = clamp(p.x, w:left(), w:right())
      p.y = w:y(p.x)
      c:center(p.x, p.y)
    end
  end
  function ctx.addPortal(name, x, d, dx, silent)
    if silent ~= true then
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
  function ctx.getCounterValue(name)
    return self.world:getCounterValue(name)
  end
  function ctx.win(text)
    self:sm():pop()
    self:sm():push(gameoverstate.new(text, self.time))
  end
  function ctx.playSwitchSound()
    sound.restart(sound.switch)
  end
  function ctx.playSound(name)
    sound.restart(sound[name])
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
    camera = camera.new(getWidth(), getHeight()),
    message = message.new(),
    lastregion = nil,
    context = nil,
    bgcolor = nil,
    time = 0
  }
  return setmetatable(instance, mt)
end

function playstate:enter(old)
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
    local counter = w:counterAt(p.x, p.w / 2)
    if counter ~= nil then
      if counter:up() == true then
        w:onCounterChanged(context, counter)
      end
    end
    
    local portal = w:portalAt(p.x)
    if portal then
      -- handle portal entrance cancellation via script
      if w:onEnterPortal(context, portal) == false then
        return
      end
      p.x = portal.dx
      if portal.destination ~= w.name then
        self:changeworld(portal.destination)
        w = self.world
        
        -- Instant pan when the world is different
        p.x = clamp(p.x, w:left(), w:right())
        p.y = w:y(p.x)
        c:center(p.x, p.y)
      end
    end
  end
  
  if key == 'down' then
    local counter = w:counterAt(p.x, p.w / 2)
    if counter ~= nil then
      if counter:down() == true then
        w:onCounterChanged(context, counter)
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
  
  if isDown('left') then
    p.x = p.x - 300 * dt
  end
  if isDown('right') then
    p.x = p.x + 300 * dt
  end
  p.x = clamp(p.x, w:left(), w:right())
  p.y = w:y(p.x)

  local r = w:regionOverlaps(p.x, p.w / 2)
  if r ~= self.lastregion then
    -- if r is nil then we've left a region
    if r then
      w:onEnterRegion(context, r)
    end
    self.lastregion = r
  end

  -- activate switches at the player's location
  if w:activateAt(p.x, p.w / 2, context) then
    sound.restart(sound.switch)
  end

  -- check for death conditions
  if w:enemyOverlaps(p.x, p.w / 2) then
    sound.restart(sound.death)
    w:onPlayerDeath(context)
  end
  
  m:setDestination(p.x - m:getWidth() / 2, p.y - p.h - m:getHeight() - 8)
  m:update(dt)

  w:update(dt)
  w:scriptUpdate(context, dt)

  c:update(dt)
  c:pan(p.x, p.y, dt * 3)
  
  self.bgcolor[1] = lerp(self.bgcolor[1], w.background[1], dt * 10)
  self.bgcolor[2] = lerp(self.bgcolor[2], w.background[2], dt * 10)
  self.bgcolor[3] = lerp(self.bgcolor[3], w.background[3], dt * 10)
  
  self.time = self.time + dt
end

function playstate:draw()
  local p = self.player
  local w = self.world
  local c = self.camera
  local m = self.message
  local cx, cy = c:position()
  
  clear(self.bgcolor)

  -- draw game
  push()
  translate(-cx, -cy)
  w:draw()

  p.color = w:oppositeColor()
  p:draw()

  w:scriptDraw(self.context)
  
  if (m and m:visible()) then
    m:setColor(w.foreground, w.background)
    m:draw()
  end
  pop()
  
  -- draw time
  local timestr = time.str(self.time)
  local timew   = scorefont:getWidth(timestr)
  setFont(scorefont)
  setColor(w.foreground)
  textrender.print(timestr, getWidth() / 2 - timew / 2, getHeight() / 32)
end

return playstate
