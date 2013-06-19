local portal = {}

function portal.new(owner, name, x, destination, dx, color)
  local instance = {
    owner = owner,
    name = name,
    destination = destination,
    x = x,
    w = 64,
    h = 96,
    y = owner:y(x),
    dx = dx,
    color = color
  }
  return setmetatable(instance, { __index = portal })
end

function portal:draw()
  local g = love.graphics

  g.setColor(self.color)
  
  local w = self.w
  local h = self.h
  g.rectangle('fill', self.x - w / 2, self.y - h, w, h)
end

function portal:contains(x)
  local w = self.w
  return x >= self.x - w / 2 and x <= self.x + w / 2
end

return portal
