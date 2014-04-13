//
//  MainViewController.m
//  Engine
//
//  Created by Luke Godfrey on 2/18/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "MainViewController.h"
#import "LGEngine.h"
#import "MainScene.h"
#import "LGEntity.h"

@implementation MainViewController

@synthesize engine;

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	engine = [[LGEngine alloc] initWithView:self.view];
	
	LGScene *scene = [[MainScene alloc] initWithEngine:engine];
	[engine gotoScene:scene];
}

@end