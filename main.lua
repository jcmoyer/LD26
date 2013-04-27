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
  p.x = p.x + 1
  p.y = w:y(p.x)
end
