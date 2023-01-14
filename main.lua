C = require "content"
I = require "inits"

lg = love.graphics

function love.load()
  
  M.init()
  C.init()
  
  
end

function love.update()
  
  
  
end

function love.draw()
  
  C.draw()
  
end

function love.keypressed(key, scanCode, isRepeat)
  
  C.keyPressed(key)

end
