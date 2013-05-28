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
    message = message
  }
  return setmetatable(instance, { __index = gameoverstate })
end

function gameoverstate:draw()
  local g = love.graphics
  local w = g.getWidth()
  local h = g.getHeight()

  g.setFont(gameoverFont)
  g.print(message, w / 2 - messageWidth / 2, h / 2 - messageHeight / 2)

  g.setFont(gameoverSubFont)
  g.print(submessage, w / 2 - submessageWidth / 2, h / 2 - messageHeight / 2 + messageHeight + 8)
  
  if self.message then
    local udsw = gameoverSubFont:getWidth(self.message)
    g.print(self.message, w / 2 - udsw / 2, h / 3)
  end
end

return gameoverstate
