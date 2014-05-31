//
//  SPWMonsterA.m
//  SpaceWeaver
//
//  Created by Ronald Lee on 5/31/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "SPWMonsterA.h"
#import "SPWGraphic.h"

@interface SPWMonsterA() {
    bool isWeaveMode;
    bool isPlayerTransforming;
    float bottom_border_y, top_border_y, left_border_x, right_border_x;
    BORDER player_current_border;
    float scale;
    
    float max_width, max_height;
    
    CGFloat fly_duration;
    
    float start_x, start_y;
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

- (id)initWithScale:(CGFloat)f_scale StartX:(CGFloat)f_sx StartY:(CGFloat)f_sy {
    self = [super init];
    if (self) {
        fly_duration = 0.2;
        
        // Initialize self.
        scale = f_scale;
        
        start_x = f_sx;
        start_y = f_sy;
        
        player_current_border = BORDER_BOTTOM;
        
        float scaled_pixel_widthheight = PIXEL_WIDTHHEIGHT*scale;
        
        max_width = scaled_pixel_widthheight*5;
        max_height = max_width;
        
        //body
        m_body_1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[SPWGraphic createBlockImage:scale]]];
        [self addChild:m_body_1];
        m_body_1.position = CGPointMake(scaled_pixel_widthheight,scaled_pixel_widthheight);
        
        m_body_2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[SPWGraphic createBlockImage:scale]]];
        [self addChild:m_body_2];
        m_body_2.position = CGPointMake(m_body_1.position.x+scaled_pixel_widthheight,m_body_1.position.y);
        
        m_body_3 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[SPWGraphic createBlockImage:scale]]];
        [self addChild:m_body_3];
        m_body_3.position = CGPointMake(m_body_2.position.x+scaled_pixel_widthheight,m_body_1.position.y);
        
        
        m_body_4 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[SPWGraphic createBlockImage:scale]]];
        [self addChild:m_body_4];
        m_body_4.position = CGPointMake(scaled_pixel_widthheight,m_body_1.position.y+scaled_pixel_widthheight);
        
        m_eye = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[SPWGraphic createRedBlockImage:scale]]];
        [self addChild:m_eye];
        m_eye.position = CGPointMake(m_body_4.position.x+scaled_pixel_widthheight,m_body_4.position.y);
        
        m_body_5 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[SPWGraphic createBlockImage:scale]]];
        [self addChild:m_body_5];
        m_body_5.position = CGPointMake(m_eye.position.x+scaled_pixel_widthheight,m_body_4.position.y);
        
        
        m_body_6 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[SPWGraphic createBlockImage:scale]]];
        [self addChild:m_body_6];
        m_body_6.position = CGPointMake(scaled_pixel_widthheight,m_body_4.position.y+scaled_pixel_widthheight);
        
        m_body_7 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[SPWGraphic createBlockImage:scale]]];
        [self addChild:m_body_7];
        m_body_7.position = CGPointMake(m_body_6.position.x+scaled_pixel_widthheight,m_body_6.position.y);
        
        m_body_8 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[SPWGraphic createBlockImage:scale]]];
        [self addChild:m_body_8];
        m_body_8.position = CGPointMake(m_body_7.position.x+scaled_pixel_widthheight,m_body_6.position.y);
        
        //lower hands
        m_hand_1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[SPWGraphic createBlockImage:scale]]];
        [self addChild:m_hand_1];
        m_hand_1.position = CGPointMake(0,0);
        
        m_hand_2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[SPWGraphic createBlockImage:scale]]];
        [self addChild:m_hand_2];
        m_hand_2.position = CGPointMake(m_body_3.position.x+scaled_pixel_widthheight,0);
        
        //upper hands
        m_hand_3 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[SPWGraphic createBlockImage:scale]]];
        [self addChild:m_hand_3];
        m_hand_3.position = CGPointMake(0,m_body_6.position.y+scaled_pixel_widthheight);
        
        m_hand_4 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[SPWGraphic createBlockImage:scale]]];
        [self addChild:m_hand_4];
        m_hand_4.position = CGPointMake(m_body_3.position.x+scaled_pixel_widthheight,m_body_6.position.y+scaled_pixel_widthheight);
        
    }
    return self;
}

