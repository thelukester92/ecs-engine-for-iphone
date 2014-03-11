//
//  LGRender.h
//  Engine
//
//  Created by Luke Godfrey on 2/19/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGComponent.h"

@interface LGRender : LGComponent

@property (nonatomic, retain) UIView *view;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) BOOL visible;

@end