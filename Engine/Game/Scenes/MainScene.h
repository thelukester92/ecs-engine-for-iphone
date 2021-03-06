//
//  MainScene.h
//  Engine
//
//  Created by Luke Godfrey on 2/19/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "LGScene.h"

@class LGTileSystem;

@interface MainScene : LGScene

@property (nonatomic, retain) LGTileSystem *tileSystem;

@end