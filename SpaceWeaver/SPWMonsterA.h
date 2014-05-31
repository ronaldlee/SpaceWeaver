//
//  SPWMonsterA.h
//  SpaceWeaver
//
//  Created by Ronald Lee on 5/31/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SPWMonsterA : SKSpriteNode

@property (nonatomic) SKSpriteNode * m_body_1;
@property (nonatomic) SKSpriteNode * m_body_2;
@property (nonatomic) SKSpriteNode * m_body_3;
@property (nonatomic) SKSpriteNode * m_body_4;
@property (nonatomic) SKSpriteNode * m_body_5;
@property (nonatomic) SKSpriteNode * m_body_6;
@property (nonatomic) SKSpriteNode * m_body_7;
@property (nonatomic) SKSpriteNode * m_body_8;
@property (nonatomic) SKSpriteNode * m_eye;

@property (nonatomic) SKSpriteNode * m_hand_1;
@property (nonatomic) SKSpriteNode * m_hand_2;
@property (nonatomic) SKSpriteNode * m_hand_3;
@property (nonatomic) SKSpriteNode * m_hand_4;

- (id)initWithScale:(CGFloat)scale;

-(void)setBorderTopY:(float)player_top_border_y LeftX:(float)player_left_border_x
             BottomY:(float)player_bottom_border_y RightX:(float)player_right_border_x;

-(void)animateFly;

@end
