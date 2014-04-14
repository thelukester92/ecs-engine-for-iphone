//
//  LGTileSystem.m
//  Engine
//
//  Created by Luke Godfrey on 3/10/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "LGTileSystem.h"
#import "LGScene.h"
#import "LGEntity.h"
#import "LGSprite.h"
#import "LGTransform.h"
#import "LGPhysics.h"
#import "LGCamera.h"
#import "LGTileCollider.h"
#import "LGTile.h"
#import "LGTileMap.h"
#import "LGTileLayer.h"

@implementation LGTileSystem

@synthesize camera, cameraTransform, sprite, visibleLayer, size, visibleX, visibleY, padding, canShift, map, mapEntity;

#pragma mark Overrides

- (void)setCamera:(LGCamera *)cam
{
	camera = cam;
	[self updateVisibleTiles];
}

- (void)setSprite:(LGSprite *)s
{
	sprite = s;
	[self updateVisibleTiles];
}

- (void)setMap:(LGTileMap *)m
{
	map = m;
	
	if(sprite == nil)
	{
		NSLog(@"Warning: Sprite is nil! Not displaying the tile map.");
		return;
	}
	
	size = CGSizeMake([map width] * [sprite size].width, [map height] * [sprite size].height);
	
	if(camera == nil)
	{
		// Entire map is visible
		visibleX = [map width];
		visibleY = [map height];
	}
	else
	{
		// Make sure the camera's bounds are big enough to fit the tile map
		CGSize bounds = [camera bounds];
		bounds.width = MAX(bounds.width, size.width);
		bounds.height = MAX(bounds.height, size.height);
		[camera setBounds:bounds];
	}
	
	mapEntity = [[LGEntity alloc] init];
	[mapEntity addComponent:[[LGTransform alloc] init]];
	
	for(LGTileLayer *layer in [map layers])
	{
		if([layer isVisible])
		{
			NSMutableArray *entities = [NSMutableArray array];
			
			for(int i = 0; i < visibleY; i++)
			{
				NSMutableArray *row = [NSMutableArray array];
				[entities addObject:row];
				
				for(int j = 0; j < visibleX; j++)
				{
					LGSprite *s = [LGSprite copyOfSprite:sprite];
					[s setPosition:[[layer tileAtRow:i andCol:j] position]];
					[s setLayer:[layer zOrder]];
					[s setOffset:CGPointMake(j * [sprite size].width, i * [sprite size].height)];
					
					[mapEntity addComponent:s];
					[row addObject:s];
				}
			}
			
			[layer setSprites:entities];
			
			visibleLayer = layer;
			canShift = YES;
		}
		
		if([layer isCollsion])
		{
			LGTileCollider *tileCollider = [[LGTileCollider alloc] init];
			[tileCollider setCollisionLayer:layer];
			[tileCollider setTileSize:CGSizeMake([map tileWidth], [map tileHeight])];
			[tileCollider setSize:size];
			
			LGEntity *collisionLayerEntity = [[LGEntity alloc] init];
			[collisionLayerEntity addComponent:tileCollider];
			[collisionLayerEntity addComponent:[[LGTransform alloc] init]];
			
			[self.scene addEntity:collisionLayerEntity];
		}
	}
	
	[self.scene addEntity:mapEntity];
	
	if(camera == nil)
	{
		// No need to shift, since entire area is displayed
		canShift = NO;
	}
}

#pragma mark Private Methods

- (void)updateVisibleTiles
{
	if(camera != nil && sprite != nil)
	{
		visibleX = (int) ceil( [camera size].width / [sprite size].width ) + padding;
		visibleY = (int) ceil( [camera size].height / [sprite size].height ) + padding;
	}
}

#pragma mark LGSystem Methods

- (BOOL)acceptsEntity:(LGEntity *)entity
{
	return [entity hasComponentsOfType:[LGCamera type], [LGTransform type], nil];
}

- (void)addEntity:(LGEntity *)entity
{
	camera = [entity componentOfType:[LGCamera type]];
	cameraTransform = [entity componentOfType:[LGTransform type]];
	[self updateVisibleTiles];
}

- (void)update
{
	if(!canShift)
	{
		return;
	}
	
	int rightMost = (int) [[[visibleLayer sprites] objectAtIndex:0] count] - 1;
	int bottomMost = (int) [[visibleLayer sprites] count] - 1;
	
	CGPoint tlOffset = [[visibleLayer spriteAtRow:0 andCol:0] offset];
	CGPoint brOffset = [[visibleLayer spriteAtRow:bottomMost andCol:rightMost] offset];
	
	BOOL canShiftInDirection;
	
	canShiftInDirection = YES;
	while(tlOffset.x + [sprite size].width < [camera offset].x + [cameraTransform position].x && canShiftInDirection)
	{
		canShiftInDirection = [map shiftRight];
		tlOffset = [[visibleLayer spriteAtRow:0 andCol:0] offset];
	}
	
	canShiftInDirection = YES;
	while(brOffset.x > [camera offset].x + [cameraTransform position].x + (visibleX - padding) * [sprite size].width && canShiftInDirection)
	{
		canShiftInDirection = [map shiftLeft];
		brOffset = [[visibleLayer spriteAtRow:bottomMost andCol:rightMost] offset];
	}
	
	canShiftInDirection = YES;
	while(tlOffset.y + [sprite size].height < [camera offset].y + [cameraTransform position].y && canShiftInDirection)
	{
		canShiftInDirection = [map shiftDown];
		tlOffset = [[visibleLayer spriteAtRow:0 andCol:0] offset];
	}
	
	canShiftInDirection = YES;
	while(brOffset.y > [camera offset].y + [cameraTransform position].y + [camera size].height && canShiftInDirection)
	{
		canShiftInDirection = [map shiftUp];
		brOffset = [[visibleLayer spriteAtRow:bottomMost andCol:rightMost] offset];
	}
}

- (void)initialize
{
	camera				= nil;
	cameraTransform		= nil;
	sprite				= nil;
	visibleLayer		= nil;
	size				= CGSizeZero;
	visibleX			= 0;
	visibleY			= 0;
	padding				= 1;
	canShift			= NO;
	self.updateOrder	= LGUpdateOrderBeforeRender;
	
	map					= nil;
}

@end