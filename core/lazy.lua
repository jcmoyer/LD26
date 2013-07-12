local lazy = {}
local mt = { __index = lazy }

function lazy.new(factory)
  local instance = {
    factory = factory,
    wasinit = false
  }
  return setmetatable(instance, mt)
end

function lazy:get()
  if self.wasinit == false then
    self.value = self.factory()
    self.wasinit = true
  end
  return self.value
end

return lazy