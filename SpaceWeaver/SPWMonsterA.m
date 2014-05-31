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

- (id)initWithScale:(CGFloat)f_scale {
    self = [super init];
    if (self) {
        // Initialize self.
        scale = f_scale;
        
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

-(void)animateFly {
    CGFloat duration = 0.2;
    
    //hand 1
    SKAction *mh1_act_up = [SKAction moveToY:PIXEL_WIDTHHEIGHT*scale duration:duration];
    
    SKAction *mh1_act_down = [SKAction moveToY:0 duration:duration];
    
    SKAction* sequence=[SKAction sequence:@[mh1_act_up,mh1_act_down]];
    
    [m_hand_1 runAction:[SKAction repeatActionForever:sequence]];
    
    //hand 2
    SKAction *mh2_act_up = [SKAction moveToY:PIXEL_WIDTHHEIGHT*scale duration:duration];
    
    SKAction *mh2_act_down = [SKAction moveToY:0 duration:duration];
    
    sequence=[SKAction sequence:@[mh1_act_up,mh2_act_down]];
    
    [m_hand_2 runAction:[SKAction repeatActionForever:sequence]];
    
    //hand 3
    SKAction *mh3_act_down = [SKAction moveToY:max_height-PIXEL_WIDTHHEIGHT*scale*2 duration:duration];
    
    SKAction *mh3_act_up = [SKAction moveToY:max_height-PIXEL_WIDTHHEIGHT*scale duration:duration];
    
    sequence=[SKAction sequence:@[mh3_act_down,mh3_act_up]];
    
    [m_hand_3 runAction:[SKAction repeatActionForever:sequence]];
    
    //hand 4
    SKAction *mh4_act_down = [SKAction moveToY:max_height-PIXEL_WIDTHHEIGHT*scale*2 duration:duration];
    
    SKAction *mh4_act_up = [SKAction moveToY:max_height-PIXEL_WIDTHHEIGHT*scale duration:duration];
    
    sequence=[SKAction sequence:@[mh4_act_down,mh4_act_up]];
    
    [m_hand_4 runAction:[SKAction repeatActionForever:sequence]];
}

@end
