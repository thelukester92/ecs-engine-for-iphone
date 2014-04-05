//
//  LGRenderingSystem.h
//  Engine
//
//  Created by Luke Godfrey on 3/26/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "LGSystem.h"

@class LGRender, LGTransform;

@interface LGRenderingSystem : LGSystem

- (void)addRenderToView:(LGRender *)render;
- (void)updateRender:(LGRender *)render withTransform:(LGTransform *)transform;

@end