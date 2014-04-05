//
//  LGCamera.m
//  Engine
//
//  Created by Luke Godfrey on 3/13/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "LGCamera.h"

@implementation LGCamera

@synthesize offset, size, bounds;

+ (NSString *)type
{
	static NSString *type = nil;
	
	if(type == nil)
	{
		type = NSStringFromClass([self class]);
	}
	
	return type;
}

- (void)initialize
{
	offset	= CGPointZero;
	size	= CGSizeZero;
	bounds	= CGRectZero;
}

@end