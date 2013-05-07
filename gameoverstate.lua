local gamestate = require('gamestate')
local gameoverstate = gamestate.new()

local gameoverFont
local gameoverSubFont

function gameoverstate.new(message)
  local instance = {
    message = message
  }
  return setmetatable(instance, { __index = gameoverstate })
end

function gameoverstate:onEnter()
  if not gameoverFont then
    gameoverFont = love.graphics.newFont(36)
  end
  if not gameoverSubFont then
    gameoverSubFont = love.graphics.newFont(16)
  end
end

function gameoverstate:draw()
  local g = love.graphics
  local w = g.getWidth()
  local h = g.getHeight()
  local message = 'Thanks for playing!'
  local submessage = 'Made for LD26 :: https://github.com/jcmoyer'
  local mh = gameoverFont:getHeight()
  local mw = gameoverFont:getWidth(message)
  local sw = gameoverSubFont:getWidth(submessage)

  local udsw = gameoverSubFont:getWidth(self.message)

  g.setFont(gameoverFont)
  g.print(message, w / 2 - mw / 2, h / 2 - mh / 2)

  g.setFont(gameoverSubFont)
  g.print(submessage, w / 2 - sw / 2, h / 2 - mh / 2 + mh + 8)
  g.print(self.message, w / 2 - udsw / 2, h / 3)
end

return gameoverstate