//
//  LGQuadtree.h
//  Engine
//
//  Created by Luke Godfrey on 4/5/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LGEntity;

@interface LGQuadtree : NSObject

@property (nonatomic, retain) NSMutableArray *entities;
@property (nonatomic, retain) NSArray *children;
@property (nonatomic, assign) CGRect bounds;
@property (nonatomic, assign) CGSize minSize;
@property (nonatomic, assign) double width, height;
@property (nonatomic, assign) int level, maxEntities, maxLevels;

- (NSArray *)entitiesNearRect:(CGRect)rect;
- (NSArray *)entitiesNearEntity:(LGEntity *)entity;

- (void)addEntity:(LGEntity *)entity withRect:(CGRect)rect;
- (void)addEntity:(LGEntity *)entity;
- (void)split;

- (id)initWithBounds:(CGRect)b andLevel:(int)l;
- (id)initWithBounds:(CGRect)b;

@end