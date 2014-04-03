//
//  LGTileCollider.m
//  Engine
//
//  Created by Luke Godfrey on 3/28/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "LGTileCollider.h"

@implementation LGTileCollider

@synthesize collisionLayer, tileSize;

- (void)initialize
{
	collisionLayer		= nil;
	tileSize			= CGSizeZero;
	self.type			= LGColliderTypeStatic;
	self.componentType	= NSStringFromClass([self superclass]);
}

@end