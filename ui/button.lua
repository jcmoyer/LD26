local control = require('ui.control')
local event = require('ui.event')

local button = setmetatable({}, { __index = control })

function button.new()
  local instance = control.new()
  instance.hoverbackcolor = { 140, 140, 140 }
  instance.pressedbackcolor = { 100, 100, 100 }
  instance.bordercolor = { 150, 150, 150 }
  instance.borderwidth = 2
  instance.text = 'button'
  
  instance.mousewasdown = false
  instance.mouseinbutton = false
  
  instance.events.click = event.new()
  instance.events.mouseenter:add(function()
      instance.mouseinbutton = true
    end)
  instance.events.mouseleave:add(function()
      instance.mouseinbutton = false
    end)
  instance.events.mousedown:add(function(x, y, button)
      if button == 1 then
        instance.mousewasdown = true
      end
    end)
  instance.events.mouseup:add(function()
      if instance.mousewasdown and instance.mouseinbutton then
        instance.events.click:dispatch()
      end
      instance.mousewasdown = false
    end)
  instance.events.globalmouseup:add(function()
      instance.mousewasdown = false
    end)
  
  return setmetatable(instance, { __index = button })
end

function button:draw()
  local g = love.graphics
  g.setColor(self.backcolor)
  if self.mouseinbutton then
    g.setColor(self.hoverbackcolor)
  end
  if self.mousewasdown and self.mouseinbutton then
    g.setColor(self.pressedbackcolor)
  end
  g.rectangle('fill', self.x, self.y, self.w, self.h)
  
  local textW = self.font:getWidth(self.text)
  local textH = self.font:getHeight()
  
  local centerX = self.x + (self.w / 2)
  local centerY = self.y + (self.h / 2)
  
  g.setFont(self.font)
  g.setColor(self.forecolor)
  g.print(self.text, centerX - textW / 2, centerY - textH / 2)
  
  g.setColor(self.bordercolor)
  g.setLineWidth(self.borderwidth)
  g.rectangle('line', self.x, self.y, self.w, self.h)
end

return button