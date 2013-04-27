local player = require('player')
local world = require('world')
local camera = require('camera')
local mathex = require('mathex')
local message = require('message')

local p = player.new()
local w = world.new('data.introworld')
local c = camera.new(800, 600)

local m = message.new("Test", 5)

function love.load()
  love.graphics.setFont(love.graphics.newFont(18))
end

function love.draw()
  local g = love.graphics
  g.setBackgroundColor(w.background)
  g.clear()

  g.translate(c.x, c.y)
  w:draw()

  p.color = w:oppositeColor()
  p:draw()

  if m:visible() then
    m.color = w:oppositeColor()

    local f = g.getFont()
    local width = f:getWidth(m.text)
    m.x = p.x - width / 2
    m.y = p.y - p.h - f:getHeight() - 8
    m:draw()
  end
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
  m:update(dt)

  c:panCenter(p.x, p.y, dt)
end

function love.keypressed(key, unicode)
  if key == 'up' then
    local portal = w:portalAt(p.x)
    if portal then
      enteredportal = true
      p.x = portal.dx
      if portal.destination ~= w.name then
        w = world.new(portal.destination)
        -- Instant pan when the world is different
        p.x = mathex.clamp(p.x, w:left(), w:right())
        p.y = w:y(p.x)
        c:center(p.x, p.y)
      end
    end
  end
end
