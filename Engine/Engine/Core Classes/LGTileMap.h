//
//  LGTileMap.h
//  Engine
//
//  Created by Luke Godfrey on 4/12/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LGTileLayer;

@interface LGTileMap : NSObject

@property (nonatomic, assign) int width, height;
@property (nonatomic, assign) int tileWidth, tileHeight;

@property (nonatomic, retain) NSMutableArray *layers;
@property (nonatomic, retain) NSString *imageName;

- (BOOL)shiftRight;
- (BOOL)shiftLeft;
- (BOOL)shiftDown;
- (BOOL)shiftUp;

- (void)addLayer:(LGTileLayer *)layer;
- (id)initWithWidth:(int)w andHeight:(int)h andTileWidth:(int)tw andTileHeight:(int)th;

@end