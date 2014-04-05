//
//  LGRender.m
//  Engine
//
//  Created by Luke Godfrey on 2/19/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "LGRender.h"

@implementation LGRender

@synthesize view, superview, size, offset, visible, layer;

- (void)setLayer:(int)l
{
	layer = l;
	[view.layer setZPosition:layer];
}

- (void)initialize
{
	view		= [[UIView alloc] initWithFrame:CGRectZero];
	superview	= nil;
	size		= CGSizeZero;
	offset		= CGPointZero;
	visible		= YES;
	layer		= LGRenderLayerMainLayer;
	
	[view.layer setZPosition:layer];
}

@end