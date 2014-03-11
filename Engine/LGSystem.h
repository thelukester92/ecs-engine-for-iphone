//
//  LGSystem.h
//  Engine
//
//  Created by Luke Godfrey on 2/20/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import <Foundation/Foundation.h>

enum
{
	LGUpdateOrderBeforeMovement,
	LGUpdateOrderMovement,
	LGUpdateOrderBeforeRender,
	LGUpdateOrderRender
};

@class LGScene, LGEntity;

@interface LGSystem : NSObject

@property (nonatomic, weak) LGScene *scene;
@property (nonatomic, retain) NSMutableArray *entities;
@property (nonatomic, assign) int updateOrder;

- (BOOL)acceptsEntity:(LGEntity *)entity;
- (void)addEntity:(LGEntity *)entity;

- (void)touchDown:(NSSet *)touches allTouches:(NSDictionary *)allTouches;
- (void)touchUp:(NSSet *)touches allTouches:(NSDictionary *)allTouches;
- (void)update;
- (void)initialize;

- (id)initWithScene:(LGScene *)s;

@end