//
//  LGPlayerInputSystem.h
//  Engine
//
//  Created by Luke Godfrey on 3/5/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGSystem.h"

@class LGSprite, LGPhysics, LGCollider, LGTransform;

@interface LGPlayerInputSystem : LGSystem

@property (nonatomic, weak) LGSprite *sprite;
@property (nonatomic, weak) LGPhysics *physics;
@property (nonatomic, weak) LGCollider *collider;
@property (nonatomic, weak) LGTransform *transform;
@property (nonatomic, assign) CGPoint previousPosition;
@property (nonatomic, assign) BOOL receivingInput, isOnGround;
@property (nonatomic, assign) double speedX, directionX;

@end