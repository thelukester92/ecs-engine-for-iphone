//
//  LGTileLayer.m
//  Engine
//
//  Created by Luke Godfrey on 4/12/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGTileLayer.h"
#import "LGTile.h"
#import "LGSprite.h"

@implementation LGTileLayer

@synthesize name, opacity, isVisible, isCollsion, data, sprites, zOrder, offsetX, offsetY;

- (BOOL)shiftRight
{
	int tileX = offsetX + [[sprites objectAtIndex:0] count];
	
	if(tileX >= [[data objectAtIndex:0] count])
	{
		return NO;
	}
	
	if(isVisible)
	{
		for(int i = 0; i < [sprites count]; i++)
		{
			int tileY = offsetY + i;
			
			// Get the left-most sprite
			LGSprite *sprite = [[sprites objectAtIndex:i] objectAtIndex:0];
			
			// Move it from its old place
			[[sprites objectAtIndex:i] removeObject:sprite];
			
			// Move it to its new place
			[[sprites objectAtIndex:i] addObject:sprite];
			
			// Swap out its texture
			[sprite setPosition:[[self tileAtRow:tileY andCol:tileX] position]];
			
			// Adjust its position
			[sprite setOffsetX:tileX * [sprite size].width];
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
		for(int i = 0; i < [sprites count]; i++)
		{
			int tileY = offsetY + i;
			
			// Get the right-most sprite
			LGSprite *sprite = [[sprites objectAtIndex:i] objectAtIndex:[[sprites objectAtIndex:0] count] - 1];
			
			// Move it from its old place
			[[sprites objectAtIndex:i] removeObject:sprite];
			
			// Move it to its new place
			[[sprites objectAtIndex:i] insertObject:sprite atIndex:0];
			
			// Swap out its texture
			[sprite setPosition:[[self tileAtRow:tileY andCol:tileX] position]];
			
			// Adjust its position
			[sprite setOffsetX:tileX * [sprite size].width];
		}
	}
	
	offsetX--;
	
	return YES;
}

- (BOOL)shiftDown
{
	int tileY = offsetY + [sprites count];
	
	if(tileY >= [data count])
	{
		return NO;
	}
	
	if(isVisible)
	{
		// Get the top-most row
		NSMutableArray *row = [sprites objectAtIndex:0];
		
		// Move it from its old place
		[sprites removeObject:row];
		
		// Move it to its new place
		[sprites addObject:row];
		
		// Swap out textures
		for(int j = 0; j < [[sprites objectAtIndex:0] count]; j++)
		{
			int tileX = offsetX + j;
			
			// Get the sprite
			LGSprite *sprite = [row objectAtIndex:j];
			
			// Swap out its texture
			[sprite setPosition:[[self tileAtRow:tileY andCol:tileX] position]];
			
			// Adjust its position
			[sprite setOffsetY:tileY * [sprite size].height];
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
		NSMutableArray *row = [sprites objectAtIndex:[sprites count] - 1];
		
		// Move it from its old place
		[sprites removeObject:row];
		
		// Move it to its new place
		[sprites insertObject:row atIndex:0];
		
		// Swap out textures
		for(int j = 0; j < [[sprites objectAtIndex:0] count]; j++)
		{
			int tileX = offsetX + j;
			
			// Get the sprite
			LGSprite *sprite = [row objectAtIndex:j];
			
			// Swap out its texture
			[sprite setPosition:[[self tileAtRow:tileY andCol:tileX] position]];
			
			// Adjust its position
			[sprite setOffsetY:tileY * [sprite size].height];
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

- (LGSprite *)spriteAtRow:(int)row andCol:(int)col
{
	if(isVisible && row < [sprites count] && col < [[sprites objectAtIndex:0] count])
	{
		return [[sprites objectAtIndex:row] objectAtIndex:col];
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
		sprites	= nil;
	}
	
	return self;
}

- (id)init
{
	return [self initWithName:nil andOpacity:1 andVisible:YES];
}

@end