local switch = {}

function switch.new(owner, name, x, ud, gvar)
  local instance = {
    owner  = owner,
    name   = name,
    x      = x,
    w      = 16,
    ud     = ud,
    gvar   = gvar,
    status = false
  }
  return setmetatable(instance, { __index = switch })
end

function switch:draw()
  local g  = love.graphics
  local y  = self.owner:y(self.x)
  local h  = self.status and 2 or 8
  g.rectangle('fill', self.x - self.w / 2, y - h, self.w, h)
end

function switch:contains(x)
  local hw = self.w / 2
  return x >= self.x - hw and x <= self.x + hw
end

return switch
