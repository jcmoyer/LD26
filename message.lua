local message = {}

function message.new(text, duration)
  local instance = {
    text = text,
    duration = duration,
    color = { 255, 255, 255 },
    x = 0,
    y = 0
  }
  return setmetatable(instance, { __index = message })
end

function message:update(dt)
  self.duration = self.duration - dt
end

function message:draw()
  local g = love.graphics
  local ic = { 255 - self.color[1], 255 - self.color[2], 255 - self.color[3], 128 }

  local f = g.getFont()
  local w = f:getWidth(self.text)
  local h = f:getHeight()

  g.setColor(ic)
  -- inflate rectangle 2px on each side
  g.rectangle('fill', self.x - 2, self.y - 2, w + 4, h + 4)

  g.setColor(self.color)
  g.print(self.text, self.x, self.y)
end

function message:visible()
  return self.duration > 0
end

return message
