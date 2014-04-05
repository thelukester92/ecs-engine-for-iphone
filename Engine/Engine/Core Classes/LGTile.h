//
//  LGTile.h
//  Engine
//
//  Created by Luke Godfrey on 4/5/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGTile : NSObject

@property (nonatomic, retain) NSString *positionString;

- (int)position;
- (id)initWithPositionString:(NSString *)p;

@end