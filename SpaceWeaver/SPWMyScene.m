//
//  SPWMyScene.m
//  SpaceWeaver
//
//  Created by Ronald Lee on 5/26/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "SPWMyScene.h"
#import "SPWPlayer.h"
#import "SPWMonsterA.h"

@interface SPWMyScene () {
    UISwipeGestureRecognizer* swipeUpGestureRecognizer;
    UISwipeGestureRecognizer* swipeDownGestureRecognizer;
    UISwipeGestureRecognizer* swipeLeftGestureRecognizer;
    UISwipeGestureRecognizer* swipeRightGestureRecognizer;
    
    UITapGestureRecognizer* tapRecognizer;
    
    float top_left_corner_x,top_left_corner_y;
    float top_right_corner_x,top_right_corner_y;
    float bottom_left_corner_x,bottom_left_corner_y;
    float bottom_right_corner_x,bottom_right_corner_y;
    
    float left_corner_x, right_corner_x, top_corner_y, bottom_corner_y;
    
    float scale;
    
    float player_bottom_border_y, player_top_border_y, player_left_border_x, player_right_border_x;
}

@property (nonatomic) SPWPlayer * player;
@property (nonatomic) SPWMonsterA * monster;

@end

@implementation SPWMyScene

-(void) didMoveToView:(SKView *)view {
    swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUpFrom:)];
    swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    
    swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDownFrom:)];
    swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    
    swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeftFrom:)];
    swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRightFrom:)];
    swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    
    [view addGestureRecognizer:swipeUpGestureRecognizer];
    [view addGestureRecognizer:swipeDownGestureRecognizer];
    [view addGestureRecognizer:swipeLeftGestureRecognizer];
    [view addGestureRecognizer:swipeRightGestureRecognizer];
    [view addGestureRecognizer:tapRecognizer];
}

-(void)willMoveFromView:(SKView*)view {
    [view removeGestureRecognizer:swipeUpGestureRecognizer];
    [view removeGestureRecognizer:swipeDownGestureRecognizer];
    [view removeGestureRecognizer:swipeLeftGestureRecognizer];
    [view removeGestureRecognizer:swipeRightGestureRecognizer];
    [view removeGestureRecognizer:tapRecognizer];
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        scale = [UIScreen mainScreen].scale;
        
        top_left_corner_x = left_corner_x = BORDER_SIDE_MARGIN;
        top_left_corner_y = top_corner_y = [[UIScreen mainScreen] bounds].size.height - TOP_HUD_HEIGHT;
        
        top_right_corner_x = right_corner_x = [[UIScreen mainScreen] bounds].size.width - BORDER_SIDE_MARGIN;
        top_right_corner_y = [[UIScreen mainScreen] bounds].size.height - TOP_HUD_HEIGHT;
        
        
        bottom_left_corner_x = BORDER_SIDE_MARGIN;
        bottom_left_corner_y = bottom_corner_y = BOTTOM_HUD_HEIGHT;
        
        bottom_right_corner_x = [[UIScreen mainScreen] bounds].size.width - BORDER_SIDE_MARGIN;
        bottom_right_corner_y = BOTTOM_HUD_HEIGHT;
        
        self.backgroundColor = [SKColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        [self setupStageBorders];
        
        player_bottom_border_y = bottom_corner_y+PIXEL_WIDTHHEIGHT+1;
        player_top_border_y = top_corner_y-PIXEL_WIDTHHEIGHT*2*scale-3;
        player_left_border_x = left_corner_x+3;
        player_right_border_x = right_corner_x-11;
        
        self.player = [[SPWPlayer alloc] initWithScale:scale];
        self.player.position = CGPointMake(([[UIScreen mainScreen] bounds].size.width-PLAYER_WIDTH)/2,
                                           player_bottom_border_y);
        
        [self.player setBorderTopY:player_top_border_y LeftX:player_left_border_x BottomY:player_bottom_border_y RightX:player_right_border_x];
        
        [self addChild:self.player];
        
        //add monster
        self.monster = [[SPWMonsterA alloc] initWithScale:scale/2];
        self.monster.position = CGPointMake(([[UIScreen mainScreen] bounds].size.width-PLAYER_WIDTH)/2,
                                           300);
        
        [self.monster setBorderTopY:player_top_border_y LeftX:player_left_border_x BottomY:player_bottom_border_y RightX:player_right_border_x];
        
        [self addChild:self.monster];
        
        [self.monster animateFly];
        
    }
    return self;
}

