//
//  LGCollisionResolver.h
//  Engine
//
//  Created by Luke Godfrey on 3/27/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LGPhysics;

@interface LGCollisionResolver : NSObject

@property (nonatomic, weak) LGPhysics *physicsA, *physicsB;
@property (nonatomic, assign) CGPoint resolution, impulse;

- (void)resolveRectangle:(CGRect)a withRectangle:(CGRect)b;

@end