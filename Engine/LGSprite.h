//
//  LGSprite.h
//  Engine
//
//  Created by Luke Godfrey on 3/4/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "LGRender.h"

@class LGSpriteState;

@interface LGSprite : LGRender

+ (NSMutableDictionary *)cachedTextures;
+ (LGSprite *)copyOfSprite:(LGSprite *)sprite;

@property (nonatomic, retain) UIImage *spriteSheet;
@property (nonatomic, retain) UIView *spriteView;		// Subview of self.view
@property (nonatomic, retain) UIImageView *imageView;	// Subview of spriteView

@property (nonatomic, retain) NSMutableDictionary *states;
@property (nonatomic, retain) NSString *currentState;
@property (nonatomic, retain) LGSpriteState *state;

@property (nonatomic, assign) int position, animationCounter, animationDelay;
@property (nonatomic, assign) BOOL animationComplete;

- (void)incrementAnimationCounter;
- (void)nextPosition;
- (void)addState:(LGSpriteState *)s forKey:(NSString *)k;
- (void)setSpriteSheetName:(NSString *)s;

@end

@interface LGSpriteState : NSObject

@property (nonatomic, assign) int start, end;
@property (nonatomic, assign) BOOL isAnimated, loops;

- (id)initWithPosition:(int)p;
- (id)initWithStart:(int)s andEnd:(int)e;
- (id)initWithStart:(int)s andEnd:(int)e loops:(BOOL)l;

@end