//
//  LGSprite.m
//  Engine
//
//  Created by Luke Godfrey on 3/4/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGSprite.h"

@implementation LGSprite

@synthesize spriteSheet, spriteView, imageView, states, currentState, state;
@synthesize frameSize, offset, position, animationCounter, animationDelay, animationComplete;

#pragma mark Class Methods

+ (NSMutableDictionary *)cachedTextures
{
	static NSMutableDictionary *dictionary = nil;
	
	if(dictionary == nil)
	{
		dictionary = [NSMutableDictionary dictionary];
	}
	
	return dictionary;
}

+ (LGSprite *)copyOfSprite:(LGSprite *)sprite
{
	LGSprite *copy = [[LGSprite alloc] init];
	[copy setFrameSize:[sprite frameSize]];
	[copy setSpriteSheet:[sprite spriteSheet]];
	[copy setStates:[sprite states]];
	return copy;
}

#pragma mark LGSprite Methods

- (void)incrementAnimationCounter
{
	if(++animationCounter > animationDelay)
	{
		animationCounter = 0;
	}
}

- (void)nextPosition
{
	[self setPosition:++position];
}

- (void)addState:(LGSpriteState *)s forKey:(NSString *)k
{
	[states setObject:s forKey:k];
}

- (void)setSpriteSheetName:(NSString *)s
{
	if([[LGSprite cachedTextures] objectForKey:s] == nil)
	{
		[[LGSprite cachedTextures] setObject:[UIImage imageNamed:s] forKey:s];
	}
	
	[self setSpriteSheet:[[LGSprite cachedTextures] objectForKey:s]];
}

#pragma mark LGSprite Overrides

- (void)setPosition:(int)p
{
	position = p;
	
	if([state isAnimated])
	{
		if(position > [state end] || position < [state start])
		{
			position = [state loops] ? [state start] : [state end];
			animationComplete = YES;
		}
	}
	
	// Subtract 1 from position because position is 1-indexed; position 0 is empty
	int sheetWidth = (int) (spriteSheet.size.width / frameSize.width);
	int row = (position - 1) / sheetWidth;
	int col = (position - 1) % sheetWidth;
	
	CGRect frame = [imageView frame];
	frame.origin.x = -col * frameSize.width;
	frame.origin.y = -row * frameSize.height;
	[imageView setFrame:frame];
}

- (void)setSpriteSheet:(UIImage *)s
{
	spriteSheet = s;
	[imageView setImage:spriteSheet];
}

- (void)setFrameSize:(CGSize)f
{
	frameSize = f;
	
	CGRect frame = [spriteView frame];
	frame.size.width = frameSize.width;
	frame.size.height = frameSize.height;
	[spriteView setFrame:frame];
}

- (void)setOffset:(CGPoint)o
{
	offset = o;
	
	CGRect frame = [self.view frame];
	frame.origin.x = -offset.x;
	frame.origin.y = -offset.y;
	[self.view setFrame:frame];
}

- (void)setState:(LGSpriteState *)s
{
	state = s;
	[self setPosition:[state isAnimated] ? [state start] - 1 : [state start]];
	
	// This flag only matters for animations that don't loop
	animationComplete = [state loops];
}

- (void)setCurrentState:(NSString *)key
{
	if(![currentState isEqualToString:key])
	{
		currentState = key;
		[self setState:[states objectForKey:key]];
	}
}

#pragma mark LGComponent Method Overrides

- (void)initialize
{
	[super initialize];
	
	frameSize = CGSizeZero;
	offset = CGPointZero;
	
	spriteSheet = nil;
	spriteView = [[UIView alloc] initWithFrame:CGRectZero];
	[spriteView setClipsToBounds:YES];
	
	imageView = [[UIImageView alloc] init];
	[imageView setContentMode:UIViewContentModeTopLeft];
	[[imageView layer] setMagnificationFilter:kCAFilterNearest];
	
	states = [NSMutableDictionary dictionary];
	state = [[LGSpriteState alloc] initWithPosition:0];
	
	animationCounter = 0;
	animationDelay = 5;
	animationComplete = YES;
	
	[spriteView addSubview:imageView];
	[self.view addSubview:spriteView];
}

@end

@implementation LGSpriteState

@synthesize start, end, isAnimated, loops;

- (id)initWithPosition:(int)p
{
	return [self initWithStart:p andEnd:p];
}

- (id)initWithStart:(int)s andEnd:(int)e
{
	return [self initWithStart:s andEnd:e loops:YES];
}

- (id)initWithStart:(int)s andEnd:(int)e loops:(BOOL)l
{
	self = [super init];
	
	if(self)
	{
		start = s;
		end = e;
		isAnimated = e > s;
		loops = l;
	}
	
	return self;
}

@end