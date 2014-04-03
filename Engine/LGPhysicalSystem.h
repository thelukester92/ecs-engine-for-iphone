//
//  LGPhysicalSystem.h
//  Engine
//
//  Created by Luke Godfrey on 2/20/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "LGSystem.h"

@interface LGPhysicalSystem : LGSystem

@property (nonatomic, assign) CGPoint gravity, terminalVelocity;

@end