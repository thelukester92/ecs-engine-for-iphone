//
//  LGCollider.m
//  Engine
//
//  Created by Luke Godfrey on 3/3/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGCollider.h"

@implementation LGCollider

@synthesize type, offset, size, leftDist, rightDist, topDist, bottomDist;

- (void)reset
{
	leftDist	= -1;
	rightDist	= -1;
	topDist		= -1;
	bottomDist	= -1;
}

- (void)initialize
{
	type	= LGColliderTypeDynamic;
	offset	= CGPointZero;
	size	= CGSizeZero;
	
	[self reset];
}

@end