//
//  LGSpatialGrid.m
//  Engine
//
//  Created by Luke Godfrey on 4/6/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGSpatialGrid.h"
#import "LGEntity.h"
#import "LGTransform.h"
#import "LGCollider.h"

@implementation LGSpatialGrid

@synthesize grid, cellSize, rowHash;

#pragma mark Private Methods

- (NSNumber *)keyForRow:(int)row andCol:(int)col
{
	return [NSNumber numberWithInt:row * rowHash + col];
}

- (void)addEntity:(LGEntity *)entity atRow:(int)row andCol:(int)col
{
	NSNumber *key = [self keyForRow:row andCol:col];
	
	NSMutableArray *cell = [grid objectForKey:key];
	
	if(cell == nil)
	{
		cell = [NSMutableArray array];
		[grid setObject:cell forKey:key];
	}
	
	[cell addObject:entity];
}

#pragma mark Public Methods

- (NSArray *)entitiesNearEntity:(LGEntity *)entity
{
	LGTransform *transform	= [entity componentOfType:[LGTransform type]];
	LGCollider *collider	= [entity componentOfType:[LGCollider type]];
	
	if(transform == nil || collider == nil)
	{
		return nil;
	}
	
	NSMutableSet *set = [NSMutableSet set];
	
	int fromY	= [self gridRowAtY:[transform position].y];
	int toY		= [self gridRowAtY:[transform position].y + [collider size].height];
	int fromX	= [self gridColAtX:[transform position].x];
	int toX		= [self gridColAtX:[transform position].x + [collider size].width];
	
	for(int i = fromY; i <= toY; i++)
	{
		for(int j = fromX; j <= toX; j++)
		{
			NSArray *cell = [grid objectForKey:[self keyForRow:i andCol:j]];
			if(cell != nil)
			{
				[set addObjectsFromArray:cell];
			}
		}
	}
	
	return [set allObjects];
}

- (int)gridRowAtY:(double)y
{
	return (int) floor(y / cellSize.height);
}

- (int)gridColAtX:(double)x
{
	return (int) floor(x / cellSize.width);
}

- (void)addEntity:(LGEntity *)entity
{
	LGTransform *transform	= [entity componentOfType:[LGTransform type]];
	LGCollider *collider	= [entity componentOfType:[LGCollider type]];
	
	if(transform == nil || collider == nil)
	{
		return;
	}
	
	int fromY	= [self gridRowAtY:[transform position].y];
	int toY		= [self gridRowAtY:[transform position].y + [collider size].height];
	int fromX	= [self gridColAtX:[transform position].x];
	int toX		= [self gridColAtX:[transform position].x + [collider size].width];
	
	for(int i = fromY; i <= toY; i++)
	{
		for(int j = fromX; j <= toX; j++)
		{
			[self addEntity:entity atRow:i andCol:j];
		}
	}
}

- (id)initWithSize:(CGSize)s andRowHash:(int)c
{
	self = [super init];
	
	if(self)
	{
		grid		= [NSMutableDictionary dictionary];
		cellSize	= s;
		rowHash		= c;
	}
	
	return self;
}

- (id)initWithSize:(CGSize)s
{
	return [self initWithSize:s andRowHash:1000];
}

- (id)init
{
	return [self initWithSize:CGSizeMake(50, 50)];
}

@end