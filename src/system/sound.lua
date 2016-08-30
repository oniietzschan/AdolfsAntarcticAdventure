local sound = {}

local data = {
  unitHit = {
    path = 'unit_hit.wav',
    volume = 0.8,
  },
  unitKilled = {
    path = 'unit_killed.wav',
    volume = 0.8,
  },
  unitWalk = {
    path = 'unit_walk.wav',
    volume = 0.6,
  },
}

sound = {}
for name, t in pairs(data) do
  local path = 'assets/sound/' .. t.path
  local stream = t.stream and 'stream' or 'static'
  local snd = la.newSource(path, stream)

  snd:setVolume(t.volume or 1)

  sound[name] = snd
end

return sound
