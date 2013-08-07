local sound = {}

local newSource = love.audio.newSource
local exists = love.filesystem.exists

local soundlist = {
  switch  = 'data/switch.ogg',
  portal  = 'data/Portal.ogg',
  shift05 = 'data/Shifting05.ogg',
  shift10 = 'data/Shifting10.ogg',
  shift15 = 'data/Shifting15.ogg',
  shift20 = 'data/Shifting20.ogg',
  death   = 'data/death.ogg',
  selection = 'data/select.ogg',
  
  squareC2 = 'data/squareC2.ogg',
  squareC3 = 'data/squareC3.ogg',
  squareC4 = 'data/squareC4.ogg',
  squareC5 = 'data/squareC5.ogg'
}

for k,v in pairs(soundlist) do
  if exists(v) then
    sound[k] = newSource(v, 'static')
  end
end

function sound.tryPlay(snd)
  if snd then
    snd:play()
  end
end

function sound.restart(snd)
  if snd then
    snd:stop()
    snd:play()
  end
end

function sound.pickShiftingSound(magnitude)
  if magnitude < 5 then
    return sound.shift05
  elseif magnitude < 10 then
    return sound.shift10
  elseif magnitude < 15 then
    return sound.shift15
  else
    return sound.shift20
  end    
end

return sound