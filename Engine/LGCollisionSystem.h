//
//  LGCollisionSystem.h
//  Engine
//
//  Created by Luke Godfrey on 3/3/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "LGSystem.h"

typedef enum
{
	LGCollisionAxisAny,
	LGCollisionAxisX,
	LGCollisionAxisY
} LGCollisionAxis;

@interface LGCollisionSystem : LGSystem

@property (nonatomic, retain) NSMutableArray *staticEntities, *dynamicEntities;

@end