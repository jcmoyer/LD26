-- facilitates the reuse of fonts instead of creating new ones
local fontpool = {}
local fonts = {}

-- https://www.love2d.org/wiki/love.graphics.newFont
--
-- TODO: Support other overloads:
--   filename, size
--   file, size
--   data, size
--
-- Since none of these overloads have been used yet, this isn't a high priority.
function fontpool.get(size)
  size = size or 12
  
  local f = fonts[size]
  if f == nil then
    f = love.graphics.newFont(size)
    fonts[size] = f
  end
  return f
end

return fontpool