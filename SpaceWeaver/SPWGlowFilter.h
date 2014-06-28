//
//  SPWGlowFilter.h
//  SpaceWeaver
//
//  Created by Ronald Lee on 6/7/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import <CoreImage/CoreImage.h>

@interface SPWGlowFilter : CIFilter

@property (strong, nonatomic) UIColor *glowColor;
@property (strong, nonatomic) CIImage *inputImage;
@property (strong, nonatomic) NSNumber *inputRadius;
@property (strong, nonatomic) CIVector *inputCenter;

@end
