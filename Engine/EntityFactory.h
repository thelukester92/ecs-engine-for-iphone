//
//  EntityFactory.h
//  Engine
//
//  Created by Luke Godfrey on 3/3/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LGEntity;

@interface EntityFactory : NSObject

+ (LGEntity *)playerEntity;
+ (LGEntity *)floorEntity:(BOOL)circ;

@end