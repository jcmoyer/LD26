local uiscene = require('ui.scene')
local uibutton = require('ui.button')
local uistackpanel = require('ui.stackpanel')
local sound = require('sound')

local gamestate = require('core.gamestate')
local playmenustate = setmetatable({}, { __index = gamestate })
playmenustate.mt = { __index = playmenustate }

function playmenustate.new()
  local instance = {
    transparent = true
  }

  -- ui code
  local ui = uiscene.new()
  local stackpanel = uistackpanel.new()
  stackpanel.x = love.graphics.getWidth() / 2 - 75
  stackpanel.y = love.graphics.getHeight() / 2 - 75
  stackpanel.w = 150
  stackpanel.h = 150
  local btnstart = uibutton.new()
  btnstart.text = "Continue"
  btnstart.events.click:add(function()
      sound.restart(sound.selection)
      instance:sm():pop()
    end)
  local btnmenu = uibutton.new()
  btnmenu.text = "Main Menu"
  btnmenu.events.click:add(function()
      sound.restart(sound.selection)
      instance:sm():pop()
      instance:sm():pop()
    end)
  local btnexit = uibutton.new()
  btnexit.text = "Exit"
  btnexit.events.click:add(function()
      sound.restart(sound.selection)
      love.event.quit()
    end)
  stackpanel:addchild(btnstart)
  stackpanel:addchild(btnmenu)
  stackpanel:addchild(btnexit)
  ui:addchild(stackpanel)
  instance.ui = ui
  -- end ui code
  
  instance.ui = ui
  
  return setmetatable(instance, playmenustate.mt)
end

function playmenustate:keypressed(key, unicode)
  if key == 'escape' then
    self:sm():pop()
  end
  
  self.ui:keypressed(key, unicode)
end

function playmenustate:mousepressed(x, y, button)
  self.ui:mousepressed(x, y, button)
end

function playmenustate:mousereleased(x, y, button)
  self.ui:mousereleased(x, y, button)
end

function playmenustate:update(dt)
  self.ui:update(dt)
end

function playmenustate:draw()
  local g = love.graphics
  g.setColor(0, 0, 0, 128)
  g.rectangle('fill', 0, 0, g.getWidth(), g.getHeight())
  
  self.ui:draw()
end

return playmenustate