//
//  LGTileCollider.h
//  Engine
//
//  Created by Luke Godfrey on 3/28/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "LGCollider.h"

@class LGTMXTileLayer;

@interface LGTileCollider : LGCollider

@property (nonatomic, retain) LGTMXTileLayer *collisionLayer;
@property (nonatomic, assign) CGSize tileSize;

@end