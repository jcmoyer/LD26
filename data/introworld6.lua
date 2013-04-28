local data = {}
data.background = { 150, 150, 150 }
data.lines = {
  -100, 0,
  0, 0,
  100, 10,
  200, 20,
  300, 30,
  400, 30,
  500, 40,
  600, 50,
  700, 60,
  800, 60,
  800, 1000,
  1000, 1000
}

data.portals  = {
  { x = 900, destination = 'data.puzzleworld1', dx = 0 }
}

data.triggers = {}
function data.triggers.onEnter(context)
  if not context.getVar('introworld6.entered') then
    context.showMessage('there\'s no going back now', 5)
    context.setVar('introworld6.entered')
  end
end
return data
