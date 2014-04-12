//
//  LGTMXTileLayer.h
//  Engine
//
//  Created by Luke Godfrey on 4/12/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LGEntity, LGTile;

@interface LGTMXTileLayer : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) double opacity;
@property (nonatomic, assign) BOOL isVisible, isCollsion;
@property (nonatomic, assign) int zOrder;

@property (nonatomic, retain) NSArray *data, *entities;

- (LGTile *)tileAtRow:(int)row andCol:(int)col;
- (LGEntity *)spriteEntityAtRow:(int)row andCol:(int)col;
- (BOOL)collidesAtRow:(int)row andCol:(int)col;

- (id)initWithName:(NSString *)n andOpacity:(double)o andVisible:(BOOL)v;

@end