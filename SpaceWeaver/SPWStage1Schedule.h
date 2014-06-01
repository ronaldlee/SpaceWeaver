//
//  SPWStage1Schedule.h
//  SpaceWeaver
//
//  Created by Ronald Lee on 6/1/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface SPWStage1Schedule : NSObject

- (id)initWithScale:(float)scale Bounds:(CGRect)bounds Scene:(SKScene*)scene;
-(void)start;
-(void)wave1;

@end
