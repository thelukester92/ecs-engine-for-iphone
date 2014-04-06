//
//  LGSpatialGrid.h
//  Engine
//
//  Created by Luke Godfrey on 4/6/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LGEntity;

@interface LGSpatialGrid : NSObject

@property (nonatomic, retain) NSMutableDictionary *grid;
@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, assign) int rowHash;

- (NSArray *)entitiesNearEntity:(LGEntity *)entity;

- (int)gridRowAtY:(double)y;
- (int)gridColAtX:(double)x;

- (void)addEntity:(LGEntity *)entity;

- (id)initWithSize:(CGSize)s andRowHash:(int)c;
- (id)initWithSize:(CGSize)s;

@end