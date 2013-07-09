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
    -- corresponding value in 't'
    local tv = t[k]
    local tvtype = type(tv)
    
    if tvtype ~= v.type and v.optional ~= true then
      error(k .. ' is not supported by this table')
    end
    
    -- enforce nested concepts
    if tvtype == 'table' and concept.isconcept(v.concept) then
      v.concept:enforce(tv)
    end
    
    if type(v.rule) == 'function' and v.rule(tv) == false then
      error(k .. ': rule was not satisfied')
    end
  end
end

concept.constructible = concept.new {
  new = {
    type = 'function'
  }
}

return concept