//
//  Component.m
//  Engine
//
//  Created by Luke Godfrey on 2/19/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "LGComponent.h"
#import "LGEntity.h"

@implementation LGComponent

+ (NSString *)type
{
	return NSStringFromClass([self class]);
}

- (void) initialize {}

- (id)init
{
	self = [super init];
	
	if(self)
	{
		[self initialize];
	}
	
	return self;
}

@end