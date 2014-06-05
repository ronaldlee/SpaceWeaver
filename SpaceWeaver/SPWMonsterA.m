//
//  SPWMonsterA.m
//  SpaceWeaver
//
//  Created by Ronald Lee on 5/31/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "SPWMonsterA.h"
#import "SPWGraphic.h"
#import "SPWFlyPatternUtil.h"

@interface SPWMonsterA() {
    bool isWeaveMode;
    bool isPlayerTransforming;
    float bottom_border_y, top_border_y, left_border_x, right_border_x;
    BORDER player_current_border;
    float scale;
    
    float max_width, max_height;
    
    CGFloat fly_duration;
    
    float start_x, start_y;
    CGRect bounds;
    CGFloat move_speed;
    float scaled_pixel_width;
    float scaled_pixel_height;
}
@end

@implementation SPWMonsterA

@synthesize m_body_1;
@synthesize m_body_2;
@synthesize m_body_3;
@synthesize m_body_4;
@synthesize m_body_5;
@synthesize m_body_6;
@synthesize m_body_7;
@synthesize m_body_8;
@synthesize m_eye;

@synthesize m_hand_1;
@synthesize m_hand_2;
@synthesize m_hand_3;
@synthesize m_hand_4;

- (id)initWithScale:(CGFloat)f_scale StartX:(CGFloat)f_sx StartY:(CGFloat)f_sy MoveSpeed:(CGFloat)mv_speed{
    self = [super init];
    if (self) {
        move_speed = mv_speed;
        fly_duration = 0.2;
        
        // Initialize self.
        scale = f_scale;
        
        start_x = f_sx;
        start_y = f_sy;
        
        self.position = CGPointMake(start_x, start_y);
        
        player_current_border = BORDER_BOTTOM;
        
        scaled_pixel_width = PIXEL_WIDTHHEIGHT*scale;
        scaled_pixel_height = scaled_pixel_width;
        
        max_width = scaled_pixel_width*5;
        max_height = max_width;
        
        //body
        m_body_1 = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_pixel_width,scaled_pixel_height)];
        [self addChild:m_body_1];
        m_body_1.position = CGPointMake(scaled_pixel_width,scaled_pixel_height);
        
        m_body_2 = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_pixel_width,scaled_pixel_height)];
        [self addChild:m_body_2];
        m_body_2.position = CGPointMake(m_body_1.position.x+scaled_pixel_width,m_body_1.position.y);
        
        m_body_3 = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_pixel_width,scaled_pixel_height)];
        [self addChild:m_body_3];
        m_body_3.position = CGPointMake(m_body_2.position.x+scaled_pixel_width,m_body_1.position.y);
        
        
        m_body_4 = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_pixel_width,scaled_pixel_height)];
        [self addChild:m_body_4];
        m_body_4.position = CGPointMake(scaled_pixel_width,m_body_1.position.y+scaled_pixel_height);
        
//        NSString* burstPath = [[NSBundle mainBundle] pathForResource:@"MonsterEye" ofType:@"sks"];
//        m_eye = [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
        
        m_eye = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(scaled_pixel_width,scaled_pixel_height)];
        [self addChild:m_eye];
        m_eye.position = CGPointMake(m_body_4.position.x+scaled_pixel_width,m_body_4.position.y);
        
        m_body_5 = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_pixel_width,scaled_pixel_height)];
        [self addChild:m_body_5];
        m_body_5.position = CGPointMake(m_eye.position.x+scaled_pixel_width,m_body_4.position.y);
        
        
        m_body_6 = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_pixel_width,scaled_pixel_height)];
        [self addChild:m_body_6];
        m_body_6.position = CGPointMake(scaled_pixel_width,m_body_4.position.y+scaled_pixel_height);
        
        m_body_7 = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_pixel_width,scaled_pixel_height)];
        [self addChild:m_body_7];
        m_body_7.position = CGPointMake(m_body_6.position.x+scaled_pixel_width,m_body_6.position.y);
        
        m_body_8 = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_pixel_width,scaled_pixel_height)];
        [self addChild:m_body_8];
        m_body_8.position = CGPointMake(m_body_7.position.x+scaled_pixel_width,m_body_6.position.y);
        
        //lower hands
        m_hand_1 = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_pixel_width,scaled_pixel_height)];
        [self addChild:m_hand_1];
        m_hand_1.position = CGPointMake(0,0);
        
        m_hand_2 = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_pixel_width,scaled_pixel_height)];
        [self addChild:m_hand_2];
        m_hand_2.position = CGPointMake(m_body_3.position.x+scaled_pixel_width,0);
        
        //upper hands
        m_hand_3 = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_pixel_width,scaled_pixel_height)];
        [self addChild:m_hand_3];
        m_hand_3.position = CGPointMake(0,m_body_6.position.y+scaled_pixel_height);
        
        m_hand_4 = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_pixel_width,scaled_pixel_height)];
        [self addChild:m_hand_4];
        m_hand_4.position = CGPointMake(m_body_3.position.x+scaled_pixel_width,m_body_6.position.y+scaled_pixel_height);
        
    }
    return self;
}

