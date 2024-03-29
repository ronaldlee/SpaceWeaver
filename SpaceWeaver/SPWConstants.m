//
//  SPWConstants.m
//  SpaceWeaver
//
//  Created by Ronald Lee on 5/26/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "SPWConstants.h"

@implementation SPWConstants

float const PIXEL_WIDTHHEIGHT =2;
float const PIXEL_WIDTHHEIGHT_x2 = PIXEL_WIDTHHEIGHT*2;
float const PIXEL_WIDTHHEIGHT_x3 = PIXEL_WIDTHHEIGHT*3;

float const PLAYER_WIDTH = PIXEL_WIDTHHEIGHT*3;
float const PLAYER_HEIGHT = PIXEL_WIDTHHEIGHT*2;

float const BOTTOM_HUD_HEIGHT = 100;
float const TOP_HUD_HEIGHT = 30;

float const BORDER_SIDE_MARGIN=2;

const CGFloat SPEED = 100;
float const TRANSFORM_SPEED_FACTOR = 0.5;

const uint32_t MISSLE_CATEGORY  =  0x1 << 0;
const uint32_t PLAYER_CATEGORY   =  0x1 << 1;
const uint32_t ENEMY_CATEGORY    =  0x1 << 2;

@end
