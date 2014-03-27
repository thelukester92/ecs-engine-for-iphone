//
//  LGTile.h
//  Engine
//
//  Created by Luke Godfrey on 3/26/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGComponent.h"

@interface LGTile : LGComponent

@property (nonatomic, retain) NSMutableArray *tiles;
@property (nonatomic, assign) int visibleTiles;

- (void)addTile:(NSNumber *)pos;

@end