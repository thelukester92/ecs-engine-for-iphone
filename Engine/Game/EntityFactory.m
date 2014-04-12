//
//  EntityFactory.m
//  Engine
//
//  Created by Luke Godfrey on 3/3/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "EntityFactory.h"
#import "LGEntity.h"
#import "LGSprite.h"
#import "LGPhysics.h"
#import "LGTransform.h"
#import "LGPlayer.h"
#import "LGCamera.h"
#import "LGCollider.h"

@implementation EntityFactory

+ (LGEntity *)playerEntity
{
	LGSprite *render = [[LGSprite alloc] init];
	[render setSpriteSheetName:@"Player"];
	[render setSize:CGSizeMake(40, 42)];
	[render setOffset:CGPointMake(-8, -2)];
	
	[render addState:[[LGSpriteState alloc] initWithPosition:1] forKey:@"idle"];
	[render addState:[[LGSpriteState alloc] initWithStart:8 andEnd:9] forKey:@"walk"];
	[render addState:[[LGSpriteState alloc] initWithPosition:6] forKey:@"jump"];
	[render addState:[[LGSpriteState alloc] initWithPosition:7] forKey:@"fall"];
	
	[render setCurrentState:@"idle"];
	
	LGCollider *collider = [[LGCollider alloc] init];
	[collider setSize:CGSizeMake(24, 40)];
	
	LGEntity *player = [[LGEntity alloc] init];
	[player addComponent:render];
	[player addComponent:collider];
	[player addComponent:[[LGPhysics alloc] init]];
	[player addComponent:[[LGTransform alloc] init]];
	[player addComponent:[[LGPlayer alloc] init]];
	
	[(LGTransform *) [player componentOfType:[LGTransform type]] setPosition:CGPointMake(100, 100)];
	
	LGCamera *camera = [[LGCamera alloc] init];
	[camera setOffset:CGPointMake(-200, -100)];
	[player addComponent:camera];
	
	return player;
}

+ (LGEntity *)blockEntity
{
	LGEntity *floor = [[LGEntity alloc] init];
	
	LGTransform *transform = [[LGTransform alloc] init];
	[transform setPosition:CGPointMake(100, 100)];
	
	LGSprite *render = [[LGSprite alloc] init];
	[render setSpriteSheet:[UIImage imageNamed:@"blue"]];
	[render setSize:CGSizeMake(50, 50)];
	[render setState:[[LGSpriteState alloc] initWithPosition:1]];
	
	LGCollider *collider = [[LGCollider alloc] init];
	[collider setSize:CGSizeMake(50, 50)];
	[floor addComponent:collider];
	
	[floor addComponent:render];
	[floor addComponent:transform];
	
	return floor;
}

@end