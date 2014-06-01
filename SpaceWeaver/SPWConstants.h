//
//  SPWConstants.h
//  SpaceWeaver
//
//  Created by Ronald Lee on 5/26/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPWConstants : NSObject

extern float const PIXEL_WIDTHHEIGHT;
extern float const PLAYER_WIDTH;
extern float const PLAYER_HEIGHT;
extern float const PIXEL_WIDTHHEIGHT_x2;
extern float const PIXEL_WIDTHHEIGHT_x3;

#define PLAYER_COLOR [UIColor whiteColor]
#define BORDER_COLOR [UIColor whiteColor]

extern float const BOTTOM_HUD_HEIGHT;
extern float const TOP_HUD_HEIGHT;

extern CGFloat const SPEED;
extern float const TRANSFORM_SPEED_FACTOR;

extern float const BORDER_SIDE_MARGIN;

typedef enum {
    BORDER_TOP,
    BORDER_LEFT,
    BORDER_BOTTOM,
    BORDER_RIGHT,
}BORDER;

#define DEGREES_TO_RADIANS(degrees) ((M_PI*degrees)/180)

@end
