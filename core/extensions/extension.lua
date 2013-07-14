local extension = {}

local type, error, pairs = type, error, pairs

-- installs the members of table 'ext' into table 't'
function extension.install(ext, t)
  if type(ext) ~= 'table' then
    error('ext must be a table')
  end
  if type(t) ~= 'table' then
    error('t must be a table')
  end
  for k,v in pairs(ext) do
    if t[k] then
      error('(extension) duplicate key: "' .. k .. '"')
    else
      t[k] = v
    end
  end
end

return extension