//
//  Scene.m
//  Engine
//
//  Created by Luke Godfrey on 2/18/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "LGScene.h"
#import "LGEngine.h"
#import "LGEntity.h"
#import "LGRender.h"
#import "LGPhysics.h"
#import "LGSystem.h"

@implementation LGScene

@synthesize engine, entities, systems, allTouches, rootView, isReady;

#pragma mark UIViewController Overrides

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	for(UITouch *touch in [touches allObjects])
	{
		NSValue *key = [NSValue valueWithPointer:(__bridge void *)touch];
		[allTouches setObject:touch forKey:key];
	}
	
	for(LGSystem *system in systems)
		[system touchDown:touches allTouches:allTouches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	for(UITouch *touch in [touches allObjects])
	{
		NSValue *key = [NSValue valueWithPointer:(__bridge void *)touch];
		[allTouches removeObjectForKey:key];
	}
	
	for(LGSystem *system in systems)
		[system touchUp:touches allTouches:allTouches];
}

#pragma mark Actions

- (void)addSystem:(LGSystem *)system
{
	BOOL inserted = NO;
	
	for(int i = 0; i < [systems count]; i++)
	{
		if([[systems objectAtIndex:i] updateOrder] > [system updateOrder])
		{
			[systems insertObject:system atIndex:i];
			inserted = YES;
			break;
		}
	}
	
	// Add this system to the end of the update array if it wasn't added in the middle
	
	if(!inserted)
	{
		[systems addObject:system];
	}
	
	// Add previously added entities to this system
	
	for(LGEntity *entity in entities)
	{
		if([system acceptsEntity:entity])
		{
			[system addEntity:entity];
		}
	}
}

- (void)addEntity:(LGEntity *)entity
{
	[entities addObject:entity];
	
	for(LGSystem *system in systems)
	{
		if([system acceptsEntity:entity])
		{
			[system addEntity:entity];
		}
	}
}

- (void)ready
{
	isReady = YES;
	
	// First call to the update loop happens before the game is visible
	[self update];
	
	// Unhide the game
	[self.view setHidden:NO];
}

#pragma mark The Loop

- (void)update
{
	if(isReady)
	{
		for(LGSystem *system in systems)
		{
			[system update];
		}
	}
}

#pragma mark Initializations

- (id)initWithEngine:(LGEngine *)e
{
	self = [super init];
	
	if(self)
	{
		engine		= e;
		entities	= [NSMutableArray array];
		systems		= [NSMutableArray array];
		allTouches	= [NSMutableDictionary dictionary];
		rootView	= [[UIView alloc] initWithFrame:[self.view frame]];
		isReady		= NO;
		
		[self.view addSubview:rootView];
		[self.view setMultipleTouchEnabled:YES];
		[self.view setHidden:YES];
	}
	
	return self;
}

@end