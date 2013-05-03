local player = require('player')
local world = require('world')
local camera = require('camera')
local mathex = require('mathex')
local message = require('message')
local gamecontext = require('gamecontext')
local sound = require('sound')

local p = player.new()
local w = nil
local c = camera.new(800, 600)

local m = nil
local mdx = 0
local mdy = 0

local lastregion = nil
local context = nil

local gameoverFont = nil
local gameoverSubFont = nil
local gameover = false
local gameoverMessage = nil

function makecontext()
  local ctx = gamecontext.new()
  function ctx.showMessage(text, duration)
    if m then
      local oldX = m.x
      local oldY = m.y
      m = message.new(text, duration)
      m.x = oldX
      m.y = oldY
    else
      m = message.new(text, duration)
    end
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
    gameover = true
    gameoverMessage = text
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

function drawWinScreen()
  local g = love.graphics
  local w = g.getWidth()
  local h = g.getHeight()
  local message = 'Thanks for playing!'
  local submessage = 'Made for LD26 :: https://github.com/jcmoyer'
  local mh = gameoverFont:getHeight()
  local mw = gameoverFont:getWidth(message)
  local sw = gameoverSubFont:getWidth(submessage)

  local udsw = gameoverSubFont:getWidth(gameoverMessage)

  g.setFont(gameoverFont)
  g.print(message, w / 2 - mw / 2, h / 2 - mh / 2)

  g.setFont(gameoverSubFont)
  g.print(submessage, w / 2 - sw / 2, h / 2 - mh / 2 + mh + 8)
  g.print(gameoverMessage, w / 2 - udsw / 2, h / 3)
end

function changeworld(name)
  w = world.new(name, context)
  w:onEnter(context)
end

function love.load()
  context = makecontext()
  love.graphics.setFont(love.graphics.newFont(18))
  gameoverFont = love.graphics.newFont(36)
  gameoverSubFont = love.graphics.newFont(16)
  changeworld('data.start')
end

function love.draw()
  if gameover then
    drawWinScreen()
    return
  end

  local g = love.graphics
  g.setBackgroundColor(w.background)
  g.clear()

  g.translate(c:calculatedX(), c:calculatedY())
  w:draw()

  p.color = w:oppositeColor()
  p:draw()

  if (m and m:visible()) then
    m.color = w:oppositeColor()

    local f = g.getFont()
    local width = f:getWidth(m.text)
    mdx = p.x - width / 2
    mdy = p.y - p.h - f:getHeight() - 8

    m.x = mathex.lerp(m.x, mdx, 0.2)
    m.y = mathex.lerp(m.y, mdy, 0.2)

    m:draw()
  end

  w:scriptDraw(context)
end

function love.update(dt)
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
    m:update(dt)
  end

  w:update(dt)
  w:scriptUpdate(context, dt)

  c:update(dt)
  c:panCenter(p.x, p.y, dt)
end

function love.keypressed(key, unicode)
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
