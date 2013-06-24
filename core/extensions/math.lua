local extensions = {}

function extensions.lerp(v0, v1, t)
  return v0 + (v1 - v0) * t
end

function extensions.clamp(x, min, max)
  if x < min then return min end
  if x > max then return max end
  return x
end

return extensions
