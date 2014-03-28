//
//  LGCollisionSystem.m
//  Engine
//
//  Created by Luke Godfrey on 3/3/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGCollisionSystem.h"
#import "LGEntity.h"
#import "LGTransform.h"
#import "LGRectangleCollider.h"
#import "LGCircleCollider.h"
#import "LGPhysics.h"
#import "LGCollisionResolver.h"
#import "LGTileCollider.h"
#import "LGTileLayer.h"

@implementation LGCollisionSystem

- (BOOL)acceptsEntity:(LGEntity *)entity
{
	return [entity hasComponentsOfType:[LGTransform class], [LGCollider class], nil];
}

- (void)update
{
	NSMutableArray *nonStaticEntities	= [NSMutableArray array];
	BOOL shouldResetColliders			= YES;
	
	// Step 1: Static to non-static collisions
	
	for(int i = 0; i < [self.entities count]; i++)
	{
		// Get a non-static entity
		
		LGEntity *a = [self.entities objectAtIndex:i];
		
		LGCollider *colliderA = [a componentOfType:[LGCollider class]];
		
		if(shouldResetColliders)
		{
			[colliderA resetCollider];
		}
		
		if([colliderA type] == LGColliderTypeStatic || [colliderA type] == LGColliderTypeTile)
		{
			continue;
		}
		else
		{
			[nonStaticEntities addObject:a];
		}
		
		for(int j = i + 1; j < [self.entities count]; j++)
		{
			// Get a static entity
			
			LGEntity *b = [self.entities objectAtIndex:j];
			
			LGCollider *colliderB = [b componentOfType:[LGCollider class]];
			
			if(shouldResetColliders)
			{
				[colliderB resetCollider];
			}
			
			if([colliderB type] == LGColliderTypeStatic)
			{
				[self resolveCollisionsBetween:a and:b];
			}
			else if([colliderB type] == LGColliderTypeTile)
			{
				[self resolveTileCollisionsBetween:a and:(LGTileCollider *)colliderB];
			}
		}
		
		if(shouldResetColliders)
		{
			shouldResetColliders = NO;
		}
	}
	
	// Step 2: Non-static to non-static collisions
	
	for(int i = 0; i < [nonStaticEntities count]; i++)
	{
		LGEntity *a = [nonStaticEntities objectAtIndex:i];
		
		for(int j = i + 1; j < [nonStaticEntities count]; j++)
		{
			LGEntity *b = [nonStaticEntities objectAtIndex:j];
			[self resolveCollisionsBetween:a and:b];
		}
	}
}

#pragma mark Hidden Methods

- (CGPoint)translate:(CGPoint)a by:(CGPoint)b
{
	return CGPointMake(a.x + b.x, a.y + b.y);
}

- (CGPoint)untranslate:(CGPoint)a by:(CGPoint)b
{
	return CGPointMake(a.x - b.x, a.y - b.y);
}

- (CGPoint)scale:(CGPoint)a by:(double)c
{
	return CGPointMake(a.x * c, a.y * c);
}

- (CGPoint)normalize:(CGPoint)a
{
	double magnitude = sqrt(a.x * a.x + a.y * a.y);
	return CGPointMake(a.x / magnitude, a.y / magnitude);
}

- (double)squareMagnitude:(CGPoint)a
{
	return a.x * a.x + a.y * a.y;
}

