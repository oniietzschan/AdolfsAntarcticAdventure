la = love.audio
lf = love.filesystem
lg = love.graphics
lm = love.mouse

-- Camera
CAMERA_WIDTH = SCREEN_WIDTH
CAMERA_HEIGHT = SCREEN_HEIGHT
CAMERA_MIN_X = 0
CAMERA_MIN_Y = 0
CAMERA_MAX_X = 0
CAMERA_MAX_Y = 0

-- Game
-- PLAYER_W = 16
-- PLAYER_H = 16
GAME_MIN_X = 0
GAME_MIN_Y = 0
GAME_MAX_X = 640 -- - PLAYER_W
GAME_MAX_Y = 360 -- - PLAYER_H

TILE_H = 16
TILE_W = 32

MAP_TILES_X = 10
MAP_TILES_Y = 10

MINE_GENERATION_RATE = 5
MINE_STEEL_COST = 30

VRIL_GENERATION_RATE = 1
VRIL_HARVESTER_STEEL_COST = 15

local player_walk_speed = 96
local time_to_stop = 0.225
local dampen_cutoff_speed = 1

PLAYER_WALK_SPEED = player_walk_speed
PLAYER_WALK_ACCELERATION = PLAYER_WALK_SPEED * 8
WALK_DAMPEN_FACTOR = math.pow(10, (math.log10(dampen_cutoff_speed / player_walk_speed) / time_to_stop))
DAMPEN_CUTOFF_SPEED = dampen_cutoff_speed

-- Colors
COLOR_BLACK = {0, 0, 0}
COLOR_BLUE = {0, 0, 255}
COLOR_DARK_BLUE = {0, 0, 128}
COLOR_DARK_GREEN = {0, 128, 0}
COLOR_DARK_GREY = {64, 64, 64}
COLOR_DARK_RED = {128, 0, 0}
COLOR_GREEN = {0, 255, 0}
COLOR_GRAY = {128, 128, 128}
COLOR_RED = {255, 0, 0}
COLOR_SHADOW = {0, 0, 0, 128}
COLOR_WHITE = {255, 255, 255}

COLOR_HIGHLIGHT_BLUE = {192, 192, 255}
COLOR_HIGHLIGHT_RED = {255, 192, 192}
COLOR_HIGHLIGHT_WHITE = {320, 320, 320}
COLOR_HIGHLIGHT_GREY = {192, 192, 192}

COLOR_BACKGROUND = {43, 48, 59}

LEFT_CLICK = 'leftClick'
-- CONFIRM = 'confirm'
-- CANCEL = 'cancel'
-- UP = 'up'
-- DOWN = 'down'
-- LEFT = 'left'
-- RIGHT = 'right'
FULLSCREEN = 'fullscreen'
MINUS = 'minus'
PLUS = 'plus'
QUIT = 'quit'

BUILD = 'build'
MOVE = 'move'
NORMAL = 'normal'
