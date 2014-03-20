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
#import "LGCircleCollider.h"
#import "LGPhysics.h"

@implementation LGCollisionSystem

- (BOOL)acceptsEntity:(LGEntity *)entity
{
	return [entity hasComponentsOfType:[LGTransform class], [LGCollider class], nil];
}

- (void)update
{
	// Use nested loops to make sure each entity pair is only run once per loop
	for(int i = 0; i < [self.entities count]; i++)
	{
		LGEntity *a = [self.entities objectAtIndex:i];
		
		if(i == 0)
			[[a componentOfType:[LGCollider class]] resetCollider];
		
		for(int j = i + 1; j < [self.entities count]; j++)
		{
			LGEntity *b = [self.entities objectAtIndex:j];
			
			if(i == 0)
				[[b componentOfType:[LGCollider class]] resetCollider];
			
			[self resolveCollisionsBetween:a and:b];
		}
	}
}

- (void)initialize
{
	self.updateOrder = LGUpdateOrderBeforeRender;
}

#pragma mark Hidden Methods

- (void)swapPointer:(void **)ptr1 with:(void **)ptr2
{
	void *tmp = *ptr1;
	*ptr1 = *ptr2;
	*ptr2 = tmp;
}

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
	
	BOOL movedB		= !CGPointEqualToPoint([transformB position], [transformB prevPosition]);
	BOOL canMoveA	= [colliderA type] != LGColliderTypeStatic;
	BOOL canMoveB	= [colliderB type] != LGColliderTypeStatic;
	
	if(canMoveB && (movedB || !canMoveA))
	{
		// Collisions can only be resolved if at least one of the colliders can be moved
		// This swap ensures that A is always movable
		
		[self swapPointer:(void *)&a with:(void *)&b];
		[self swapPointer:(void *)&transformA with:(void *)&transformB];
		[self swapPointer:(void *)&colliderA with:(void *)&colliderB];
		
		canMoveB = canMoveA;
		canMoveA = YES;
	}
	else if(!canMoveA)
	{
		// Both of the colliders ignore each other and any collision doesn't need to be resolved
		return;
	}
	
	CGPoint colliderPositionA = [self translate:[transformA position] by:[colliderA offset]];
	CGPoint colliderPositionB = [self translate:[transformB position] by:[colliderB offset]];
	
	CGPoint colliderPrevPositionA = [self translate:[transformA prevPosition] by:[colliderA offset]];
	CGPoint colliderPrevPositionB = [self translate:[transformB prevPosition] by:[colliderB offset]];
	
	/*
	 * Basic Detection
	 */
	
	BOOL outsideLeft	= colliderPositionA.x > colliderPositionB.x + [colliderB size].width;
	BOOL outsideRight	= colliderPositionA.x + [colliderA size].width < colliderPositionB.x;
	BOOL outsideTop		= colliderPositionA.y > colliderPositionB.y + [colliderB size].height;
	BOOL outsideBottom	= colliderPositionA.y + [colliderA size].height < colliderPositionB.y;
	
	if(!outsideLeft && !outsideRight && !outsideTop && !outsideBottom)
	{
		// Get direction of movement
		
		double xdelA = colliderPositionA.x - colliderPrevPositionA.x;
		double ydelA = colliderPositionA.y - colliderPrevPositionA.y;
		double xdelB = colliderPositionB.x - colliderPrevPositionB.x;
		double ydelB = colliderPositionB.y - colliderPrevPositionB.y;
		
		int xdirA = (ABS(xdelA) > ABS(xdelB) ? (xdelA > 0 ? 1 : -1) : (xdelB > 0 ? -1 : 1));
		int ydirA = (ABS(ydelA) > ABS(ydelB) ? (ydelA > 0 ? 1 : -1) : (ydelB > 0 ? -1 : 1));
		
		/*
		 * Resolution
		 */
		
		LGPhysics *physicsA = [a componentOfType:[LGPhysics class]];
		LGPhysics *physicsB = [b componentOfType:[LGPhysics class]];
		
		CGPoint resolution = CGPointZero;
		CGPoint impulse = CGPointZero;
		
		if([colliderA isMemberOfClass:[colliderB class]] && [colliderA isMemberOfClass:[LGCollider class]])
		{
			// Case 1: Rectangle to Rectangle Collision
			
			double overlapX, overlapY;
			
			if(xdirA == 1)
			{
				overlapX = colliderPositionA.x + [colliderA size].width - colliderPositionB.x;
				[colliderA setCollidedRight:YES];
				[colliderB setCollidedLeft:YES];
			}
			else
			{
				overlapX = colliderPositionB.x + [colliderB size].width - colliderPositionA.x;
				[colliderA setCollidedLeft:YES];
				[colliderB setCollidedRight:YES];
			}
			
			if(ydirA == 1)
			{
				overlapY = colliderPositionA.y + [colliderA size].height - colliderPositionB.y;
				[colliderA setCollidedBottom:YES];
				[colliderB setCollidedTop:YES];
			}
			else
			{
				overlapY = colliderPositionB.y + [colliderB size].height - colliderPositionA.y;
				[colliderA setCollidedTop:YES];
				[colliderB setCollidedBottom:YES];
			}
			
			if(overlapY < overlapX || xdirA == 0)
			{
				resolution.y -= (overlapY + 0.1) * ydirA;
				
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
				resolution.x -= (overlapX + 0.1) * xdirA;
				
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
		else if([colliderA isMemberOfClass:[colliderB class]] && [colliderA isMemberOfClass:[LGCircleCollider class]])
		{
			// Case 2: Circle to Circle Collision
			
			CGPoint dist = CGPointZero;
			dist.x = colliderPositionA.x + [colliderA size].width / 2 - colliderPositionB.x - [colliderB size].width / 2;
			dist.y = colliderPositionA.y + [colliderA size].height / 2 - colliderPositionB.y - [colliderB size].height / 2;
			
			double radii = [(LGCircleCollider *)colliderA radius] + [(LGCircleCollider *)colliderB radius];
			
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
		}
		
		// Adjust the transforms
		if(physicsA != nil && physicsB != nil && canMoveB)
		{
			double aRatio = [physicsA mass] / ([physicsA mass] + [physicsB mass]);
			double bRatio = [physicsB mass] / ([physicsA mass] + [physicsB mass]) * -1;
			
			colliderPositionA = [self translate:colliderPositionA by:[self scale:resolution by:aRatio]];
			colliderPositionB = [self translate:colliderPositionB by:[self scale:resolution by:bRatio]];
			
			[transformA setPosition:[self untranslate:colliderPositionA by:[colliderA offset]]];
			[transformB setPosition:[self untranslate:colliderPositionB by:[colliderB offset]]];
		}
		else
		{
			colliderPositionA = [self translate:colliderPositionA by:resolution];
			[transformA setPosition:[self untranslate:colliderPositionA by:[colliderA offset]]];
		}
		
		// Adjust the velocities
		if(physicsA != nil && !CGPointEqualToPoint(impulse, CGPointZero))
		{
			if(!canMoveB || physicsB == nil)
			{
				// Model entity B as if it has infinite mass; apply the entire impulse to entity A
				double elasticity = physicsB != nil ? MAX([physicsA elasticity], [physicsB elasticity]) : [physicsA elasticity];
				[physicsA setVelocity:CGPointMake(elasticity * impulse.x, elasticity * impulse.y)];
			}
			else
			{
				double elasticity = MAX([physicsA elasticity], [physicsB elasticity]);
				
				double newVelocityAx = (elasticity * [physicsB mass] * impulse.x + [physicsA mass] * [physicsA velocity].x + [physicsB mass] * [physicsB velocity].x) / ([physicsA mass] + [physicsB mass]);
				double newVelocityBx = (elasticity * [physicsA mass] * -impulse.x + [physicsA mass] * [physicsA velocity].x + [physicsB mass] * [physicsB velocity].x) / ([physicsA mass] + [physicsB mass]);
				
				double newVelocityAy = (elasticity * [physicsB mass] * impulse.y + [physicsA mass] * [physicsA velocity].y + [physicsB mass] * [physicsB velocity].y) / ([physicsA mass] + [physicsB mass]);
				double newVelocityBy = (elasticity * [physicsA mass] * -impulse.y + [physicsA mass] * [physicsA velocity].y + [physicsB mass] * [physicsB velocity].y) / ([physicsA mass] + [physicsB mass]);
				
				[physicsA setVelocity:CGPointMake(newVelocityAx, newVelocityAy)];
				[physicsB setVelocity:CGPointMake(newVelocityBx, newVelocityBy)];
			}
		}
	}
}

@end