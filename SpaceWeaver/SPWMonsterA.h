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
//@property (nonatomic) SKEmitterNode * m_eye;

@property (nonatomic) SKSpriteNode * m_hand_1;
@property (nonatomic) SKSpriteNode * m_hand_2;
@property (nonatomic) SKSpriteNode * m_hand_3;
@property (nonatomic) SKSpriteNode * m_hand_4;

- (id)initWithScale:(CGFloat)scale StartX:(CGFloat)s_x StartY:(CGFloat)s_y MoveSpeed:(CGFloat)mv_speed;

-(void)setBorderBounds:(CGRect)bounds;

-(void)animateFly;

-(void)walkLeft;

-(void)walkRight;

-(void)walkTop;

-(void)walkBottom;

-(void)flyAndLandLeftAtY:(CGFloat)land_y Duration:(CGFloat)duration;
-(void)flyAndLandRightAtY:(CGFloat)land_y Duration:(CGFloat)duration;

-(void)flyAndLandTopAtX:(CGFloat)land_x Duration:(CGFloat)duration;
-(void)flyAndLandBottomAtX:(CGFloat)land_x Duration:(CGFloat)duration;

-(void)hover:(CGFloat)duration Loop:(int)loop completion:(void(^)(void))block;

-(void)hoverInfinitySymbol:(CGFloat)duration Loop:(int)loop completion:(void(^)(void))block;

@end
