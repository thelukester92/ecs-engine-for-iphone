//
//  LGRenderingSystem.h
//  Engine
//
//  Created by Luke Godfrey on 3/26/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGSystem.h"

@class LGRender;

@interface LGRenderingSystem : LGSystem

- (void)addRenderToView:(LGRender *)render;

@end