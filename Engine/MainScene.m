//
//  MainScene.m
//  Engine
//
//  Created by Luke Godfrey on 2/19/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "MainScene.h"
#import "LGPhysicalSystem.h"
#import "LGSpriteRenderer.h"
#import "LGCollisionSystem.h"
#import "LGPlayerInputSystem.h"
#import "LGCameraSystem.h"
#import "LGTileSystem.h"
#import "LGEntity.h"
#import "LGTransform.h"
#import "LGSprite.h"
#import "LGPhysics.h"
#import "LGCollider.h"
#import "EntityFactory.h"

@implementation MainScene

- (id)initWithEngine:(LGEngine *)e
{
	self = [super initWithEngine:e];
	
	if(self)
	{
		[self addSystem:[[LGPhysicalSystem alloc] initWithScene:self]];
		[self addSystem:[[LGCollisionSystem alloc] initWithScene:self]];
		[self addSystem:[[LGSpriteRenderer alloc] initWithScene:self]];
		// [self addSystem:[[LGPlayerInputSystem alloc] initWithScene:self]];
		// [self addSystem:[[LGTileSystem alloc] initWithScene:self]];
		// [self addSystem:[[LGCameraSystem alloc] initWithScene:self]];
		
		LGEntity *player = [EntityFactory playerEntity];
		[(LGTransform *)[player componentOfType:[LGTransform class]] setPosition:CGPointMake(150, 0)];
		// [self addEntity:player];
	}
	
	return self;
}

@end