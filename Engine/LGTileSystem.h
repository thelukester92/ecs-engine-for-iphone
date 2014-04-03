//
//  LGTileSystem.h
//  Engine
//
//  Created by Luke Godfrey on 3/10/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGSystem.h"

@class LGSprite, LGCamera, LGTransform, LGTileLayer;

@interface LGTileSystem : LGSystem

@property (nonatomic, retain) NSMutableArray *layers;
@property (nonatomic, retain) LGCamera *camera;
@property (nonatomic, retain) LGTransform *cameraTransform;
@property (nonatomic, retain) LGSprite *sprite;
@property (nonatomic, retain) LGTileLayer *visibleLayer;
@property (nonatomic, assign) int visibleX, visibleY, padding;

- (void)addLayer:(LGTileLayer *)layer;

@end