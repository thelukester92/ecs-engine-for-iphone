//
//  LGPhysics.h
//  Engine
//
//  Created by Luke Godfrey on 2/19/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGComponent.h"

@interface LGPhysics : LGComponent

@property (nonatomic, assign) CGPoint velocity;

- (void)addToVelocity:(CGPoint)v;
- (void)limitVelocity:(CGPoint)v;

- (void)addToVelocityX:(double)x;
- (void)addToVelocityY:(double)y;

- (void)setVelocityX:(double)x;
- (void)setVelocityY:(double)y;

@end