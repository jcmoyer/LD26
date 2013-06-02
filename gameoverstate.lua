local uiscene = require('ui.scene')
local uibutton = require('ui.button')
local sound = require('sound')

local gamestate = require('gamestate')
local gameoverstate = setmetatable({}, { __index = gamestate })

local gameoverFont = love.graphics.newFont(36)
local gameoverSubFont = love.graphics.newFont(16)

local message = 'Thanks for playing!'
local messageWidth = gameoverFont:getWidth(message)
local messageHeight = gameoverFont:getHeight()

local submessage = 'Made for LD26 :: https://github.com/jcmoyer'
local submessageWidth = gameoverSubFont:getWidth(submessage)

function gameoverstate.new(message)
  local instance = {
    message = message,
    ui = uiscene.new()
  }
  
  local btnmenu = uibutton.new()
  btnmenu.text = "Main Menu"
  btnmenu.w = 100
  btnmenu.h = 50
  btnmenu.x = love.graphics.getWidth() - btnmenu.w - 32
  btnmenu.y = love.graphics.getHeight() - btnmenu.h - 32
  btnmenu.events.click:add(function()
      sound.restart(sound.selection)
      instance:sm():pop()
    end)
  instance.ui:addchild(btnmenu)
  
  return setmetatable(instance, { __index = gameoverstate })
end

function gameoverstate:mousepressed(x, y, button)
  self.ui:mousepressed(x, y, button)
end

function gameoverstate:mousereleased(x, y, button)
  self.ui:mousereleased(x, y, button)
end

function gameoverstate:update(dt)
  self.ui:update(dt)
end

function gameoverstate:draw()
  local g = love.graphics
  local w = g.getWidth()
  local h = g.getHeight()
  
  g.setBackgroundColor(0, 0, 0)
  g.clear()
  
  g.setColor(255, 255, 255)
  g.setFont(gameoverFont)
  g.print(message, w / 2 - messageWidth / 2, h / 2 - messageHeight / 2)

  g.setFont(gameoverSubFont)
  g.print(submessage, w / 2 - submessageWidth / 2, h / 2 - messageHeight / 2 + messageHeight + 8)
  
  if self.message then
    local udsw = gameoverSubFont:getWidth(self.message)
    g.print(self.message, w / 2 - udsw / 2, h / 3)
  end
  
  self.ui:draw()
end

return gameoverstate
