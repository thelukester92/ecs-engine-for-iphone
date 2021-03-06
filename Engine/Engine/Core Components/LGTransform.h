//
//  LGTransform.h
//  Engine
//
//  Created by Luke Godfrey on 2/21/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "LGComponent.h"

@interface LGTransform : LGComponent

@property (nonatomic, assign) CGPoint position, prevPosition;

- (void)addToPosition:(CGPoint)p;
- (void)addToPositionX:(double)x;
- (void)addToPositionY:(double)y;

- (void)setPositionX:(double)x;
- (void)setPositionY:(double)y;

@end