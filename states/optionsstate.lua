local module = require('hug.module')
local textrender = require('textrender')
local gamestate = require('hug.gamestate')

local uiscene = require('ui.scene')
local uistackpanel = require('ui.stackpanel')
local uibutton = require('ui.button')

local optionsstate = setmetatable({}, { __index = gamestate })
local mt = { __index = optionsstate }

function optionsstate.new()
  local instance = {
    transparent = true,
    ui          = uiscene.new()
  }

  local sp = uistackpanel.new()
  sp.x = 0
  sp.y = 0
  sp.w = 200
  sp.h = 400

  local modes = love.window.getFullscreenModes(display)

  for i=1,#modes do
    local mode = modes[i]
    local btn  = uibutton.new()
    btn.text = string.format('%d x %d', mode.width, mode.height)
    btn.events.click:add(function()
      love.window.setMode(mode.width, mode.height)
    end)
    sp:addchild(btn)
  end

  local backbtn = uibutton.new()
  backbtn.text = "Back"
  backbtn.events.click:add(function()
    instance:sm():pop()
  end)
  backbtn.x = 400
  backbtn.y = 100
  backbtn.w = 100
  backbtn.h = 40

  instance.ui:addchild(sp)
  instance.ui:addchild(backbtn)

  return setmetatable(instance, mt)
end

function optionsstate:mousepressed(x, y, button)
  self.ui:mousepressed(x, y, button)
end

function optionsstate:mousereleased(x, y, button)
  self.ui:mousereleased(x, y, button)
end

function optionsstate:update(dt)
  self.ui:update(dt)
  return true
end

function optionsstate:draw()
  self.ui:draw()
end

return optionsstate
