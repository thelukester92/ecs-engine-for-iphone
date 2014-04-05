//
//  LGTileMapParser.m
//  Engine
//
//  Created by Luke Godfrey on 4/2/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "TileMapParser.h"
#import "Constants.h"
#import "LGScene.h"
#import "LGTileSystem.h"
#import "LGTileLayer.h"
#import "LGEntity.h"
#import "LGTransform.h"
#import "LGSprite.h"

@implementation TileMapParser

+ (void)parsePlist:(NSString *)filename forSystem:(LGTileSystem *)system
{
	NSDictionary *data	= [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:@"plist"]];
	NSArray *layerData	= [data objectForKey:TileMapLayers];
	
	for(NSDictionary *layerDictionary in layerData)
	{
		NSString *contents = [layerDictionary objectForKey:TileLayerContents];
		
		BOOL isVisible		= ( [layerDictionary objectForKey:TileLayerIsVisible] ? [[layerDictionary objectForKey:TileLayerIsVisible] boolValue] : YES);
		BOOL isCollision	= ( [layerDictionary objectForKey:TileLayerIsCollision] ? [[layerDictionary objectForKey:TileLayerIsCollision] boolValue] : NO);
		int layerOffset		= ( [layerDictionary objectForKey:TileLayerZOffset] ? [[layerDictionary objectForKey:TileLayerZOffset] intValue] : 0);
		
		// Data to be stored in an LGTileLayer
		
		NSMutableArray *tiles = [NSMutableArray array];
		
		// Populate tiles array from contents
		
		NSArray *rows = [contents componentsSeparatedByString:TileLayerRowSplitter];
		for(int i = 0; i < [rows count]; i++)
		{
			NSMutableArray *row = [NSMutableArray array];
			[tiles addObject:row];
			
			NSArray *cols = [[rows objectAtIndex:i] componentsSeparatedByString:TileLayerColSplitter];
			for(int j = 0; j < [cols count]; j++)
			{
				[row addObject:[cols objectAtIndex:j]];
			}
		}
		
		// Store in an LGTileLayer
		
		[system generateLayerFromArray:tiles layer:(LGRenderLayerMainLayer + layerOffset) visible:isVisible collision:isCollision];
	}
}

@end