function love.conf(t)
  t.identity = "Linewalker"
  t.version  = "11.2"
  
  t.window.title      = "Linewalker"
  t.window.width      = 800
  t.window.height     = 600
  t.window.fullscreen = false
  
  t.modules.joystick = false
  t.modules.physics = false
end
