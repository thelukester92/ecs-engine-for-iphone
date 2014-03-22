Notes, Quirks, and Todos

# Quirks

* Entities expect exactly one component of each type.

# Todo

* Allow for multiple components of one type on a single object (colliders, renderables) -- use a dictionary of arrays.
* Make a Camera system.
* Make a TileSystem to manage the loading and re-using of tile entities and sprites (making use of Player and Camera).
* Make the TileSystem manage entity-to-tile collisions. Tiles should not be entitites any more.