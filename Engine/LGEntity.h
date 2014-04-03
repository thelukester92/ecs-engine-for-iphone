//
//  Entity.h
//  Engine
//
//  Created by Luke Godfrey on 2/18/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import <Foundation/Foundation.h>

@class LGComponent;

@interface LGEntity : NSObject

@property (nonatomic, retain) NSMutableDictionary *components;

- (void)addComponent:(LGComponent *)component;
- (id)componentOfType:(Class)c;

- (BOOL)hasComponentOfType:(Class)c;
- (BOOL)hasComponentsOfType:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;

@end