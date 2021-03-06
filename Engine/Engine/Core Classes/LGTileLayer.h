//
//  LGTileLayer.h
//  Engine
//
//  Created by Luke Godfrey on 4/12/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LGSprite, LGTile;

@interface LGTileLayer : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) double opacity;
@property (nonatomic, assign) BOOL isVisible, isCollsion;


@property (nonatomic, retain) NSArray *data;
@property (nonatomic, retain) NSMutableArray *sprites;
@property (nonatomic, assign) int zOrder, offsetX, offsetY;

- (BOOL)shiftRight;
- (BOOL)shiftLeft;
- (BOOL)shiftDown;
- (BOOL)shiftUp;

- (LGTile *)tileAtRow:(int)row andCol:(int)col;
- (LGSprite *)spriteAtRow:(int)row andCol:(int)col;
- (BOOL)collidesAtRow:(int)row andCol:(int)col;

- (id)initWithName:(NSString *)n andOpacity:(double)o andVisible:(BOOL)v;

@end