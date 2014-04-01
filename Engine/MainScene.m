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
	
	// [self addSystem:tileSystem];
}

#pragma mark UIViewController Methods

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self registerSystems];
	
	LGEntity *player = [EntityFactory playerEntity];
	[[player componentOfType:[LGCamera class]] setSize:CGSizeMake([self.view frame].size.width, [self.view frame].size.height)];
//	[[player componentOfType:[LGPhysics class]] setRespondsToGravity:NO];
//	[[player componentOfType:[LGTransform class]] addToPositionX:400];
	[self addEntity:player];
	
	LGEntity *test = [EntityFactory floorEntity:NO];
	[(LGTransform *)[test componentOfType:[LGTransform class]] addToPositionX:200];
	[self addEntity:test];
	
	LGEntity *ceiling = [EntityFactory floorEntity:NO];
	[(LGTransform *)[ceiling componentOfType:[LGTransform class]] addToPositionY:-200];
	[(LGCollider *)[ceiling componentOfType:[LGCollider class]] setType:LGColliderTypeStatic];
	[self addEntity:ceiling];
	
	for(int i = 0; i < 1; i++)
	{
		LGEntity *floor = [EntityFactory floorEntity:NO];
		[(LGTransform *)[floor componentOfType:[LGTransform class]] addToPosition:CGPointMake(0, 100 + i * 70)];
		[floor addComponent:[[LGPhysics alloc] init]];
		
		if(i == 0)
		{
			[(LGCollider *)[floor componentOfType:[LGCollider class]] setType:LGColliderTypeStatic];
			[(LGPhysics *)[floor componentOfType:[LGPhysics class]] setRespondsToGravity:NO];
			[(LGPhysics *)[floor componentOfType:[LGPhysics class]] setVelocityY:-1];
		}
		
		[self addEntity:floor];
	}
	
	// [tileSystem loadPlist:@"level1"];
}

@end