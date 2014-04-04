//
//  LGRender.h
//  Engine
//
//  Created by Luke Godfrey on 2/19/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "LGComponent.h"

enum
{
	LGRenderLayerBackground,
	LGRenderLayerMainLayer,
	LGRenderLayerForeground
};

@interface LGRender : LGComponent

@property (nonatomic, retain) UIView *view;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint offset;
@property (nonatomic, assign) BOOL visible;
@property (nonatomic, assign) int layer;

- (void)addSubRender:(LGRender *)render;

@end