//
//  SPWStage1Schedule.m
//  SpaceWeaver
//
//  Created by Ronald Lee on 6/1/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "SPWStage1Schedule.h"

@implementation SPWStage1Schedule

- (id)init {
    self = [super init];
    if (self) {
        //instantiates monsters
        
    }
    return self;
}

-(void)start {
    SKAction *wait = [SKAction waitForDuration:10];
    SKAction *wave1 = [SKAction performSelector:@selector(wave1:) onTarget:self];
    SKAction *sequence = [SKAction sequence:@[wait,wave1]];
    [self runAction:sequence];
}

-(void)wave1 {
    
}

@end
