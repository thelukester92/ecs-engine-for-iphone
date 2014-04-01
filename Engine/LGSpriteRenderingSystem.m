//
//  LGSpriteRenderingSystem.m
//  Engine
//
//  Created by Luke Godfrey on 2/20/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGSpriteRenderingSystem.h"
#import "LGEntity.h"
#import "LGComponent.h"
#import "LGTransform.h"
#import "LGSprite.h"
#import "LGScene.h"
#import "LGPlayer.h"

@implementation LGSpriteRenderingSystem

- (BOOL)acceptsEntity:(LGEntity *)entity
{
	return [entity hasComponentsOfType:[LGSprite class], [LGTransform class], nil];
}

- (void)addEntity:(LGEntity *)entity
{
	[super addEntity:entity];
	[self addRenderToView:[entity componentOfType:[LGSprite class]]];
}

- (void)update
{
	for(LGEntity *entity in self.entities)
	{
		LGSprite *sprite		= [entity componentOfType:[LGSprite class]];
		LGTransform *transform	= [entity componentOfType:[LGTransform class]];
		
		if([sprite visible])
		{
			[[sprite view] setFrame:CGRectMake(round([transform position].x - [sprite offset].x), round([transform position].y - [sprite offset].y), [sprite size].width, [sprite size].height)];
			
			if([[sprite state] isAnimated])
			{
				[sprite incrementAnimationCounter];
				if([sprite animationCounter] == 0)
					[sprite nextPosition];
			}
		}
	}
}

@end