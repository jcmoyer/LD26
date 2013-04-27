local mathex = {}

function mathex.lerp(v0, v1, t)
  return v0 + (v1 - v0) * t
end

return mathex
