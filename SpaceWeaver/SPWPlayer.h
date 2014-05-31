//
//  SPWPlayer.h
//  SpaceWeaver
//
//  Created by Ronald Lee on 5/31/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SPWPlayer : SKSpriteNode

@property (nonatomic) SKSpriteNode * playerA;
@property (nonatomic) SKSpriteNode * playerB;
@property (nonatomic) SKSpriteNode * playerC;
@property (nonatomic) SKSpriteNode * playerD;

- (id)initWithScale:(CGFloat)scale;

-(void)moveUp;
-(void)moveDown;
-(void)moveLeft;
-(void)moveRight;

-(void)setBorderTopY:(float)player_top_border_y LeftX:(float)player_left_border_x
             BottomY:(float)player_bottom_border_y RightX:(float)player_right_border_x;

@end
