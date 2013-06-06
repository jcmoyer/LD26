local event = {}

function event.new()
  local instance = {
    functions = {}
  }
  return setmetatable(instance, { __index = event })
end

function event:add(f)
  table.insert(self.functions, f)
end

function event:remove(f)
  for i = 1, #self.functions do
    if self.functions[i] == f then
      return table.remove(self.functions, i)
    end
  end
end

function event:dispatch(...)
  for i = 1, #self.functions do
    self.functions[i](...)
  end
end

return event