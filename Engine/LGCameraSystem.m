//
//  LGCameraSystem.m
//  Engine
//
//  Created by Luke Godfrey on 3/13/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "LGCameraSystem.h"
#import "LGScene.h"
#import "LGEntity.h"
#import "LGCamera.h"
#import "LGTransform.h"

@implementation LGCameraSystem

@synthesize camera, cameraTransform;

- (BOOL)acceptsEntity:(LGEntity *)entity
{
	return [entity hasComponentsOfType:[LGCamera class], [LGTransform class], nil];
}

- (void)addEntity:(LGEntity *)entity
{
	[super addEntity:entity];
	
	camera = [entity componentOfType:[LGCamera class]];
	cameraTransform = [entity componentOfType:[LGTransform class]];
}

- (void)update
{
	CGRect frame = [[self.scene rootView] frame];
	frame.origin.x = round( MIN( 0, MAX( [camera size].width - [camera bounds].size.width - [camera bounds].origin.x, - [camera offset].x - [cameraTransform position].x ) ) );
	frame.origin.y = round( MIN( 0, MAX( [camera size].height - [camera bounds].size.height - [camera bounds].origin.y, - [camera offset].y - [cameraTransform position].y ) ) );
	[[self.scene rootView] setFrame:frame];
}

- (void)initialize
{
	self.updateOrder = LGUpdateOrderRender;
}

@end