Notes, Quirks, and Todos

# Quirks

* Entities expect exactly one component of each type.
* [LGTileSystem initializeWithPlist:] must be called after entities (the camera entity, specifically) have been added to the scene.
* Entities can't be added before systems.
* Components can't be added/removed from entities after they've been added to the scene because their entities won't be added to the appropriate systems.
* Transformable entities appear at (0, 0) on the first frame.
* Sprite logic is in the component instead of in the system.
* Collision chaining causes a massive amount of unnecessary collision checks.

# Todo

* Allow for multiple components of one type on a single object (colliders, renderables) -- use a dictionary of arrays.
	* Fixes "Entities expect exactly one component of each type."
* Add spatial partitioning using a quadtree.
	* Fixes "Collision chaining causes a massive amount of unnecessary collision checks."

QUADTREES SUCKKK

1) walk grid rows from top-to-bottom
2) walk the row left-to-right
3) walk the contained entities in the cell first to last and perform broad-band collision detection with all enities "forward" in the list.  If this entity crosses one-or-more cells to the left and/or bottom of this cell's edges check all of those cells as well.

You never need to check entities to the right or above because they've already done that work.

SPATIAL HASHING


^^ What he said. In spatial hashing you basically:

- divide world by grid (best size for grid cell is a bit larger than the average mobile object). 

- Maintain a hash table (a simple 1D list of buckets, each bucket is a vector containing the ID of each object that is in that cell).

- Every frame you do a "hash function" on each object which computes what bucket that object is in. Place the object ID (or a reference) in the appropriate bucket. You do not need any true hashing functions, since it is easier just to make each bucket a list with overflow (C++ vector is what I use).

- Hashing an object depends on its Bounding Volume. Axis-aligned Bounding Boxes (AABB) are fastest to hash. Spheres are fine though as well.

- During collision only collide objects in the same bucket

- Objects may hash to more than 1 bucket, that is fine. Objects on a line may do that. Large objects may as well.

Besides collision you also gain:

- Frustum culling for top down camera: hash camera, only draw objects within a certain number grid squares from camera

- Fast Proximity Queries: "who is near object X?" = nearby buckets

- Picking Optimization: hash your mouse click, only objects in that bucket are candidates for being picked

Of course - ^those^ become a bit trickier if you dont have a strictly top-down camera.