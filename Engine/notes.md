Notes, Quirks, and Todos

# Quirks

* Entities expect exactly one component of each type.
* [LGTileSystem initializeWithPlist:] must be called after entities (the camera entity, specifically) have been added to the scene.
* Entities can't be added before systems.
* Components can't be added/removed from entities after they've been added to the scene because their entities won't be added to the appropriate systems.
* Transformable entities appear at (0, 0) on the first frame.
* Sprite logic is in the component instead of in the system.

# Todo

* Allow for multiple components of one type on a single object (colliders, renderables) -- use a dictionary of arrays.
	* Fixes "Entities expect exactly one component of each type."