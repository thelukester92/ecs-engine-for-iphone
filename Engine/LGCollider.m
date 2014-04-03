//
//  LGCollider.m
//  Engine
//
//  Created by Luke Godfrey on 3/3/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGCollider.h"

@implementation LGCollider

@synthesize type, offset, size, topCollided, rightCollided, bottomCollided, leftCollided;

- (void)reset
{
	topCollided		= NO;
	rightCollided	= NO;
	bottomCollided	= NO;
	leftCollided	= NO;
}

- (void)initialize
{
	type	= LGColliderTypeDynamic;
	offset	= CGPointZero;
	size	= CGSizeZero;
	
	[self reset];
}

@end