local data = {}
data.background = { 200, 200, 200 }

data.lines = {
  0, 0,
  100, 0,
  200, 25,
  300, 25,
  400, 0,
  500, 0,
  600, -25,
  700, -25
}

data.portals  = {
  { name = 'sp1', x = 250, destination = 'data.puzzleworld1_1', dx = 50 },
  { name = 'sp2', x = 450, destination = 'data.puzzleworld1_2', dx = -150 },
  { name = 'sp3', x = 650, destination = 'data.puzzleworld1_3', dx = 100 }
}

data.triggers = {}

local t = 0
local puzzlesLeft = 3

function data.triggers.onEnter(context)
  puzzlesLeft = 3

  if not context.getVar('puzzleworld1.entered') then
    context.showMessage("you can't leave this dimension until you've solved my puzzles!!", 10)
    context.setVar('puzzleworld1.entered', true)
  end

  if context.getVar('puzzleworld1_1.solved') then
    puzzlesLeft = puzzlesLeft - 1
  end
  if context.getVar('puzzleworld1_2.solved') then
    puzzlesLeft = puzzlesLeft - 1
  end
  if context.getVar('puzzleworld1_3.solved') then
    puzzlesLeft = puzzlesLeft - 1
  end

  if puzzlesLeft == 0 then
    context.setVar('puzzleworld1.solved', true)
    context.addPortal('next', 50, 'data.introworld6', 1150, true)
  end
end

function data.triggers.onEnterPortal(context, p)
  if p.name == 'sp2' and not context.getVar('puzzleworld1_1.solved') then
    return false
  end
  if p.name == 'sp3' and not context.getVar('puzzleworld1_2.solved') then
    return false
  end
  return true
end

function data.triggers.onUpdate(context, dt)
  -- make time flow backwards when all puzzles have been solved
  t = t + dt * 4 * (puzzlesLeft - 1)
end

function data.triggers.onDraw(context)
  local g = love.graphics
  g.circle('fill', 350, -200, 100)

  local cr, cg, cb = g.getColor()
  g.setColor(255 - cr, 255 - cg, 255 - cb)
  g.line(350, -200, 350 + math.cos(t) * 100, -200 + math.sin(t) * 100)
  g.line(350, -200, 350 + math.cos(t / 60) * 70, -200 + math.sin(t / 60) * 70)
end
return data
