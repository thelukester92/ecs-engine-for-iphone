//
//  LGPhysics.m
//  Engine
//
//  Created by Luke Godfrey on 2/19/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGPhysics.h"

@implementation LGPhysics

@synthesize velocity, mass, respondsToGravity;

- (void)addToVelocity:(CGPoint)v
{
	velocity.x += v.x;
	velocity.y += v.y;
}

- (void)subtractFromVelocity:(CGPoint)v
{
	velocity.x -= v.x;
	velocity.y -= v.y;
}

- (void)limitVelocity:(CGPoint)v
{
	velocity.x = MIN(velocity.x, v.x);
	velocity.y = MIN(velocity.y, v.y);
	
	velocity.x = MAX(velocity.x, -v.x);
	velocity.y = MAX(velocity.y, -v.y);
}

- (void)addToVelocityX:(double)x
{
	velocity.x += x;
}

- (void)addToVelocityY:(double)y
{
	velocity.y += y;
}

- (void)setVelocityX:(double)x
{
	velocity.x = x;
}

- (void)setVelocityY:(double)y
{
	velocity.y = y;
}

- (void)initialize
{
	velocity			= CGPointZero;
	mass				= 1.0;
	respondsToGravity	= YES;
}

@end