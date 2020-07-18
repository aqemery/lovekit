require('./other')
 



function love.load()
	chunk = love.filesystem.load("other.lua")
	local result = chunk()
	love.load()
end

function love.draw()
	love.graphics.circle( "fill", 100, 100, 10 )
end