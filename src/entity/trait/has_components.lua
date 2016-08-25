local T = {}

function T:initializeComponents(components)
  self.components = {}

  if components == nil then
    return
  end

  for _, class in ipairs(components) do
    self:initComponent(class)
  end
end

function T:initComponent(class, t)
  t = t or {}
  t.parent = self

  table.insert(self.components, class:new(t))
end

function T:updateComponents(dt)
  for _,cmpt in ipairs(self.components) do
    if cmpt.update then
      cmpt:update(dt)
    end
  end
end

function T:handleComponentCollision(col)
  for _,cmpt in ipairs(self.components) do
    if cmpt.handleCollision then
      cmpt:handleCollision(col)
    end
  end
end

function T:hasComponent(cmpt_class)
  for _,cmpt in ipairs(self.components) do
    if cmpt:isInstanceOf(cmpt_class) then
      return true
    end
  end

  return false
end

function T:trigger(event, ...)
  for _, cmpt in ipairs(self.components) do
    if cmpt[event] then
      -- print('Trigger ' .. event .. ' on ' .. self.class.name .. ' - ' .. cmpt.class.name)
      cmpt[event](event, ...)

    elseif cmpt.listen ~= nil then
      -- Old way...
      cmpt:listen(event, ...)
    end
  end
end

return T
