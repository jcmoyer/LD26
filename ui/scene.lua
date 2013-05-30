local scene = {}

function scene.new()
  local instance = {
    children = {},
    
    lastmx = 0,
    lastmy = 0,
    lasthit = nil
  }
  return setmetatable(instance, { __index = scene })
end

function scene:update(dt)
  local newmx = love.mouse.getX()
  local newmy = love.mouse.getY()
  local mmove = false
  if newmx ~= lastmx or newmy ~= lastmy then
    mmove = true
  end
  
  local hit
  for i = 1, #self.children do
    local child = self.children[i]
    hit = child:hittest(newmx - child.x, newmy - child.y)
    
    if hit then
      if hit == self.lasthit then
        hit.events.mousemove:dispatch()
      else
        if self.lasthit then
          self.lasthit.events.mouseleave:dispatch()
        end
        hit.events.mouseenter:dispatch()
        self.lasthit = hit
      end
    end
    
    child:update(dt)
  end
  if not hit and self.lasthit then
    self.lasthit.events.mouseleave:dispatch()
    self.lasthit = nil
  end
  
  lastmx = newmx
  lastmy = newmy
end

function scene:draw()
  for i = 1, #self.children do
    self.children[i]:draw()
  end
end

function scene:mousepressed(x, y, button)
  for i = 1, #self.children do
    local child = self.children[i]
    local hit = child:hittest(x - child.x, y - child.y)
    if hit then
      hit.events.mousedown:dispatch(x, y, button)
    end
    
    child:dispatcheventrecursive('globalmousedown', x, y, button)
  end
end

function scene:mousereleased(x, y, button)
  for i = 1, #self.children do
    local child = self.children[i]
    local hit = child:hittest(x - child.x, y - child.y)
    if hit then
      hit.events.mouseup:dispatch(x, y, button)
    end
    
    child:dispatcheventrecursive('globalmouseup', x, y, button)
  end
end

function scene:keypressed(key, unicode)
end

function scene:keyreleased(key, unicode)
end

function scene:addchild(a)
  table.insert(self.children, a)
end

return scene