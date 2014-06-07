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
        
        self.monster = [[SPWMonsterA alloc] initWithScale:scale/2 StartX:80 StartY:300+BOTTOM_HUD_HEIGHT
                                                MoveSpeed:mv_speed];
        
        [self.monster setBorderBounds:bounds];
        
        //monster2
        self.monster2 = [[SPWMonsterA alloc] initWithScale:scale/2 StartX:130 StartY:300+BOTTOM_HUD_HEIGHT
                                                MoveSpeed:mv_speed];
        
        [self.monster2 setBorderBounds:bounds];
        
        //monster3
        self.monster3 = [[SPWMonsterA alloc] initWithScale:scale/2 StartX:180 StartY:300+BOTTOM_HUD_HEIGHT
                                                 MoveSpeed:mv_speed];
        
        [self.monster3 setBorderBounds:bounds];
        
        //monster4
        self.monster4 = [[SPWMonsterA alloc] initWithScale:scale/2 StartX:230 StartY:300+BOTTOM_HUD_HEIGHT
                                                 MoveSpeed:mv_speed];
        
        [self.monster4 setBorderBounds:bounds];
        
        
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
    [self.monster hoverInfinitySymbol:1.0 Loop:1 completion:^(void) {
        //then fly to borders
        [self.monster flyAndLandRightAtY:200 Duration:1.0];
    }];
    
    [scene addChild:self.monster2];
    [self.monster2 animateFly];
    [self.monster2 hoverInfinitySymbol:1.0 Loop:1 completion:^(void) {
        //then fly to borders
        [self.monster2 flyAndLandLeftAtY:300 Duration:1.0];
    }];
    
    [scene addChild:self.monster3];
    [self.monster3 animateFly];
    [self.monster3 hoverInfinitySymbol:1.0 Loop:1 completion:^(void) {
        //then fly to borders
        [self.monster3 flyAndLandTopAtX:100 Duration:1.0];
    }];
    
    [scene addChild:self.monster4];
    [self.monster4 animateFly];
    [self.monster4 hoverInfinitySymbol:1.0 Loop:1 completion:^(void) {
        //then fly to borders
        [self.monster4 flyAndLandBottomAtX:250 Duration:1.0];
    }];
}

@end
