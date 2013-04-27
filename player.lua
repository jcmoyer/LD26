local player = {}

function player.new()
  local instance = {
    x = 0,
    y = 0
  }
  return setmetatable(instance, { __index = player })
end

function player:draw()
  local g = love.graphics
  g.setColor(255, 255, 255)
  g.rectangle('fill', self.x, self.y, 32, 64)
end

return player
