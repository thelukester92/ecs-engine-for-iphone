# Quirks

* Using init instead of initWithScene: breaks everything.
* Not having a camera breaks the tile system.
* Not setting a camera size breaks the tile system.

* Collision chaining still causes jitter when pushing one object into a stack of two.
* Tile maps smaller than the screen size so that visibleX or visibleY is bigger than the map, the app crashes.