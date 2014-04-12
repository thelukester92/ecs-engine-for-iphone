//
//  LGTileMap.m
//  Engine
//
//  Created by Luke Godfrey on 4/12/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGTileMap.h"
#import "LGTileLayer.h"

@implementation LGTileMap

@synthesize width, height, tileWidth, tileHeight, layers, imageName;

- (BOOL)shiftRight
{
	BOOL shifted = YES;
	
	for(NSString *name in layers)
	{
		shifted = [[layers objectForKey:name] shiftRight];
	}
	
	return shifted;
}

- (BOOL)shiftLeft
{
	BOOL shifted = YES;
	
	for(NSString *name in layers)
	{
		shifted = [[layers objectForKey:name] shiftLeft];
	}
	
	return shifted;
}

- (BOOL)shiftDown
{
	BOOL shifted = YES;
	
	for(NSString *name in layers)
	{
		shifted = [[layers objectForKey:name] shiftDown];
	}
	
	return shifted;
}

- (BOOL)shiftUp
{
	BOOL shifted = YES;
	
	for(NSString *name in layers)
	{
		shifted = [[layers objectForKey:name] shiftUp];
	}
	
	return shifted;
}

- (void)addLayer:(LGTileLayer *)layer
{
	[layers setObject:layer forKey:[layer name]];
}

- (id)initWithWidth:(int)w andHeight:(int)h andTileWidth:(int)tw andTileHeight:(int)th
{
	self = [super init];
	
	if(self)
	{
		width		= w;
		height		= h;
		tileWidth	= tw;
		tileHeight	= th;
		
		layers		= [NSMutableDictionary dictionary];
		imageName	= nil;
	}
	
	return self;
}

- (id)init
{
	return [self initWithWidth:0 andHeight:0 andTileWidth:0 andTileHeight:0];
}

@end