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
	
	NSArray *sprites = [entity componentsOfType:[LGSprite type]];
	for(LGSprite *sprite in sprites)
	{
		[self addRenderToView:sprite];
	}
}

- (void)update
{
	for(LGEntity *entity in self.entities)
	{
		NSArray *sprites		= [entity componentsOfType:[LGSprite type]];
		LGTransform *transform	= [entity componentOfType:[LGTransform type]];
		
		for(LGSprite *sprite in sprites)
		{
			[self updateRender:sprite withTransform:transform];
			
			if([sprite visible] && [[sprite state] isAnimated])
			{
				[sprite incrementAnimationCounter];
				if([sprite animationCounter] == 0)
				{
					[sprite nextPosition];
				}
			}
		}
	}
}

@end