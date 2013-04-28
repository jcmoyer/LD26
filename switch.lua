local switch = {}

function switch.new(owner, name, x, ud, gvar)
  local instance = {
    owner  = owner,
    name   = name,
    x      = x,
    ud     = ud,
    gvar   = gvar,
    status = false
  }
  return setmetatable(instance, { __index = switch })
end

function switch:draw()
  local g  = love.graphics
  local w  = 16
  local y  = self.owner:y(self.x)
  local h  = self.status and 2 or 8
  g.rectangle('fill', self.x - w / 2, y - h, w, h)
end

function switch:contains(x)
  local hw = 8
  return x >= self.x - hw and x <= self.x + hw
end

return switch
