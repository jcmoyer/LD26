local menu = {}

function menu.new(font)
  local instance = {
    index = 1,
    items = {},
    font = font,
    normal = { 255, 255, 255 },
    selected = { 255, 255, 0 }
  }
  return setmetatable(instance, { __index = menu })
end

function menu:add(text, callback)
  self.items[#self.items + 1] = {
    text = text,
    callback = callback
  }
end

function menu:selectPrev()
  self.index = self.index - 1
  if self.index < 1 then
    self.index = 1
    return false
  else
    return true
  end
end

function menu:selectNext()
  self.index = self.index + 1
  if self.index > #self.items then
    self.index = #self.items
    return false
  else
    return true
  end
end

function menu:executeCallback()
  self.items[self.index].callback()
end

function menu:draw()
  local g = love.graphics
  local x = self.x or 0
  local y = self.y or 0
  local oneh = self.font:getHeight()
  local totalh = oneh * #self.items
  local oy = y - totalh / 2
  
  g.setFont(self.font)
  
  for i = 1, #self.items do
    local thisw = self.font:getWidth(self.items[i].text)
    if i == self.index then
      g.setColor(self.selected)
    else
      g.setColor(self.normal)
    end
    g.print(self.items[i].text, self.x - thisw / 2, oy)
    oy = oy + self.font:getHeight()
  end
end

return menu