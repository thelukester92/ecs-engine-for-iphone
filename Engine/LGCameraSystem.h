//
//  LGCameraSystem.h
//  Engine
//
//  Created by Luke Godfrey on 3/13/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "LGSystem.h"

@class LGCamera, LGTransform;

@interface LGCameraSystem : LGSystem

@property (nonatomic, retain) LGCamera *camera;
@property (nonatomic, retain) LGTransform *cameraTransform;

@end