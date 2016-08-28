local T = {}

function T:shake(t)
  Util.require(t, {'duration', 'intensity'})

  self.shakeIntensity = t.intensity
  Timer.tween(t.duration, self, {shakeIntensity = 0}, 'in-out-quad')
end

function T:shakeGetOffset()
  if self.shakeIntensity == nil or self.shakeIntensity == 0 then
    return 0
  end

  return (math.random() * 2 * self.shakeIntensity) - self.shakeIntensity
end

return T
