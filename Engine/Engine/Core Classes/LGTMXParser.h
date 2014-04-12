//
//  LGTMXParser.h
//  Engine
//
//  Created by Luke Godfrey on 4/12/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LGTileMap, LGTileLayer;

typedef void(^LGTMXParserCompletionBlock)(LGTileMap *map);

@interface LGTMXParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, retain) NSXMLParser *parser;
@property (nonatomic, retain) NSString *currentElement, *tempData, *collisionLayerName, *foregroundLayerName;

@property (nonatomic, retain) LGTileMap *map;
@property (nonatomic, retain) LGTileLayer *currentLayer;

@property (nonatomic, assign) LGTMXParserCompletionBlock completionHandler;
@property (nonatomic, assign) int zOrder, backgroundLayer, foregroundLayer;

- (void)parseFile:(NSString *)filename;

@end