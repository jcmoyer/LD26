local statemachine = {}

function statemachine.new()
  local instance = {
    s = nil
  }
  return setmetatable(instance, { __index = statemachine })
end

function statemachine:update(dt)
  if self.s then
    self.s:update(dt)
  end
end

function statemachine:draw()
  if self.s then
    self.s:draw()
  end
end

function statemachine:keypressed(key, unicode)
  if self.s then
    self.s:keypressed(key, unicode)
  end
end

function statemachine:changeState(newstate)
  if not newstate.isgamestate then
    error('newstate is not a gamestate')
  end
  newstate:sm(self)
  
  if self.s then
    self.s:onLeave(newstate)
  end
  newstate:onEnter(self.s)
  self.s = newstate
end

return statemachine