.____     ________  ________   ________
|    |    \______ \ \_____  \ /  _____/
|    |     |    |  \  _/__  </   __  \
|    |___  |    `   \/       \  |__\  \
|_______ \/_______  /______  /\_____  /
        \/        \/       \/       \/
`

- Ichiban Daisuki
  -- Map Generation
    -- Read from template
    -- Mountains
    -- Vril Energy
  -- Resources
    -- display
  - Buildings
    - Vril Flying Machine
      - Sprite
    -- Mine
      -- Sprite
      -- Button
      -- Replace Tile On Click
      -- validate
        -- check that is mountain
        -- check for resources
    -- Vril Harvester
      -- Sprite
      -- Button
      -- Replace Tile On Click
      -- validate
        -- check that is crystal
        -- check for resources
  - Units
    - Black Order Panzer
      -- Sprite
      -- On Map
      - Movement
        - UI Mode
        - Highlight Moveable Area
        - Track HasMoved
        - Physical Movement
        - Pathfinding
      - Can Build
  - Enemy
    - Agarthan Grunt
  - Turn
    -- Generate Resources
    - Enemy AI


- Daisuki
  - Hover for info
    -- Name
    -- Gameplay Info
    - Flavour Text
    -- Hover Over Units
  - Fix Shitty Sprites
    - Mine
    - Vril Harvester
  - Accessibility
    - Show red X when unable to build on a certain terrain, or similar
  -- Focused Tile should be more precise
  - Polish
    - Actually Good UI




- Suki
  - Meh Sprites
    - Panzer
  - Alternate Sprites
    - Different Mountains
