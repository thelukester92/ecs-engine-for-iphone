Notes, Quirks, and Todos

# Quirks

* Collision system gives preference to one of the colliders if neither collider ignores collisions.
* Entities expect exactly one component of each type.
* Sprite sheets must have equal frame dimensions.

# Todo

* Consider what happens if two colliders collide, but neither ignores collisions.
* Allow for multiple components of one type on a single object (colliders, renderables) -- use a dictionary of arrays.
* Allow for circle colliders.
* Make a TileSystem to manage the loading and re-using of tile entities and sprites.