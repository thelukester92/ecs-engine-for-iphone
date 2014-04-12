//
//  LGTMXParser.m
//  Engine
//
//  Created by Luke Godfrey on 4/12/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGTMXParser.h"
#import "LGTileMap.h"
#import "LGTMXTileLayer.h"
#import "LGTile.h"

@implementation LGTMXParser

@synthesize parser, currentElement, tempData, collisionLayerName, foregroundLayerName, map, currentLayer, completionHandler, zOrder, backgroundLayer, foregroundLayer;

#pragma mark LGTMXParser Methods

- (void)parseFile:(NSString *)filename
{
	NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"tmx"];
	
	if(path == nil)
	{
		NSLog(@"Failed to load file: %@", filename);
		
		if(completionHandler)
		{
			completionHandler(nil);
		}
		
		return;
	}
	
	zOrder = backgroundLayer;
	
	parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]];
	[parser setDelegate:self];
	[parser parse];
}

- (id)init
{
	self = [super init];
	
	if(self)
	{
		collisionLayerName	= nil;
		foregroundLayerName	= nil;
		backgroundLayer		= 0;
		foregroundLayer		= 0;
	}
	
	return self;
}

#pragma mark NSXMLParserDelegate Methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	currentElement = [elementName lowercaseString];
	
	if([currentElement isEqualToString:@"map"])
	{
		int width = 0, height = 0, tileWidth = 0, tileHeight = 0;
		
		if([attributeDict objectForKey:@"width"] != nil)
		{
			width = [[attributeDict objectForKey:@"width"] intValue];
		}
		
		if([attributeDict objectForKey:@"height"] != nil)
		{
			height = [[attributeDict objectForKey:@"height"] intValue];
		}
		
		if([attributeDict objectForKey:@"tilewidth"] != nil)
		{
			tileWidth = [[attributeDict objectForKey:@"tilewidth"] intValue];
		}
		
		if([attributeDict objectForKey:@"tileheight"] != nil)
		{
			tileHeight = [[attributeDict objectForKey:@"tileheight"] intValue];
		}
		
		map = [[LGTileMap alloc] initWithWidth:width andHeight:height andTileWidth:tileWidth andTileHeight:tileHeight];
	}
	
	if([currentElement isEqualToString:@"image"])
	{
		[map setImageName:[attributeDict objectForKey:@"source"]];
	}
	
	if([currentElement isEqualToString:@"layer"])
	{
		double opacity	= 1;
		BOOL visible	= YES;
		
		if([attributeDict objectForKey:@"opacity"] != nil)
		{
			opacity = [[attributeDict objectForKey:@"opacity"] doubleValue];
		}
		
		if([attributeDict objectForKey:@"visible"] != nil)
		{
			visible = [[attributeDict objectForKey:@"visible"] boolValue];
		}
		
		currentLayer = [[LGTMXTileLayer alloc] initWithName:[attributeDict objectForKey:@"name"] andOpacity:opacity andVisible:visible];
		
		if([[currentLayer name] isEqualToString:collisionLayerName])
		{
			[currentLayer setIsCollsion:YES];
		}
		
		if([[currentLayer name] isEqualToString:foregroundLayerName])
		{
			zOrder = foregroundLayer;
		}
		
		[currentLayer setZOrder:zOrder];
		[map addLayer:currentLayer];
	}
	
	if([currentElement isEqualToString:@"data"])
	{
		tempData = @"";
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if([currentElement isEqualToString:@"data"])
	{
		tempData = [NSString stringWithFormat:@"%@%@", tempData, string];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if([elementName isEqualToString:@"data"])
	{
		NSMutableArray *tiles = [NSMutableArray array];
		
		NSArray *rows = [tempData componentsSeparatedByString:@",\n"];
		for(int i = 0; i < [rows count]; i++)
		{
			NSMutableArray *row = [NSMutableArray array];
			[tiles addObject:row];
			
			NSArray *cols = [[rows objectAtIndex:i] componentsSeparatedByString:@","];
			for(int j = 0; j < [cols count]; j++)
			{
				LGTile *tile = [[LGTile alloc] initWithPositionString:[cols objectAtIndex:j]];
				[row addObject:tile];
			}
		}
		
		[currentLayer setData:tiles];
	}
	
	if([elementName isEqualToString:@"layer"])
	{
		currentLayer = nil;
	}
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	if(completionHandler)
	{
		completionHandler(nil);
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	if(completionHandler)
	{
		completionHandler(map);
	}
}

@end