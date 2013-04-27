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
  if self.status then
    g.rectangle('fill', self.x - w / 2, y - 2, w, 2)
  else
    g.rectangle('fill', self.x - w / 2, y - 8, w, 8)
  end
end

function switch:contains(x)
  local hw = 8
  return x >= self.x - hw and x <= self.x + hw
end

return switch
