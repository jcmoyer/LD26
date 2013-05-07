local menu = require('menu')
local sound = require('sound')
local world = require('world')
local camera = require('camera')
local mathex = require('mathex')
local gamecontext = require('gamecontext')
local playstate = require('playstate')
local gamestate = require('gamestate')
local menustate = gamestate.new()

local datafiles = love.filesystem.enumerate('data')
local headerfont = love.graphics.newFont(48)
local font = love.graphics.newFont(18)

function menustate.new()
  local g = love.graphics
  local instance = setmetatable({}, { __index = menustate })
  instance.currentworld = nil
  instance.camera = camera.new(g.getWidth(), g.getHeight())
  instance.x = 0
  instance.menu = menu.new(font)
  instance.menu.x = g.getWidth() / 2
  instance.menu.y = g.getHeight() / 2
  instance.menu:add('Start', function()
    instance:sm():changeState(playstate.new())
  end)
  instance.menu:add('Exit', function()
    love.event.quit()
  end)
  instance:setRandomWorld()
  return instance
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

function menustate:update(dt)
  self.camera:update(dt)
  
  self.camera:panCenter(self.x, self.currentworld:y(self.x) - 100, dt)
  self.x = self.x + 50 * dt
  
  if self.x > self.currentworld:right() then
    self:setRandomWorld()
  end
end

function menustate:draw()
  local g = love.graphics
  g.setBackgroundColor(self.currentworld.background)
  g.clear()
  
  g.translate(self.camera:calculatedX(), self.camera:calculatedY())
  self.currentworld:draw()
  
  -- reverse the translation to draw the overlay
  g.translate(-self.camera:calculatedX(), -self.camera:calculatedY())
  drawHeader()
  self.menu:draw()
end

function menustate:setRandomWorld()
  local lastname = currentworld and currentworld.name or nil
  local emptycontext = gamecontext.new()
  repeat
    self.currentworld = world.new(pickWorldName(), emptycontext)
  until self.currentworld.name ~= lastname
  self.x = self.currentworld:left()
  self.camera:center(self.x, self.currentworld:y(self.x) - 100)
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

function pickWorldName()
  local worldnames = {}
  for i = 1, #datafiles do
    local _, _, name = datafiles[i]:find('([%a%d_]+)%.lua$')
    if name then
      worldnames[#worldnames + 1] = name
    end
  end
  return 'data.' .. worldnames[math.random(#worldnames)]
end

return menustate