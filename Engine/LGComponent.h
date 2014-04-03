//
//  Component.h
//  Engine
//
//  Created by Luke Godfrey on 2/19/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import <Foundation/Foundation.h>

@interface LGComponent : NSObject

@property (nonatomic, retain) NSString *componentType;

- (void)initialize;

@end