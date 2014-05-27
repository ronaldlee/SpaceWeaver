//
//  SPWConstants.h
//  SpaceWeaver
//
//  Created by Ronald Lee on 5/26/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPWConstants : NSObject

extern float const pixel_widthheight;
extern float const player_width;
extern float const player_height;
extern float const pixel_widthheight_x2;
extern float const pixel_widthheight_x3;

#define PLAYER_COLOR [UIColor redColor]
#define BORDER_COLOR [UIColor whiteColor]

extern float const bottom_hud_height;
extern float const top_hud_height;

extern CGFloat const speed;
extern float const transform_speed_factor;

extern float const BORDER_SIDE_MARGIN;

typedef enum {
    BORDER_TOP,
    BORDER_LEFT,
    BORDER_BOTTOM,
    BORDER_RIGHT,
}BORDER;

@end
