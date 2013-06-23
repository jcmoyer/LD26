local camera = {}

function camera.new(width, height)
  local instance = {
    x = 0,
    y = 0,
    sx = 0,
    sy = 0,
    sd = 0,
    st = 0,
    sm = 0,
    w = width,
    h = height
  }
  return setmetatable(instance, { __index = camera })
end

function camera:center(x, y)
  self.x = self.w / 2 - x
  self.y = self.h / 2 - y
end

function camera:panCenter(x, y, dt)
  local cx = self.x
  local cy = self.y
  self:center(x, y)
  self.x = math.lerp(cx, self.x, dt * 3)
  self.y = math.lerp(cy, self.y, dt * 3)
end

function camera:update(dt)
  self.st = self.st - dt
  if self.st < 0 then
    self.st = 0
    self.sx = 0
    self.sy = 0
  else
    self.sx = math.random() * self.sm * (self.st / self.sd)
    self.sy = math.random() * self.sm * (self.st / self.sd)
  end
end

function camera:shake(duration, magnitude)
  self.st = duration
  self.sd = duration
  self.sm = magnitude or math.random() * 20
end

function camera:calculatedX()
  return self.x + self.sx
end

function camera:calculatedY()
  return self.y + self.sy
end

return camera
