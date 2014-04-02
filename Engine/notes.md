Notes, Quirks, and Todos

# Broken Things

* LGSystem.init (not initWithScene) breaks everything without being clearly broken.

# Quirks

* Entities expect exactly one component of each type.
* Tile size is expected to be sprite.size.
* [LGTileSystem initializeWithPlist:] must be called after entities (the camera entity, specifically) have been added to the scene.
* Entities can't be added before systems.
* Components can't be added/removed from entities after they've been added to the scene.
* Transformable entities appear at (0, 0) on the first frame.
* Sprite logic is in the component instead of in the system.
* Camera size must be set.
* "collision" is the colliding layer's name always.
* Only .plist levels are allowed.
* All tile layers are set to background.
* Collisions treat both objects as having equal masses.
* Chained collisions treat both objects as having equal masses.

# Todo

* Move the logic for parsing .plist outside of the tile system -- the tile system should only have an addLayer: method.
* Add an "isCollision" flag to TileLayers.
* Add a "zIndex" to TileLayers.
* Allow for multiple components of one type on a single object (colliders, renderables) -- use a dictionary of arrays.