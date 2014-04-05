//
//  LGTileLayer.h
//  Engine
//
//  Created by Luke Godfrey on 3/26/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import <Foundation/Foundation.h>

@class LGTileSystem, LGEntity;

@interface LGTileLayer : NSObject

@property (nonatomic, weak) LGTileSystem *parent;
@property (nonatomic, retain) NSArray *tiles;
@property (nonatomic, retain) NSMutableArray *spriteEntities;
@property (nonatomic, assign) int offsetX, offsetY;
@property (nonatomic, assign) BOOL isVisible;

- (BOOL)shiftRight;
- (BOOL)shiftLeft;
- (BOOL)shiftDown;
- (BOOL)shiftUp;

- (NSString *)tileAtRow:(int)row andCol:(int)col;
- (LGEntity *)spriteEntityAtRow:(int)row andCol:(int)col;
- (BOOL)collidesAtRow:(int)row andCol:(int)col;

- (id)initWithParent:(LGTileSystem *)p andTiles:(NSArray *)t andSprites:(NSMutableArray *)s;

@end