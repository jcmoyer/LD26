local lazy = {}

function lazy.new(factory)
  local instance = {
    factory = factory
  }
  return setmetatable(instance, { __index = lazy })
end

function lazy:get()
  if self.value == nil then
    self.value = self.factory()
  end
  return self.value
end

return lazy