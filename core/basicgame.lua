local statemachine = require('core.statemachine')
local timerpool = require('core.timerpool')
local extension = require('core.extensions.extension')

local basicgame = {}

local sm = statemachine.new()

function basicgame.start(initialstate)  
  extension.install(require('core.extensions.math'), math)
  extension.install(require('core.extensions.table'), table)
  
  sm:push(initialstate)

  function love.load(args)
    sm:push(initialstate)
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
end

return basicgame