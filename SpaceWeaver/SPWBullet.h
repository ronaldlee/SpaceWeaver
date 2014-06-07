//
//  SPWBullet.h
//  SpaceWeaver
//
//  Created by Ronald Lee on 6/5/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SPWBullet : SKSpriteNode<SPWGameObject>

@property (nonatomic) SKSpriteNode * bullet;

- (id)initWithScale:(CGFloat)scale;


-(void)setBorderBounds:(CGRect)p_bounds;
@end
