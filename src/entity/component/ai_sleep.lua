local AiSleep = class('AiSleep', Component)

function AiSleep:initialize(t)
  Component.initialize(self, t)

  self.facing_left = util.sample({true, false})
  self.parent.img_mirror = util.sample({true, false})

  local _, _, w = self.parent:getRect()
  self.parent:addFrill(Particles, {
    image = img.zzz,
    quads = {
      img.zzz.quads[1],
      img.zzz.quads[2],
      img.zzz.quads[3],
      img.zzz.quads[3],
      img.zzz.quads[3],
    },
    layer = 'foreground',
    colors = {
      255, 255, 255, 255,
      255, 255, 255, 255,
      255, 255, 255, 255,
      255, 255, 255, 0,
    },
    emissionRate = 2.25,
    particleLifetime = {1, 1},
    offsetX = math.floor(w / 2),
    speed = {20, 20},
    direction = math.pi * 1.75,
    visibleY1 = -16
  })
end

return AiSleep
