Notes, Quirks, and Todos

# Quirks

* Collision system gives preference to one of the colliders if neither collider ignores collisions.
* Entities expect exactly one component of each type.
* Circle collisions set the center of the circle at the center of the collider's bounding box.

# Todo

* Consider what happens if two colliders collide, but neither ignores collisions (perhaps assume masses are equal and use basic physics to adjust the velocities?).
* Allow for multiple components of one type on a single object (colliders, renderables) -- use a dictionary of arrays.
* Allow for circle colliders.
* Make a Camera system.
* Make a TileSystem to manage the loading and re-using of tile entities and sprites (making use of Player and Camera).
* Better designed collisions; what about elasticity? Mass?