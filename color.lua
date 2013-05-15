local color = {}

function color.invert(r, g, b, a)
  if type(r) == 'table' then
    return { 255 - r[1], 255 - r[2], 255 - r[3], r[4] }
  else
    return 255 - r, 255 - g, 255 - b, a
  end
end

return color