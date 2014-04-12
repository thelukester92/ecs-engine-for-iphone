//
//  LGTMXTileLayer.m
//  Engine
//
//  Created by Luke Godfrey on 4/12/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGTMXTileLayer.h"
#import "LGEntity.h"
#import "LGTile.h"

@implementation LGTMXTileLayer

@synthesize name, opacity, isVisible, isCollsion, zOrder, data, entities;

- (LGTile *)tileAtRow:(int)row andCol:(int)col
{
	if(row < [data count] && col < [[entities objectAtIndex:0] count])
	{
		return [[data objectAtIndex:row] objectAtIndex:col];
	}
	
	return nil;
}

- (LGEntity *)spriteEntityAtRow:(int)row andCol:(int)col
{
	if(isVisible && row < [entities count] && col < [[entities objectAtIndex:0] count])
	{
		return [[entities objectAtIndex:row] objectAtIndex:col];
	}
	
	return nil;
}

- (BOOL)collidesAtRow:(int)row andCol:(int)col
{
	if(isCollsion)
	{
		if(row < [data count] && col < [[entities objectAtIndex:0] count])
		{
			return [[[data objectAtIndex:row] objectAtIndex:col] intValue] > 0;
		}
		
		return YES;
	}
	
	return NO;
}

- (id)initWithName:(NSString *)n andOpacity:(double)o andVisible:(BOOL)v
{
	self = [super init];
	
	if(self)
	{
		name		= n;
		opacity		= o;
		isVisible	= v;
		isCollsion	= NO;
		zOrder		= 0;
		data		= nil;
		entities	= nil;
	}
	
	return self;
}

- (id)init
{
	return [self initWithName:nil andOpacity:1 andVisible:YES];
}

@end