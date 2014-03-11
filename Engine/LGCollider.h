//
//  LGCollider.h
//  Engine
//
//  Created by Luke Godfrey on 3/3/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGComponent.h"

@interface LGCollider : LGComponent

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) BOOL ignoresOtherColliders;
@property (nonatomic, assign) BOOL collidedLeft, collidedRight, collidedTop, collidedBottom;

- (void)resetCollider;

@end