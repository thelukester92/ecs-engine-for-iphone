Notes, Quirks, and Todos

# Quirks

* Entities can't be added before systems.
* Components can't be added/removed from entities after they've been added to the scene because their entities won't be added to the appropriate systems.
* Sprite logic is in the component instead of in the system.
* Collision chaining still causes jitter when pushing one object into a stack of two.
* Tile maps smaller than the screen size so that visibleX or visibleY is bigger than the map, the app crashes.

# Todo