-(void)setBorderBounds:(CGRect)p_bounds {
//    bounds = p_bounds;
    NSLog(@"setborderbounds p_bounds: x: %f, y: %f, width: %f, height: %f",
          p_bounds.origin.x,p_bounds.origin.y,
          p_bounds.size.width,p_bounds.size.height);
    
    bounds = CGRectMake(p_bounds.origin.x-2,//scaled_pixel_widthheight,
                        p_bounds.origin.y-2,
                        p_bounds.size.width + 4, //scaled_pixel_widthheight,
                        p_bounds.size.height+4);
    
    NSLog(@"setborderbounds bounds: x: %f, y: %f, width: %f, height: %f",
          bounds.origin.x,bounds.origin.y,
          bounds.size.width,bounds.size.height);
    
    left_border_x = bounds.origin.x;
    right_border_x = left_border_x+bounds.size.width;
    bottom_border_y = bounds.origin.y;
    top_border_y = bottom_border_y+bounds.size.height;
}

-(void) removeAllHandActions {
    [m_hand_1 removeAllActions];
    [m_hand_2 removeAllActions];
    [m_hand_3 removeAllActions];
    [m_hand_4 removeAllActions];
}

-(void)animateFly {
    [self removeAllHandActions];
    
    //hand 1
    SKAction *mh_act_up = [SKAction moveToY:PIXEL_WIDTHHEIGHT*scale duration:fly_duration];
    
    SKAction *mh_act_down = [SKAction moveToY:0 duration:fly_duration];
    
    SKAction* sequence=[SKAction sequence:@[mh_act_up,mh_act_down]];
    
    [m_hand_1 runAction:[SKAction repeatActionForever:sequence]];
    
    //hand 2
    
    sequence=[SKAction sequence:@[mh_act_up,mh_act_down]];
    
    [m_hand_2 runAction:[SKAction repeatActionForever:sequence]];
    
    //hand 3
    mh_act_down = [SKAction moveToY:max_height-PIXEL_WIDTHHEIGHT*scale*2 duration:fly_duration];
    
    mh_act_up = [SKAction moveToY:max_height-PIXEL_WIDTHHEIGHT*scale duration:fly_duration];
    
    sequence=[SKAction sequence:@[mh_act_down,mh_act_up]];
    
    [m_hand_3 runAction:[SKAction repeatActionForever:sequence]];
    
    //hand 4
    
    sequence=[SKAction sequence:@[mh_act_down,mh_act_up]];
    
    [m_hand_4 runAction:[SKAction repeatActionForever:sequence]];
}

-(void)moveAllHandsToOriginPos {
    SKAction *mh_act = [SKAction moveTo:CGPointMake(0, 0) duration:fly_duration];
    [m_hand_1 runAction:mh_act];
    
    mh_act = [SKAction moveTo:CGPointMake(max_width-PIXEL_WIDTHHEIGHT*scale, 0) duration:fly_duration];
    [m_hand_2 runAction:mh_act];
    
    mh_act = [SKAction moveTo:CGPointMake(0,max_height-PIXEL_WIDTHHEIGHT*scale) duration:fly_duration];
    [m_hand_3 runAction:mh_act];
    
    mh_act = [SKAction moveTo:CGPointMake(max_width-PIXEL_WIDTHHEIGHT*scale,max_height-PIXEL_WIDTHHEIGHT*scale) duration:fly_duration];
    [m_hand_4 runAction:mh_act];
}

