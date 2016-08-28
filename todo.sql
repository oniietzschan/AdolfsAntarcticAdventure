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
    - Can only build in certain proximity to units
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
  -- Units
    -- Black Order Panzer
      -- Sprite
      -- On Map
      -- Movement
        -- UI Mode
        -- Highlight Moveable Area
        -- Track HasMoved
        -- Physical Movement
        -- Pathfinding
      - Attacking
        -- Highlight Attackable Area
        -- Move Closer
          -- Move Closer
          -- Handle When Closest Spot Is Not Free
        -- Physical Attack
          -- Remove HP
          -- Remove Unit if destroyed
        - Need ability to hold ground and attack
  -- Enemy
    -- Agarthan
      -- Sprite
      -- Generate On Map
      -- AI
    -- Agarthan Polar Monolith
      -- Sprite
      -- Convert To Unit
      -- Can Be Destoyed
  -- Turn
    -- Generate Resources
    -- Allow Units To Move Again
    -- Enemy AI
  -- Gameflow
    -- After Monolith destroyed, load next map
  -- UI
    -- Show Unit HP


- Daisuki
  - Sound
  - Music
  - Gameplay - Fundamental
    - Enemies should determine whether target still exists before moving towards it
    -- Should be able to move 1-2 spaces, then attack. To allow for fighting in close quarters
  - Gameplay - Quality Of Life
    - Animations During Attack
    - Animations During Movement
    - Animations During Enemy Turn
  - Units
    - Vril Flying Machine
      - Sprite
      - On Map
      - Movement
        - Uses Vril Force
  - Tiles
    - Forests (provide cover)
  -- Hover for info
    -- Name
    -- Gameplay Info
    -- Flavour Text
    -- Hover Over Units
  - Fix Shitty Sprites
    - Mine
    - Vril Harvester
  - Accessibility
    - Show red X when unable to build on a certain terrain, or similar
  -- Focused Tile should be more precise
  - Graphical Polish
    - Units Change Facing After Movement
    - Actually Good UI




- Suki
  - Generate Cute Names For Units
  - More Flavour Text
    - Allow Wrapping?
  - Story
  - Meh Sprites
    - Panzer
  - Alternate Sprites
    - Different Mountains
