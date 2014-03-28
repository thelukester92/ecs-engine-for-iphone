//
//  LGCollider.m
//  Engine
//
//  Created by Luke Godfrey on 3/3/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGCollider.h"

@implementation LGCollider

@synthesize type, offset, collidedLeft, collidedRight, collidedTop, collidedBottom, staticLeft, staticRight, staticTop, staticBottom;

- (CGSize)boundingBox
{
	return CGSizeZero;
}

- (void)resetCollider
{
	// Whether any collisions were made on each side
	collidedLeft	= NO;
	collidedRight	= NO;
	collidedTop		= NO;
	collidedBottom	= NO;
	
	// Whether static collisions were made on each side
	staticLeft		= NO;
	staticRight		= NO;
	staticTop		= NO;
	staticBottom	= NO;
}

- (void)initialize
{
	type	= LGColliderTypeSolid;
	offset	= CGPointZero;
	
	[self resetCollider];
}

@end