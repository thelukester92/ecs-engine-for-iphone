//
//  MainScene.m
//  Engine
//
//  Created by Luke Godfrey on 2/19/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "MainScene.h"
#import "LGPhysicalSystem.h"
#import "LGSpriteRenderingSystem.h"
#import "LGCollisionSystem.h"
#import "LGPlayerInputSystem.h"
#import "LGCameraSystem.h"
#import "LGTileSystem.h"
#import "LGEntity.h"
#import "LGTransform.h"
#import "LGSprite.h"
#import "LGPhysics.h"
#import "LGCollider.h"
#import "LGCamera.h"
#import "EntityFactory.h"

@implementation MainScene

@synthesize tileSystem;

#pragma mark Private Methods

- (void)registerSystems
{
	[self addSystem:[[LGRenderingSystem alloc] initWithScene:self]];
	[self addSystem:[[LGSpriteRenderingSystem alloc] initWithScene:self]];
	[self addSystem:[[LGCameraSystem alloc] initWithScene:self]];
	[self addSystem:[[LGPlayerInputSystem alloc] initWithScene:self]];
	[self addSystem:[[LGPhysicalSystem alloc] initWithScene:self]];
	[self addSystem:[[LGCollisionSystem alloc] initWithScene:self]];
	
	tileSystem = [[LGTileSystem alloc] initWithScene:self];
	
	LGSprite *sprite = [[LGSprite alloc] init];
	[sprite setSpriteSheetName:@"tileset"];
	[sprite setSize:CGSizeMake(32, 32)];
	
	[tileSystem setSprite:sprite];
	
	[self addSystem:tileSystem];
}

#pragma mark UIViewController Methods

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self registerSystems];
	
	LGEntity *player = [EntityFactory playerEntity];
	[[player componentOfType:[LGCamera class]] setSize:CGSizeMake([self.view frame].size.width, [self.view frame].size.height)];
	[self addEntity:player];
	
	LGEntity *floor = [EntityFactory floorEntity:NO];
//	[(LGCollider *)[floor componentOfType:[LGCollider class]] setType:LGColliderTypeCloud];
	
	LGPhysics *phys = [[LGPhysics alloc] init];
	[phys setVelocity:CGPointMake(0, 0)];
	[floor addComponent:phys];

	LGEntity *floor2 = [EntityFactory floorEntity:NO];
	[(LGTransform *)[floor2 componentOfType:[LGTransform class]] addToPosition:CGPointMake(-100, 100)];
	[(LGCollider *)[floor2 componentOfType:[LGCollider class]] setType:LGColliderTypeStatic];
	
//	LGPhysics *phys2 = [[LGPhysics alloc] init];
//	[phys2 setVelocity:CGPointMake(-2, 0)];
//	[phys2 setRespondsToGravity:NO];
//	[floor2 addComponent:phys2];
	
	[self addEntity:floor];
	[self addEntity:floor2];
	
	[tileSystem loadPlist:@"level1"];
}

@end