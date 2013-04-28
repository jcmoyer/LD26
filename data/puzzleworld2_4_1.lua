local data = {}
data.lines = {
  0, 0,
  62, 0,
  125, 0,
  187, 0,
  250, 0,
  375, 0,
  500, 0
}
data.portals = {
  { x = 62, destination = 'data.puzzleworld2', dx = 612 }
}

data.triggers = {}
function data.triggers.onEnter(context)
  context.showMessage('nothing to see here', 5)
end

return data
