//
//  LGCollisionSystem.h
//  Engine
//
//  Created by Luke Godfrey on 3/3/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGSystem.h"

@interface LGCollisionSystem : LGSystem

@property (nonatomic, retain) NSMutableArray *staticEntities, *dynamicEntities;

@end