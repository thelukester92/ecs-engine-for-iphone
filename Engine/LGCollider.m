//
//  LGCollider.m
//  Engine
//
//  Created by Luke Godfrey on 3/3/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGCollider.h"

@implementation LGCollider

@synthesize size, ignoresOtherColliders, collidedLeft, collidedRight, collidedTop, collidedBottom;

- (void)resetCollider
{
	collidedLeft	= NO;
	collidedRight	= NO;
	collidedTop		= NO;
	collidedBottom	= NO;
}

- (void)initialize
{
	size = CGSizeZero;
	ignoresOtherColliders = NO;
	[self resetCollider];
}

@end