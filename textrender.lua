local textrender = {}

local print = love.graphics.print
local floor = math.floor

-- prints text with rounded x/y coordinates to avoid rendering artifacts from
-- using subpixel coordinates
function textrender.print(text, x, y)
  print(text, floor(x + 0.5), floor(y + 0.5))
end

return textrender