// Detect and resolve all collision between an entity and a tile layer
- (void)resolveTileCollisionsBetween:(LGEntity *)a and:(LGTileCollider *)tileCollider
{
	LGTransform *transform = [a componentOfType:[LGTransform class]];
	LGCollider *collider = [a componentOfType:[LGCollider class]];
	LGPhysics *physics = [a componentOfType:[LGPhysics class]];
	
	CGPoint position;
	int tileX, tileY;
	
	// Decompose the collision along each axis
	
	if([physics velocity].y != 0)
	{
		// Collide along the y-axis only; don't check the x-axis
		position = [transform position];
		position.x -= [physics velocity].x;
		
		// Only check the leading edge
		BOOL isBottom = [physics velocity].y > 0;
		
		// Check one row of tiles
		tileY = (int) floor( ( position.y + ( isBottom ? [collider boundingBox].height : 0 ) ) / [tileCollider tileSize].height );
		
		// Check a range of columns
		
		int fromX	= (int) floor( (position.x + 1) / [tileCollider tileSize].width );
		int toX		= (int) floor( (position.x + [collider boundingBox].width - 1) / [tileCollider tileSize].width );
		
		for(tileX = fromX; tileX <= toX; tileX++)
		{
			if( [[tileCollider collisionLayer] collidesAtRow:tileY andCol:tileX] )
			{
				// Resolution
				
				if(isBottom)
				{
					[transform setPositionY:tileY * [tileCollider tileSize].height - [collider boundingBox].height];
					[collider setCollidedBottom:YES];
					[collider setStaticBottom:YES];
				}
				else
				{
					[transform setPositionY:(tileY + 1) * [tileCollider tileSize].height];
					[collider setCollidedTop:YES];
					[collider setStaticTop:YES];
				}
				
				// Impulse
				[physics setVelocityY:0];
				
				// Only need to find one collision, so stop here
				break;
			}
		}
	}
	
	if([physics velocity].x != 0)
	{
		// Collide along the x-axis only; don't check the y-axis
		position = [transform position];
		position.y -= [physics velocity].y;
		
		// Only check the leading edge
		BOOL isRight = [physics velocity].x > 0;
		
		// Check one column of tiles
		tileX = (int) floor( ( position.x + ( isRight ? [collider boundingBox].width : 0 ) ) / [tileCollider tileSize].height );
		
		// Check a range of rows
		
		int fromY	= (int) floor( (position.y + 1) / [tileCollider tileSize].height );
		int toY		= (int) floor( (position.y + [collider boundingBox].height - 1) / [tileCollider tileSize].height );
		
		for(tileY = fromY; tileY <= toY; tileY++)
		{
			if( [[tileCollider collisionLayer] collidesAtRow:tileY andCol:tileX] )
			{
				// Resolution
				
				if(isRight)
				{
					[transform setPositionX:tileX * [tileCollider tileSize].width - [collider boundingBox].width];
					[collider setCollidedRight:YES];
					[collider setStaticRight:YES];
				}
				else
				{
					[transform setPositionX:(tileX + 1) * [tileCollider tileSize].width];
					[collider setCollidedLeft:YES];
					[collider setStaticLeft:YES];
				}
				
				// Impulse
				[physics setVelocityX:0];
				
				// Only need to find one collision, so stop here
				break;
			}
		}
	}
}

