local portal = {}

function portal.new(owner, name, x, destination, dx)
  local instance = {
    owner = owner,
    name = name,
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

  local cr, cg, cb = g.getColor()
  g.setColor(cr * 0.8, cg * 0.8, cb * 0.8)
  
  local w = self:width()
  local h = self:height()
  g.rectangle('fill', self.x - w / 2, self.y - h, w, h)
end

function portal:contains(x)
  local w = self:width()
  return x >= self.x - w / 2 and x <= self.x + w / 2
end

return portal
