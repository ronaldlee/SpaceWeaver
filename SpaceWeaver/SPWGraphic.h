//
//  SPWGraphic.h
//  SpaceWeaver
//
//  Created by Ronald Lee on 5/31/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPWGraphic : NSObject

+(UIImage*)createBlockImage:(float)scale;
+(UIImage*)createBlueBlockImage:(float)scale;
+(UIImage*)createYellowBlockImage:(float)scale;
+(UIImage*)createRedBlockImage:(float)scale;

@end
