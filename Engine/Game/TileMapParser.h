//
//  LGTileMapParser.h
//  Engine
//
//  Created by Luke Godfrey on 4/2/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import <Foundation/Foundation.h>

@class LGTileSystem, LGTileLayer;

@interface TileMapParser : NSObject

+ (void)parsePlist:(NSString *)filename forSystem:(LGTileSystem *)system;

@end