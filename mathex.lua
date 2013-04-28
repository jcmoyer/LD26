local mathex = {}

function mathex.lerp(v0, v1, t)
  return v0 + (v1 - v0) * t
end

function mathex.clamp(x, min, max)
  if x < min then return min end
  if x > max then return max end
  return x
end

return mathex
