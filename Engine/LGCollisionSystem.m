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
#import "LGCollider.h"
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

- (void)resolveCollisionsBetween:(LGEntity *)a and:(LGEntity *)b
{
	LGTransform *transformA = [a componentOfType:[LGTransform class]];
	LGTransform *transformB = [b componentOfType:[LGTransform class]];
	
	LGCollider *colliderA = [a componentOfType:[LGCollider class]];
	LGCollider *colliderB = [b componentOfType:[LGCollider class]];
	
	BOOL outsideLeft	= [transformA position].x > [transformB position].x + [colliderB size].width;
	BOOL outsideRight	= [transformA position].x + [colliderA size].width < [transformB position].x;
	BOOL outsideTop		= [transformA position].y > [transformB position].y + [colliderB size].height;
	BOOL outsideBottom	= [transformA position].y + [colliderA size].height < [transformB position].y;
	
	if(!outsideLeft && !outsideRight && !outsideTop && !outsideBottom)
	{
		BOOL movedB = !CGPointEqualToPoint([transformB position], [transformB prevPosition]);
		
		if(![colliderB ignoresOtherColliders] && (movedB || [colliderA ignoresOtherColliders]))
		{
			// Entity B needs to be moved; swap A and B
			[self swapPointer:(void *)&a with:(void *)&b];
			[self swapPointer:(void *)&transformA with:(void *)&transformB];
			[self swapPointer:(void *)&colliderA with:(void *)&colliderB];
		}
		else if([colliderA ignoresOtherColliders])
		{
			// Both of the colliders ignore each other and the collision doesn't need to be resolved
			return;
		}
		
		int xdirA = [transformA position].x != [transformA prevPosition].x ? (([transformA position].x - [transformA prevPosition].x) > 0 ? 1 : -1) : 0;
		int xdirB = [transformB position].x != [transformB prevPosition].x ? (([transformB position].x - [transformB prevPosition].x) > 0 ? 1 : -1) : 0;
		int ydirA = [transformA position].y != [transformA prevPosition].y ? (([transformA position].y - [transformA prevPosition].y) > 0 ? 1 : -1) : 0;
		int ydirB = [transformB position].y != [transformB prevPosition].y ? (([transformB position].y - [transformB prevPosition].y) > 0 ? 1 : -1) : 0;
		
		if(xdirA == 0)
			xdirA = -xdirB;
		
		if(ydirA == 0)
			ydirA = -ydirB;
		
		if(xdirA == 0 && ydirA == 0)
		{
			// Collision without movement -- this should never happen
			return;
		}
		
		LGPhysics *physics = [a componentOfType:[LGPhysics class]];
		double overlapX, overlapY;
		
		if(xdirA == 1)
		{
			overlapX = [transformA position].x + [colliderA size].width - [transformB position].x;
			[colliderA setCollidedRight:YES];
			[colliderB setCollidedLeft:YES];
		}
		else
		{
			overlapX = [transformB position].x + [colliderB size].width - [transformA position].x;
			[colliderA setCollidedLeft:YES];
			[colliderB setCollidedRight:YES];
		}
		
		if(ydirA == 1)
		{
			overlapY = [transformA position].y + [colliderA size].height - [transformB position].y;
			[colliderA setCollidedBottom:YES];
			[colliderB setCollidedTop:YES];
		}
		else
		{
			overlapY = [transformB position].y + [colliderB size].height - [transformA position].y;
			[colliderA setCollidedTop:YES];
			[colliderB setCollidedBottom:YES];
		}
		
		if(overlapY < overlapX || xdirA == 0)
		{
			// Resolve along the y-axis
			[transformA addToPositionY:((overlapY + 0.1) * -ydirA)];
			
			if(physics != nil)
			{
				[physics setVelocityY:0];
			}
		}
		else
		{
			// Resolve along the x-axis
			[transformA addToPositionX:((overlapX + 0.1) * -xdirA)];
			
			if(physics != nil)
			{
				[physics setVelocityX:0];
			}
		}
	}
}

@end