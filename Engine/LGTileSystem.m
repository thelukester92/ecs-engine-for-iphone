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

#pragma mark LGTileSystem Methods

- (void)loadPlist:(NSString *)filename
{
	NSDictionary *data	= [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:@"plist"]];
	NSArray *layerData	= [data objectForKey:@"layers"];
	
	visibleX = (int) ceil( [camera size].width / [sprite size].width ) + padding;
	visibleY = (int) ceil( [camera size].height / [sprite size].height ) + padding;
	
	for(NSDictionary *layerDictionary in layerData)
	{
		NSString *name = [layerDictionary objectForKey:@"name"];
		NSString *contents = [layerDictionary objectForKey:@"contents"];
		
		BOOL isVisible = ![name isEqualToString:@"collision"];
		
		// Data to be stored in an LGTileLayer
		
		NSMutableArray *tiles	= [NSMutableArray array];
		NSMutableArray *sprites	= isVisible ? [NSMutableArray array] : nil;
		
		// The renderable entity for the scene
		
		LGEntity *layerEntity = [[LGEntity alloc] init];
		[layerEntity addComponent:[[LGTransform alloc] init]];
		
		LGRender *render = [[LGRender alloc] init];
		[render setSize:[self.scene view].frame.size];
		[render setLayer:LGRenderLayerBackground];
		[layerEntity addComponent:render];
		
		[self.scene addEntity:layerEntity];
		
		// Populate tiles and sprites arrays
		
		NSArray *rows = [contents componentsSeparatedByString:@",\n"];
		for(int i = 0; i < [rows count]; i++)
		{
			if(sprites != nil && i < visibleY)
			{
				[sprites addObject:[NSMutableArray array]];
			}
			
			NSMutableArray *row = [NSMutableArray array];
			[tiles addObject:row];
			
			NSArray *cols = [[rows objectAtIndex:i] componentsSeparatedByString:@","];
			for(int j = 0; j < [cols count]; j++)
			{
				if(sprites != nil && i < visibleY && j < visibleX)
				{
					LGSprite *s = [LGSprite copyOfSprite:sprite];
					[s setPosition:[[cols objectAtIndex:j] intValue]];
					
					[[s view] setFrame:CGRectMake(j * [sprite size].width, i * [sprite size].height, [sprite size].width, [sprite size].height)];
					[[render view] addSubview:[s view]];
					
					[[sprites objectAtIndex:i] addObject:s];
				}
				
				[row addObject:[cols objectAtIndex:j]];
			}
		}
		
		// Store in an LGTileLayer and save
		
		LGTileLayer *layer = [[LGTileLayer alloc] initWithParent:self andTiles:tiles andSprites:sprites];
		[layer setIsVisible:isVisible];
		
		[layers setValue:layer forKey:name];
		
		// Set as the collision layer
		if([name isEqualToString:@"collision"])
		{
			LGTileCollider *tileCollider = [[LGTileCollider alloc] init];
			[tileCollider setCollisionLayer:layer];
			[tileCollider setTileSize:[sprite size]];
			
			LGEntity *collisionLayerEntity = [[LGEntity alloc] init];
			[collisionLayerEntity addComponent:tileCollider];
			[collisionLayerEntity addComponent:[[LGTransform alloc] init]];
			
			[self.scene addEntity:collisionLayerEntity];
		}
	}
}

#pragma mark Private Methods

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