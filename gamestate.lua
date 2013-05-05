local gamestate = {}

gamestate.isgamestate = true

function gamestate.new()
  local instance = {}
  return setmetatable(instance, { __index = gamestate })
end

function gamestate:onEnter(oldstate)
end

function gamestate:onLeave(newstate)
end

function gamestate:keypressed(key, unicode)
end

function gamestate:update(dt)
end

function gamestate:draw()
end

function gamestate:sm(who)
  if who then
    self.sm = who
  end
  return self.sm
end

return gamestate