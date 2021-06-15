Action = {}
Action.__index = Action

function Action.moveBy(x,y,t)
  local behav = function (node, dt)
    local dx = x/(t*1.0)
    local dy = y/(t*1.0)
    local current = 0
    while current < t do
      current = current + dt
      node.position.x = node.position.x + dx * dt
      node.position.y = node.position.y + dy * dt
      node,dt = coroutine.yield()
    end
    end
    return behav
end

function Action.rotateBy(degrees,t)
  local behav = function (node,dt)
    local dr = degrees/(t*1.0)
    local current = 0
    while current < t do
      current = current + dt
      node.rotation = node.rotation + dr * dt
      node, dt = coroutine.yield()
    end
    end
    return behav
end

function Action.scaleBy(scaleBy, t)
  local behav = function (node, dt)
    local delta = scaleBy /(t*1.0)
    local current = 0
    while current < t do
      current = current + dt
      posX = node.position.x
      posY = node.position.y
      node.scale = node.scale + delta * dt
      node,dt = coroutine.yield()
    end
    end
    return behav
end

function Action.wait(t)
  local behav = function (node, dt)
    local current = 0
    while current < t do
      current = current + dt
      node,dt = coroutine.yield()
    end
    end
    return behav
end

function Action.sequence(actions)
  local behav = function (node, dt)
    for i,v in ipairs(actions) do
      local step = coroutine.create(v)
      while true do
        local status = coroutine.resume(step,node,dt)
        if not status then break end
        node,dt = coroutine.yield()
      end
    end
    end
    return behav
end

function Action.group(actions)
  local behav = function (node, dt)
    local routines = {}
    for a,v in ipairs(actions) do
      table.insert(routines, coroutine.create(v))
    end
    local running = true
    while running do
      for a,v in ipairs(routines) do
        local status = coroutine.resume(v,node,dt)
        running = false
        if status then
          running = status
        end
      end
      node,dt = coroutine.yield()
    end
  end 
    return behav
end

function Action.loop(action, times)
  local behav = function (node, dt)
    for i = 1, times, 1 do
      local step = coroutine.create(action)
      while true do
        local status = coroutine.resume(step,node,dt)
        if not status then break end
        node,dt = coroutine.yield()
      end
    end
    end
    return behav
end

function Action:update(dt, node)
  for a,v in ipairs(self.actions) do
    if not v ~= nil then
      suc,val = coroutine.resume(v,dt) 
      if suc and val ~= nil then out = val end
    end
  end
end

return Action