local lazy = {}
local mt = { __index = lazy }

function lazy.new(factory)
  local instance = {
    factory = factory
  }
  return setmetatable(instance, mt)
end

function lazy:get()
  if self.value == nil then
    self.value = self.factory()
  end
  return self.value
end

return lazy