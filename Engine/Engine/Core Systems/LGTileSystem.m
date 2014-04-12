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

@synthesize camera, cameraTransform, sprite, visibleLayer, size, visibleX, visibleY, padding;
@synthesize map;

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
	
	size = CGSizeMake([map width] * [sprite size].width, [map height] * [sprite size].height);
	
	for(NSString *name in [map layers])
	{
		LGTileLayer *layer = [[map layers] objectForKey:name];
		
		if([layer isVisible])
		{
			NSMutableArray *entities = [NSMutableArray array];
			
			for(int i = 0; i < visibleY; i++)
			{
				NSMutableArray *row = [NSMutableArray array];
				[entities addObject:row];
				
				for(int j = 0; j < visibleX; j++)
				{
					LGEntity *spriteEntity = [[LGEntity alloc] init];
					
					LGSprite *s = [LGSprite copyOfSprite:sprite];
					[s setPosition:[[layer tileAtRow:i andCol:j] position]];
					[s setLayer:[layer zOrder]];
					[spriteEntity addComponent:s];
					
					LGTransform *t = [[LGTransform alloc] init];
					[t setPosition:CGPointMake(j * [sprite size].width, i * [sprite size].height)];
					[spriteEntity addComponent:t];
					
					[self.scene addEntity:spriteEntity];
					[row addObject:spriteEntity];
				}
			}
			
			[layer setEntities:entities];
			
			visibleLayer = layer;
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

- (void)shiftTiles
{
	if(visibleLayer == nil)
	{
		return;
	}
	
	int rightMost = (int) [[[visibleLayer entities] objectAtIndex:0] count] - 1;
	int bottomMost = (int) [[visibleLayer entities] count] - 1;
	
	LGTransform *leftTransform	= [[visibleLayer spriteEntityAtRow:0 andCol:0] componentOfType:[LGTransform type]];
	LGTransform *rightTransform	= [[visibleLayer spriteEntityAtRow:bottomMost andCol:rightMost] componentOfType:[LGTransform type]];
	
	BOOL canShift;
	
	canShift = YES;
	while([leftTransform position].x + [sprite size].width < [camera offset].x + [cameraTransform position].x && canShift)
	{
		canShift = [map shiftRight];
		leftTransform = [[visibleLayer spriteEntityAtRow:0 andCol:0] componentOfType:[LGTransform type]];
	}
	
	canShift = YES;
	while([rightTransform position].x > [camera offset].x + [cameraTransform position].x + (visibleX - padding) * [sprite size].width && canShift)
	{
		canShift = [map shiftLeft];
		rightTransform = [[visibleLayer spriteEntityAtRow:bottomMost andCol:rightMost] componentOfType:[LGTransform type]];
	}
	
	canShift = YES;
	while([leftTransform position].y + [sprite size].height < [camera offset].y + [cameraTransform position].y && canShift)
	{
		canShift = [map shiftDown];
		leftTransform = [[visibleLayer spriteEntityAtRow:0 andCol:0] componentOfType:[LGTransform type]];
	}
	
	canShift = YES;
	while([rightTransform position].y > [camera offset].y + [cameraTransform position].y + [camera size].height && canShift)
	{
		canShift = [map shiftUp];
		rightTransform = [[visibleLayer spriteEntityAtRow:bottomMost andCol:rightMost] componentOfType:[LGTransform type]];
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
	[self shiftTiles];
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
	self.updateOrder	= LGUpdateOrderBeforeRender;
	
	map					= nil;
}

@end