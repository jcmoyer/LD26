local portal = {}

function portal.new(owner, x, destination, dx)
  local instance = {
    owner = owner,
    destination = destination,
    x = x,
    y = owner:y(x),
    dx = dx
  }
  return setmetatable(instance, { __index = portal })
end

function portal:width()
  return 64
end

function portal:height()
  return 96
end

function portal:draw()
  local g = love.graphics
  g.setColor(160, 160, 240)
  
  local w = self:width()
  local h = self:height()
  g.rectangle('fill', self.x - w / 2, self.y - h, w, h)
end

function portal:contains(x)
  local w = self:width()
  return x >= self.x - w / 2 and x <= self.x + w / 2
end

return portal
