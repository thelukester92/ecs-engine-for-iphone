//
//  LGTile.m
//  Engine
//
//  Created by Luke Godfrey on 4/5/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGTile.h"

@implementation LGTile

@synthesize positionString;

- (int)position
{
	return [positionString intValue];
}

- (id)initWithPositionString:(NSString *)p
{
	self = [super init];
	
	if(self)
	{
		positionString = p;
	}
	
	return self;
}

@end