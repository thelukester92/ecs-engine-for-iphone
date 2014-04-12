//
//  LGTileSystem.h
//  Engine
//
//  Created by Luke Godfrey on 3/10/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "LGSystem.h"

@class LGSprite, LGCamera, LGTransform, LGTileLayer, LGTileMap;

@interface LGTileSystem : LGSystem

@property (nonatomic, retain) LGCamera *camera;
@property (nonatomic, retain) LGTransform *cameraTransform;
@property (nonatomic, retain) LGSprite *sprite;
@property (nonatomic, retain) LGTileLayer *visibleLayer;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) int visibleX, visibleY, padding;

@property (nonatomic, retain) LGTileMap *map;

@end