// Detect and resolve all collisions between two entities
- (void)resolveCollisionsBetween:(LGEntity *)a and:(LGEntity *)b
{
	/*
	 * Initialization
	 */
	
	LGTransform *transformA = [a componentOfType:[LGTransform class]];
	LGTransform *transformB = [b componentOfType:[LGTransform class]];
	
	LGCollider *colliderA = [a componentOfType:[LGCollider class]];
	LGCollider *colliderB = [b componentOfType:[LGCollider class]];
	
	BOOL canMoveB = [colliderB type] != LGColliderTypeStatic;
	
	CGPoint colliderPositionA = [self translate:[transformA position] by:[colliderA offset]];
	CGPoint colliderPositionB = [self translate:[transformB position] by:[colliderB offset]];
	
	/*
	 * Basic Detection
	 */
	
	BOOL outsideLeft	= colliderPositionA.x > colliderPositionB.x + [colliderB boundingBox].width;
	BOOL outsideRight	= colliderPositionA.x + [colliderA boundingBox].width < colliderPositionB.x;
	BOOL outsideTop		= colliderPositionA.y > colliderPositionB.y + [colliderB boundingBox].height;
	BOOL outsideBottom	= colliderPositionA.y + [colliderA boundingBox].height < colliderPositionB.y;
	
	if(!outsideLeft && !outsideRight && !outsideTop && !outsideBottom)
	{
		/*
		 * Resolution
		 */
		
		LGPhysics *physicsA = [a componentOfType:[LGPhysics class]];
		LGPhysics *physicsB = [b componentOfType:[LGPhysics class]];
		
		CGPoint resolution = CGPointZero;
		CGPoint impulse = CGPointZero;
		
		if([colliderA isMemberOfClass:[colliderB class]] && [colliderA isMemberOfClass:[LGRectangleCollider class]])
		{
			// Case 1: Rectangle to Rectangle Collision
			
			LGRectangleCollider *rectColliderA = (LGRectangleCollider *)colliderA;
			LGRectangleCollider *rectColliderB = (LGRectangleCollider *)colliderB;
			
			LGCollisionResolver *resolver = [[LGCollisionResolver alloc] init];
			[resolver setPhysicsA:physicsA];
			[resolver setPhysicsB:physicsB];
			
			CGRect rectA = CGRectMake(colliderPositionA.x, colliderPositionA.y, [rectColliderA size].width, [rectColliderA size].height);
			CGRect rectB = CGRectMake(colliderPositionB.x, colliderPositionB.y, [rectColliderB size].width, [rectColliderB size].height);
			
			[resolver resolveRectangle:rectA withRectangle:rectB];
			
			resolution = [resolver resolution];
			impulse = [resolver impulse];
			
			if(resolution.y > 0)
			{
				[colliderA setCollidedTop:YES];
				[colliderB setCollidedBottom:YES];
			}
			else if(resolution.y < 0)
			{
				[colliderA setCollidedBottom:YES];
				[colliderB setCollidedTop:YES];
			}
		}
		else if([colliderA isMemberOfClass:[colliderB class]] && [colliderA isMemberOfClass:[LGCircleCollider class]])
		{
			// Case 2: Circle to Circle Collision
			
			LGCircleCollider *circleA = (LGCircleCollider *)colliderA;
			LGCircleCollider *circleB = (LGCircleCollider *)colliderB;
			
			CGPoint dist = CGPointZero;
			dist.x = colliderPositionA.x + [circleA radius] - colliderPositionB.x - [circleB radius];
			dist.y = colliderPositionA.y + [circleA radius] - colliderPositionB.y - [circleB radius];
			
			double radii = [circleA radius] + [circleB radius];
			
			double squareDist	= [self squareMagnitude:dist];
			double squareRadii	= radii * radii;
			
			if(squareDist < squareRadii)
			{
				// Resolve along the line between the two circles
				
				double magnitude = sqrt(squareDist);
				
				resolution = dist;
				resolution.x *= radii / magnitude - 1;
				resolution.y *= radii / magnitude - 1;
				
				if(physicsA != nil)
				{
					double impulseMagnitude;
					
					if(physicsB != nil)
					{
						impulseMagnitude = sqrt( ([physicsB velocity].x - [physicsA velocity].x) * ([physicsB velocity].x - [physicsA velocity].x) + ([physicsB velocity].y - [physicsA velocity].y) * ([physicsB velocity].y - [physicsA velocity].y) );
					}
					else
					{
						impulseMagnitude = sqrt( [physicsA velocity].x * [physicsA velocity].x + [physicsA velocity].y * [physicsA velocity].y );
					}
					
					impulse = [self normalize:resolution];
					impulse.x *= impulseMagnitude;
					impulse.y *= impulseMagnitude;
				}
			}
		}
		else
		{
			// Case 3: Rectangle to Circle
			
			LGRectangleCollider *rect = nil;
			LGCircleCollider *circle = nil;
			
			CGPoint rectPos, circlePos;
			
			BOOL circleIsA = NO;
			
			if([colliderA isMemberOfClass:[LGRectangleCollider class]] && [colliderB isMemberOfClass:[LGCircleCollider class]])
			{
				rect = (LGRectangleCollider *)colliderA;
				circle = (LGCircleCollider *)colliderB;
				
				rectPos = colliderPositionA;
				circlePos = colliderPositionB;
			}
			else if([colliderA isMemberOfClass:[LGCircleCollider class]] && [colliderB isMemberOfClass:[LGRectangleCollider class]])
			{
				circle = (LGCircleCollider *)colliderA;
				rect = (LGRectangleCollider *)colliderB;
				
				circlePos = colliderPositionA;
				rectPos = colliderPositionB;
				
				circleIsA = YES;
			}
			
			BOOL outsideX = circlePos.x + [circle radius] < rectPos.x || circlePos.x + [circle radius] > rectPos.x + [rect size].width;
			BOOL outsideY = circlePos.y + [circle radius] < rectPos.y || circlePos.y + [circle radius] > rectPos.y + [rect size].height;
			
			if(outsideX && outsideY)
			{
				// Treat the rectangle as a single point: the closest corner
				
				CGPoint dist = CGPointZero;
				dist.x = circlePos.x + [circle radius] < rectPos.x ? rectPos.x - circlePos.x - [circle radius] : rectPos.x + [rect size].width - circlePos.x - [circle radius];
				dist.y = circlePos.y + [circle radius] < rectPos.y ? rectPos.y - circlePos.y - [circle radius] : rectPos.y + [rect size].height - circlePos.y - [circle radius];
				
				double squareDist = [self squareMagnitude:dist];
				
				if(squareDist < [circle radius] * [circle radius])
				{
					double magnitude = sqrt(squareDist);
					
					resolution = dist;
					resolution.x *= ([circle radius] / magnitude - 1) * (circleIsA ? -1 : 1);
					resolution.y *= ([circle radius] / magnitude - 1) * (circleIsA ? -1 : 1);
					
					if(physicsA != nil)
					{
						double impulseMagnitude;
						
						if(physicsB != nil)
						{
							impulseMagnitude = sqrt( ([physicsB velocity].x - [physicsA velocity].x) * ([physicsB velocity].x - [physicsA velocity].x) + ([physicsB velocity].y - [physicsA velocity].y) * ([physicsB velocity].y - [physicsA velocity].y) );
						}
						else
						{
							impulseMagnitude = sqrt( [physicsA velocity].x * [physicsA velocity].x + [physicsA velocity].y * [physicsA velocity].y );
						}
						
						impulse = [self normalize:resolution];
						impulse.x *= impulseMagnitude;
						impulse.y *= impulseMagnitude;
					}
				}
			}
			else
			{
				// Treat the circle as a rectangle
				
				CGPoint dist = CGPointZero;
				dist.x = circlePos.x > rectPos.x ? circlePos.x - rectPos.x - [rect size].width : circlePos.x + [circle radius] * 2 - rectPos.x;
				dist.y = circlePos.y > rectPos.y ? circlePos.y - rectPos.y - [rect size].height : circlePos.y + [circle radius] * 2 - rectPos.y;
				
				if(fabs(dist.y) < fabs(dist.x))
				{
					resolution.y -= dist.y * (circleIsA ? 1 : -1);
					
					if(physicsA != nil)
					{
						if(physicsB != nil)
						{
							impulse.y = [physicsB velocity].y - [physicsA velocity].y;
						}
						else
						{
							impulse.y = -[physicsA velocity].y;
						}
					}
				}
				else
				{
					resolution.x -= dist.x * (circleIsA ? 1 : -1);
					
					if(physicsA != nil)
					{
						if(physicsB != nil)
						{
							impulse.x = [physicsB velocity].x - [physicsA velocity].x;
						}
						else
						{
							impulse.x = -[physicsA velocity].x;
						}
					}
				}
			}
		}
		
		// Check for entities that are against static entities
		
		BOOL againstStaticA = NO;
		BOOL againstStaticB = NO;
		
		if(canMoveB)
		{
			// Only consider single-axis collisions
			if(resolution.x == 0 || resolution.y == 0)
			{
				if(resolution.x > 0)
				{
					againstStaticA = [colliderA staticRight];
					againstStaticB = [colliderB staticLeft];
				}
				else if(resolution.x < 0)
				{
					againstStaticA = [colliderA staticLeft];
					againstStaticB = [colliderB staticRight];
				}
				else if(resolution.y > 0)
				{
					againstStaticA = [colliderA staticBottom];
					againstStaticB = [colliderB staticTop];
				}
				else if(resolution.y < 0)
				{
					againstStaticA = [colliderA staticTop];
					againstStaticB = [colliderB staticBottom];
				}
			}
			
			// Adjustment of velocities: go to zero on the moved axis
			
			if(resolution.x != 0)
			{
				if(againstStaticA && physicsB != nil)
				{
					[physicsB setVelocityX:0];
				}
				
				if(againstStaticB)
				{
					[physicsA setVelocityX:0];
				}
			}
			
			if(resolution.y != 0)
			{
				if(againstStaticA && physicsB != nil)
				{
					[physicsB setVelocityY:0];
				}
				
				if(againstStaticB)
				{
					[physicsA setVelocityY:0];
				}
			}
		}
		
		// Adjust the transforms
		if(physicsA != nil && physicsB != nil && canMoveB && !againstStaticA && !againstStaticB)
		{
			double aRatio = [physicsB mass] / ([physicsA mass] + [physicsB mass]);
			double bRatio = [physicsA mass] / ([physicsA mass] + [physicsB mass]) * -1;
			
			colliderPositionA = [self translate:colliderPositionA by:[self scale:resolution by:aRatio]];
			colliderPositionB = [self translate:colliderPositionB by:[self scale:resolution by:bRatio]];
			
			[transformA setPosition:[self untranslate:colliderPositionA by:[colliderA offset]]];
			[transformB setPosition:[self untranslate:colliderPositionB by:[colliderB offset]]];
		}
		else if(againstStaticA && canMoveB)
		{
			colliderPositionB = [self translate:colliderPositionB by:[self scale:resolution by:-1]];
			[transformB setPosition:[self untranslate:colliderPositionB by:[colliderB offset]]];
		}
		else
		{
			colliderPositionA = [self translate:colliderPositionA by:resolution];
			[transformA setPosition:[self untranslate:colliderPositionA by:[colliderA offset]]];
		}
		
		// Adjust the velocities
		if(!CGPointEqualToPoint(impulse, CGPointZero) && !againstStaticA && !againstStaticB)
		{
			if(physicsA != nil && physicsB != nil && canMoveB)
			{
				double elasticity = MAX([physicsA elasticity], [physicsB elasticity]);
				
				double newVelocityAx = (elasticity * [physicsB mass] * impulse.x + [physicsA mass] * [physicsA velocity].x + [physicsB mass] * [physicsB velocity].x) / ([physicsA mass] + [physicsB mass]);
				double newVelocityBx = (elasticity * [physicsA mass] * -impulse.x + [physicsA mass] * [physicsA velocity].x + [physicsB mass] * [physicsB velocity].x) / ([physicsA mass] + [physicsB mass]);
				
				double newVelocityAy = (elasticity * [physicsB mass] * impulse.y + [physicsA mass] * [physicsA velocity].y + [physicsB mass] * [physicsB velocity].y) / ([physicsA mass] + [physicsB mass]);
				double newVelocityBy = (elasticity * [physicsA mass] * -impulse.y + [physicsA mass] * [physicsA velocity].y + [physicsB mass] * [physicsB velocity].y) / ([physicsA mass] + [physicsB mass]);
				
				[physicsA setVelocity:CGPointMake(newVelocityAx, newVelocityAy)];
				[physicsB setVelocity:CGPointMake(newVelocityBx, newVelocityBy)];
			}
			else
			{
				// Model entity B as if it has infinite mass; apply the entire impulse to entity A
				double elasticity = physicsB != nil ? MAX([physicsA elasticity], [physicsB elasticity]) : [physicsA elasticity];
				[physicsA setVelocity:CGPointMake(elasticity * impulse.x, elasticity * impulse.y)];
			}
		}
	}
}

@end