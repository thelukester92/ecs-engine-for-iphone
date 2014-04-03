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
#import "LGTransform.h"

@implementation LGPlayerInputSystem

@synthesize sprite, physics, collider, transform, previousPosition, receivingInput, isOnGround, speedX, directionX;

#pragma mark Hidden Methods

- (void)jump
{
	if(isOnGround)
	{
		[sprite setCurrentState:@"jump"];
		[physics setVelocityY:-6];
	}
}

#pragma mark LGSystem Overrides

- (BOOL)acceptsEntity:(LGEntity *)entity
{
	return [self.entities count] == 0 && [entity hasComponentsOfType:[LGPlayer class], [LGPhysics class], [LGSprite class], [LGTransform class], nil];
}

- (void)addEntity:(LGEntity *)entity
{
	physics		= [entity componentOfType:[LGPhysics class]];
	sprite		= [entity componentOfType:[LGSprite class]];
	collider	= [entity componentOfType:[LGCollider class]];
	transform	= [entity componentOfType:[LGTransform class]];
}

- (void)touchDown:(NSSet *)touches allTouches:(NSDictionary *)allTouches
{
	CGPoint point = [[touches anyObject] locationInView:[self.scene view]];
	
	if([allTouches count] == 2)
	{
		[self jump];
	}
	else
	{
		if(point.x > [[self.scene view] frame].size.width / 2)
		{
			directionX = 1;
			[sprite view].transform = CGAffineTransformMakeScale(1.0, 1.0);
		}
		else
		{
			directionX = -1;
			[sprite view].transform = CGAffineTransformMakeScale(-1.0, 1.0);
		}
	}
	
	receivingInput = YES;
}

- (void)touchUp:(NSSet *)touches allTouches:(NSDictionary *)allTouches
{
	if([allTouches count] == 0)
	{
		directionX = 0;
		receivingInput = NO;
	}
	else if([allTouches count] == 1)
	{
		CGPoint point = [[[allTouches allValues] objectAtIndex:0] locationInView:[self.scene view]];
		
		if(point.x > [[self.scene view] frame].size.width / 2)
		{
			directionX = 1;
			[sprite view].transform = CGAffineTransformMakeScale(1.0, 1.0);
		}
		else
		{
			directionX = -1;
			[sprite view].transform = CGAffineTransformMakeScale(-1.0, 1.0);
		}
	}
}

- (void)update
{
	CGPoint delta = CGPointMake([transform position].x - previousPosition.x, [transform position].y - previousPosition.y);
	isOnGround = [collider bottomCollided] && [physics velocity].y >= 0;
	
	if([sprite animationComplete])
	{
		if(!isOnGround)
		{
			if([physics velocity].y >= 0)
			{
				[sprite setCurrentState:@"fall"];
			}
			else
			{
				[sprite setCurrentState:@"jump"];
			}
		}
		else if(delta.x != 0)
		{
			[sprite setCurrentState:@"walk"];
		}
		else
		{
			[sprite setCurrentState:@"idle"];
		}
		
		[physics setVelocityX:(speedX * directionX)];
	}
	
	previousPosition = [transform position];
}

- (void)initialize
{
	sprite				= nil;
	physics				= nil;
	collider			= nil;
	transform			= nil;
	previousPosition	= CGPointZero;
	receivingInput		= NO;
	isOnGround			= NO;
	speedX				= 4;
	directionX			= 0;
	self.updateOrder	= LGUpdateOrderBeforeMovement;
}

@end