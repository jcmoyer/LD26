local statemachine = require('statemachine')
local menustate = require('menustate')
local timerpool = require('timerpool')

local sm = statemachine.new()

function love.load(args)
  sm:changeState(menustate.new())
end

function love.draw()
  sm:draw()
end

function love.update(dt)
  timerpool.update(dt)
  sm:update(dt)
end

function love.keypressed(key, unicode)
  sm:keypressed(key, unicode)
end

function love.keyreleased(key, unicode)
  sm:keyreleased(key)
end

function love.mousepressed(x, y, button)
  sm:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
  sm:mousereleased(x, y, button)
end