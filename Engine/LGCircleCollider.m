//
//  LGCircleCollider.m
//  Engine
//
//  Created by Luke Godfrey on 3/18/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGCircleCollider.h"

@implementation LGCircleCollider

@synthesize radius;

- (void)initialize
{
	[super initialize];
	
	radius = 0;
	self.componentType = NSStringFromClass([self superclass]);
}

@end