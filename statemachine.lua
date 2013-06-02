local statemachine = {}

function statemachine.new()
  local instance = {
    states = {}
  }
  return setmetatable(instance, { __index = statemachine })
end

function statemachine:forVisible(f)
  local i = #self.states + 1
  local s
  if i > 0 then
    -- find the top-most concrete state
    repeat
      i = i - 1
      s = self.states[i]
    until not s.transparent or i < 1
    
    -- apply f to each state from that point upwards
    for i = i, #self.states do
      f(self.states[i])
    end
  end
end

function statemachine:update(dt)
  self:forVisible(function(s)
    s:update(dt)
  end)
end

function statemachine:draw()
  local g = love.graphics
  
  self:forVisible(function(s)
    g.push()
    s:draw()
    g.pop()
  end)
end

function statemachine:keypressed(key, unicode)
  self:forVisible(function(s)
    s:keypressed(key, unicode)
  end)
end

function statemachine:keyreleased(key)
  self:forVisible(function(s)
    s:keyreleased(key)
  end)
end

function statemachine:mousepressed(x, y, button)
  self:forVisible(function(s)
    s:mousepressed(x, y, button)
  end)
end

function statemachine:mousereleased(x, y, button)
  self:forVisible(function(s)
    s:mousereleased(x, y, button)
  end)
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
end

function statemachine:pop()
  local popped = table.remove(self.states, newstate)
  
  if popped then
    popped:onLeave(newstate)
  end
  self:top():onEnter(popped)
  
  return popped
end

return statemachine