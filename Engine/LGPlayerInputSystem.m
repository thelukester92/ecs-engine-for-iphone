//
//  LGPlayerInputSystem.m
//  Engine
//
//  Created by Luke Godfrey on 3/5/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGPlayerInputSystem.h"
#import "LGScene.h"
#import "LGEntity.h"
#import "LGPlayer.h"
#import "LGSprite.h"
#import "LGPhysics.h"
#import "LGCollider.h"

@implementation LGPlayerInputSystem

@synthesize sprite, physics, collider, receivingInput, speedX;

#pragma mark Hidden Methods

- (void)jump
{
	if([collider collidedBottom])
	{
		[sprite setCurrentState:@"jump"];
		[physics setVelocityY:-5];
		[collider setCollidedBottom:NO];
	}
}

#pragma mark LGSystem Overrides

- (BOOL)acceptsEntity:(LGEntity *)entity
{
	return [self.entities count] == 0 && [entity hasComponentsOfType:[LGPlayer class], [LGPhysics class], [LGSprite class], nil];
}

- (void)addEntity:(LGEntity *)entity
{
	[super addEntity:entity];
	
	physics		= [[self.entities objectAtIndex:0] componentOfType:[LGPhysics class]];
	sprite		= [[self.entities objectAtIndex:0] componentOfType:[LGSprite class]];
	collider	= [[self.entities objectAtIndex:0] componentOfType:[LGCollider class]];
}

- (void)touchDown:(NSSet *)touches allTouches:(NSDictionary *)allTouches
{
	CGPoint point = [[touches anyObject] locationInView:[self.scene view]];
	
	if(point.x > [[self.scene view] frame].size.width / 2)
		speedX = 3;
	else
		speedX = -3;
	
	if(speedX < 0)
		[sprite view].transform = CGAffineTransformMakeScale(-1.0, 1.0);
	else
		[sprite view].transform = CGAffineTransformMakeScale(1.0, 1.0);
	
	receivingInput = YES;
}

- (void)touchUp:(NSSet *)touches allTouches:(NSDictionary *)allTouches
{
	[physics setVelocityX:0];
	
	receivingInput = [allTouches count] > 0;
}

- (void)update
{
	if([sprite animationComplete])
	{
		if(![collider collidedBottom])
			[sprite setCurrentState:@"fall"];
		else if(receivingInput)
		{
			[sprite setCurrentState:@"walk"];
			[physics setVelocityX:speedX];
		}
		else
			[sprite setCurrentState:@"idle"];
	}
}

- (void)initialize
{
	sprite				= nil;
	physics				= nil;
	collider			= nil;
	receivingInput		= NO;
	speedX				= 0;
	self.updateOrder	= LGUpdateOrderBeforeMovement;
}

@end