-(void)setBorderTopY:(float)player_top_border_y LeftX:(float)player_left_border_x
             BottomY:(float)player_bottom_border_y RightX:(float)player_right_border_x {
    bottom_border_y = player_bottom_border_y;
    top_border_y = player_top_border_y;
    left_border_x = player_left_border_x;
    right_border_x = player_right_border_x;
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

-(void)walkLeft {
    [self removeAllHandActions];
    
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
    
    //hand 2 (move to its original position and stop)
    mh_act_down = [SKAction moveToY:0 duration:fly_duration];
    [m_hand_2 runAction:mh_act_down];
    
    //hand 4 (move to its original position and stop)
    mh_act_up = [SKAction moveToY:max_height-PIXEL_WIDTHHEIGHT*scale duration:fly_duration];
    [m_hand_4 runAction:mh_act_up];
}

-(void)walkRight {
    [self removeAllHandActions];
    
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
    
    //hand 1 (move to its original position and stop)
    mh_act_down = [SKAction moveToY:0 duration:fly_duration];
    [m_hand_1 runAction:mh_act_down];
    
    //hand 3 (move to its original position and stop)
    mh_act_up = [SKAction moveToY:max_height-PIXEL_WIDTHHEIGHT*scale duration:fly_duration];
    [m_hand_3 runAction:mh_act_up];
}

-(void)walkTop {
    [self removeAllHandActions];
    
    SKAction *mh_act_right = [SKAction moveToX:PIXEL_WIDTHHEIGHT*scale duration:fly_duration];
    
    SKAction *mh_act_left = [SKAction moveToX:0 duration:fly_duration];
    
    SKAction* sequence=[SKAction sequence:@[mh_act_right,mh_act_left]];
    
    [m_hand_3 runAction:[SKAction repeatActionForever:sequence]];
    
    //hand 4
    mh_act_left = [SKAction moveToX:max_width-PIXEL_WIDTHHEIGHT*scale*2 duration:fly_duration];
    
    mh_act_right = [SKAction moveToX:max_width-PIXEL_WIDTHHEIGHT*scale duration:fly_duration];
    
    sequence=[SKAction sequence:@[mh_act_left,mh_act_right]];
    
    [m_hand_4 runAction:[SKAction repeatActionForever:sequence]];
    
    //hand 1 (move to its original position and stop)
    mh_act_left = [SKAction moveToX:0 duration:fly_duration];
    [m_hand_1 runAction:mh_act_left];
    
    //hand 2 (move to its original position and stop)
    mh_act_right = [SKAction moveToX:max_height-PIXEL_WIDTHHEIGHT*scale duration:fly_duration];
    [m_hand_2 runAction:mh_act_right];
}

-(void)walkBottom {
    [self removeAllHandActions];
    
    SKAction *mh_act_right = [SKAction moveToX:PIXEL_WIDTHHEIGHT*scale duration:fly_duration];
    
    SKAction *mh_act_left = [SKAction moveToX:0 duration:fly_duration];
    
    SKAction* sequence=[SKAction sequence:@[mh_act_right,mh_act_left]];
    
    [m_hand_1 runAction:[SKAction repeatActionForever:sequence]];
    
    
    mh_act_left = [SKAction moveToX:max_width-PIXEL_WIDTHHEIGHT*scale*2 duration:fly_duration];
    
    mh_act_right = [SKAction moveToX:max_width-PIXEL_WIDTHHEIGHT*scale duration:fly_duration];
    
    sequence=[SKAction sequence:@[mh_act_left,mh_act_right]];
    
    [m_hand_2 runAction:[SKAction repeatActionForever:sequence]];
    
    //hand 3 (move to its original position and stop)
    mh_act_left = [SKAction moveToX:0 duration:fly_duration];
    [m_hand_3 runAction:mh_act_left];
    
    //hand 4 (move to its original position and stop)
    mh_act_right = [SKAction moveToX:max_height-PIXEL_WIDTHHEIGHT*scale duration:fly_duration];
    [m_hand_4 runAction:mh_act_right];
}

-(void)flyAndLandLeftAtY:(CGFloat)land_y Duration:(CGFloat)duration {
    CGRect bounds = CGRectMake(left_border_x, bottom_border_y, right_border_x-left_border_x, top_border_y-bottom_border_y);
    
    CGPoint randP1 = [SPWGraphic getRandomPoint:bounds];
    CGPoint randP2 = [SPWGraphic getRandomPoint:bounds];
    
    //startx: 100, y: 200+BUD_HEIGHT = 300
    //p1: {306, 269}; p2: {219, 162} => fly to right and turn and land on left
    
    NSLog(@"fly left: p1: %@; p2: %@", NSStringFromCGPoint(randP1), NSStringFromCGPoint(randP2));
    
    UIBezierPath* flyPath = [UIBezierPath bezierPath];
    [flyPath moveToPoint:CGPointMake(start_x, start_y)];
    [flyPath addCurveToPoint:CGPointMake(left_border_x, land_y)
//               controlPoint1:CGPointMake(150, start_y+50)
//               controlPoint2:CGPointMake(150, start_y-100)];
//               controlPoint1:randP1
//               controlPoint2:randP2];
               controlPoint1:CGPointMake((start_x-left_border_x)/2, land_y+50)
               controlPoint2:CGPointMake((start_x-left_border_x)/2, land_y-50)];

    

    
    SKAction* flyAction = [SKAction followPath:flyPath.CGPath asOffset:NO orientToPath:NO duration:duration];
//    SKAction *forever = [SKAction repeatActionForever:flyAction];
    [self runAction:flyAction completion:^(void) {
        [self walkLeft];
    }];
}

-(void)flyAndLandRightAtY:(CGFloat)land_y Duration:(CGFloat)duration {
    CGRect bounds = CGRectMake(left_border_x, bottom_border_y, right_border_x-left_border_x, top_border_y-bottom_border_y);
    
    CGPoint randP1 = [SPWGraphic getRandomPoint:bounds];
    CGPoint randP2 = [SPWGraphic getRandomPoint:bounds];
    
    //startx: 100, y: 200+BUD_HEIGHT = 300
    //p1: {306, 269}; p2: {219, 162} => fly to right and turn and land on left
    
    NSLog(@"fly left: p1: %@; p2: %@", NSStringFromCGPoint(randP1), NSStringFromCGPoint(randP2));
    
    UIBezierPath* flyPath = [UIBezierPath bezierPath];
    [flyPath moveToPoint:CGPointMake(start_x, start_y)];
    [flyPath addCurveToPoint:CGPointMake(right_border_x, land_y)
               controlPoint1:CGPointMake((start_x-left_border_x)/2, land_y+50)
               controlPoint2:CGPointMake((start_x-left_border_x)/2, land_y-50)];

    
    SKAction* flyAction = [SKAction followPath:flyPath.CGPath asOffset:NO orientToPath:NO duration:duration];
    //    SKAction *forever = [SKAction repeatActionForever:flyAction];
    [self runAction:flyAction completion:^(void) {
        NSLog(@"landed right start walking!");
        [self walkRight];
    }];
}



@end
