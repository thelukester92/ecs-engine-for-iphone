//
//  LGTileSystem.m
//  Engine
//
//  Created by Luke Godfrey on 3/10/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
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

@synthesize layers, camera, cameraTransform, sprite, visibleLayer, visibleX, visibleY, padding;

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
	
	LGSprite *leftMostSprite = [visibleLayer spriteAtRow:0 andCol:0];
	LGSprite *rightMostSprite = [visibleLayer spriteAtRow:[[visibleLayer sprites] count] - 1 andCol:[[[visibleLayer sprites] objectAtIndex:0] count] - 1];
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
		
		rightMostSprite = [visibleLayer spriteAtRow:[[visibleLayer sprites] count] - 1 andCol:[[[visibleLayer sprites] objectAtIndex:0] count] - 1];
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
		
		rightMostSprite = [visibleLayer spriteAtRow:[[visibleLayer sprites] count] - 1 andCol:[[[visibleLayer sprites] objectAtIndex:0] count] - 1];
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
	visibleX		= 0;
	visibleY		= 0;
	padding			= 1;
}

@end