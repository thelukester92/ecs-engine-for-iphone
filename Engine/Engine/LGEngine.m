//
//  Engine.m
//  Engine
//
//  Created by Luke Godfrey on 2/18/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "LGEngine.h"
#import "LGScene.h"

@implementation LGEngine

@synthesize currentScene, view, displayLink;
@synthesize counter, counterMax;
@synthesize running;

#pragma mark Actions

- (void)gotoScene:(LGScene *)scene
{
	if(currentScene != nil)
		[[currentScene view] removeFromSuperview];
	
	[view addSubview:[scene view]];
	currentScene = scene;
	
	[self startTheLoop];
}

#pragma mark The Loop

- (void)update
{
	counter++;
	if(counter > counterMax)
	{
		counter = 0;
	}
	else
	{
		
	}
	
	if(currentScene != nil)
	{
		[currentScene update];
	}
}

#pragma mark Initializations

- (id)initWithView:(UIView *)v
{
	self = [super init];
	
	if(self)
	{
		currentScene	= nil;
		view			= v;
		displayLink		= [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
		
		counter			= 0;
		counterMax		= 100;
		
		running			= NO;
	}
	
	return self;
}

#pragma mark Private Methods

- (void)startTheLoop
{
	if(!running)
	{
		[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		running = YES;
	}
}

@end