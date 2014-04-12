//
//  LGTileMap.h
//  Engine
//
//  Created by Luke Godfrey on 4/12/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LGTMXTileLayer;

@interface LGTileMap : NSObject

@property (nonatomic, assign) int width, height;
@property (nonatomic, assign) int tileWidth, tileHeight;

@property (nonatomic, retain) NSMutableDictionary *layers;
@property (nonatomic, retain) NSString *imageName;

- (BOOL)shiftRight;
- (BOOL)shiftLeft;
- (BOOL)shiftDown;
- (BOOL)shiftUp;

- (void)addLayer:(LGTMXTileLayer *)layer;
- (id)initWithWidth:(int)w andHeight:(int)h andTileWidth:(int)tw andTileHeight:(int)th;

@end