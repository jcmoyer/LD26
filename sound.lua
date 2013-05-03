local sound = {}

local newSource = love.audio.newSource
local stop = love.audio.stop
local play = love.audio.play

local soundlist = {
  switch  = 'data/switch.ogg',
  portal  = 'data/portal.ogg',
  shift05 = 'data/Shifting05.ogg',
  shift10 = 'data/Shifting10.ogg',
  shift15 = 'data/Shifting15.ogg',
  shift20 = 'data/Shifting20.ogg',
  death   = 'data/death.ogg',
}

for k,v in pairs(soundlist) do
  if love.filesystem.exists(v) then
    sound[k] = newSource(v, 'static')
  end
end

function sound.tryPlay(snd)
  if snd then
    play(snd)
  end
end

function sound.restart(snd)
  if snd then
    stop(snd)
    play(snd)
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