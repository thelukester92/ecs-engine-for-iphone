//
//  LGCollider.m
//  Engine
//
//  Created by Luke Godfrey on 3/3/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGCollider.h"

@implementation LGCollider

@synthesize type, offset, collidedLeft, collidedRight, collidedTop, collidedBottom;

- (CGSize)boundingBox
{
	return CGSizeZero;
}

- (void)resetCollider
{
	collidedLeft	= NO;
	collidedRight	= NO;
	collidedTop		= NO;
	collidedBottom	= NO;
}

- (void)initialize
{
	type	= LGColliderTypeSolid;
	offset	= CGPointZero;
	
	[self resetCollider];
}

@end