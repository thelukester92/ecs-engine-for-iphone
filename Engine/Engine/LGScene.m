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

@synthesize engine, entities, systems, allTouches, rootView;

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
	for(int i = 0; i < [systems count]; i++)
	{
		if([[systems objectAtIndex:i] updateOrder] > [system updateOrder])
		{
			[systems insertObject:system atIndex:i];
			return;
		}
	}
	
	// If we reach this, then it hasn't yet been inserted; add it to the end
	[systems addObject:system];
}

- (void)addEntity:(LGEntity *)entity
{
	[entities addObject:entity];
	
	for(LGSystem *system in systems)
	{
		if([system acceptsEntity:entity])
			[system addEntity:entity];
	}
}

#pragma mark The Loop

- (void)update
{
	for(LGSystem *system in systems)
		[system update];
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
		
		[self.view addSubview:rootView];
		[self.view setMultipleTouchEnabled:YES];
	}
	
	return self;
}

@end