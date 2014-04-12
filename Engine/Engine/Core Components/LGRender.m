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

+ (NSString *)type
{
	static NSString *type = nil;
	
	if(type == nil)
	{
		type = NSStringFromClass([self class]);
	}
	
	return type;
}

- (void)setLayer:(int)l
{
	layer = l;
	[view.layer setZPosition:layer];
}

- (void)setOffsetX:(double)x
{
	offset.x = x;
}

- (void)setOffsetY:(double)y
{
	offset.y = y;
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