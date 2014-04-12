//
//  LGRenderingSystem.m
//  Engine
//
//  Created by Luke Godfrey on 3/26/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "LGRenderingSystem.h"
#import "LGScene.h"
#import "LGEntity.h"
#import "LGRender.h"
#import "LGTransform.h"

@implementation LGRenderingSystem

#pragma mark LGRenderingSystem Methods

- (void)addRenderToView:(LGRender *)render
{
	[[self.scene rootView] addSubview:[render view]];
}

- (void)updateRender:(LGRender *)render withTransform:(LGTransform *)transform
{
	if([render visible])
	{
		[[render view] setFrame:CGRectMake(round([transform position].x - [render offset].x), round([transform position].y - [render offset].y), [render size].width, [render size].height)];
	}
}

#pragma mark LGSystem Methods

- (BOOL)acceptsEntity:(LGEntity *)entity
{
	return [entity hasComponentsOfType:[LGRender type], [LGTransform type], nil];
}

- (void)addEntity:(LGEntity *)entity
{
	[super addEntity:entity];
	
	// Only perform this step when using this class directly
	
	if([self isMemberOfClass:[LGRenderingSystem class]])
	{
		[self addRenderToView:[entity componentOfType:[LGRender type]]];
	}
}

- (void)update
{
	for(LGEntity *entity in self.entities)
	{
		LGRender *render		= [entity componentOfType:[LGRender type]];
		LGTransform *transform	= [entity componentOfType:[LGTransform type]];
		
		[self updateRender:render withTransform:transform];
	}
}

- (void)initialize
{
	self.updateOrder = LGUpdateOrderRender;
}

@end