-(void)walkLeft {
    [self removeAllHandActions];
    
    [self moveAllHandsToOriginPos];

    //hand 1
    SKAction *mh_act_up = [SKAction moveToY:PIXEL_WIDTHHEIGHT*scale duration:fly_duration];
    
    SKAction *mh_act_down = [SKAction moveToY:0 duration:fly_duration];
    
    SKAction* sequence=[SKAction sequence:@[mh_act_up,mh_act_down]];
    
    [m_hand_1 runAction:[SKAction repeatActionForever:sequence]];
    
    //hand 3
    mh_act_down = [SKAction moveToY:max_height-PIXEL_WIDTHHEIGHT*scale*2 duration:fly_duration];
    
    mh_act_up = [SKAction moveToY:max_height-PIXEL_WIDTHHEIGHT*scale duration:fly_duration];
    
    sequence=[SKAction sequence:@[mh_act_down,mh_act_up]];
    
    [m_hand_3 runAction:[SKAction repeatActionForever:sequence]];
    
    //actually moving
    CGFloat player_x = self.position.x;
    CGFloat player_y = self.position.y;
    BOOL isMoveUp = true;
    
    if (isMoveUp) {
        CGFloat distance = top_border_y-player_y;
        CGFloat duration = distance/move_speed;
        
        SKAction *movePlayer = [SKAction moveToY:top_border_y duration:duration];
        
        [self runAction:movePlayer completion:^{
        }];
    }
    else {
        
        CGFloat distance = player_y-bottom_border_y;
        CGFloat duration = distance/move_speed;
        
        SKAction *movePlayer = [SKAction moveToY:bottom_border_y duration:duration];
        
        [self runAction:movePlayer completion:^{
        }];
    }

}

-(void)walkRight {
    [self removeAllHandActions];
    
    [self moveAllHandsToOriginPos];
    
    //hand 2
    SKAction *mh_act_up = [SKAction moveToY:PIXEL_WIDTHHEIGHT*scale duration:fly_duration];
    
    SKAction *mh_act_down = [SKAction moveToY:0 duration:fly_duration];
    
    SKAction *sequence=[SKAction sequence:@[mh_act_up,mh_act_down]];
    
    [m_hand_2 runAction:[SKAction repeatActionForever:sequence]];
    
    //hand 4
    mh_act_down = [SKAction moveToY:max_height-PIXEL_WIDTHHEIGHT*scale*2 duration:fly_duration];
    
    mh_act_up = [SKAction moveToY:max_height-PIXEL_WIDTHHEIGHT*scale duration:fly_duration];
    
    sequence=[SKAction sequence:@[mh_act_down,mh_act_up]];
    
    [m_hand_4 runAction:[SKAction repeatActionForever:sequence]];
    
    //actually moving
    CGFloat player_x = self.position.x;
    CGFloat player_y = self.position.y;
    BOOL isMoveUp = true;
    
    if (isMoveUp) {
        CGFloat distance = top_border_y-player_y;
        CGFloat duration = distance/move_speed;
        
        SKAction *movePlayer = [SKAction moveToY:top_border_y duration:duration];
        
        [self runAction:movePlayer completion:^{
        }];
    }
    else {
        
        CGFloat distance = player_y-bottom_border_y;
        CGFloat duration = distance/move_speed;
        
        SKAction *movePlayer = [SKAction moveToY:bottom_border_y duration:duration];
        
        [self runAction:movePlayer completion:^{
        }];
    }

}

