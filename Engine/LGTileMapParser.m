//
//  LGTileMapParser.m
//  Engine
//
//  Created by Luke Godfrey on 4/2/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGTileMapParser.h"
#import "LGScene.h"
#import "LGTileSystem.h"
#import "LGTileLayer.h"
#import "LGEntity.h"
#import "LGTransform.h"
#import "LGSprite.h"
#import "LGTileCollider.h"

@implementation LGTileMapParser

+ (void)parsePlist:(NSString *)filename forSystem:(LGTileSystem *)system
{
	NSDictionary *data	= [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:@"plist"]];
	NSArray *layerData	= [data objectForKey:@"layers"];
	
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
		[render setSize:[[system scene] view].frame.size];
		[render setLayer:LGRenderLayerBackground];
		[layerEntity addComponent:render];
		
		[[system scene] addEntity:layerEntity];
		
		// Populate tiles and sprites arrays
		
		NSArray *rows = [contents componentsSeparatedByString:@",\n"];
		for(int i = 0; i < [rows count]; i++)
		{
			if(sprites != nil && i < [system visibleY])
			{
				[sprites addObject:[NSMutableArray array]];
			}
			
			NSMutableArray *row = [NSMutableArray array];
			[tiles addObject:row];
			
			NSArray *cols = [[rows objectAtIndex:i] componentsSeparatedByString:@","];
			for(int j = 0; j < [cols count]; j++)
			{
				if(sprites != nil && i < [system visibleY] && j < [system visibleX])
				{
					LGSprite *s = [LGSprite copyOfSprite:[system sprite]];
					[s setPosition:[[cols objectAtIndex:j] intValue]];
					
					[[s view] setFrame:CGRectMake(j * [[system sprite] size].width, i * [[system sprite] size].height, [[system sprite] size].width, [[system sprite] size].height)];
					[[render view] addSubview:[s view]];
					
					[[sprites objectAtIndex:i] addObject:s];
				}
				
				[row addObject:[cols objectAtIndex:j]];
			}
		}
		
		// Store in an LGTileLayer and save
		
		LGTileLayer *layer = [[LGTileLayer alloc] initWithParent:system andTiles:tiles andSprites:sprites];
		[layer setIsVisible:isVisible];
		
		[[system layers] setValue:layer forKey:name];
		
		// Set as the collision layer
		if([name isEqualToString:@"collision"])
		{
			LGTileCollider *tileCollider = [[LGTileCollider alloc] init];
			[tileCollider setCollisionLayer:layer];
			[tileCollider setTileSize:[[system sprite] size]];
			
			LGEntity *collisionLayerEntity = [[LGEntity alloc] init];
			[collisionLayerEntity addComponent:tileCollider];
			[collisionLayerEntity addComponent:[[LGTransform alloc] init]];
			
			[[system scene] addEntity:collisionLayerEntity];
		}
	}
}

@end