//
//  LGCollider.h
//  Engine
//
//  Created by Luke Godfrey on 3/3/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGComponent.h"

typedef enum
{
	LGColliderTypeDynamic,
	LGColliderTypeStatic
} LGColliderType;

@interface LGCollider : LGComponent

@property (nonatomic, assign) LGColliderType type;
@property (nonatomic, assign) CGPoint offset;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) double leftDist, rightDist, topDist, bottomDist;

- (void)reset;

@end