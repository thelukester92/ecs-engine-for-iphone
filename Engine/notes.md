# Quirks

* Components cannot be added to or removed from entities that have already been added to the scene.
* Collision chaining still causes jitter when pushing one object into a stack of two.
* Tile maps smaller than the screen size so that visibleX or visibleY is bigger than the map, the app crashes.