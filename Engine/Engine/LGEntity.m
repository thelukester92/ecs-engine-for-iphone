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

- (void)addComponent:(LGComponent *)component
{
	NSString *type = [[component class] type];
	NSMutableArray *array = [components objectForKey:type];
	
	if(array == nil)
	{
		array = [NSMutableArray array];
		[components setObject:array forKey:type];
	}
	
	[array addObject:component];
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