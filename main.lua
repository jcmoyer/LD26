local statemachine = require('statemachine')
local menustate = require('menustate')

local sm = statemachine.new()

function love.load(args)
  sm:changeState(menustate.new())
end

function love.draw()
  sm:draw()
end

function love.update(dt)
  sm:update(dt)
end

function love.keypressed(key, unicode)
  sm:keypressed(key, unicode)
end
