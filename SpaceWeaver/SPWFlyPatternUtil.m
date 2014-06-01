//
//  SPWFlyPatternUtil.m
//  SpaceWeaver
//
//  Created by Ronald Lee on 6/1/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "SPWFlyPatternUtil.h"

@implementation SPWFlyPatternUtil


+(void)hoverTarget:(SKSpriteNode*)target Duration:(CGFloat)duration Loop:(int)loop completion:(void(^)(void))block {
    UIBezierPath* flyPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(target.position.x,target.position.y)
                                                           radius:10
                                                       startAngle:0 endAngle:DEGREES_TO_RADIANS(360) clockwise:YES];
    SKAction* flyAction = [SKAction followPath:flyPath.CGPath asOffset:NO orientToPath:NO duration:duration];
    
    SKAction* repeatAction = [SKAction repeatAction:flyAction count:loop];
    
    [target runAction:repeatAction completion:block];
}

+(void)hoverInfinitySymbolTarget:(SKSpriteNode*)target Radius:(CGFloat)radius Duration:(CGFloat)duration Loop:(int)loop completion:(void(^)(void))block {
    CGFloat x1 = target.position.x-radius+(target.size.width/2);
    CGFloat x2 = x1 + 2*radius;
    
    UIBezierPath* flyPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(x1,target.position.y)
                                                           radius:radius
                                                       startAngle:0 endAngle:DEGREES_TO_RADIANS(360) clockwise:YES];
    SKAction* flyAction = [SKAction followPath:flyPath.CGPath asOffset:NO orientToPath:NO duration:duration];
    
    flyPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(x2,target.position.y)
                                             radius:radius
                                         startAngle:DEGREES_TO_RADIANS(180) endAngle:DEGREES_TO_RADIANS(-180) clockwise:NO];
    SKAction* flyAction2 = [SKAction followPath:flyPath.CGPath asOffset:NO orientToPath:NO duration:duration];
    
    SKAction* sequence=[SKAction sequence:@[flyAction,flyAction2]];
    
    SKAction* repeatAction = [SKAction repeatAction:sequence count:loop];
    
    [target runAction:repeatAction completion:block];
}

@end
