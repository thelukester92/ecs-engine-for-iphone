//
//  LGQuadtree.m
//  Engine
//
//  Created by Luke Godfrey on 4/5/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGQuadtree.h"
#import "LGEntity.h"
#import "LGTransform.h"
#import "LGCollider.h"

@implementation LGQuadtree

@synthesize entities, children, bounds, minSize, width, height, level, maxEntities, maxLevels;

- (NSArray *)entitiesNearRect:(CGRect)rect
{
	if(children == nil)
	{
		return entities;
	}
	else
	{
		NSMutableSet *set = [NSMutableSet set];
		
		if(rect.origin.y < height)
		{
			if(rect.origin.x < width)
			{
				[set addObjectsFromArray:[[children objectAtIndex:0] entitiesNearRect:rect]];
			}
			
			if(rect.origin.x + rect.size.width > width)
			{
				[set addObjectsFromArray:[[children objectAtIndex:1] entitiesNearRect:rect]];
			}
		}
		
		if(rect.origin.y + rect.size.height > height)
		{
			if(rect.origin.x < width)
			{
				[set addObjectsFromArray:[[children objectAtIndex:2] entitiesNearRect:rect]];
			}
			
			if(rect.origin.x + rect.size.width > width)
			{
				[set addObjectsFromArray:[[children objectAtIndex:3] entitiesNearRect:rect]];
			}
		}
		
		return [set allObjects];
	}
}

- (NSArray *)entitiesNearEntity:(LGEntity *)entity
{
	LGTransform *transform = [entity componentOfType:[LGTransform type]];
	LGCollider *collider = [entity componentOfType:[LGCollider type]];
	
	if(transform == nil || collider == nil)
	{
		return nil;
	}
	
	return [self entitiesNearRect:CGRectMake([transform position].x, [transform position].y, [collider size].width, [collider size].height)];
}

- (void)addEntity:(LGEntity *)entity withRect:(CGRect)rect
{
	if(children == nil && [entities count] >= maxEntities && level < maxLevels && width > minSize.width && height > minSize.height)
	{
		[self split];
	}
	
	if(children == nil)
	{
		[entities addObject:entity];
	}
	else
	{
		if(rect.origin.y < bounds.origin.y + height)
		{
			if(rect.origin.x < bounds.origin.x + width)
			{
				[[children objectAtIndex:0] addEntity:entity withRect:rect];
			}
			
			if(rect.origin.x + rect.size.width > bounds.origin.x + width)
			{
				[[children objectAtIndex:1] addEntity:entity withRect:rect];
			}
		}
		
		if(rect.origin.y + rect.size.height > bounds.origin.y + height)
		{
			if(rect.origin.x < bounds.origin.x + width)
			{
				[[children objectAtIndex:2] addEntity:entity withRect:rect];
			}
			
			if(rect.origin.x + rect.size.width > bounds.origin.x + width)
			{
				[[children objectAtIndex:3] addEntity:entity withRect:rect];
			}
		}
	}
}

- (void)addEntity:(LGEntity *)entity
{
	LGTransform *transform = [entity componentOfType:[LGTransform type]];
	LGCollider *collider = [entity componentOfType:[LGCollider type]];
	
	if(transform == nil || collider == nil)
	{
		return;
	}
	
	[self addEntity:entity withRect:CGRectMake([transform position].x, [transform position].y, [collider size].width, [collider size].height)];
}

- (void)split
{
	if(children != nil)
	{
		return;
	}
	
	// Split into four nodes
	
	children = [NSArray arrayWithObjects:
		[[LGQuadtree alloc] initWithBounds:CGRectMake(bounds.origin.x, bounds.origin.y, width, height) andLevel:(level + 1)],
		[[LGQuadtree alloc] initWithBounds:CGRectMake(bounds.origin.x + width, bounds.origin.y, width, height) andLevel:(level + 1)],
		[[LGQuadtree alloc] initWithBounds:CGRectMake(bounds.origin.x, bounds.origin.y + height, width, height) andLevel:(level + 1)],
		[[LGQuadtree alloc] initWithBounds:CGRectMake(bounds.origin.x + width, bounds.origin.y + height, width, height) andLevel:(level + 1)],
	nil];
	
	// Distribute entities
	
	for(LGEntity *entity in entities)
	{
		[self addEntity:entity];
	}
	
	entities = nil;
}

- (id)initWithBounds:(CGRect)b andLevel:(int)l
{
	self = [super init];
	
	if(self)
	{
		entities		= [NSMutableArray array];
		children		= nil;
		bounds			= b;
		minSize			= CGSizeMake(50, 50);
		width			= bounds.size.width / 2;
		height			= bounds.size.height / 2;
		level			= l;
		maxLevels		= 5;
		maxEntities		= 10;
	}
	
	return self;
}

- (id)initWithBounds:(CGRect)b
{
	return [self initWithBounds:b andLevel:0];
}

#pragma mark Overrides

- (void)setBounds:(CGRect)b
{
	bounds	= b;
	width	= bounds.size.width / 2;
	height	= bounds.size.height / 2;
}

- (id)init
{
	return [self initWithBounds:CGRectZero andLevel:0];
}

@end