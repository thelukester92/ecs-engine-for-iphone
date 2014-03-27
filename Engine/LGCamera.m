//
//  LGCamera.m
//  Engine
//
//  Created by Luke Godfrey on 3/13/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGCamera.h"

@implementation LGCamera

@synthesize offset, size;

- (void)initialize
{
	offset	= CGPointZero;
	size	= CGSizeZero;
}

@end