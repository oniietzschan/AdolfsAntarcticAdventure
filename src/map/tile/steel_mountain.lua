local C = class('SteelMountain', Mountain)

function C:initialize(...)
  Mountain.initialize(self, ...)
end

function C:getDefaultAnimation()
  return 'steelMountain'
end

function C:hover()
  return {
    name = 'Steel Mountains',
    gameplay = 'Build a Mine here to generate steel.'
  }
end

return C
