Notes, Quirks, and Todos

# Quirks

* Entities expect exactly one component of each type.
* Circle collisions set the center of the circle at the center of the collider's bounding box.
* Adding 0.1 to the overlap adds up; an object that is "pushed" by another one sometimes pops out of alignment.

# Todo

* Allow for multiple components of one type on a single object (colliders, renderables) -- use a dictionary of arrays.
* Allow for circle colliders.
* Make a Camera system.
* Make a TileSystem to manage the loading and re-using of tile entities and sprites (making use of Player and Camera).