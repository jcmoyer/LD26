local fontpool = require('fontpool')
local sound = require('sound')
local world = require('world')
local camera = require('hug.camera')
local gamecontext = require('gamecontext')
local timerpool = require('hug.timerpool')
local playstate = require('states.playstate')
local gamestate = require('hug.gamestate')
local textrender = require('textrender')

local uiscene = require('ui.scene')
local uistackpanel = require('ui.stackpanel')
local uibutton = require('ui.button')

local setmetatable = setmetatable
local random = math.random
local graphics = love.graphics
local setBackgroundColor, clear, translate = graphics.setBackgroundColor, graphics.clear, graphics.translate
local setColor, setFont, rectangle = graphics.setColor, graphics.setFont, graphics.rectangle
local push, pop = graphics.push, graphics.pop
local getWidth, getHeight = graphics.getWidth, graphics.getHeight
local getTitle = love.window.getTitle

local mathex = require('hug.extensions.math')
local clamp, lerp = mathex.clamp, mathex.lerp

local menustate = setmetatable({}, { __index = gamestate })
local mt = { __index = menustate }

local headerfont = fontpool:get(48)

local function pickWorldName()
  local worldnames = world.getNames()
  return worldnames[random(#worldnames)]
end

local function drawHeader()
  local text = getTitle()
  local w = headerfont:getWidth(text)
  local h = headerfont:getHeight()
  setColor(1, 1, 1)
  setFont(headerfont)
  textrender.print(text, getWidth() / 2 - w / 2, getHeight() / 6 - h / 2)
end

function menustate.new()
  local instance = setmetatable({}, mt)
  instance.currentworld = nil
  instance.fadeintimer = nil
  instance.fadeouttimer = nil
  instance.camera = camera.new(getWidth(), getHeight())
  instance.x = 0
  instance.timerpool = timerpool.new()
  
  -- ui code
  local ui = uiscene.new()
  local stackpanel = uistackpanel.new()
  stackpanel.x = getWidth() / 2 - 75
  stackpanel.y = getHeight() / 2 - 50
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

function menustate:enter()
  self:setRandomWorld()
end

function menustate:mousepressed(x, y, button)
  self.ui:mousepressed(x, y, button)
end

function menustate:mousereleased(x, y, button)
  self.ui:mousereleased(x, y, button)
end

function menustate:update(dt)
  self.timerpool:update(dt)
  self.ui:update(dt)
  
  self.camera:update(dt)
  
  self.camera:pan(self.x, self.currentworld:y(self.x) - 100, dt)
  self.x = self.x + 50 * dt
  
  if self.x > self.currentworld:right() then
    if (not self.fadeouttimer or self.fadeouttimer:status() == 'finished') then
      self.fadeouttimer = self.timerpool:start(3, function()
        self:setRandomWorld()
      end)
    end
  end
end

function menustate:draw()
  setBackgroundColor(self.currentworld.background)
  clear()
  
  local cx, cy = self.camera:position()
  translate(-cx, -cy)
  self.currentworld:draw()
  
  -- reverse the translation to draw the overlay
  translate(cx, cy)
  
  if self.fadeintimer then
    local a = lerp(0, 1, self.fadeintimer:remaining() / self.fadeintimer:duration())
    a = clamp(a, 0, 1)
    setColor(0, 0, 0, a)
    rectangle('fill', 0, 0, getWidth(), getHeight())
  end
  if self.fadeouttimer and self.fadeouttimer:status() ~= 'finished' then
    local a = lerp(1, 0, self.fadeouttimer:remaining() / self.fadeouttimer:duration())
    a = clamp(a, 0, 1)
    setColor(0, 0, 0, a)
    rectangle('fill', 0, 0, getWidth(), getHeight())
  end
  
  -- maybe only a temporary solution
  setColor(0, 0, 0, 0.4)
  rectangle('fill', 0, 0, getWidth(), getHeight())
  
  drawHeader()
  

  if self:sm():top() == self then
    push()
    self.ui:draw()
    pop()
  end
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
  self.fadeintimer = self.timerpool:start(3)
end

return menustate
