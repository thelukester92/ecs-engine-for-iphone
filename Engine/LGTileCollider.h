//
//  LGTileCollider.h
//  Engine
//
//  Created by Luke Godfrey on 3/28/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGCollider.h"

@class LGTileLayer;

@interface LGTileCollider : LGCollider

@property (nonatomic, retain) LGTileLayer *collisionLayer;
@property (nonatomic, assign) CGSize tileSize;

@end