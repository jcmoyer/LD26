local data = {}

data.background = { 0.8, 0.8, 0.8 }

data.lines = {
  270, 387,
  320, 387,
  364, 387,
  418, 394,
  472, 401,
  501, 398,
  530, 395,
  628, 391,
  748, 398,
  810, 401,
  866, 401,
  926, 396,
  984, 396,
  1048, 396,
  1164, 401,
  1328, 398,
  1376, 399,
  1454, 397,
  1498, 392,
  1534, 390,
  1730, 391,
  1832, 389,
  1898, 398,
  1926, 403,
  1952, 408,
  2032, 412,
  2130, 411,
  2170, 411,
  2250, 399,
  2285, 403,
  2318, 412,
  2424, 412
}

data.portals = {
  { x = 320 , destination = 'start'      , dx = 306 },
  { x = 984 , destination = 'emptyroom'  , dx = 50  },
  { x = 2371, destination = 'introworld2', dx = 50  }
}

data.triggers = {}

function data.triggers.onEnter(context)
  if not context.getVar('introworld.entered') then
    context.showMessage('hey', 5)
    context.setVar('introworld.entered', true)
  end
end

return data
