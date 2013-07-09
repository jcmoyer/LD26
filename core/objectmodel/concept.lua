local concept = {}
local mt      = { __index = concept }

function concept.new(t)
  return setmetatable(t, mt)
end

function concept:isconcept()
  return getmetatable(self) == mt
end

function concept:check(t)
  return pcall(concept.enforce, self, t)
end

function concept:enforce(t)
  for k,v in pairs(self) do
    local tktype = type(t[k])
    
    if tktype ~= v.type and v.optional ~= true then
      error(k .. ' is not supported by this table')
    end
    
    -- enforce nested concepts
    if tktype == 'table' and concept.isconcept(v.concept) then
      v.concept:enforce(t[k])
    end
    
    if type(v.rule) == 'function' and not v.rule(t[k]) then
      error(k .. ': rule was not satisfied')
    end
  end
end

concept.constructible = concept.new({
  new = {
    type = 'function'
  }
})

return concept