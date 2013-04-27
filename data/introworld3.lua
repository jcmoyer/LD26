local data = {}

data.background = { 215, 215, 215 }

data.lines = {
  0, 300,
  100, 300,
  200, 250,
  300, 250,
  400, 200,
  500, 200,
  600, 150,
  700, 150,
  800, 100,
  900, 100,
  1000, 50,
  1100, 50,
  1200, 0,
  1300, 0
}

data.portals = {
  { x = 650 , destination = 'data.iw3r1'      , dx = 650 },
  { x = 1250, destination = 'data.introworld3', dx = 50 }
}

data.regions = {
  { name = 'question', x = 650, w = 20 }
}

data.triggers = {}

function data.triggers.onEnter(context)
  context.showMessage('don\'t you know it\s dangerous?', 10)
end

local r_question_triggered = false
function data.triggers.onEnterRegion(context, r)
  if (r.name == 'question' and not question_triggered) then
    context.showMessage('just go away', 10)
    r_question_triggered = true
  end
end

function data.triggers.onEnterPortal(context, p)
  if p.destination == 'data.introworld3' then
    if context.getVar('introworld3.continue') then
      context.changeWorld('data.introworld4', 50)
      return false
    end
  end
  return true
end

return data
