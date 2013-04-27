local player = require('player')
local world = require('world')

local p = player.new()
local w = world.new('data.introworld')

function love.load()
end

function love.draw()
  local g = love.graphics
  g.clear()

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
  p.y = w:y(p.x)
end
