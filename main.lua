local player = require('player')
local world = require('world')
local camera = require('camera')
local mathex = require('mathex')
local message = require('message')
local gamecontext = require('gamecontext')

local switchSnd = love.audio.newSource('data/switch.ogg', 'static')

local p = player.new()
local w = nil
local c = camera.new(800, 600)

local m = nil
local lastregion = nil
local context = nil

local gameoverFont = nil
local gameoverSubFont = nil
local gameover = false

function makecontext()
  local ctx = gamecontext.new()
  function ctx.showMessage(text, duration)
    m = message.new(text, duration)
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
  function ctx.addPortal(name, x, d, dx)
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
  function ctx.setSwitchStatus(name, status)
    w:setSwitchStatus(name, status)
  end
  function ctx.win()
    gameover = true
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

  g.setFont(gameoverFont)
  g.print(message, w / 2 - mw / 2, h / 2 - mh / 2)

  g.setFont(gameoverSubFont)
  love.graphics.print(submessage, w / 2 - sw / 2, h / 2 - mh / 2 + mh + 8)
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
  changeworld('data.introworld')
end

function love.draw()
  if gameover then
    drawWinScreen()
    return
  end

  local g = love.graphics
  g.setBackgroundColor(w.background)
  g.clear()

  g.translate(c.x, c.y)
  w:draw()

  p.color = w:oppositeColor()
  p:draw()

  if (m and m:visible()) then
    m.color = w:oppositeColor()

    local f = g.getFont()
    local width = f:getWidth(m.text)
    m.x = p.x - width / 2
    m.y = p.y - p.h - f:getHeight() - 8
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
    love.audio.play(switchSnd)
  end

  -- check for death conditions
  if w:enemyAt(p.x) then
    w:onPlayerDeath(context)
  end
  
  if m then
    m:update(dt)
  end

  w:update(dt)
  w:scriptUpdate(context, dt)

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
