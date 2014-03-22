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

// Vector operations

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
			
			LGRectangleCollider *rectA = (LGRectangleCollider *)colliderA;
			LGRectangleCollider *rectB = (LGRectangleCollider *)colliderB;
			
			CGPoint dist = CGPointZero;
			dist.x = colliderPositionB.x > colliderPositionA.x ? colliderPositionB.x - colliderPositionA.x - [rectA size].width : colliderPositionB.x + [rectB size].width - colliderPositionA.x;
			dist.y = colliderPositionB.y > colliderPositionA.y ? colliderPositionB.y - colliderPositionA.y - [rectA size].height : colliderPositionB.y + [rectB size].height - colliderPositionA.y;
			
			if(fabs(dist.y) < fabs(dist.x))
			{
				resolution.y += dist.y;
				
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
				resolution.x += dist.x;
				
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
		
		// Adjust the transforms
		if(physicsA != nil && physicsB != nil && canMoveB)
		{
			double aRatio = [physicsB mass] / ([physicsA mass] + [physicsB mass]);
			double bRatio = [physicsA mass] / ([physicsA mass] + [physicsB mass]) * -1;
			
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
		if(!CGPointEqualToPoint(impulse, CGPointZero))
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