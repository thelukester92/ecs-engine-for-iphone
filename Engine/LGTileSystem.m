//
//  LGTileSystem.m
//  Engine
//
//  Created by Luke Godfrey on 3/10/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGTileSystem.h"
#import "LGScene.h"
#import "LGEntity.h"
#import "LGSprite.h"
#import "LGTransform.h"
#import "LGRectangleCollider.h"
#import "LGPhysics.h"

@implementation LGTileSystem

@synthesize sprite;

- (void)initialize
{
	NSArray *layer = @[
		@0, @0, @0, @0, @0,
		@0, @1, @0, @0, @0,
		@0, @1, @0, @0, @0,
		@0, @1, @0, @0, @1,
		@0, @0, @1, @1, @0
	];
	
	sprite = [[LGSprite alloc] init];
	[sprite setSpriteSheetName:@"blue"];
	[sprite setSize:CGSizeMake(50, 50)];
	[sprite setFrameSize:CGSizeMake(50, 50)];
	
	int n = 5;
	
	for(int i = 0; i < [layer count]; i++)
	{
		int row = i / n;
		int col = i % n;
		
		LGTransform *transform = [[LGTransform alloc] init];
		[transform setPosition:CGPointMake(col * [sprite size].width, row * [sprite size].height)];
		[transform setPrevPosition:[transform position]];
		
		LGSprite *s = [LGSprite copyOfSprite:sprite];
		[s setState:[[LGSpriteState alloc] initWithPosition:[[layer objectAtIndex:i] intValue]]];
		
		LGEntity *tile = [[LGEntity alloc] init];
		[tile addComponent:s];
		[tile addComponent:transform];
		
		if([[layer objectAtIndex:i] intValue] == 1)
		{
			LGRectangleCollider *c = [[LGRectangleCollider alloc] init];
			[c setSize:CGSizeMake(50, 50)];
			[c setType:LGColliderTypeStatic];
			[tile addComponent:c];
		}
		
		[self.scene addEntity:tile];
	}
}

@end