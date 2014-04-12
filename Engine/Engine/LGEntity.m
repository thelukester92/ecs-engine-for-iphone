//
//  Entity.m
//  Engine
//
//  Created by Luke Godfrey on 2/18/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "LGEntity.h"
#import "LGComponent.h"

@implementation LGEntity

@synthesize components;

#pragma mark Private Methods

- (NSMutableArray *)arrayForComponentType:(NSString *)type
{
	if([components objectForKey:type] == nil)
	{
		[components setObject:[NSMutableArray array] forKey:type];
	}
	
	return [components objectForKey:type];
}

#pragma mark Public Methods

- (void)addComponent:(LGComponent *)component
{
	[[self arrayForComponentType:[[component class] type]] addObject:component];
}

- (NSArray *)componentsOfType:(NSString *)type
{
	return [components objectForKey:type];
}

- (id)componentOfType:(NSString *)type
{
	return [[components objectForKey:type] firstObject];
}

- (BOOL)hasComponentOfType:(NSString *)type
{
	return [self componentsOfType:type] != nil;
}

- (BOOL)hasComponentsOfType:(NSString *)firstObject, ...
{
	if(![self hasComponentOfType:firstObject])
		return NO;
	
	id obj;
	va_list args;
	va_start(args, firstObject);
	
	while((obj = va_arg(args, id)))
	{
		if(![self hasComponentOfType:obj])
			return NO;
	}
	
	return YES;
}

#pragma mark Initializer

- (id)init
{
	self = [super init];
	
	if(self)
		components = [NSMutableDictionary dictionary];
	
	return self;
}

@end