-(void)walkTop {
    [self removeAllHandActions];
    
    [self moveAllHandsToOriginPos];
    
    SKAction *mh_act_right = [SKAction moveToX:PIXEL_WIDTHHEIGHT*scale duration:fly_duration];
    
    SKAction *mh_act_left = [SKAction moveToX:0 duration:fly_duration];
    
    SKAction* sequence=[SKAction sequence:@[mh_act_right,mh_act_left]];
    
    [m_hand_3 runAction:[SKAction repeatActionForever:sequence]];
    
    //hand 4
    mh_act_left = [SKAction moveToX:max_width-PIXEL_WIDTHHEIGHT*scale*2 duration:fly_duration];
    
    mh_act_right = [SKAction moveToX:max_width-PIXEL_WIDTHHEIGHT*scale duration:fly_duration];
    
    sequence=[SKAction sequence:@[mh_act_left,mh_act_right]];
    
    [m_hand_4 runAction:[SKAction repeatActionForever:sequence]];
    
    //actually moving
    CGFloat player_x = self.position.x;
    CGFloat player_y = self.position.y;
    BOOL isMoveLeft = true;
    
    if (isMoveLeft) {
        CGFloat distance = player_x-left_border_x;
        CGFloat duration = distance/move_speed;
        
        SKAction *movePlayer = [SKAction moveToX:left_border_x duration:duration];
        
        [self runAction:movePlayer completion:^{
        }];
    }
    else {
        
        CGFloat distance = player_x-right_border_x;
        CGFloat duration = distance/move_speed;
        
        SKAction *movePlayer = [SKAction moveToX:right_border_x duration:duration];
        
        [self runAction:movePlayer completion:^{
        }];
    }

}

-(void)walkBottom {
    [self removeAllHandActions];
    
    [self moveAllHandsToOriginPos];
    
    SKAction *mh_act_right = [SKAction moveToX:PIXEL_WIDTHHEIGHT*scale duration:fly_duration];
    
    SKAction *mh_act_left = [SKAction moveToX:0 duration:fly_duration];
    
    SKAction* sequence=[SKAction sequence:@[mh_act_right,mh_act_left]];
    
    [m_hand_1 runAction:[SKAction repeatActionForever:sequence]];
    
    
    mh_act_left = [SKAction moveToX:max_width-PIXEL_WIDTHHEIGHT*scale*2 duration:fly_duration];
    
    mh_act_right = [SKAction moveToX:max_width-PIXEL_WIDTHHEIGHT*scale duration:fly_duration];
    
    sequence=[SKAction sequence:@[mh_act_left,mh_act_right]];
    
    [m_hand_2 runAction:[SKAction repeatActionForever:sequence]];
    
    //actually moving
    CGFloat player_x = self.position.x;
    CGFloat player_y = self.position.y;
    BOOL isMoveLeft = true;
    
    if (isMoveLeft) {
        CGFloat distance = player_x-left_border_x;
        CGFloat duration = distance/move_speed;
        
        SKAction *movePlayer = [SKAction moveToX:left_border_x duration:duration];
        
        [self runAction:movePlayer completion:^{
        }];
    }
    else {
        
        CGFloat distance = player_x-right_border_x;
        CGFloat duration = distance/move_speed;
        
        SKAction *movePlayer = [SKAction moveToX:right_border_x duration:duration];
        
        [self runAction:movePlayer completion:^{
        }];
    }
}

-(void)flyAndLandLeftAtY:(CGFloat)land_y Duration:(CGFloat)duration {
    land_y += bottom_border_y;
    
//    CGPoint randP1 = [SPWGraphic getRandomPoint:bounds];
//    CGPoint randP2 = [SPWGraphic getRandomPoint:bounds];
    
    //startx: 100, y: 200+BUD_HEIGHT = 300
    //p1: {306, 269}; p2: {219, 162} => fly to right and turn and land on left
    
//    NSLog(@"fly left: p1: %@; p2: %@", NSStringFromCGPoint(randP1), NSStringFromCGPoint(randP2));
    
    UIBezierPath* flyPath = [UIBezierPath bezierPath];
    [flyPath moveToPoint:CGPointMake(self.position.x, self.position.y)];
    [flyPath addCurveToPoint:CGPointMake(left_border_x, land_y)
//               controlPoint1:CGPointMake(150, start_y+50)
//               controlPoint2:CGPointMake(150, start_y-100)];
//               controlPoint1:randP1
//               controlPoint2:randP2];
               controlPoint1:CGPointMake((self.position.x-left_border_x)/2, land_y+50)
               controlPoint2:CGPointMake((self.position.x-left_border_x)/2, land_y-50)];
    
    SKAction* flyAction = [SKAction followPath:flyPath.CGPath asOffset:NO orientToPath:NO duration:duration];
//    SKAction *forever = [SKAction repeatActionForever:flyAction];
    [self runAction:flyAction completion:^(void) {
        
        SKAction *movePlayer = [SKAction moveToX:left_border_x duration:0.0];
        [self runAction:movePlayer completion:^{
            [self walkLeft];
        }];
    }];
}

