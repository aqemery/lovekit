Node = {}
Node.__index = Node

function Node.new()
  local p = {
    position = {x=0, y=0},
    zPosition = 0.0,
    rotation = 0,
    scale = 1.5,
    radius = 10,
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

function Node:clearActions(action)
  self.actions = {}
end

function Node:runGroup(group)
  for _,v in ipairs(group) do
    table.insert(self.actions, coroutine.create(v))
  end
end

function Node:update(dt)
  for _,v in ipairs(self.actions) do
    coroutine.resume(v,self,dt)
  end

  for _,v in ipairs(self.children) do
    v:update(dt)
  end
end

function Node:draw()
  local rs = self.radius * self.scale
  love.graphics.translate(self.position.x, self.position.y)
  love.graphics.push()
  love.graphics.translate(-rs, -rs)
  love.graphics.circle("line", rs, rs, rs)
  love.graphics.line(rs, rs, rs + rs*math.cos(math.rad(self.rotation)), rs - rs*math.sin(math.rad(self.rotation)))
  love.graphics.pop()
  love.graphics.translate(-self.position.x, -self.position.y)
  for a,v in ipairs(self.children) do
    v:draw(dt)
  end
end

return Node