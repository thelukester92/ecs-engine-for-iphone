//
//  LGTileLayer.m
//  Engine
//
//  Created by Luke Godfrey on 3/26/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGTileLayer.h"
#import "LGTileSystem.h"
#import "LGSprite.h"

@implementation LGTileLayer

@synthesize parent, tiles, sprites, offsetX, offsetY, isVisible;

- (BOOL)shiftRight
{
	int tileX = offsetX + [parent visibleX];
	
	if(tileX >= [[tiles objectAtIndex:0] count])
	{
		return NO;
	}
	
	if(isVisible)
	{
		for(int i = 0; i < [parent visibleY]; i++)
		{
			int tileY = offsetY + i;
			
			// Get the left-most sprite
			LGSprite *s = [[sprites objectAtIndex:i] objectAtIndex:0];
			
			// Move it from its old place
			[[sprites objectAtIndex:i] removeObject:s];
			
			// Move it to its new place
			[[sprites objectAtIndex:i] addObject:s];
			
			// Swap out its texture
			[s setPosition:[[self tileAtRow:tileY andCol:tileX] intValue]];
			
			// Adjust its frame
			CGRect frame = [[s view] frame];
			frame.origin.x = tileX * [[parent sprite] size].width;
			frame.origin.y = tileY * [[parent sprite] size].height;
			[[s view] setFrame:frame];
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
		for(int i = 0; i < [parent visibleY]; i++)
		{
			int tileY = offsetY + i;
			
			// Get the right-most sprite
			LGSprite *s = [[sprites objectAtIndex:i] objectAtIndex:[[sprites objectAtIndex:0] count] - 1];
			
			// Move it from its old place
			[[sprites objectAtIndex:i] removeObject:s];
			
			// Move it to its new place
			[[sprites objectAtIndex:i] insertObject:s atIndex:0];
			
			// Swap out its texture
			[s setPosition:[[self tileAtRow:tileY andCol:tileX] intValue]];
			
			// Adjust its frame
			CGRect frame = [[s view] frame];
			frame.origin.x = tileX * [[parent sprite] size].width;
			frame.origin.y = tileY * [[parent sprite] size].height;
			[[s view] setFrame:frame];
		}
	}
	
	offsetX--;
	
	return YES;
}

- (BOOL)shiftDown
{
	int tileY = offsetY + [parent visibleY];
	
	if(tileY >= [tiles count])
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
		for(int j = 0; j < [parent visibleX]; j++)
		{
			int tileX = offsetX + j;
			
			// Get the sprite
			LGSprite *s = [[sprites objectAtIndex:[sprites count] - 1] objectAtIndex:j];
			
			// Swap out its texture
			[s setPosition:[[self tileAtRow:tileY andCol:tileX] intValue]];
			
			// Adjust its frame
			CGRect frame = [[s view] frame];
			frame.origin.x = tileX * [[parent sprite] size].width;
			frame.origin.y = tileY * [[parent sprite] size].height;
			[[s view] setFrame:frame];
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
		for(int j = 0; j < [parent visibleX]; j++)
		{
			int tileX = offsetX + j;
			
			// Get the sprite
			LGSprite *s = [[sprites objectAtIndex:0] objectAtIndex:j];
			
			// Swap out its texture
			[s setPosition:[[self tileAtRow:tileY andCol:tileX] intValue]];
			
			// Adjust its frame
			CGRect frame = [[s view] frame];
			frame.origin.x = tileX * [[parent sprite] size].width;
			frame.origin.y = tileY * [[parent sprite] size].height;
			[[s view] setFrame:frame];
		}
	}
	
	offsetY--;
	
	return YES;
}

- (NSString *)tileAtRow:(int)row andCol:(int)col
{
	if(row < [tiles count] && col < [[tiles objectAtIndex:0] count])
	{
		return [[tiles objectAtIndex:row] objectAtIndex:col];
	}
	
	return nil;
}

- (LGSprite *)spriteAtRow:(int)row andCol:(int)col
{
	if(row < [sprites count] && col < [[sprites objectAtIndex:0] count])
	{
		return [[sprites objectAtIndex:row] objectAtIndex:col];
	}
	
	return nil;
}

- (BOOL)collidesAtRow:(int)row andCol:(int)col
{
	if(row < [tiles count] && col < [[tiles objectAtIndex:0] count])
	{
		return [[[tiles objectAtIndex:row] objectAtIndex:col] intValue] != 0;
	}
	
	return YES;
}

- (id)initWithParent:(LGTileSystem *)p andTiles:(NSMutableArray *)t andSprites:(NSMutableArray *)s
{
	self = [super init];
	
	if(self)
	{
		parent		= p;
		tiles		= t;
		sprites		= s;
		offsetX		= 0;
		offsetY		= 0;
		isVisible	= YES;
	}
	
	return self;
}

@end