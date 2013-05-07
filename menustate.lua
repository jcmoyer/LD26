local menu = require('menu')
local sound = require('sound')
local playstate = require('playstate')
local gamestate = require('gamestate')
local menustate = gamestate.new()

local headerfont = love.graphics.newFont(48)
local font = love.graphics.newFont(18)

function menustate.new()
  local instance = {
    menu = menu.new(font)
  }
  instance.menu.x = love.graphics.getWidth() / 2
  instance.menu.y = love.graphics.getHeight() / 2
  instance.menu:add('Start', function()
    instance:sm():changeState(playstate.new())
  end)
  instance.menu:add('Exit', function()
    love.event.quit()
  end)
  return setmetatable(instance, { __index = menustate })
end

function menustate:keypressed(key)
  if key == 'up' then
    if self.menu:selectPrev() then
      sound.restart(sound.selection)
    end
  elseif key == 'down' then
    if self.menu:selectNext() then
      sound.restart(sound.selection)
    end
  elseif key == 'return' then
    sound.restart(sound.selection)
    self.menu:executeCallback()
  end
end

function menustate:draw()
  drawHeader()
  self.menu:draw()
end

function drawHeader()
  local g = love.graphics
  local text = g.getCaption()
  local w = headerfont:getWidth(text)
  local h = headerfont:getHeight()
  g.setColor(255, 255, 255)
  g.setFont(headerfont)
  g.print(text, love.graphics.getWidth() / 2 - w / 2, love.graphics.getHeight() / 6 - h / 2)
end

return menustate