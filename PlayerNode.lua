PlayerNode = {}
PlayerNode.__index = PlayerNode

function PlayerNode.new()
	local p = {
		position = {x=0, y=0},
		zPosition = 0.0,
		rotation = 0,
		xScale = 1.5,
		yScale = 1.5,
		alpha = 1,
		isHidden = false,
		children = {},
		actions = {},
		burn = false
	}
	setmetatable(p, PlayerNode)

	local moveRight = Action.moveBy(300,0,3)
	local moveLeft = Action.moveBy(-300,0,3)
	local moveDown = Action.moveBy(0,100,2)
	local moveUp = Action.moveBy(0,-100,2)



	Messager.addListener("burn_start", function(body)
		p.burn = true
	end)

	Messager.addListener("burn_stop", function(body)
		p.burn = false
	end)

	Messager.addListener("right", function(body)
		Messager.send("burn_start")
		p:clearActions()
		p:run(moveRight)
	end)


	Messager.addListener("right", function(body)
		p:clearActions()
		p:run(moveRight)
	end)

	Messager.addListener("down", function(body)
		p:clearActions()
		p:run(moveDown)
	end)

	Messager.addListener("left", function(body)
		p:clearActions()
		p:run(moveLeft)
	end)

	Messager.addListener("up", function(body)
		p:clearActions()
		p:run(moveUp)
	end)
  return p
end

function PlayerNode:run(action)
	table.insert(self.actions, coroutine.create(action))
end

function PlayerNode:clearActions()
	self.actions = {}
end

function PlayerNode:runGroup(group)
	for a,v in ipairs(group) do
		table.insert(self.actions, coroutine.create(v))
	end
end

function PlayerNode:update(dt)
	for a,v in ipairs(self.actions) do
		status = coroutine.resume(v,self,dt)
		-- if status then break end
	end

	for a,v in ipairs(self.children) do
		v:update(dt)
	end
end


function PlayerNode:draw()
		love.graphics.translate(self.position.x, self.position.y)
		love.graphics.push()
    	love.graphics.scale(self.xScale, self.yScale)
		love.graphics.translate(10, 10)
		love.graphics.rotate(math.rad(self.rotation))
		love.graphics.translate(-10, -10)
		love.graphics.polygon("line", 0,0,20,10,0,20,10,10)
		love.graphics.setColor(255, 0, 0)
		if self.burn then
			love.graphics.polygon("line", -5,10,4,6,8,10,4,14)
		end
		love.graphics.setColor(255, 255, 255)
		love.graphics.translate(-self.position.x, -self.position.y)
		for a,v in ipairs(self.children) do
			v:draw(dt)
		end
		love.graphics.pop()
		love.graphics.translate(-self.position.x, -self.position.y)
    -- love.graphics.setCanvas()
    -- love.graphics.draw(canvas, 0, 0)



	-- love.graphics.push()
	-- -- love.graphics.scale(self.xScale, self.yScale)
	-- love.graphics.circle( "fill", self.position.x, self.position.y, 10 )
	-- love.graphics.setColor(255, 0, 0)
	-- love.graphics.line(self.position.x, self.position.y, self.position.x + 10*math.cos(math.rad(self.rotation)), self.position.y - 10*math.sin(math.rad(self.rotation)))
	-- love.graphics.setColor(255, 255, 255)
	-- love.graphics.pop()
	for a,v in ipairs(self.children) do
		v:draw(dt)
	end
end

return PlayerNode