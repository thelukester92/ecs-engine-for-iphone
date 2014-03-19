//
//  LGCameraSystem.m
//  Engine
//
//  Created by Luke Godfrey on 3/13/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGCameraSystem.h"
#import "LGScene.h"
#import "LGEntity.h"
#import "LGCamera.h"
#import "LGTransform.h"

@implementation LGCameraSystem

- (BOOL)acceptsEntity:(LGEntity *)entity
{
	return [entity hasComponentsOfType:[LGCamera class], [LGTransform class], nil];
}

- (void)update
{
	LGTransform *transform = [[self.entities objectAtIndex:0] componentOfType:[LGTransform class]];
	
	CGRect frame = [[self.scene rootView] frame];
	frame.origin.x = round([[self.scene view] frame].size.width / 2 - [transform position].x);
	frame.origin.y = round([[self.scene view] frame].size.height / 2 - [transform position].y);
	[[self.scene rootView] setFrame:frame];
}

@end