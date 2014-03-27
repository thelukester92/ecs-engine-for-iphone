//
//  LGRenderingSystem.m
//  Engine
//
//  Created by Luke Godfrey on 3/26/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
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

#pragma mark LGSystem Methods

- (BOOL)acceptsEntity:(LGEntity *)entity
{
	return [entity hasComponentsOfType:[LGRender class], [LGTransform class], nil];
}

- (void)addEntity:(LGEntity *)entity
{
	[super addEntity:entity];
	
	// Only perform this step when using this base class directly
	if([self isMemberOfClass:[LGRenderingSystem class]])
	{
		[self addRenderToView:[entity componentOfType:[LGRender class]]];
	}
}

- (void)update
{
	for(LGEntity *entity in self.entities)
	{
		LGRender *render		= [entity componentOfType:[LGRender class]];
		LGTransform *transform	= [entity componentOfType:[LGTransform class]];
		
		if([render visible])
		{
			[[render view] setFrame:CGRectMake(round([transform position].x - [render offset].x), round([transform position].y - [render offset].y), [render size].width, [render size].height)];
		}
	}
}

- (void)initialize
{
	self.updateOrder = LGUpdateOrderRender;
}

@end