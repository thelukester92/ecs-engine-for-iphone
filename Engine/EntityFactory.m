//
//  EntityFactory.m
//  Engine
//
//  Created by Luke Godfrey on 3/3/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "EntityFactory.h"
#import "LGEntity.h"
#import "LGSprite.h"
#import "LGPhysics.h"
#import "LGTransform.h"
#import "LGRectangleCollider.h"
#import "LGCircleCollider.h"
#import "LGPlayer.h"
#import "LGCamera.h"

@implementation EntityFactory

+ (LGEntity *)playerEntity
{
	LGSprite *render = [[LGSprite alloc] init];
	[render setSpriteSheetName:@"Player"];
	[render setSize:CGSizeMake(64, 64)];
	[render setOffset:CGPointMake(24, 24)];
	[render setFrameSize:CGSizeMake(64, 64)];
	
	[render addState:[[LGSpriteState alloc] initWithStart:1 andEnd:8] forKey:@"idle"];
	[render addState:[[LGSpriteState alloc] initWithStart:11 andEnd:18] forKey:@"walk"];
	[render addState:[[LGSpriteState alloc] initWithStart:21 andEnd:22 loops:NO] forKey:@"jump"];
	[render addState:[[LGSpriteState alloc] initWithStart:23 andEnd:24 loops:NO] forKey:@"fall"];
	[render addState:[[LGSpriteState alloc] initWithStart:31 andEnd:35 loops:NO] forKey:@"die"];
	[render addState:[[LGSpriteState alloc] initWithStart:41 andEnd:49 loops:NO] forKey:@"disappear"];
	[render addState:[[LGSpriteState alloc] initWithStart:51 andEnd:59 loops:NO] forKey:@"appear"];
	
	[render setCurrentState:@"idle"];
	
	LGRectangleCollider *collider = [[LGRectangleCollider alloc] init];
	[collider setSize:CGSizeMake(20, 40)];
	
	LGEntity *player = [[LGEntity alloc] init];
	[player addComponent:render];
	[player addComponent:collider];
	[player addComponent:[[LGPhysics alloc] init]];
	[player addComponent:[[LGTransform alloc] init]];
	[player addComponent:[[LGPlayer alloc] init]];
	[player addComponent:[[LGCamera alloc] init]];
	
	return player;
}

+ (LGEntity *)floorEntity:(BOOL)circ
{
	LGEntity *floor = [[LGEntity alloc] init];
	
	LGTransform *transform = [[LGTransform alloc] init];
	[transform setPosition:CGPointMake(100, 200)];
	
	LGSprite *render = [[LGSprite alloc] init];
	[render setSpriteSheet:[UIImage imageNamed:circ ? @"ball" : @"blue"]];
	[render setSize:CGSizeMake(50, 50)];
	[render setFrameSize:CGSizeMake(50, 50)];
	[render setState:[[LGSpriteState alloc] initWithPosition:1]];
	
	if(circ)
	{
		LGCircleCollider *collider = [[LGCircleCollider alloc] init];
		[collider setRadius:25];
		[floor addComponent:collider];
	}
	else
	{
		LGRectangleCollider *collider = [[LGRectangleCollider alloc] init];
		[collider setSize:CGSizeMake(50, 50)];
		[floor addComponent:collider];
	}
	
	[floor addComponent:render];
	[floor addComponent:transform];
	
	return floor;
}

@end