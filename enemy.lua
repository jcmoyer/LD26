local enemy = {}

function calculatePixelSize(e)
  return e.size * 32, e.size * 32
end

function enemy.new(owner, x, patrol)
  local instance = {
    owner = owner,
    x = x,
    size = 1,
    patrol = patrol,
    direction = 'right'
  }
end

function enemy:update(dt)
  if self.direction = 'right' then
    self.x = self.x + dt * 150
    if self.x >= patrol.right then
      self.direction = 'left'
    end
  elseif self.direction = 'left' then
    self.x = self.x - dt * 150
    if self.x <= patrol.left then
      self.direction = 'right'
    end
  end
end

function enemy:draw()
  local g = love.graphics
  local y = owner:y(x)
  local w, h = calculatePixelSize(self)
  local hw = w / 2
  g.polygon('fill', self.x, y, self.x - hw, y - h, self.x + hw, y - h)
end

function enemy:contains(x)
  local w, _ = calculatePixelSize(self)
  return x >= self.x - w / 2 and x <= self.x + w / 2
end

return enemy
