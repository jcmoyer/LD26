local player = require('player')
local world = require('world')
local camera = require('camera')
local mathex = require('mathex')
local message = require('message')
local gamecontext = require('gamecontext')
local sound = require('sound')
local gameoverstate = require('gameoverstate')

local gamestate = require('gamestate')
local playstate = setmetatable({}, { __index = gamestate })

local p = player.new()
local w = nil
local c = camera.new(love.graphics.getWidth(), love.graphics.getHeight())

local m = message.new()

local lastregion = nil
local context = nil

local function changeworld(name)
  w = world.new(name, context)
  w:onEnter(context)
end

local function makecontext(sm)
  local ctx = gamecontext.new()
  function ctx.showMessage(text, duration)
    m = message.new(text, duration, m.x, m.y)
  end
  function ctx.changeWorld(name, x)
    p.x = x or p.x
    if name ~= w.name then
      changeworld(name)
      p.x = mathex.clamp(p.x, w:left(), w:right())
      p.y = w:y(p.x)
      c:center(p.x, p.y)
    end
  end
  function ctx.addPortal(name, x, d, dx, silent)
    if not silent then
      sound.restart(sound.portal)
    end
    w:addPortal(name, x, d, dx)
  end
  function ctx.removePortal(name)
    w:removePortal(name)
  end
  function ctx.addRegion(name, x, width)
    w:addRegion(name, x, width)
  end
  function ctx.y(x)
    return w:y(x)
  end
  function ctx.preferredColor()
    return w:oppositeColor()
  end
  function ctx.getSwitchStatus(name)
    return w:getSwitchStatus(name)
  end
  function ctx.setSwitchStatus(name, status)
    w:setSwitchStatus(name, status)
  end
  function ctx.win(text)
    sm:changeState(gameoverstate.new(text))
  end
  function ctx.playSwitchSound()
    sound.restart(sound.switch)
  end
  function ctx.shakeCamera(d, m)
    sound.tryPlay(sound.pickShiftingSound(m))
    c:shake(d, m)
  end
  function ctx.playerX()
    return p.x
  end
  function ctx.left()
    return w:left()
  end
  function ctx.right()
    return w:right()
  end
  function ctx.setBackground(rgb)
    w.background = rgb
  end
  function ctx.setForeground(rgb)
    w.foreground = rgb
  end
  return ctx
end

function playstate.new()
  local instance = {}
  return setmetatable(instance, { __index = playstate })
end

function playstate:onEnter()
  context = makecontext(self:sm())
  changeworld('start')
end

function playstate:onLeave()
end

function playstate:keypressed(key, unicode)
  if key == 'up' then
    local portal = w:portalAt(p.x)
    if portal then
      if not w:onEnterPortal(context, portal) then return end
      p.x = portal.dx
      if portal.destination ~= w.name then
        changeworld(portal.destination)
        -- Instant pan when the world is different
        p.x = mathex.clamp(p.x, w:left(), w:right())
        p.y = w:y(p.x)
        c:center(p.x, p.y)
      end
    end
  end
end

function playstate:update(dt)
  local k = love.keyboard
  if k.isDown('left') then
    p.x = p.x - 300 * dt
  end
  if k.isDown('right') then
    p.x = p.x + 300 * dt
  end
  p.x = mathex.clamp(p.x, w:left(), w:right())
  p.y = w:y(p.x)

  local r = w:regionAt(p.x)
  if r ~= lastregion then
    -- if r is nil then we've left a region
    if r then
      w:onEnterRegion(context, r)
    end
    lastregion = r
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
  
  if m then
    m:setDestination(p.x - m:getWidth() / 2, p.y - p.h - m:getHeight() - 8)
    m:update(dt)
  end

  w:update(dt)
  w:scriptUpdate(context, dt)

  c:update(dt)
  c:panCenter(p.x, p.y, dt)
end

function playstate:draw()
  local g = love.graphics
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

  w:scriptDraw(context)
end

return playstate