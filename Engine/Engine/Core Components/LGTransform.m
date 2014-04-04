//
//  LGTransform.m
//  Engine
//
//  Created by Luke Godfrey on 2/21/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "LGTransform.h"

@implementation LGTransform

@synthesize position, prevPosition;

- (void)addToPosition:(CGPoint)p
{
	position.x += p.x;
	position.y += p.y;
}

- (void)addToPositionX:(double)x
{
	position.x += x;
}

- (void)addToPositionY:(double)y
{
	position.y += y;
}

- (void)setPositionX:(double)x
{
	position.x = x;
}

- (void)setPositionY:(double)y
{
	position.y = y;
}

- (void)initialize
{
	position = CGPointZero;
	prevPosition = CGPointZero;
}

@end