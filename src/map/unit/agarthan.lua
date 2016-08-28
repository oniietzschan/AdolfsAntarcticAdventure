local C = class('Agarthan', Enemy)

function C:initialize(...)
  self.sprite = Sprite.agarthan:newInstance()

  Enemy.initialize(self)

  self.attack = 3
  self.movementRange = 2
end

function C:getRandomName()
  return Util.sample({
    'Konata',
    'Nekomata',
    'Satin Tights',
    'Zorg',
    'Zuul',
  })
end

function C:hover()
  return {
    name = 'Agarthan',
    -- gameplay = 'Destroy this to proceed.',
    -- flavour = "An obsidian obelisk with the power to shift the poles of the Earth.",
  }
end

return C
