//
//  LGPlayer.m
//  Engine
//
//  Created by Luke Godfrey on 3/5/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "LGPlayer.h"

@implementation LGPlayer

+ (NSString *)type
{
	static NSString *type = nil;
	
	if(type == nil)
	{
		type = NSStringFromClass([self class]);
	}
	
	return type;
}

@end