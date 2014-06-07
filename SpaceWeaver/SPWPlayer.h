//
//  SPWPlayer.h
//  SpaceWeaver
//
//  Created by Ronald Lee on 5/31/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SPWPlayer : SKSpriteNode<SPWGameObject>

@property (nonatomic) SKSpriteNode * playerA;
@property (nonatomic) SKSpriteNode * playerB;
@property (nonatomic) SKSpriteNode * playerC;
@property (nonatomic) SKSpriteNode * playerD;

- (id)initWithScale:(CGFloat)scale;

-(void)moveUp;
-(void)moveDown;
-(void)moveLeft;
-(void)moveRight;

-(void)setBorderBounds:(CGRect)p_bounds;

@end
