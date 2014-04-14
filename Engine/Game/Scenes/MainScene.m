//
//  MainScene.m
//  Engine
//
//  Created by Luke Godfrey on 2/19/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
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
#import "LGTMXParser.h"
#import "LGTileMap.h"
#import "LGTileLayer.h"

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
	[self addSystem:tileSystem];
}

#pragma mark UIViewController Methods

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self.view setBackgroundColor:[UIColor grayColor]];
	
	[self registerSystems];
	
	LGEntity *player = [EntityFactory playerEntity];
	[self addEntity:player];
	
	LGEntity *block = [EntityFactory blockEntity];
	[(LGTransform *)[block componentOfType:[LGTransform type]] addToPosition:CGPointMake(100, 0)];
	
	LGPhysics *physics = [[LGPhysics alloc] init];
	[block addComponent:physics];
	
	[self addEntity:block];
	
	LGTMXParser *parser = [[LGTMXParser alloc] init];
	[parser setCompletionHandler:^(LGTileMap *map)
	{
		LGSprite *sprite = [[LGSprite alloc] init];
		[sprite setSpriteSheetName:[map imageName]];
		[sprite setSize:CGSizeMake([map tileWidth], [map tileHeight])];
		
		[tileSystem setSprite:sprite];
		[tileSystem setMap:map];
		
//		LGCamera *camera = [player componentOfType:[LGCamera type]];
//		[camera setBounds:CGSizeMake([tileSystem size].width, [tileSystem size].height)];
		
		[self ready];
	}];
	
	[parser parseFile:@"level1"];
}

@end