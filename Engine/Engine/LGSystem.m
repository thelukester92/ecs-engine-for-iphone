//
//  LGSystem.m
//  Engine
//
//  Created by Luke Godfrey on 2/20/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "LGSystem.h"
#import "LGEntity.h"

@implementation LGSystem

@synthesize scene, entities, updateOrder;

- (BOOL)acceptsEntity:(LGEntity *)entity
{
	return NO;
}

- (void)addEntity:(LGEntity *)entity
{
	[entities addObject:entity];
}

- (void)touchDown:(NSSet *)touches allTouches:(NSDictionary *)allTouches {}
- (void)touchUp:(NSSet *)touches allTouches:(NSDictionary *)allTouches {}
- (void)update {}
- (void)initialize {}

- (id)initWithScene:(LGScene *)s
{
	self = [super init];
	
	if(self)
	{
		scene		= s;
		entities	= [NSMutableArray array];
		updateOrder	= LGUpdateOrderDefault;
		[self initialize];
	}
	
	return self;
}

- (id)init
{
	return [self initWithScene:nil];
}

@end