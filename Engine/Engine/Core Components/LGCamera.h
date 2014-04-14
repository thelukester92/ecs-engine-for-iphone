//
//  LGCamera.h
//  Engine
//
//  Created by Luke Godfrey on 3/13/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "LGComponent.h"

@interface LGCamera : LGComponent

@property (nonatomic, assign) CGPoint offset;
@property (nonatomic, assign) CGSize size, bounds;

@end