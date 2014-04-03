//
//  LGPhysicalSystem.m
//  Engine
//
//  Created by Luke Godfrey on 2/20/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "LGPhysicalSystem.h"
#import "LGEntity.h"
#import "LGPhysics.h"
#import "LGTransform.h"

@implementation LGPhysicalSystem

@synthesize gravity, terminalVelocity;

- (BOOL)acceptsEntity:(LGEntity *)entity
{
	return [entity hasComponentsOfType:[LGPhysics class], [LGTransform class], nil];
}

- (void)update
{
	for(LGEntity *entity in self.entities)
	{
		LGPhysics *physics = [entity componentOfType:[LGPhysics class]];
		LGTransform *transform = [entity componentOfType:[LGTransform class]];
		
		if([physics respondsToGravity])
		{
			[physics addToVelocity:gravity];
		}
		
		[physics limitVelocity:terminalVelocity];
		[transform addToPosition:[physics velocity]];
	}
}

- (void)initialize
{
	gravity				= CGPointMake(0, 0.25);
	terminalVelocity	= CGPointMake(15, 15);
	self.updateOrder	= LGUpdateOrderMovement;
}

@end