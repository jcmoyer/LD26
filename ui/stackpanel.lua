local control = require('ui.control')
local stackpanel = setmetatable({}, { __index = control })

function stackpanel.new()
  return setmetatable(control.new(), { __index = stackpanel })
end

function stackpanel:draw()
  local g = love.graphics
  g.translate(self.x, self.y)
  for i = 1, #self.children do
    self.children[i]:draw()
  end
end

function stackpanel:layout()
  -- allocate a height to each child
  local ch = self.h / #self.children
  for i = 1, #self.children do
    self.children[i].x = 0
    self.children[i].y = (i - 1) * ch
    self.children[i].w = self.w
    self.children[i].h = ch
  end
end

return stackpanel
