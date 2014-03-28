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
	LGColliderTypeSolid,
	LGColliderTypeCloud,
	LGColliderTypeTile,
	LGColliderTypeStatic
} LGColliderType;

@interface LGCollider : LGComponent

@property (nonatomic, assign) LGColliderType type;
@property (nonatomic, assign) CGPoint offset;
@property (nonatomic, assign) BOOL collidedLeft, collidedRight, collidedTop, collidedBottom;
@property (nonatomic, assign) BOOL staticLeft, staticRight, staticTop, staticBottom;

- (CGSize)boundingBox;
- (void)resetCollider;

@end