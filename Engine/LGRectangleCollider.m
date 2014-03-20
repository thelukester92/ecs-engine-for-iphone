//
//  LGRectangleCollider.m
//  Engine
//
//  Created by Luke Godfrey on 3/19/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGRectangleCollider.h"

@implementation LGRectangleCollider

@synthesize size;

- (CGSize)boundingBox
{
	return size;
}

- (void)initialize
{
	[super initialize];
	
	size = CGSizeZero;
	self.componentType = NSStringFromClass([self superclass]);
}

@end