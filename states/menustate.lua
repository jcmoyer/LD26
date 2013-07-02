local fontpool = require('core.fontpool')
local sound = require('sound')
local world = require('world')
local camera = require('core.camera')
local gamecontext = require('gamecontext')
local timerpool = require('core.timerpool')
local playstate = require('states.playstate')
local gamestate = require('core.gamestate')

local uiscene = require('ui.scene')
local uistackpanel = require('ui.stackpanel')
local uibutton = require('ui.button')

local menustate = setmetatable({}, { __index = gamestate })

local headerfont = fontpool.get(48)

local function pickWorldName()
  local worldnames = world.getNames()
  return worldnames[math.random(#worldnames)]
end

local function drawHeader()
  local g = love.graphics
  local text = g.getCaption()
  local w = headerfont:getWidth(text)
  local h = headerfont:getHeight()
  g.setColor(255, 255, 255)
  g.setFont(headerfont)
  g.print(text, g.getWidth() / 2 - w / 2, g.getHeight() / 6 - h / 2)
end

function menustate.new()
  local g = love.graphics
  local instance = setmetatable({}, { __index = menustate })
  instance.currentworld = nil
  instance.fadeintimer = nil
  instance.fadeouttimer = nil
  instance.camera = camera.new(g.getWidth(), g.getHeight())
  instance.x = 0
  
  -- ui code
  local ui = uiscene.new()
  local stackpanel = uistackpanel.new()
  stackpanel.x = g.getWidth() / 2 - 75
  stackpanel.y = g.getHeight() / 2 - 50
  stackpanel.w = 150
  stackpanel.h = 100
  local btnstart = uibutton.new()
  btnstart.text = "Start"
  btnstart.events.click:add(function()
      sound.restart(sound.selection)
      instance:sm():push(playstate.new())
    end)
  local btnexit = uibutton.new()
  btnexit.text = "Exit"
  btnexit.events.click:add(function()
      sound.restart(sound.selection)
      love.event.quit()
    end)
  stackpanel:addchild(btnstart)
  stackpanel:addchild(btnexit)
  ui:addchild(stackpanel)
  instance.ui = ui
  -- end ui code
  
  return instance
end

function menustate:onEnter()
  self:setRandomWorld()
end

function menustate:mousepressed(x, y, button)
  self.ui:mousepressed(x, y, button)
end

function menustate:mousereleased(x, y, button)
  self.ui:mousereleased(x, y, button)
end

function menustate:update(dt)
  self.ui:update(dt)
  
  self.camera:update(dt)
  
  self.camera:panCenter(self.x, self.currentworld:y(self.x) - 100, dt)
  self.x = self.x + 50 * dt
  
  if self.x > self.currentworld:right() then
    if (not self.fadeouttimer or self.fadeouttimer.finished()) then
      self.fadeouttimer = timerpool.start(3, function()
        self:setRandomWorld()
      end)
    end
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
  
  if self.fadeintimer then
    local a = math.lerp(0, 255, self.fadeintimer.getRemaining() / self.fadeintimer.getDuration())
    a = math.clamp(a, 0, 255)
    g.setColor(0, 0, 0, a)
    g.rectangle('fill', 0, 0, g.getWidth(), g.getHeight())
  end
  if self.fadeouttimer and not self.fadeouttimer.finished() then
    local a = math.lerp(255, 0, self.fadeouttimer.getRemaining() / self.fadeouttimer.getDuration())
    a = math.clamp(a, 0, 255)
    g.setColor(0, 0, 0, a)
    g.rectangle('fill', 0, 0, g.getWidth(), g.getHeight())
  end
  
  -- maybe only a temporary solution
  g.setColor(0, 0, 0, 96)
  g.rectangle('fill', 0, 0, g.getWidth(), g.getHeight())
  
  drawHeader()
  
  g.push()
  self.ui:draw()
  g.pop()
end

function menustate:setRandomWorld()
  local lastname = self.currentworld and self.currentworld.name or nil
  local newname
  local emptycontext = gamecontext.new()
  repeat
    newname = pickWorldName()
  until newname ~= lastname
  self.currentworld = world.new(newname, emptycontext)
  self.x = self.currentworld:left()
  self.camera:center(self.x, self.currentworld:y(self.x) - 100)
  self.fadeintimer = timerpool.start(3)
end

return menustate