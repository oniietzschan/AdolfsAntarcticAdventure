local C = class('React', Component)

function C:initialize(t)
  Component.initialize(self, t)

  if t.callback == nil then
    error('Invalid callback: ' .. Serpent.line(t.callback), 2)
  end

  self.callback = t.callback
  self.filter = t.filter or function(item) return item.solid or item.living end
  self.triggersLeft = t.triggersLeft or nil
end

function C:react(...)
  if self.triggersLeft ~= nil then
    if self.triggersLeft <= 0 then
      return
    end

    self.triggersLeft = self.triggersLeft -1
  end

  self:callback(...)
end

return C
