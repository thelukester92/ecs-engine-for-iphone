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
#import "LGTile.h"
#import "LGCamera.h"
#import "LGTileLayer.h"
#import "LGTileCollider.h"

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

- (void)addLayer:(LGTileLayer *)layer
{
	[layers addObject:layer];
	
	if([layer isVisible])
	{
		visibleLayer = layer;
	}
	
	if(sprite != nil)
	{
		size = CGSizeMake([[[layer tiles] objectAtIndex:0] count] * [sprite size].width, [[layer tiles] count] * [sprite size].height);
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
	
	int rightMost = (int) [[[visibleLayer sprites] objectAtIndex:0] count] - 1;
	int bottomMost = (int) [[visibleLayer sprites] count] - 1;
	
	LGSprite *leftMostSprite = [visibleLayer spriteAtRow:0 andCol:0];
	LGSprite *rightMostSprite = [visibleLayer spriteAtRow:bottomMost andCol:rightMost];
	BOOL canShift;
	
	canShift = YES;
	while([[leftMostSprite view] frame].origin.x + [sprite size].width < [camera offset].x + [cameraTransform position].x && canShift)
	{
		for(LGTileLayer *layer in layers)
		{
			canShift = [layer shiftRight];
		}
		
		leftMostSprite = [visibleLayer spriteAtRow:0 andCol:0];
	}
	
	canShift = YES;
	while([[rightMostSprite view] frame].origin.x > [camera offset].x + [cameraTransform position].x + (visibleX - padding) * [sprite size].width && canShift)
	{
		for(LGTileLayer *layer in layers)
		{
			canShift = [layer shiftLeft];
		}
		
		rightMostSprite = [visibleLayer spriteAtRow:bottomMost andCol:rightMost];
	}
	
	canShift = YES;
	while([[leftMostSprite view] frame].origin.y + [sprite size].height < [camera offset].y + [cameraTransform position].y && canShift)
	{
		for(LGTileLayer *layer in layers)
		{
			canShift = [layer shiftDown];
		}
		
		leftMostSprite = [visibleLayer spriteAtRow:0 andCol:0];
	}
	
	canShift = YES;
	while([[rightMostSprite view] frame].origin.y > [camera offset].y + [cameraTransform position].y + [camera size].height && canShift)
	{
		for(LGTileLayer *layer in layers)
		{
			canShift = [layer shiftUp];
		}
		
		rightMostSprite = [visibleLayer spriteAtRow:bottomMost andCol:rightMost];
	}
}

#pragma mark LGSystem Methods

- (BOOL)acceptsEntity:(LGEntity *)entity
{
	return [entity hasComponentsOfType:[LGCamera class], [LGTransform class], nil];
}

- (void)addEntity:(LGEntity *)entity
{
	camera = [entity componentOfType:[LGCamera class]];
	cameraTransform = [entity componentOfType:[LGTransform class]];
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