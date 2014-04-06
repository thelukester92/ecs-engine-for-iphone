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
#import "LGTileLayer.h"
#import "LGTileCollider.h"
#import "LGTile.h"

@implementation LGTileSystem

@synthesize layers, camera, cameraTransform, sprite, visibleLayer, size, visibleX, visibleY, padding;

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

#pragma mark Public Methods

- (void)generateLayerFromArray:(NSArray *)array layer:(int)layer visible:(BOOL)isVisible collision:(BOOL)isCollision
{
	NSMutableArray *spriteEntities = nil;
	
	// Create the visual portion of the layer
	
	if(isVisible)
	{
		spriteEntities = [NSMutableArray array];
		
		for(int i = 0; i < visibleY; i++)
		{
			NSMutableArray *row = [NSMutableArray array];
			[spriteEntities addObject:row];
			
			for(int j = 0; j < visibleX; j++)
			{
				LGEntity *spriteEntity = [[LGEntity alloc] init];
				
				LGSprite *s = [LGSprite copyOfSprite:sprite];
				[s setPosition:[(LGTile *)[[array objectAtIndex:i] objectAtIndex:j] position]];
				[s setLayer:layer];
				[spriteEntity addComponent:s];
				
				LGTransform *t = [[LGTransform alloc] init];
				[t setPosition:CGPointMake(j * [sprite size].width, i * [sprite size].height)];
				[spriteEntity addComponent:t];
				
				[self.scene addEntity:spriteEntity];
				[row addObject:spriteEntity];
			}
		}
	}
	
	// Generate a layer object to store in the system
	
	LGTileLayer *tileLayer = [[LGTileLayer alloc] initWithParent:self andTiles:array andSprites:spriteEntities];
	[tileLayer setIsVisible:isVisible];
	
	// Add the layer to the system
	
	[layers addObject:tileLayer];
	
	if(isVisible)
	{
		visibleLayer = tileLayer;
	}
	
	if(sprite != nil)
	{
		size = CGSizeMake([[array objectAtIndex:0] count] * [sprite size].width, [array count] * [sprite size].height);
	}
	
	// Generate a tile collider out of the collision layer
	
	if(isCollision)
	{
		LGTileCollider *tileCollider = [[LGTileCollider alloc] init];
		[tileCollider setCollisionLayer:tileLayer];
		[tileCollider setTileSize:[sprite size]];
		[tileCollider setSize:size];
		
		LGEntity *collisionLayerEntity = [[LGEntity alloc] init];
		[collisionLayerEntity addComponent:tileCollider];
		[collisionLayerEntity addComponent:[[LGTransform alloc] init]];
		
		[self.scene addEntity:collisionLayerEntity];
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
	
	int rightMost = (int) [[[visibleLayer spriteEntities] objectAtIndex:0] count] - 1;
	int bottomMost = (int) [[visibleLayer spriteEntities] count] - 1;
	
	LGTransform *leftTransform	= [[visibleLayer spriteEntityAtRow:0 andCol:0] componentOfType:[LGTransform type]];
	LGTransform *rightTransform	= [[visibleLayer spriteEntityAtRow:bottomMost andCol:rightMost] componentOfType:[LGTransform type]];
	
	BOOL canShift;
	
	canShift = YES;
	while([leftTransform position].x + [sprite size].width < [camera offset].x + [cameraTransform position].x && canShift)
	{
		for(LGTileLayer *layer in layers)
		{
			canShift = [layer shiftRight];
		}
		
		leftTransform = [[visibleLayer spriteEntityAtRow:0 andCol:0] componentOfType:[LGTransform type]];
	}
	
	canShift = YES;
	while([rightTransform position].x > [camera offset].x + [cameraTransform position].x + (visibleX - padding) * [sprite size].width && canShift)
	{
		for(LGTileLayer *layer in layers)
		{
			canShift = [layer shiftLeft];
		}
		
		rightTransform = [[visibleLayer spriteEntityAtRow:bottomMost andCol:rightMost] componentOfType:[LGTransform type]];
	}
	
	canShift = YES;
	while([leftTransform position].y + [sprite size].height < [camera offset].y + [cameraTransform position].y && canShift)
	{
		for(LGTileLayer *layer in layers)
		{
			canShift = [layer shiftDown];
		}
		
		leftTransform = [[visibleLayer spriteEntityAtRow:0 andCol:0] componentOfType:[LGTransform type]];
	}
	
	canShift = YES;
	while([rightTransform position].y > [camera offset].y + [cameraTransform position].y + [camera size].height && canShift)
	{
		for(LGTileLayer *layer in layers)
		{
			canShift = [layer shiftUp];
		}
		
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
	layers			= [NSMutableArray array];
	camera			= nil;
	cameraTransform	= nil;
	sprite			= nil;
	visibleLayer	= nil;
	size			= CGSizeZero;
	visibleX		= 0;
	visibleY		= 0;
	padding			= 1;
}

@end