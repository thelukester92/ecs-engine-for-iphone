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

@synthesize layers, camera, cameraTransform, sprite, visibleX, visibleY, padding;

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
	LGTileLayer *layer = [layers objectForKey:[[layers allKeys] objectAtIndex:0]];
	
	LGSprite *leftMostSprite = [layer spriteAtRow:0 andCol:0];
	LGSprite *rightMostSprite = [layer spriteAtRow:[[layer sprites] count] - 1 andCol:[[[layer sprites] objectAtIndex:0] count] - 1];
	BOOL canShift;
	
	canShift = YES;
	while([[leftMostSprite view] frame].origin.x + [sprite size].width < [camera offset].x + [cameraTransform position].x && canShift)
	{
		for(NSString *name in layers)
		{
			canShift = [[layers objectForKey:name] shiftRight];
		}
		
		leftMostSprite = [layer spriteAtRow:0 andCol:0];
	}
	
	canShift = YES;
	while([[rightMostSprite view] frame].origin.x > [camera offset].x + [cameraTransform position].x + (visibleX - padding) * [sprite size].width && canShift)
	{
		for(NSString *name in layers)
		{
			canShift = [[layers objectForKey:name] shiftLeft];
		}
		
		rightMostSprite = [layer spriteAtRow:[[layer sprites] count] - 1 andCol:[[[layer sprites] objectAtIndex:0] count] - 1];
	}
	
	canShift = YES;
	while([[leftMostSprite view] frame].origin.y + [sprite size].height < [camera offset].y + [cameraTransform position].y && canShift)
	{
		for(NSString *name in layers)
		{
			canShift = [[layers objectForKey:name] shiftDown];
		}
		
		leftMostSprite = [layer spriteAtRow:0 andCol:0];
	}
	
	canShift = YES;
	while([[rightMostSprite view] frame].origin.y > [camera offset].y + [cameraTransform position].y + [camera size].height && canShift)
	{
		for(NSString *name in layers)
		{
			canShift = [[layers objectForKey:name] shiftUp];
		}
		
		rightMostSprite = [layer spriteAtRow:[[layer sprites] count] - 1 andCol:[[[layer sprites] objectAtIndex:0] count] - 1];
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
	layers			= [NSMutableDictionary dictionary];
	camera			= nil;
	cameraTransform	= nil;
	sprite			= nil;
	visibleX		= 0;
	visibleY		= 0;
	padding			= 1;
}

@end