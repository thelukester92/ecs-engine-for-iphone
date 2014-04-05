//
//  LGSpriteRenderingSystem.m
//  Engine
//
//  Created by Luke Godfrey on 2/20/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "LGSpriteRenderingSystem.h"
#import "LGEntity.h"
#import "LGComponent.h"
#import "LGTransform.h"
#import "LGSprite.h"
#import "LGScene.h"

@implementation LGSpriteRenderingSystem

- (BOOL)acceptsEntity:(LGEntity *)entity
{
	return [entity hasComponentsOfType:[LGSprite type], [LGTransform type], nil];
}

- (void)addEntity:(LGEntity *)entity
{
	[super addEntity:entity];
	[self addRenderToView:[entity componentOfType:[LGSprite type]]];
}

- (void)update
{
	for(LGEntity *entity in self.entities)
	{
		LGSprite *sprite		= [entity componentOfType:[LGSprite type]];
		LGTransform *transform	= [entity componentOfType:[LGTransform type]];
		
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