//-(UIImage*)createPlayerImage:(int)border {
//    
//    switch(border) {
//        case BORDER_TOP:
//            UIGraphicsBeginImageContextWithOptions(CGSizeMake(pixel_widthheight_x3, pixel_widthheight_x2), NO, [UIScreen mainScreen].scale);
//            CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), PLAYER_COLOR.CGColor);
//            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,0,pixel_widthheight,pixel_widthheight));
//            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(pixel_widthheight,0,pixel_widthheight,pixel_widthheight));
//            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(pixel_widthheight_x2,0,pixel_widthheight,pixel_widthheight));
//            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(pixel_widthheight,pixel_widthheight,pixel_widthheight,pixel_widthheight));
//            break;
//        case BORDER_LEFT:
//            UIGraphicsBeginImageContextWithOptions(CGSizeMake(pixel_widthheight_x2, pixel_widthheight_x3), NO, [UIScreen mainScreen].scale);
//            CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), PLAYER_COLOR.CGColor);
//            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,0,pixel_widthheight,pixel_widthheight));
//            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,pixel_widthheight,pixel_widthheight,pixel_widthheight));
//            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,pixel_widthheight_x2,pixel_widthheight,pixel_widthheight));
//            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(pixel_widthheight,pixel_widthheight,pixel_widthheight,pixel_widthheight));
//            break;
//        case BORDER_BOTTOM:
//            UIGraphicsBeginImageContextWithOptions(CGSizeMake(pixel_widthheight_x3, pixel_widthheight_x2), NO, [UIScreen mainScreen].scale);
//            CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), PLAYER_COLOR.CGColor);
//            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,pixel_widthheight,pixel_widthheight,pixel_widthheight));
//            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(pixel_widthheight,pixel_widthheight,pixel_widthheight,pixel_widthheight));
//            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(pixel_widthheight_x2,pixel_widthheight,pixel_widthheight,pixel_widthheight));
//            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(pixel_widthheight,0,pixel_widthheight,pixel_widthheight));
//            break;
//        case BORDER_RIGHT:
//            UIGraphicsBeginImageContextWithOptions(CGSizeMake(pixel_widthheight_x2, pixel_widthheight_x3), NO, [UIScreen mainScreen].scale);
//            CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), PLAYER_COLOR.CGColor);
//            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(pixel_widthheight,0,pixel_widthheight,pixel_widthheight));
//            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(pixel_widthheight,pixel_widthheight,pixel_widthheight,pixel_widthheight));
//            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(pixel_widthheight,pixel_widthheight_x2,pixel_widthheight,pixel_widthheight));
//            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,pixel_widthheight,pixel_widthheight,pixel_widthheight));
//            break;
//    }
//    
//    UIImage *playerImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return playerImage;
//}


-(void)setupStageBorders {
    
    CGMutablePathRef pathToDraw = CGPathCreateMutable();
    
    //top
    SKShapeNode* border_top = [SKShapeNode node];
    
    CGPathMoveToPoint(pathToDraw, NULL, left_corner_x, top_corner_y);
    CGPathAddLineToPoint(pathToDraw, NULL, right_corner_x, top_corner_y);
    
    border_top.path = pathToDraw;
    [border_top setStrokeColor:BORDER_COLOR];
    [border_top setLineWidth:1];
    [border_top setAntialiased:FALSE];
    [self addChild:border_top];
    
    //left
    SKShapeNode* border_left = [SKShapeNode node];
    
    CGPathMoveToPoint(pathToDraw, NULL, left_corner_x, bottom_corner_y);
    CGPathAddLineToPoint(pathToDraw, NULL, left_corner_x, top_corner_y);
    
    border_left.path = pathToDraw;
    [border_left setStrokeColor:BORDER_COLOR];
    [border_left setLineWidth:1];
    [border_left setAntialiased:FALSE];
    [self addChild:border_left];
    
    //bottom
    SKShapeNode* border_bottom = [SKShapeNode node];
    
    CGPathMoveToPoint(pathToDraw, NULL, left_corner_x, bottom_corner_y);
    CGPathAddLineToPoint(pathToDraw, NULL, right_corner_x, bottom_corner_y);
    
    border_bottom.path = pathToDraw;
    [border_bottom setStrokeColor:BORDER_COLOR];
    [border_bottom setLineWidth:1];
    [border_bottom setAntialiased:FALSE];
    [self addChild:border_bottom];
    
    //right
    SKShapeNode* border_right = [SKShapeNode node];
    
    CGPathMoveToPoint(pathToDraw, NULL, right_corner_x, bottom_corner_y);
    CGPathAddLineToPoint(pathToDraw, NULL, right_corner_x, top_corner_y);
    
    border_right.path = pathToDraw;
    [border_right setStrokeColor:BORDER_COLOR];
    [border_right setLineWidth:1];
    [border_right setAntialiased:FALSE];
    [self addChild:border_right];
    
}

- (void)handleSwipeUpFrom:(UIGestureRecognizer*)recognizer {
    [[self player] moveUp];
}

- (void)handleSwipeDownFrom:(UIGestureRecognizer*)recognizer {
    [[self player] moveDown];
}

- (void)handleSwipeLeftFrom:(UIGestureRecognizer*)recognizer {
    [[self player] moveLeft];
}

- (void)handleSwipeRightFrom:(UIGestureRecognizer*)recognizer {
    [[self player] moveRight];
}

-(void)handleTap:(UITapGestureRecognizer*)recognizer {
    [[self player] removeAllActions];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
   
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}



@end
