local statemachine = {}
local mt = { __index = statemachine }

function statemachine.new()
  local instance = {
    states = {},
    base = 0
  }
  return setmetatable(instance, mt)
end

function statemachine:findBaseState()
  local i = #self.states + 1
  local s
  if i > 0 then
    -- find the top-most concrete state
    repeat
      i = i - 1
      s = self.states[i]
    until not s.transparent or i < 1
    self.base = math.max(i, 1)
  end
end

function statemachine:update(dt)
  for i = #self.states, self.base, -1 do
    if not self.states[i]:update(dt) then return end
  end
end

function statemachine:draw()
  local g = love.graphics
  for i = self.base, #self.states do
    g.push()
    self.states[i]:draw()
    g.pop()
  end
end

function statemachine:keypressed(key, unicode)
  for i = #self.states, self.base, -1 do
    if not self.states[i]:keypressed(key, unicode) then return end
  end
end

function statemachine:keyreleased(key)
  for i = #self.states, self.base, -1 do
    if not self.states[i]:keyreleased(key) then return end
  end
end

function statemachine:mousepressed(x, y, button)
  for i = #self.states, self.base, -1 do
    if not self.states[i]:mousepressed(x, y, button) then return end
  end
end

function statemachine:mousereleased(x, y, button)
  for i = #self.states, self.base, -1 do
    if not self.states[i]:mousereleased(x, y, button) then return end
  end
end

function statemachine:any()
  return #self.states > 0
end

function statemachine:top()
  return self.states[#self.states]
end

function statemachine:push(newstate)
  if not newstate.isgamestate then
    error('newstate is not a gamestate')
  end
  
  local oldstate = self:top()
  
  newstate:sm(self)
  table.insert(self.states, newstate)
  
  if oldstate then
    oldstate:onLeave(newstate)
  end
  newstate:onEnter(oldstate)
  
  self:findBaseState()
end

function statemachine:pop()
  local popped = table.remove(self.states, newstate)
  
  if popped then
    popped:onLeave(newstate)
  end
  self:top():onEnter(popped)
  
  self:findBaseState()
  
  return popped
end

return statemachine