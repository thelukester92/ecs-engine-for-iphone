//
//  LGCollisionResolver.m
//  Engine
//
//  Created by Luke Godfrey on 3/27/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGCollisionResolver.h"
#import "LGPhysics.h"

@implementation LGCollisionResolver

@synthesize physicsA, physicsB, resolution, impulse;

- (void)resolveRectangle:(CGRect)a withRectangle:(CGRect)b
{
	[self reset];
	
	CGPoint dist = CGPointZero;
	dist.x = b.origin.x > a.origin.x ? b.origin.x - a.origin.x - a.size.width : b.origin.x + b.size.width - a.origin.x;
	dist.y = b.origin.y > a.origin.y ? b.origin.y - a.origin.y - a.size.height : b.origin.y + b.size.height - a.origin.y;
	
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

- (id)init
{
	self = [super init];
	
	if(self)
	{
		[self reset];
	}
	
	return self;
}

#pragma mark Private Methods

- (void)reset
{
	physicsA	= nil;
	physicsB	= nil;
	resolution	= CGPointZero;
	impulse		= CGPointZero;
}

@end