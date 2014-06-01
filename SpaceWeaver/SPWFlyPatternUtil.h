//
//  SPWFlyPatternUtil.h
//  SpaceWeaver
//
//  Created by Ronald Lee on 6/1/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface SPWFlyPatternUtil : NSObject

+(void)hoverTarget:(SKSpriteNode*)target Duration:(CGFloat)duration Loop:(int)loop completion:(void(^)(void))block;

+(void)hoverInfinitySymbolTarget:(SKSpriteNode*)target Radius:(CGFloat)radius Duration:(CGFloat)duration Loop:(int)loop completion:(void(^)(void))block;

@end
