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
	[components setValue:component forKey:[component componentType]];
}

- (id)componentOfType:(NSString *)type
{
	return [components valueForKey:type];
}

- (BOOL)hasComponentOfType:(NSString *)type
{
	return [self componentOfType:type] != nil;
}

- (BOOL)hasComponentsOfType:(NSString *)firstObject, ...
{
	if(![self hasComponentOfType:firstObject])
		return NO;
	
	NSString *obj;
	va_list args;
	va_start(args, firstObject);
	
	while((obj = va_arg(args, NSString *)))
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