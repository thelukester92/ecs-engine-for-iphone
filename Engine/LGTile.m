//
//  LGTile.m
//  Engine
//
//  Created by Luke Godfrey on 3/26/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGTile.h"

@implementation LGTile

@synthesize tiles, visibleTiles;

- (void)addTile:(NSNumber *)pos
{
	[tiles addObject:pos];
	
	if([pos intValue] > 0)
	{
		visibleTiles++;
	}
}

- (void)initialize
{
	tiles = [NSMutableArray array];
	visibleTiles = 0;
}

@end