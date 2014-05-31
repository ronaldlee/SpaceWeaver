//
//  SPWGraphic.m
//  SpaceWeaver
//
//  Created by Ronald Lee on 5/31/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "SPWGraphic.h"

@implementation SPWGraphic


+(UIImage*)createBlockImage:(float)scale {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(PIXEL_WIDTHHEIGHT, PIXEL_WIDTHHEIGHT), NO, scale);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), PLAYER_COLOR.CGColor);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,0,PIXEL_WIDTHHEIGHT,PIXEL_WIDTHHEIGHT));
    UIImage *blockImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return blockImage;
}

+(UIImage*)createBlueBlockImage:(float)scale {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(PIXEL_WIDTHHEIGHT, PIXEL_WIDTHHEIGHT), NO, scale);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor blueColor].CGColor);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,0,PIXEL_WIDTHHEIGHT,PIXEL_WIDTHHEIGHT));
    UIImage *blockImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return blockImage;
}

+(UIImage*)createYellowBlockImage:(float)scale {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(PIXEL_WIDTHHEIGHT, PIXEL_WIDTHHEIGHT), NO, scale);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor yellowColor].CGColor);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,0,PIXEL_WIDTHHEIGHT,PIXEL_WIDTHHEIGHT));
    UIImage *blockImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return blockImage;
}

+(UIImage*)createRedBlockImage:(float)scale {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(PIXEL_WIDTHHEIGHT, PIXEL_WIDTHHEIGHT), NO, scale);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor redColor].CGColor);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,0,PIXEL_WIDTHHEIGHT,PIXEL_WIDTHHEIGHT));
    UIImage *blockImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return blockImage;
}

+(CGPoint)getRandomPoint:(CGRect)bounds {
    return CGPointMake(CGRectGetMinX(bounds)+arc4random()%(int)CGRectGetWidth(bounds),
                       CGRectGetMinY(bounds)+arc4random()%(int)CGRectGetHeight(bounds));
}

@end
