Node = {}
Node.__index = Node

function Node.new()
  local p = {
    position = {x=0, y=0},
	zPosition = 0.0,
	rotation = 0,
	xScale = 1,
	yScale = 2,
	alpha = 1,
	isHidden = false,
	children = {},
    actions = {}
  }
  setmetatable(p, Node)
  return p
end

function Node:run(action)
	table.insert(self.actions, coroutine.create(action))
end

function Node:runGroup(group)
	for a,v in ipairs(group) do
		table.insert(self.actions, coroutine.create(v))
	end
end

function Node:update(dt)
	for a,v in ipairs(self.actions) do
		status = coroutine.resume(v,self,dt)
		-- if status then break end
	end
end


function Node:draw()
	canvas = love.graphics.newCanvas(800, 600)
 
    -- Rectangle is drawn to the canvas with the regular alpha blend mode.
    love.graphics.setCanvas(canvas)
    	love.graphics.push()
    	love.graphics.scale(self.xScale, self.yScale)
        love.graphics.clear()
		love.graphics.circle("fill", 10, 10, 10)
		love.graphics.setColor(255, 0, 0)
		love.graphics.line(10, 10, 10 + 10*math.cos(math.rad(self.rotation)), 10 - 10*math.sin(math.rad(self.rotation)))
		love.graphics.setColor(255, 255, 255)
		
		love.graphics.pop()
    love.graphics.setCanvas()
    love.graphics.draw(canvas,self.position.x, self.position.y)



	-- love.graphics.push()
	-- -- love.graphics.scale(self.xScale, self.yScale)
	-- love.graphics.circle( "fill", self.position.x, self.position.y, 10 )
	-- love.graphics.setColor(255, 0, 0)
	-- love.graphics.line(self.position.x, self.position.y, self.position.x + 10*math.cos(math.rad(self.rotation)), self.position.y - 10*math.sin(math.rad(self.rotation)))
	-- love.graphics.setColor(255, 255, 255)
	-- love.graphics.pop()
end

return Node