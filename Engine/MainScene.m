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
		
		LGPhysics *physics = [[LGPhysics alloc] init];
		[physics setVelocity:CGPointMake(1, 0)];
		[physics setElasticity:0];
		[physics setRespondsToGravity:NO];
		
		LGEntity *floor = [EntityFactory floorEntity];
		[(LGCollider *)[floor componentOfType:[LGCollider class]] setType:LGColliderTypeStatic];
		[floor addComponent:physics];
		
		LGPhysics *physicsB = [[LGPhysics alloc] init];
		[physicsB setVelocity:CGPointMake(-2, 0)];
		[physicsB setRespondsToGravity:NO];
		
		LGEntity *floorB = [EntityFactory floorEntity];
		[[floorB componentOfType:[LGTransform class]] addToPosition:CGPointMake(200, 0)];
		// [(LGCollider *)[floorB componentOfType:[LGCollider class]] setType:LGColliderTypeStatic];
		[floorB addComponent:physicsB];
		
		[self addEntity:floor];
		[self addEntity:floorB];
		
	}
	
	return self;
}

@end