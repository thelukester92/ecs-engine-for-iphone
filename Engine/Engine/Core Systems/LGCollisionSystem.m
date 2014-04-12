//
//  LGCollisionSystem.m
//  Engine
//
//  Created by Luke Godfrey on 3/3/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "LGCollisionSystem.h"
#import "LGEntity.h"
#import "LGTransform.h"
#import "LGPhysics.h"
#import "LGTileCollider.h"
#import "LGPlayer.h"
#import "LGSpatialGrid.h"
#import "LGScene.h"
#import "LGTMXTileLayer.h"

@implementation LGCollisionSystem

@synthesize staticEntities, dynamicEntities, grid;

#pragma mark LGCollisionSystem Private Methods

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

- (void)updateTransform:(LGTransform *)transform andCollider:(LGCollider *)collider andPhysics:(LGPhysics *)physics with:(CGPoint)resolution
{
	[transform setPosition:[self translate:[transform position] by:resolution]];
	
	if(physics != nil)
	{
		if((resolution.x > 0 && [physics velocity].x < 0) || (resolution.x < 0 && [physics velocity].x > 0))
		{
			[physics setVelocityX:0];
		}
		
		if((resolution.y > 0 && [physics velocity].y < 0) || (resolution.y < 0 && [physics velocity].y > 0))
		{
			[physics setVelocityY:0];
		}
	}
}

- (CGPoint)resolveTileCollisionsBetween:(LGEntity *)a and:(LGTileCollider *)tileCollider alreadyAdjusted:(CGPoint)alreadyAdjusted chainingAxis:(LGCollisionAxis)axis
{
	LGTransform *transform = [a componentOfType:[LGTransform type]];
	LGCollider *collider = [a componentOfType:[LGCollider type]];
	LGPhysics *physics = [a componentOfType:[LGPhysics type]];
	
	CGPoint position = [self translate:[transform position] by:[collider offset]];
	int tileX, tileY;
	
	// Decompose the collision along each axis
	
	if(axis != LGCollisionAxisY)
	{
		position.y -= [physics velocity].y + alreadyAdjusted.y;
		
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
					}
					else
					{
						position.x = (tileX + 1) * [tileCollider tileSize].width;
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
		}
		
		position.y += [physics velocity].y + alreadyAdjusted.y;
	}
	
	if(axis != LGCollisionAxisX)
	{
		position.x -= [physics velocity].x + alreadyAdjusted.x;
		
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
					}
					else
					{
						position.y = (tileY + 1) * [tileCollider tileSize].height;
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
		}
		
		position.x += [physics velocity].x + alreadyAdjusted.x;
	}
	
	position = [self untranslate:position by:[collider offset]];
	
	return CGPointMake(position.x - [transform position].x, position.y - [transform position].y);
}

