//
//  LGScene.h
//  Engine
//
//  Created by Luke Godfrey on 2/18/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import <Foundation/Foundation.h>

@class LGEngine, LGEntity, LGSystem;

@interface LGScene : UIViewController

@property (nonatomic, weak) LGEngine *engine;
@property (nonatomic, retain) NSMutableArray *entities, *systems;
@property (nonatomic, retain) NSMutableDictionary *allTouches;
@property (nonatomic, retain) UIView *rootView;
@property (nonatomic, assign) CGSize size;

// Actions
- (void)addSystem:(LGSystem *)system;
- (void)addEntity:(LGEntity *)entity;

// The Loop
- (void)update;

// Initializations
- (id)initWithEngine:(LGEngine *)e;

@end