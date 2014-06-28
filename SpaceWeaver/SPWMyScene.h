//
//  SPWMyScene.h
//  SpaceWeaver
//

//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SPWMyScene : SKScene<SKPhysicsContactDelegate>

@property (nonatomic) SKEmitterNode * space_bg;
@property (nonatomic) SPWFireButton * fire_button;
@end