- (CGPoint)resolveCollisionsBetween:(LGEntity *)a and:(LGEntity *)b ignoring:(LGEntity *)entityToIgnore withAdditionalMass:(double)additionalMass forceStatic:(BOOL)forceStatic alreadyAdjustedA:(CGPoint)alreadyAdjustedA collisionAxis:(LGCollisionAxis)axis
{
	// Initialize
	
	LGCollider *colliderA = [a componentOfType:[LGCollider type]];
	LGCollider *colliderB = [b componentOfType:[LGCollider type]];
	
	LGTransform *transformA = [a componentOfType:[LGTransform type]];
	LGTransform *transformB = [b componentOfType:[LGTransform type]];
	
	LGPhysics *physicsA = [a componentOfType:[LGPhysics type]];
	LGPhysics *physicsB = [b componentOfType:[LGPhysics type]];
	
	CGPoint colliderPositionA = [self translate:[transformA position] by:[colliderA offset]];
	CGPoint colliderPositionB = [self translate:[transformB position] by:[colliderB offset]];
	
	CGPoint resolution = CGPointZero;
	
	// Calculate resolution
	
	if([colliderB isMemberOfClass:[LGTileCollider class]])
	{
		resolution = [self resolveTileCollisionsBetween:a and:(LGTileCollider *)colliderB alreadyAdjusted:alreadyAdjustedA chainingAxis:axis];
	}
	else
	{
		// Bounding box test
		
		BOOL outsideLeft	= colliderPositionA.x > colliderPositionB.x + [colliderB size].width;
		BOOL outsideRight	= colliderPositionA.x + [colliderA size].width < colliderPositionB.x;
		BOOL outsideTop		= colliderPositionA.y > colliderPositionB.y + [colliderB size].height;
		BOOL outsideBottom	= colliderPositionA.y + [colliderA size].height < colliderPositionB.y;
		
		if(!outsideLeft && !outsideRight && !outsideTop && !outsideBottom)
		{
			// Calculate the resolution vector pointing from entity B to entity A
			
			resolution.x = colliderPositionB.x > colliderPositionA.x ? colliderPositionB.x - colliderPositionA.x - [colliderA size].width : colliderPositionB.x + [colliderB size].width - colliderPositionA.x;
			resolution.y = colliderPositionB.y > colliderPositionA.y ? colliderPositionB.y - colliderPositionA.y - [colliderA size].height : colliderPositionB.y + [colliderB size].height - colliderPositionA.y;
			
			if(fabs(resolution.y) < fabs(resolution.x))
			{
				resolution.x = 0;
			}
			else
			{
				resolution.y = 0;
			}
		}
	}
	
	// Limit to the given axis
	
	if(axis == LGCollisionAxisX)
	{
		resolution.y = 0;
	}
	
	if(axis == LGCollisionAxisY)
	{
		resolution.x = 0;
	}
	
	// Update collider flags
	
	if(resolution.x > 0)
	{
		[colliderA setLeftCollided:YES];
		[colliderB setRightCollided:YES];
	}
	else if(resolution.x < 0)
	{
		[colliderA setRightCollided:YES];
		[colliderB setLeftCollided:YES];
	}
	
	if(resolution.y > 0)
	{
		[colliderA setTopCollided:YES];
		[colliderB setBottomCollided:YES];
	}
	else if(resolution.y < 0)
	{
		[colliderA setBottomCollided:YES];
		[colliderB setTopCollided:YES];
	}
	
	// Resolve the collision
	
	if(!CGPointEqualToPoint(resolution, CGPointZero))
	{
		double massA = (physicsA != nil ? [physicsA mass] : 0) + additionalMass;
		double massB = physicsB != nil ? [physicsB mass] : 0;
		
		CGPoint deltaA, deltaB;
		
		if(forceStatic || [colliderB type] == LGColliderTypeStatic)
		{
			deltaA = resolution;
			deltaB = CGPointZero;
		}
		else
		{
			double ratioA, ratioB;
			
			if(massA == 0 && massB == 0)
			{
				ratioA = 0.5;
				ratioB = 0.5;
			}
			else
			{
				ratioA = massB / (massA + massB);
				ratioB = ratioA - 1;
			}
			
			deltaA = [self scale:resolution by:ratioA];
			deltaB = [self scale:resolution by:ratioB];
		}
		
		// Resolve the collision
		
		[self updateTransform:transformA andCollider:colliderA andPhysics:physicsA with:deltaA];
		
		if(!CGPointEqualToPoint(deltaB, CGPointZero))
		{
			[self updateTransform:transformB andCollider:colliderB andPhysics:physicsB with:deltaB];
		}
		
		// Collision chaining
		
		LGCollisionAxis collisionAxis = resolution.y != 0 ? LGCollisionAxisY : LGCollisionAxisX;
		
		if(forceStatic || [colliderB type] == LGColliderTypeStatic)
		{
			NSArray *entities = [grid entitiesNearEntity:a];
			
			for(int i = 0; i < [entities count]; i++)
			{
				LGEntity *c = [entities objectAtIndex:i];
				if(![c isEqual:a] && ![c isEqual:entityToIgnore] && [(LGCollider *)[c componentOfType:[LGCollider type]] type] != LGColliderTypeStatic)
				{
					[self resolveCollisionsBetween:c and:a ignoring:b withAdditionalMass:0 forceStatic:YES alreadyAdjustedA:CGPointZero collisionAxis:collisionAxis];
				}
			}
		}
		else
		{
			BOOL chained = NO;
			
			NSArray *entities = [grid entitiesNearEntity:a];
			
			for(int i = 0; i < [entities count]; i++)
			{
				LGEntity *c = [entities objectAtIndex:i];
				if(![c isEqual:a] && ![c isEqual:b] && ![c isEqual:entityToIgnore])
				{
					CGPoint resolutionA = [self resolveCollisionsBetween:a and:c ignoring:b withAdditionalMass:massB forceStatic:NO alreadyAdjustedA:deltaA collisionAxis:collisionAxis];
					if(!CGPointEqualToPoint(resolutionA, CGPointZero))
					{
						// Resolution caused another collision -- move entity B back
						[transformB addToPosition:resolutionA];
						deltaB = [self translate:deltaB by:resolutionA];
						
						chained = YES;
					}
				}
			}
			
			if(!chained)
			{
				entities = [grid entitiesNearEntity:b];
				
				for(int i = 0; i < [entities count]; i++)
				{
					LGEntity *c = [entities objectAtIndex:i];
					if(![c isEqual:a] && ![c isEqual:b] && ![c isEqual:entityToIgnore])
					{
						CGPoint resolutionB = [self resolveCollisionsBetween:b and:c ignoring:a withAdditionalMass:massA forceStatic:NO alreadyAdjustedA:deltaB collisionAxis:collisionAxis];
						if(!CGPointEqualToPoint(resolutionB, CGPointZero))
						{
							// Resolution caused another collision -- move entity A back
							[transformA addToPosition:resolutionB];
							deltaA = [self translate:deltaA by:resolutionB];
						}
					}
				}
			}
		}
		
		return deltaA;
	}
	
	return CGPointZero;
}

#pragma mark LGSystem Methods

- (BOOL)acceptsEntity:(LGEntity *)entity
{
	return [entity hasComponentsOfType:[LGTransform type], [LGCollider type], nil];
}

- (void)addEntity:(LGEntity *)entity
{
	[super addEntity:entity];
	
	LGCollider *collider = [entity componentOfType:[LGCollider type]];
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
	grid = [[LGSpatialGrid alloc] initWithSize:CGSizeMake(100, 100)];
	
	for(int i = 0; i < [self.entities count]; i++)
	{
		LGEntity *entity = [self.entities objectAtIndex:i];
		[(LGCollider *)[entity componentOfType:[LGCollider type]] reset];
		[grid addEntity:entity];
	}
	
	for(int i = 0; i < [dynamicEntities count]; i++)
	{
		LGEntity *a = [dynamicEntities objectAtIndex:i];
		
		NSArray *entities = [grid entitiesNearEntity:a];
		
		for(int j = 0; j < [entities count]; j++)
		{
			LGEntity *b = [entities objectAtIndex:j];
			
			if(![a isEqual:b])
			{
				[self resolveCollisionsBetween:a and:b ignoring:nil withAdditionalMass:0 forceStatic:NO alreadyAdjustedA:CGPointZero collisionAxis:LGCollisionAxisAny];
			}
		}
	}
}

- (void)initialize
{
	staticEntities	= [NSMutableArray array];
	dynamicEntities	= [NSMutableArray array];
}

@end