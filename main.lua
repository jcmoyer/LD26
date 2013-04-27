local player = require('player')
local world = require('world')
local camera = require('camera')
local mathex = require('mathex')

local p = player.new()
local w = world.new('data.introworld')
local c = camera.new(800, 600)

function love.load()
end

function love.draw()
  local g = love.graphics
  g.clear()

  g.translate(c.x, c.y)
  w:draw()
  p:draw()
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

  c:panCenter(p.x, p.y, dt)
end
