//
//  LGTileLayer.m
//  Engine
//
//  Created by Luke Godfrey on 3/26/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "LGTileLayer.h"
#import "LGTileSystem.h"
#import "LGSprite.h"
#import "LGEntity.h"
#import "LGTransform.h"
#import "LGTile.h"

@implementation LGTileLayer

@synthesize parent, tiles, spriteEntities, offsetX, offsetY, isVisible;

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
			LGEntity *entity		= [[spriteEntities objectAtIndex:i] objectAtIndex:0];
			LGSprite *sprite		= [entity componentOfType:[LGSprite type]];
			LGTransform *transform	= [entity componentOfType:[LGTransform type]];
			
			// Move it from its old place
			[[spriteEntities objectAtIndex:i] removeObject:entity];
			
			// Move it to its new place
			[[spriteEntities objectAtIndex:i] addObject:entity];
			
			// Swap out its texture
			[sprite setPosition:[[self tileAtRow:tileY andCol:tileX] position]];
			
			// Adjust its position
			[transform setPositionX:tileX * [[parent sprite] size].width];
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
			LGEntity *entity		= [[spriteEntities objectAtIndex:i] objectAtIndex:[[spriteEntities objectAtIndex:0] count] - 1];
			LGSprite *sprite		= [entity componentOfType:[LGSprite type]];
			LGTransform *transform	= [entity componentOfType:[LGTransform type]];
			
			// Move it from its old place
			[[spriteEntities objectAtIndex:i] removeObject:entity];
			
			// Move it to its new place
			[[spriteEntities objectAtIndex:i] insertObject:entity atIndex:0];
			
			// Swap out its texture
			[sprite setPosition:[[self tileAtRow:tileY andCol:tileX] position]];
			
			// Adjust its position
			[transform setPositionX:tileX * [[parent sprite] size].width];
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
		NSMutableArray *row = [spriteEntities objectAtIndex:0];
		
		// Move it from its old place
		[spriteEntities removeObject:row];
		
		// Move it to its new place
		[spriteEntities addObject:row];
		
		// Swap out textures
		for(int j = 0; j < [parent visibleX]; j++)
		{
			int tileX = offsetX + j;
			
			// Get the sprite
			LGEntity *entity		= [row objectAtIndex:j];
			LGSprite *sprite		= [entity componentOfType:[LGSprite type]];
			LGTransform *transform	= [entity componentOfType:[LGTransform type]];
			
			// Swap out its texture
			[sprite setPosition:[[self tileAtRow:tileY andCol:tileX] position]];
			
			// Adjust its position
			[transform setPositionY:tileY * [[parent sprite] size].height];
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
		NSMutableArray *row = [spriteEntities objectAtIndex:[spriteEntities count] - 1];
		
		// Move it from its old place
		[spriteEntities removeObject:row];
		
		// Move it to its new place
		[spriteEntities insertObject:row atIndex:0];
		
		// Swap out textures
		for(int j = 0; j < [parent visibleX]; j++)
		{
			int tileX = offsetX + j;
			
			// Get the sprite
			LGEntity *entity		= [row objectAtIndex:j];
			LGSprite *sprite		= [entity componentOfType:[LGSprite type]];
			LGTransform *transform	= [entity componentOfType:[LGTransform type]];
			
			// Swap out its texture
			[sprite setPosition:[[self tileAtRow:tileY andCol:tileX] position]];
			
			// Adjust its position
			[transform setPositionY:tileY * [[parent sprite] size].height];
		}
	}
	
	offsetY--;
	
	return YES;
}

- (LGTile *)tileAtRow:(int)row andCol:(int)col
{
	if(row < [tiles count] && col < [[tiles objectAtIndex:0] count])
	{
		return [[tiles objectAtIndex:row] objectAtIndex:col];
	}
	
	return nil;
}

- (LGEntity *)spriteEntityAtRow:(int)row andCol:(int)col
{
	if(row < [spriteEntities count] && col < [[spriteEntities objectAtIndex:0] count])
	{
		return [[spriteEntities objectAtIndex:row] objectAtIndex:col];
	}
	
	return nil;
}

- (BOOL)collidesAtRow:(int)row andCol:(int)col
{
	if(row < [tiles count] && col < [[tiles objectAtIndex:0] count])
	{
		return [[self tileAtRow:row andCol:col] position] != 0;
	}
	
	return YES;
}

- (id)initWithParent:(LGTileSystem *)p andTiles:(NSArray *)t andSprites:(NSMutableArray *)s
{
	self = [super init];
	
	if(self)
	{
		parent		= p;
		tiles		= t;
		spriteEntities		= s;
		offsetX		= 0;
		offsetY		= 0;
		isVisible	= YES;
	}
	
	return self;
}

@end