-(void)flyAndLandRightAtY:(CGFloat)land_y Duration:(CGFloat)duration {
    land_y += bottom_border_y;
    
    NSLog(@"fly and land right x: %f",right_border_x);
    
    UIBezierPath* flyPath = [UIBezierPath bezierPath];
    
    NSLog(@"landed right starting x: self x: %f",self.position.x);
    
    [flyPath moveToPoint:CGPointMake(self.position.x, self.position.y)];
    [flyPath addCurveToPoint:CGPointMake(right_border_x, land_y)
               controlPoint1:CGPointMake(self.position.x+(self.position.x-left_border_x)/2, land_y+50)
               controlPoint2:CGPointMake(self.position.x+(self.position.x-left_border_x)/2, land_y-50)];

    
    SKAction* flyAction = [SKAction followPath:flyPath.CGPath asOffset:NO orientToPath:NO duration:duration];
    //    SKAction *forever = [SKAction repeatActionForever:flyAction];
    
    
    [self runAction:flyAction completion:^(void) {
        NSLog(@"landed right start walking!: self x: %f",self.position.x);
//        self.position.x = right_border_x;
        
        SKAction *movePlayer = [SKAction moveToX:right_border_x duration:0.0];
        [self runAction:movePlayer completion:^{
            [self walkRight];
        }];
    }];
}

-(void)flyAndLandTopAtX:(CGFloat)land_x Duration:(CGFloat)duration {
    land_x += left_border_x;
    
    UIBezierPath* flyPath = [UIBezierPath bezierPath];
    [flyPath moveToPoint:CGPointMake(self.position.x, self.position.y)];
    [flyPath addCurveToPoint:CGPointMake(land_x,top_border_y)
               controlPoint1:CGPointMake(land_x+50, self.position.y+(top_border_y-self.position.y)/2)
               controlPoint2:CGPointMake(land_x-50, self.position.y+(top_border_y-self.position.y)/2)];
    
    
    SKAction* flyAction = [SKAction followPath:flyPath.CGPath asOffset:NO orientToPath:NO duration:duration];
    //    SKAction *forever = [SKAction repeatActionForever:flyAction];
    [self runAction:flyAction completion:^(void) {
        NSLog(@"landed right start walking!");
        
        SKAction *movePlayer = [SKAction moveToY:top_border_y duration:0.0];
        [self runAction:movePlayer completion:^{
            [self walkTop];
        }];
    }];
}

-(void)flyAndLandBottomAtX:(CGFloat)land_x Duration:(CGFloat)duration {
    land_x += left_border_x;
    
    UIBezierPath* flyPath = [UIBezierPath bezierPath];
    [flyPath moveToPoint:CGPointMake(self.position.x, self.position.y)];
    [flyPath addCurveToPoint:CGPointMake(land_x,bottom_border_y)
               controlPoint1:CGPointMake(land_x+50, (self.position.y-bottom_border_y)/2)
               controlPoint2:CGPointMake(land_x-50, (self.position.y-bottom_border_y)/2)];
    
    
    SKAction* flyAction = [SKAction followPath:flyPath.CGPath asOffset:NO orientToPath:NO duration:duration];
    //    SKAction *forever = [SKAction repeatActionForever:flyAction];
    [self runAction:flyAction completion:^(void) {
        NSLog(@"landed right start walking!");
        
        SKAction *movePlayer = [SKAction moveToY:bottom_border_y duration:0.0];
        [self runAction:movePlayer completion:^{
            [self walkBottom];
        }];
    }];
}

-(void)hover:(CGFloat)duration Loop:(int)loop completion:(void(^)(void))block {
    [SPWFlyPatternUtil hoverTarget:self Duration:duration Loop:loop completion:block];
}

-(void)hoverInfinitySymbol:(CGFloat)duration Loop:(int)loop completion:(void(^)(void))block {
    [SPWFlyPatternUtil hoverInfinitySymbolTarget:self Radius:10 Duration:duration Loop:loop completion:block];
}


@end
