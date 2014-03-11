//
//  LGRender.m
//  Engine
//
//  Created by Luke Godfrey on 2/19/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGRender.h"

@implementation LGRender

@synthesize view, size, visible;

- (void)initialize
{
	view = [[UIView alloc] initWithFrame:CGRectZero];
	size = CGSizeZero;
	visible = YES;
}

@end