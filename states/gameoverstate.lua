local fontpool = require('core.fontpool')
local uiscene = require('ui.scene')
local uibutton = require('ui.button')
local sound = require('sound')
local time = require('time')

local gamestate = require('core.gamestate')
local gameoverstate = setmetatable({}, { __index = gamestate })

local gameoverFont = fontpool.get(36)
local gameoverSubFont = fontpool.get(16)

local message = 'Thanks for playing!'
local messageWidth = gameoverFont:getWidth(message)
local messageHeight = gameoverFont:getHeight()

local submessage = 'Made for LD26 :: https://github.com/jcmoyer'
local submessageWidth = gameoverSubFont:getWidth(submessage)

function gameoverstate.new(message, time)
  local instance = {
    message = message,
    time = time,
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

function gameoverstate:onEnter()
  if love.filesystem.exists('time.dat') then
    local n = love.filesystem.read('time.dat')
    self.oldtime = tonumber(n)
  end
  
  if type(self.oldtime) == 'number' and self.time < self.oldtime then
    love.filesystem.write('time.dat', tostring(self.time))
  end
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
  
  if self.time then
    local scorestr = 'Your time was ' .. time.str(self.time)
    local scorew = gameoverSubFont:getWidth(scorestr)
    g.print(scorestr, w / 2 - scorew / 2, h / 3 + 8 + gameoverSubFont:getHeight())
  end
  
  if self.oldtime ~= nil then
    local oldtimestr = 'Previous best was ' .. time.str(self.oldtime)
    local oldtimew = gameoverSubFont:getWidth(oldtimestr)
    g.print(oldtimestr, w / 2 - oldtimew / 2, h / 3 + (8 + gameoverSubFont:getHeight()) * 2)
  end
  
  self.ui:draw()
end

return gameoverstate
