//
//  MainViewController.m
//  Engine
//
//  Created by Luke Godfrey on 2/18/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "MainViewController.h"
#import "LGEngine.h"
#import "MainScene.h"
#import "LGEntity.h"

@implementation MainViewController

@synthesize engine;

- (id)init
{
	self = [super init];
	
	if(self)
	{
		
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	engine = [[LGEngine alloc] initWithView:self.view];
	
	LGScene *scene = [[MainScene alloc] initWithEngine:engine];
	[engine gotoScene:scene];
}

@end