//
//  LGTileLayer.m
//  Engine
//
//  Created by Luke Godfrey on 4/12/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGTileLayer.h"
#import "LGEntity.h"
#import "LGTile.h"
#import "LGSprite.h"
#import "LGTransform.h"

@implementation LGTileLayer

@synthesize name, opacity, isVisible, isCollsion, data, entities, zOrder, offsetX, offsetY;

- (BOOL)shiftRight
{
	int tileX = offsetX + [[entities objectAtIndex:0] count];
	
	if(tileX >= [[data objectAtIndex:0] count])
	{
		return NO;
	}
	
	if(isVisible)
	{
		for(int i = 0; i < [entities count]; i++)
		{
			int tileY = offsetY + i;
			
			// Get the left-most sprite
			LGEntity *entity		= [[entities objectAtIndex:i] objectAtIndex:0];
			LGSprite *sprite		= [entity componentOfType:[LGSprite type]];
			LGTransform *transform	= [entity componentOfType:[LGTransform type]];
			
			// Move it from its old place
			[[entities objectAtIndex:i] removeObject:entity];
			
			// Move it to its new place
			[[entities objectAtIndex:i] addObject:entity];
			
			// Swap out its texture
			[sprite setPosition:[[self tileAtRow:tileY andCol:tileX] position]];
			
			// Adjust its position
			[transform setPositionX:tileX * [sprite size].width];
		}
	}
	
	offsetX++;
	
	return YES;
}

- (BOOL)shiftLeft
{
	int tileX = offsetX - 1;
	
	if(tileX < 0)
	{
		return NO;
	}
	
	if(isVisible)
	{
		for(int i = 0; i < [entities count]; i++)
		{
			int tileY = offsetY + i;
			
			// Get the right-most sprite
			LGEntity *entity		= [[entities objectAtIndex:i] objectAtIndex:[[entities objectAtIndex:0] count] - 1];
			LGSprite *sprite		= [entity componentOfType:[LGSprite type]];
			LGTransform *transform	= [entity componentOfType:[LGTransform type]];
			
			// Move it from its old place
			[[entities objectAtIndex:i] removeObject:entity];
			
			// Move it to its new place
			[[entities objectAtIndex:i] insertObject:entity atIndex:0];
			
			// Swap out its texture
			[sprite setPosition:[[self tileAtRow:tileY andCol:tileX] position]];
			
			// Adjust its position
			[transform setPositionX:tileX * [sprite size].width];
		}
	}
	
	offsetX--;
	
	return YES;
}

- (BOOL)shiftDown
{
	int tileY = offsetY + [entities count];
	
	if(tileY >= [data count])
	{
		return NO;
	}
	
	if(isVisible)
	{
		// Get the top-most row
		NSMutableArray *row = [entities objectAtIndex:0];
		
		// Move it from its old place
		[entities removeObject:row];
		
		// Move it to its new place
		[entities addObject:row];
		
		// Swap out textures
		for(int j = 0; j < [[entities objectAtIndex:0] count]; j++)
		{
			int tileX = offsetX + j;
			
			// Get the sprite
			LGEntity *entity		= [row objectAtIndex:j];
			LGSprite *sprite		= [entity componentOfType:[LGSprite type]];
			LGTransform *transform	= [entity componentOfType:[LGTransform type]];
			
			// Swap out its texture
			[sprite setPosition:[[self tileAtRow:tileY andCol:tileX] position]];
			
			// Adjust its position
			[transform setPositionY:tileY * [sprite size].height];
		}
	}
	
	offsetY++;
	
	return YES;
}

- (BOOL)shiftUp
{
	int tileY = offsetY - 1;
	
	if(tileY < 0)
	{
		return NO;
	}
	
	if(isVisible)
	{
		// Get the bottom-most row
		NSMutableArray *row = [entities objectAtIndex:[entities count] - 1];
		
		// Move it from its old place
		[entities removeObject:row];
		
		// Move it to its new place
		[entities insertObject:row atIndex:0];
		
		// Swap out textures
		for(int j = 0; j < [[entities objectAtIndex:0] count]; j++)
		{
			int tileX = offsetX + j;
			
			// Get the sprite
			LGEntity *entity		= [row objectAtIndex:j];
			LGSprite *sprite		= [entity componentOfType:[LGSprite type]];
			LGTransform *transform	= [entity componentOfType:[LGTransform type]];
			
			// Swap out its texture
			[sprite setPosition:[[self tileAtRow:tileY andCol:tileX] position]];
			
			// Adjust its position
			[transform setPositionY:tileY * [sprite size].height];
		}
	}
	
	offsetY--;
	
	return YES;
}

- (LGTile *)tileAtRow:(int)row andCol:(int)col
{
	if(row < [data count] && col < [[data objectAtIndex:0] count])
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
		LGTile *tile = [self tileAtRow:row andCol:col];
		return tile == nil || [tile position] > 0;
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