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
#import "LGPhysics.h"
#import "LGTileCollider.h"
#import "LGTileLayer.h"
#import "LGPlayer.h"

@implementation LGCollisionSystem

@synthesize staticEntities, dynamicEntities;

- (BOOL)acceptsEntity:(LGEntity *)entity
{
	return [entity hasComponentsOfType:[LGTransform class], [LGCollider class], nil];
}

- (void)addEntity:(LGEntity *)entity
{
	[super addEntity:entity];
	
	LGCollider *collider = [entity componentOfType:[LGCollider class]];
	if([collider type] == LGColliderTypeStatic)
	{
		[staticEntities addObject:entity];
	}
	else if([collider type] == LGColliderTypeDynamic)
	{
		[dynamicEntities addObject:entity];
	}
}

- (void)update
{
	// Step 1: Dynamic-to-Static Collisions
	
	for(int i = 0; i < [dynamicEntities count]; i++)
	{
		LGEntity *a = [dynamicEntities objectAtIndex:i];
		[(LGCollider *)[a componentOfType:[LGCollider class]] reset];
		
		for(int j = 0; j < [staticEntities count]; j++)
		{
			LGEntity *b = [staticEntities objectAtIndex:j];
			[self resolveCollisionsBetween:a and:b];
		}
	}
	
	// Step 2: Dynamic-to-Dynamic Collisions
	
	for(int i = 0; i < [dynamicEntities count]; i++)
	{
		LGEntity *a = [dynamicEntities objectAtIndex:i];
		
		for(int j = i + 1; j < [dynamicEntities count]; j++)
		{
			LGEntity *b = [dynamicEntities objectAtIndex:j];
			
			[self resolveCollisionsBetween:a and:b];
		}
	}
}

- (void)initialize
{
	staticEntities	= [NSMutableArray array];
	dynamicEntities	= [NSMutableArray array];
}

#pragma mark Private Methods

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

// Detect and resolve all collision between an entity and a tile layer
- (void)resolveTileCollisionsBetween:(LGEntity *)a and:(LGTileCollider *)tileCollider
{
	LGTransform *transform = [a componentOfType:[LGTransform class]];
	LGCollider *collider = [a componentOfType:[LGCollider class]];
	LGPhysics *physics = [a componentOfType:[LGPhysics class]];
	
	CGPoint position = [self translate:[transform position] by:[collider offset]];;
	int tileX, tileY;
	
	// Decompose the collision along each axis
	
	position.x -= [physics velocity].x;
	
	for(int i = 0; i < 2; i++)
	{
		BOOL isBottom = i == 0;
		BOOL shouldBreak = NO;
		
		// Check one row of tiles
		
		tileY = (int) floor( ( position.y + ( isBottom ? [collider size].height : 0 ) ) / [tileCollider tileSize].height );
		
		// Check a range of columns
		
		int fromX	= (int) floor( (position.x + 1) / [tileCollider tileSize].width );
		int toX		= (int) floor( (position.x + [collider size].width - 1) / [tileCollider tileSize].width );
		
		for(tileX = fromX; tileX <= toX; tileX++)
		{
			if( [[tileCollider collisionLayer] collidesAtRow:tileY andCol:tileX] )
			{
				if(isBottom)
				{
					position.y = tileY * [tileCollider tileSize].height - [collider size].height;
					[collider setBottomDist:0];
				}
				else
				{
					position.y = (tileY + 1) * [tileCollider tileSize].height;
					[collider setTopDist:0];
				}
				
				if(physics != nil)
				{
					[physics setVelocityY:0];
				}
				
				// Only need to find one collision, so stop here
				shouldBreak = YES;
				break;
			}
		}
		
		if(shouldBreak)
		{
			break;
		}
		else
		{
			// Check if the next tile is solid
			tileY += isBottom ? 1 : -1;
			for(tileX = fromX; tileX <= toX; tileX++)
			{
				if( [[tileCollider collisionLayer] collidesAtRow:tileY andCol:tileX] )
				{
					if(isBottom)
					{
						double bottomDist = tileY * [tileCollider tileSize].height - ([transform position].y + [collider size].height);
						if(bottomDist >= 0 && ([collider bottomDist] < 0 || bottomDist < [collider bottomDist]))
						{
							[collider setBottomDist:bottomDist];
						}
					}
					else
					{
						double topDist = [transform position].y - (tileY + 1) * [tileCollider tileSize].height;
						if(topDist >= 0 && ([collider topDist] < 0 || topDist < [collider topDist]))
						{
							[collider setTopDist:topDist];
						}
					}
					
					break;
				}
			}
		}
	}
	
	position.x += [physics velocity].x;
	position.y -= [physics velocity].y;
	
	for(int i = 0; i < 2; i++)
	{
		BOOL isRight = i == 0;
		BOOL shouldBreak = NO;
		
		// Check one column of tiles
		
		tileX = (int) floor( ( position.x + ( isRight ? [collider size].width : 0 ) ) / [tileCollider tileSize].width );
		
		// Check a range of rows
		
		int fromY	= (int) floor( (position.y + 1) / [tileCollider tileSize].height );
		int toY		= (int) floor( (position.y + [collider size].height - 1) / [tileCollider tileSize].height );
		
		for(tileY = fromY; tileY <= toY; tileY++)
		{
			if( [[tileCollider collisionLayer] collidesAtRow:tileY andCol:tileX] )
			{
				if(isRight)
				{
					position.x = tileX * [tileCollider tileSize].width - [collider size].width;
					[collider setRightDist:0];
				}
				else
				{
					position.x = (tileX + 1) * [tileCollider tileSize].width;
					[collider setLeftDist:0];
				}
				
				if(physics != nil)
				{
					[physics setVelocityX:0];
				}
				
				// Only need to find one collision, so stop here
				shouldBreak = YES;
				break;
			}
		}
		
		if(shouldBreak)
		{
			break;
		}
		else
		{
			// Check if the next tile is solid
			tileX += isRight ? 1 : -1;
			for(tileY = fromY; tileY <= toY; tileY++)
			{
				if( [[tileCollider collisionLayer] collidesAtRow:tileY andCol:tileX] )
				{
					if(isRight)
					{
						double rightDist = tileX * [tileCollider tileSize].width - ([transform position].x + [collider size].width);
						if(rightDist >= 0 && ([collider rightDist] < 0 || rightDist < [collider rightDist]))
						{
							[collider setRightDist:rightDist];
						}
					}
					else
					{
						double leftDist = [transform position].x - (tileX + 1) * [tileCollider tileSize].width;
						if(leftDist >= 0 && ([collider leftDist] < 0 || leftDist < [collider leftDist]))
						{
							[collider setLeftDist:leftDist];
						}
					}
					
					break;
				}
			}
		}
	}
	
	position.y += [physics velocity].y;
	
	[transform setPosition:[self untranslate:position by:[collider offset]]];
}

