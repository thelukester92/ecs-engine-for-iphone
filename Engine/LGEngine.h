//
//  Engine.h
//  Engine
//
//  Created by Luke Godfrey on 2/18/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import <Foundation/Foundation.h>

@class LGScene;

@interface LGEngine : NSObject

@property (nonatomic, retain) LGScene *currentScene;
@property (nonatomic, retain) UIView *view;
@property (nonatomic, retain) CADisplayLink *displayLink;
@property (nonatomic, assign) int counter, counterMax;
@property (nonatomic, assign) BOOL running;

// Actions
- (void)gotoScene:(LGScene *)scene;

// The Loop
- (void)update;

// Initializations
- (id)initWithView:(UIView *)v;

@end