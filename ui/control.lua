local event = require('ui.event')
local control = {}

local defaultFont = love.graphics.newFont()

function control.new(x, y, w, h)
  local instance = {
    x = x or 0,
    y = y or 0,
    w = w or 100,
    h = h or 32,
    visible = true,
    focusable = false,
    focused = false,
    backcolor = { 128, 128, 128 },
    forecolor = { 255, 255, 255 },
    text = 'control',
    
    font = defaultFont,
    
    events = {
      click = event.new(),
      
      mousedown = event.new(),
      mouseup = event.new(),
      mousemove = event.new(),
      mouseenter = event.new(),
      mouseleave = event.new(),
      
      globalmouseup = event.new(),
      globalmousedown = event.new()
    },
    children = {}
  }
  return setmetatable(instance, { __index = control })
end

function control:update(dt)
end

-- Extremely primitive rendering
function control:draw()
  if not self.visible then
    return
  end
  
  local g = love.graphics
  g.setColor(self.backcolor)
  g.rectangle('fill', self.x, self.y, self.w, self.h)
  
  for i = 1, #self.children do
    self.children[i]:draw()
  end
end

function control:mousepressed(x, y, button)
end

function control:mousereleased(x, y, button)
end

function control:keypressed(key, unicode)
end

function control:keyreleased(key, unicode)
end

function control:layout()
end

function control:addchild(a)
  table.insert(self.children, a)
  self:layout()
end

-- Returns nil if no child could be found at the hittest point. Otherwise, this
-- function will recursively find the deepest nested control that was hit and
-- return it. If no nested control was found in the hittest and the point was
-- within the bounds of this control, this control will be returned instead.
function control:hittest(x, y)
  for i = 1, #self.children do
    local child = self.children[i]
    if x >= child.x and x <= child.x + child.w and y >= child.y and y <= child.y + child.h then
      return child:hittest(x - child.x, y - child.y)
    end
  end
  -- x and y are already in client coordinates
  if x >= 0 and x <= self.w and y >= 0 and y <= self.h then
    return self
  end
end

function control:dispatcheventrecursive(name, ...)
  self.events[name]:dispatch(...)
  for i = 1, #self.children do
    self.children[i]:dispatcheventrecursive(name, ...)
  end
end

return control