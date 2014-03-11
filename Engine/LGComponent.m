//
//  Component.m
//  Engine
//
//  Created by Luke Godfrey on 2/19/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGComponent.h"
#import "LGEntity.h"

@implementation LGComponent

- (void) initialize {}

- (id)init
{
	self = [super init];
	
	if(self)
		[self initialize];
	
	return self;
}

@end