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
  900, 70,
  1000, 80,
  1100, 90,
  1150, 90,
  1200, 90
}
data.portals  = {
  { x = 1150, destination = 'data.puzzleworld1', dx = 0 }
}

data.regions = {
  { name = 'warning', x = 800, w = 50 }
}

data.triggers = {}
function data.triggers.onEnterRegion(context, r)
  if not context.getVar('introworld6.warning') then
    context.showMessage('you\'re finished', 5)
    context.setVar('introworld6.warning', true)
  end
end

function data.triggers.onEnter(context)
  if not context.getVar('introworld6.entered') then
    context.showMessage('there\'s no going back now', 5)
    context.setVar('introworld6.entered', true)
  end
  if context.getVar('puzzleworld1.solved') then
    context.addPortal('backtrack', -50, 'data.introworld5', 1300, true)
  end
end
return data
