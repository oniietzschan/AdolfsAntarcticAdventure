local T = {}

function T:colorInit(t)
  self.colorR = 1
  self.colorG = 1
  self.colorB = 1
  self.colorA = 1
end

function T:colorProcessRgb(r, b, g, a)
  return r * self.colorR, b * self.colorB, g * self.colorG, a * self.colorA
end

return T
