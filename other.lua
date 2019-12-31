require('./Node')
require('./Action')


nodes = {}


function love.load()

	love.window.setMode(1920/2, 1080/2, {fullscreen=false, resizable=true, highdpi=true,vsync=true})
	love.mouse.setVisible(false)

	local moveRight = Action.moveBy(300,0,3)
	local moveLeft = Action.moveBy(-300,0,3)
	local moveDown = Action.moveBy(0,100,2)
	local moveUp = Action.moveBy(0,-100,2)
	local rotateRight = Action.rotateBy(270*3,3)
	local rotateLeft = Action.rotateBy(-270*3,3)
	local wait = Action.wait(3)

	local downRotate = Action.group({moveDown, rotateRight})
	local sequence = Action.sequence({moveDown, rotateRight})
	local sequence2 = Action.sequence({moveRight, moveLeft})
	local sequence3 = Action.sequence({rotateRight, rotateLeft})



	node = Node.new()
	node.position = { x = 300, y = 100}

	-- node:runS
	node:run(Action.loop(sequence,4))
	node:run(sequence2)
	node:run(sequence3)



	-- node:run(moveRight)
	-- node:run(moveDown)
	-- node:run(moveLeft)
	-- node:run(moveUp)


	

	node1 = Node.new()
	node1.position = { x = 10, y = 30}
	node1:run(downRotate)
	-- node1:run(moveDown)
	-- node1:run(rotateLeft)

	-- node2 = Node.new()
	-- node2.position = { x = 40, y = 80}
	-- node2:run(moveRight)
	-- node2:run(moveDown)

	table.insert(nodes, node)
	table.insert(nodes, node1)
	-- table.insert(nodes, node2)
end

function love.resize(w, h)
end

function love.keyreleased(key)
end

function love.keypressed(key, unicode)
	love.event.quit( 0 )
end

function love.update( dt )
	for i,m in ipairs(nodes) do
		m:update(dt) 
	end
	collectgarbage()
end

function love.draw()
	for i,m in ipairs(nodes) do
		m:draw() 
	end
	love.graphics.circle( "line", 300, 130, 20 )
end

