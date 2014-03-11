//
//  LGPlayerInputSystem.h
//  Engine
//
//  Created by Luke Godfrey on 3/5/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGSystem.h"

@class LGSprite, LGPhysics, LGCollider;

@interface LGPlayerInputSystem : LGSystem

@property (nonatomic, weak) LGSprite *sprite;
@property (nonatomic, weak) LGPhysics *physics;
@property (nonatomic, weak) LGCollider *collider;
@property (nonatomic, assign) BOOL receivingInput;
@property (nonatomic, assign) double speedX;

@end