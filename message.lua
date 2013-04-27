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
  g.setColor(self.color)
  g.print(self.text, self.x, self.y)
end

function message:visible()
  return self.duration > 0
end

return message
