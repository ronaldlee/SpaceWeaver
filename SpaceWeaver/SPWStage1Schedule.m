//
//  SPWStage1Schedule.m
//  SpaceWeaver
//
//  Created by Ronald Lee on 6/1/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "SPWStage1Schedule.h"
#import "SPWMonsterA.h"

@interface SPWStage1Schedule () {

}

@property (nonatomic) SPWMonsterA * monster,*monster2,*monster3,*monster4;
@property (nonatomic) SKScene* scene;
@end

@implementation SPWStage1Schedule

@synthesize scene;

- (id)initWithScale:(float)scale Bounds:(CGRect)bounds Scene:(SKScene*)sk_scene {
    self = [super init];
    if (self) {
        scene = sk_scene;
        
        //instantiates monsters
        CGFloat mv_speed = 10;
        
        self.monster = [[SPWMonsterA alloc] initWithScale:scale/2 StartX:100 StartY:200+BOTTOM_HUD_HEIGHT
                                                MoveSpeed:mv_speed];
        self.monster.position = CGPointMake(([[UIScreen mainScreen] bounds].size.width-PLAYER_WIDTH)/2,
                                            300);
        
        [self.monster setBorderBounds:bounds];
        
        //monster2
//        self.monster2 = [[SPWMonsterA alloc] initWithScale:scale/2 StartX:100 StartY:200+BOTTOM_HUD_HEIGHT
//                                                MoveSpeed:mv_speed];
//        self.monster2.position = CGPointMake(([[UIScreen mainScreen] bounds].size.width-PLAYER_WIDTH)/2,
//                                             300);
//        
//        [self.monster2 setBorderBounds:bounds];
//        
//        //monster3
//        self.monster3 = [[SPWMonsterA alloc] initWithScale:scale/2 StartX:100 StartY:200+BOTTOM_HUD_HEIGHT
//                                                 MoveSpeed:mv_speed];
//        self.monster3.position = CGPointMake(([[UIScreen mainScreen] bounds].size.width-PLAYER_WIDTH)/2,
//                                             300);
//        
//        [self.monster3 setBorderBounds:bounds];
//        
//        //monster4
//        self.monster4 = [[SPWMonsterA alloc] initWithScale:scale/2 StartX:100 StartY:200+BOTTOM_HUD_HEIGHT
//                                                 MoveSpeed:mv_speed];
//        self.monster4.position = CGPointMake(([[UIScreen mainScreen] bounds].size.width-PLAYER_WIDTH)/2,
//                                             300);
//        
//        [self.monster4 setBorderBounds:bounds];
        
        
    }
    return self;
}

-(void)start {
    SKAction *wait = [SKAction waitForDuration:1];
    SKAction *wave_1 = [SKAction performSelector:@selector(wave1) onTarget:self];
    SKAction *sequence = [SKAction sequence:@[wait,wave_1]];
    [scene runAction:sequence completion:^(void){
        NSLog(@"done sequence");
    }];
}

-(void)wave1 {
    NSLog(@"wave1");
    [scene addChild:self.monster];
    
    [self.monster animateFly];
    
    //hover continuously for 10 seconds
    [self.monster hoverInfinitySymbol:1.0 Loop:1 completion:^(void) {
        [self.monster flyAndLandRightAtY:200+BOTTOM_HUD_HEIGHT Duration:1.0];
    }];
    
    //then fly to borders
//    [self.monster flyAndLandLeftAtY:200+BOTTOM_HUD_HEIGHT Duration:1.0];
}

@end
