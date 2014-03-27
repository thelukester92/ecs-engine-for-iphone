//
//  LGTileLayer.h
//  Engine
//
//  Created by Luke Godfrey on 3/26/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LGTileSystem, LGSprite;

@interface LGTileLayer : NSObject

@property (nonatomic, weak) LGTileSystem *parent;
@property (nonatomic, retain) NSMutableArray *tiles, *sprites;
@property (nonatomic, assign) int offsetX, offsetY;
@property (nonatomic, assign) BOOL isVisible;

- (BOOL)shiftRight;
- (BOOL)shiftLeft;
- (BOOL)shiftDown;
- (BOOL)shiftUp;

- (NSString *)tileAtRow:(int)row andCol:(int)col;
- (LGSprite *)spriteAtRow:(int)row andCol:(int)col;
- (BOOL)collidesAtRow:(int)row andCol:(int)col;

- (id)initWithParent:(LGTileSystem *)p andTiles:(NSMutableArray *)t andSprites:(NSMutableArray *)s;

@end