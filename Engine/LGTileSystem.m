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
#import "LGRectangleCollider.h"
#import "LGPhysics.h"
#import "LGTile.h"
#import "LGCamera.h"
#import "LGTileLayer.h"
#import "LGCollisionResolver.h"

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

- (void)resolveCollisionsWith:(LGEntity *)a
{
	LGTransform *transform = [a componentOfType:[LGTransform class]];
	LGRectangleCollider *collider = [a componentOfType:[LGCollider class]];
	LGPhysics *physics = [a componentOfType:[LGPhysics class]];
	
	int tileX, tileY;
	
	[collider resetCollider];
	
	// Top collisions
	
	tileY = (int) floor( [transform position].y / [sprite size].height );
	
	for(tileX = (int) floor( ([transform position].x + 1) / [sprite size].width ); tileX <= (int) floor( ( [transform position].x + [collider size].width - 1 ) / [sprite size].width ); tileX++)
	{
		if( [[layers objectForKey:@"collision"] collidesAtRow:tileY andCol:tileX] )
		{
			[transform setPositionY:(tileY + 1) * [sprite size].height];
			[collider setCollidedTop:YES];
			
			if(physics)
			{
				[physics setVelocityY:0];
			}
			
			break;
		}
	}
	
	// Bottom collisions
	
	tileY = (int) floor( ( [transform position].y + [collider size].height ) / [sprite size].height );
	
	for(tileX = (int) floor( ([transform position].x + 1) / [sprite size].width ); tileX <= (int) floor( ( [transform position].x + [collider size].width - 1 ) / [sprite size].width ); tileX++)
	{
		if( [[layers objectForKey:@"collision"] collidesAtRow:tileY andCol:tileX] )
		{
			// Case 1: Rectangle to Rectangle Collision
			
			LGCollisionResolver *resolver = [[LGCollisionResolver alloc] init];
			
			CGRect rectA = CGRectMake([transform position].x, [transform position].y, [collider size].width, [collider size].height);
			CGRect rectB = CGRectMake(tileX * [sprite size].width, tileY * [sprite size].height, [sprite size].width, [sprite size].height);
			
			[resolver resolveRectangle:rectA withRectangle:rectB];
			
			// TODO: Apply resolution to the entity
			
			[transform setPositionY:tileY * [sprite size].height - [collider size].height];
			[collider setCollidedBottom:YES];
			
			if(physics)
			{
				[physics setVelocityY:0];
			}
			
			break;
		}
	}
	
	// Left collisions
	
	tileX = (int) floor( [transform position].x / [sprite size].width );
	
	for(tileY = (int) floor( ([transform position].y + 1) / [sprite size].height ); tileY <= (int) floor( ( [transform position].y + [collider size].height - 1 ) / [sprite size].height ); tileY++)
	{
		if([[layers objectForKey:@"collision"] collidesAtRow:tileY andCol:tileX] )
		{
			[transform setPositionX:(tileX + 1) * [sprite size].width];
			[collider setCollidedLeft:YES];
			
			if(physics)
			{
				[physics setVelocityX:0];
			}
			
			break;
		}
	}
	
	// Right collisions
	
	tileX = (int) floor( ( [transform position].x + [collider size].width ) / [sprite size].width );
	
	for(tileY = (int) floor( ([transform position].y + 1) / [sprite size].height ); tileY <= (int) floor( ( [transform position].y + [collider size].height - 1 ) / [sprite size].height ); tileY++)
	{
		if([[layers objectForKey:@"collision"] collidesAtRow:tileY andCol:tileX] )
		{
			[transform setPositionX:tileX * [sprite size].width - [collider size].width];
			[collider setCollidedRight:YES];
			
			if(physics)
			{
				[physics setVelocityX:0];
			}
			
			break;
		}
	}
}

#pragma mark LGSystem Methods

- (BOOL)acceptsEntity:(LGEntity *)entity
{
	return [entity hasComponentsOfType:[LGCamera class], [LGTransform class], nil] || [entity hasComponentsOfType:[LGCollider class], [LGTransform class], nil];
}

- (void)addEntity:(LGEntity *)entity
{
	if([entity hasComponentsOfType:[LGCamera class], [LGTransform class], nil])
	{
		camera = [entity componentOfType:[LGCamera class]];
		cameraTransform = [entity componentOfType:[LGTransform class]];
	}
	
	if([entity hasComponentsOfType:[LGCollider class], [LGTransform class], nil])
	{
		[super addEntity:entity];
	}
}

- (void)update
{
	[self shiftTiles];
	
	for(int i = 0; i < [self.entities count]; i++)
	{
		LGEntity *a = [self.entities objectAtIndex:i];
		[[a componentOfType:[LGCollider class]] resetCollider];
		
		[self resolveCollisionsWith:a];
	}
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