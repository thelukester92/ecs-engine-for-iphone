//
//  LGTileCollider.m
//  Engine
//
//  Created by Luke Godfrey on 3/28/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "LGTileCollider.h"
#import "LGTMXTileLayer.h"

@implementation LGTileCollider

@synthesize collisionLayer, tileSize;

+ (NSString *)type
{
	static NSString *type = nil;
	
	if(type == nil)
	{
		type = NSStringFromClass([LGCollider class]);
	}
	
	return type;
}

- (void)initialize
{
	collisionLayer	= nil;
	tileSize		= CGSizeZero;
	self.type		= LGColliderTypeStatic;
}

@end