- (void)resolveCollisionsBetween:(LGEntity *)a and:(LGEntity *)b
{
	// Initialize
	
	LGTransform *transformA = [a componentOfType:[LGTransform class]];
	LGTransform *transformB = [b componentOfType:[LGTransform class]];
	
	LGCollider *colliderA = [a componentOfType:[LGCollider class]];
	LGCollider *colliderB = [b componentOfType:[LGCollider class]];
	
	LGPhysics *physicsA = [a componentOfType:[LGPhysics class]];
	LGPhysics *physicsB = [b componentOfType:[LGPhysics class]];
	
	if([colliderB isMemberOfClass:[LGTileCollider class]])
	{
		[self resolveTileCollisionsBetween:a and:(LGTileCollider *)colliderB];
		return;
	}
	
	// Calculate distances
	
	CGPoint colliderPositionA = [self translate:[transformA position] by:[colliderA offset]];
	CGPoint colliderPositionB = [self translate:[transformB position] by:[colliderB offset]];
	
	double leftDist		= colliderPositionA.x - (colliderPositionB.x + [colliderB size].width);
	double rightDist	= colliderPositionB.x - (colliderPositionA.x + [colliderA size].width);
	double topDist		= colliderPositionA.y - (colliderPositionB.y + [colliderB size].height);
	double bottomDist	= colliderPositionB.y - (colliderPositionA.y + [colliderA size].height);
	
	// Update maximum distances
	
	if(leftDist >= 0 && (topDist <= 0 && bottomDist <= 0) && ([colliderA leftDist] < 0 || leftDist < [colliderA leftDist]))
	{
		[colliderA setLeftDist:leftDist];
	}
	
	if(rightDist >= 0 && (topDist <= 0 && bottomDist <= 0) && ([colliderA rightDist] < 0 || rightDist < [colliderA rightDist]))
	{
		[colliderA setRightDist:rightDist];
	}
	
	if(topDist >= 0 && (leftDist <= 0 && rightDist <= 0) && ([colliderA topDist] < 0|| topDist < [colliderA topDist]))
	{
		[colliderA setTopDist:topDist];
	}
	
	if(bottomDist >= 0 && (leftDist <= 0 && rightDist <= 0) && ([colliderA bottomDist] < 0 || bottomDist < [colliderA bottomDist]))
	{
		[colliderA setBottomDist:bottomDist];
	}
	
	// Bounding box test
	
	if(leftDist <= 0 && rightDist <= 0 && topDist <= 0 && bottomDist <= 0)
	{
		CGPoint resolution = CGPointZero;
		
		// Calculate resolution vector
		
		CGPoint dist = CGPointZero;
		dist.x = colliderPositionB.x > colliderPositionA.x ? colliderPositionB.x - colliderPositionA.x - [colliderA size].width : colliderPositionB.x + [colliderB size].width - colliderPositionA.x;
		dist.y = colliderPositionB.y > colliderPositionA.y ? colliderPositionB.y - colliderPositionA.y - [colliderA size].height : colliderPositionB.y + [colliderB size].height - colliderPositionA.y;
		
		if(fabs(dist.y) < fabs(dist.x))
		{
			resolution.y += dist.y;
		}
		else
		{
			resolution.x += dist.x;
		}
		
		// Resolve the collision
		
		if(!CGPointEqualToPoint(resolution, CGPointZero))
		{
			if([colliderB type] == LGColliderTypeStatic)
			{
				// Apply all of the resolution vector to dynamic entity A
				
				colliderPositionA = [self translate:colliderPositionA by:resolution];
				[transformA setPosition:[self untranslate:colliderPositionA by:[colliderA offset]]];
				
				if(physicsA != nil)
				{
					if((resolution.x > 0 && [physicsA velocity].x < 0) || (resolution.x < 0 && [physicsA velocity].x > 0))
					{
						[physicsA setVelocityX:0];
					}
					
					if((resolution.y > 0 && [physicsA velocity].y < 0) || (resolution.y < 0 && [physicsA velocity].y > 0))
					{
						[physicsA setVelocityY:0];
					}
				}
			}
			else
			{
				// Split the resolution vector between dynamic entities A and B
				
				CGPoint deltaA = [self scale:resolution by:0.5];
				CGPoint deltaB = [self scale:resolution by:-0.5];
				
				if(deltaA.x < 0 && [colliderA leftDist] < -deltaA.x && [colliderA leftDist] >= 0)
				{
					deltaB.x -= deltaA.x + [colliderA leftDist];
					deltaA.x = -[colliderA leftDist];
				}
				else if(deltaA.x > 0 && [colliderA rightDist] < deltaA.x && [colliderA rightDist] >= 0)
				{
					deltaB.x -= deltaA.x - [colliderA rightDist];
					deltaA.x = [colliderA rightDist];
				}
				
				if(deltaA.y < 0 && [colliderA topDist] < -deltaA.y && [colliderA topDist] >= 0)
				{
					deltaB.y -= deltaA.y + [colliderA topDist];
					deltaA.y = -[colliderA topDist];
				}
				else if(deltaA.y > 0 && [colliderA bottomDist] < deltaA.y && [colliderA bottomDist] >= 0)
				{
					deltaB.y -= deltaA.y - [colliderA bottomDist];
					deltaA.y = [colliderA bottomDist];
				}
				
				if(deltaB.x < 0 && [colliderB leftDist] < -deltaB.x && [colliderB leftDist] >= 0)
				{
					deltaA.x -= deltaB.x + [colliderB leftDist];
					deltaB.x = -[colliderB leftDist];
				}
				else if(deltaB.x > 0 && [colliderB rightDist] < deltaB.x && [colliderB rightDist] >= 0)
				{
					deltaA.x -= deltaB.x - [colliderB rightDist];
					deltaB.x = [colliderB rightDist];
				}
				
				if(deltaB.y < 0 && [colliderB topDist] < -deltaB.y && [colliderB topDist] >= 0)
				{
					deltaA.y -= deltaB.y + [colliderB topDist];
					deltaB.y = -[colliderB topDist];
				}
				else if(deltaB.y > 0 && [colliderB bottomDist] < deltaB.y && [colliderB bottomDist] >= 0)
				{
					deltaA.y -= deltaB.y - [colliderB bottomDist];
					deltaB.y = [colliderB bottomDist];
				}
				
				// Finally, resolve the collision
				
				colliderPositionA = [self translate:colliderPositionA by:deltaA];
				colliderPositionB = [self translate:colliderPositionB by:deltaB];
				
				[transformA setPosition:[self untranslate:colliderPositionA by:[colliderA offset]]];
				[transformB setPosition:[self untranslate:colliderPositionB by:[colliderB offset]]];
				
				if(physicsA != nil)
				{
					if((deltaA.x > 0 && [physicsA velocity].x < 0) || (deltaA.x < 0 && [physicsA velocity].x > 0))
					{
						[physicsA setVelocityX:0];
					}
					
					if((deltaA.y > 0 && [physicsA velocity].y < 0) || (deltaA.y < 0 && [physicsA velocity].y > 0))
					{
						[physicsA setVelocityY:0];
					}
				}
				
				if(physicsB != nil)
				{
					if((deltaB.x > 0 && [physicsB velocity].x < 0) || (deltaB.x < 0 && [physicsB velocity].x > 0))
					{
						[physicsB setVelocityX:0];
					}
					
					if((deltaB.y > 0 && [physicsB velocity].y < 0) || (deltaB.y < 0 && [physicsB velocity].y > 0))
					{
						[physicsB setVelocityY:0];
					}
				}
			}
			
			// Update distances
			
			if(resolution.x < 0)
			{
				[colliderA setRightDist:0];
				[colliderB setLeftDist:0];
			}
			else if(resolution.x > 0)
			{
				[colliderA setLeftDist:0];
				[colliderB setRightDist:0];
			}
			
			if(resolution.y < 0)
			{
				[colliderA setBottomDist:0];
				[colliderB setTopDist:0];
			}
			else if(resolution.y > 0)
			{
				[colliderA setTopDist:0];
				[colliderB setBottomDist:0];
			}
		}
	}
}

@end