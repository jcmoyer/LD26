local player = require('player')
local world = require('world')
local camera = require('camera')
local mathex = require('mathex')
local message = require('message')
local gamecontext = require('gamecontext')

local p = player.new()
local w = nil
local c = camera.new(800, 600)

local m = nil
local lastregion = nil

function makecontext()
  local ctx = gamecontext.new()
  function ctx.showMessage(text, duration)
    m = message.new(text, duration)
  end
  function ctx.changeWorld(name, x)
    changeworld(name)
    p.x = x or p.x
  end
  function ctx.addPortal(x, d, dx)
    w:addPortal(x, d, dx)
  end
  function ctx.addRegion(name, x, width)
    w:addRegion(name, x, width)
  end
  return ctx
end

function changeworld(name)
  w = world.new(name)
  w:onEnter(makecontext())
end

function love.load()
  love.graphics.setFont(love.graphics.newFont(18))
  changeworld('data.introworld')
end

function love.draw()
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

  w:scriptDraw(makecontext())
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
      w:onEnterRegion(makecontext(), r)
    end
    lastregion = r
  end
  
  if m then
    m:update(dt)
  end

  w:scriptUpdate(makecontext(), dt)

  c:panCenter(p.x, p.y, dt)
end

function love.keypressed(key, unicode)
  if key == 'up' then
    local portal = w:portalAt(p.x)
    if portal then
      enteredportal = true
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
