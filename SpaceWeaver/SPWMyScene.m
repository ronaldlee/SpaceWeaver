//
//  SPWMyScene.m
//  SpaceWeaver
//
//  Created by Ronald Lee on 5/26/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "SPWMyScene.h"

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
    
    bool isWeaveMode;
}

@property (nonatomic) SKSpriteNode * player;

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
        
        top_left_corner_x = left_corner_x = BORDER_SIDE_MARGIN;
        top_left_corner_y = top_corner_y = [[UIScreen mainScreen] bounds].size.height - top_hud_height;
        
        top_right_corner_x = right_corner_x = [[UIScreen mainScreen] bounds].size.width - BORDER_SIDE_MARGIN;
        top_right_corner_y = [[UIScreen mainScreen] bounds].size.height - top_hud_height;
        
        
        bottom_left_corner_x = BORDER_SIDE_MARGIN;
        bottom_left_corner_y = bottom_corner_y = bottom_hud_height;
        
        bottom_right_corner_x = [[UIScreen mainScreen] bounds].size.width - BORDER_SIDE_MARGIN;
        bottom_right_corner_y = bottom_hud_height;
        
        
        self.backgroundColor = [SKColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        
        
        [self setupStageBorders];
        
        
        self.player = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[self createPlayerImage:BORDER_BOTTOM]]];
        self.player.position = CGPointMake(([[UIScreen mainScreen] bounds].size.width-player_width)/2,bottom_hud_height+player_height);
        
        
        [self addChild:self.player];
    }
    return self;
}

-(UIImage*)createPlayerImage:(int)border {
    
    switch(border) {
        case BORDER_TOP:
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(pixel_widthheight_x3, pixel_widthheight_x2), NO, [UIScreen mainScreen].scale);
            CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), PLAYER_COLOR.CGColor);
            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,0,pixel_widthheight,pixel_widthheight));
            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(pixel_widthheight,0,pixel_widthheight,pixel_widthheight));
            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(pixel_widthheight_x2,0,pixel_widthheight,pixel_widthheight));
            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(pixel_widthheight,pixel_widthheight,pixel_widthheight,pixel_widthheight));
            break;
        case BORDER_LEFT:
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(pixel_widthheight_x2, pixel_widthheight_x3), NO, [UIScreen mainScreen].scale);
            CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), PLAYER_COLOR.CGColor);
            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,0,pixel_widthheight,pixel_widthheight));
            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,pixel_widthheight,pixel_widthheight,pixel_widthheight));
            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,pixel_widthheight_x2,pixel_widthheight,pixel_widthheight));
            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(pixel_widthheight,pixel_widthheight,pixel_widthheight,pixel_widthheight));
            break;
        case BORDER_BOTTOM:
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(pixel_widthheight_x3, pixel_widthheight_x2), NO, [UIScreen mainScreen].scale);
            CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), PLAYER_COLOR.CGColor);
            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,pixel_widthheight,pixel_widthheight,pixel_widthheight));
            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(pixel_widthheight,pixel_widthheight,pixel_widthheight,pixel_widthheight));
            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(pixel_widthheight_x2,pixel_widthheight,pixel_widthheight,pixel_widthheight));
            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(pixel_widthheight,0,pixel_widthheight,pixel_widthheight));
            break;
        case BORDER_RIGHT:
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(pixel_widthheight_x2, pixel_widthheight_x3), NO, [UIScreen mainScreen].scale);
            CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), PLAYER_COLOR.CGColor);
            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(pixel_widthheight,0,pixel_widthheight,pixel_widthheight));
            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(pixel_widthheight,pixel_widthheight,pixel_widthheight,pixel_widthheight));
            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(pixel_widthheight,pixel_widthheight_x2,pixel_widthheight,pixel_widthheight));
            CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,pixel_widthheight,pixel_widthheight,pixel_widthheight));
            break;
    }
    
    UIImage *playerImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return playerImage;
}


-(void)setupStageBorders {
    
    CGMutablePathRef pathToDraw = CGPathCreateMutable();
    
    //top
    SKShapeNode* border_top = [SKShapeNode node];
    
    CGPathMoveToPoint(pathToDraw, NULL, BORDER_SIDE_MARGIN, [[UIScreen mainScreen] bounds].size.height-top_hud_height);
    CGPathAddLineToPoint(pathToDraw, NULL, [[UIScreen mainScreen] bounds].size.width-BORDER_SIDE_MARGIN, [[UIScreen mainScreen] bounds].size.height-top_hud_height);
    
    border_top.path = pathToDraw;
    [border_top setStrokeColor:BORDER_COLOR];
    [border_top setLineWidth:1];
    [border_top setAntialiased:FALSE];
    [self addChild:border_top];
    
    //left
    SKShapeNode* border_left = [SKShapeNode node];
    
    CGPathMoveToPoint(pathToDraw, NULL, BORDER_SIDE_MARGIN, bottom_hud_height);
    CGPathAddLineToPoint(pathToDraw, NULL, BORDER_SIDE_MARGIN, [[UIScreen mainScreen] bounds].size.height-top_hud_height);
    
    border_left.path = pathToDraw;
    [border_left setStrokeColor:BORDER_COLOR];
    [border_left setLineWidth:1];
    [border_left setAntialiased:FALSE];
    [self addChild:border_left];
    
    //bottom
    SKShapeNode* border_bottom = [SKShapeNode node];
    
    CGPathMoveToPoint(pathToDraw, NULL, BORDER_SIDE_MARGIN, bottom_hud_height);
    CGPathAddLineToPoint(pathToDraw, NULL, [[UIScreen mainScreen] bounds].size.width-BORDER_SIDE_MARGIN, bottom_hud_height);
    
    border_bottom.path = pathToDraw;
    [border_bottom setStrokeColor:BORDER_COLOR];
    [border_bottom setLineWidth:1];
    [border_bottom setAntialiased:FALSE];
    [self addChild:border_bottom];
    
    //right
    SKShapeNode* border_right = [SKShapeNode node];
    
    CGPathMoveToPoint(pathToDraw, NULL, [[UIScreen mainScreen] bounds].size.width-BORDER_SIDE_MARGIN, [[UIScreen mainScreen] bounds].size.height-top_hud_height);
    CGPathAddLineToPoint(pathToDraw, NULL, [[UIScreen mainScreen] bounds].size.width-BORDER_SIDE_MARGIN, bottom_hud_height);
    
    border_right.path = pathToDraw;
    [border_right setStrokeColor:BORDER_COLOR];
    [border_right setLineWidth:1];
    [border_right setAntialiased:FALSE];
    [self addChild:border_right];
    
}

- (void)handleSwipeUpFrom:(UIGestureRecognizer*)recognizer {
    CGFloat player_x = [self player].position.x;
    CGFloat player_y = [self player].position.y;
    
    if ((player_x == left_corner_x+player_width) ||
        (player_x == right_corner_x-player_width) ){
        isWeaveMode = FALSE;
    }
    
    if (!isWeaveMode) {
        [[self player] removeAllActions];
        
        CGPoint toPoint = CGPointMake(player_x, top_corner_y-player_height);
        
        CGFloat distance = toPoint.y - player_y;
        CGFloat duration = distance/speed;
        
        SKAction *movePlayer = [SKAction moveTo:toPoint duration:duration];
        
        [[self player] runAction:movePlayer];
    }
    
}
- (void)handleSwipeDownFrom:(UIGestureRecognizer*)recognizer {
    
}
- (void)handleSwipeLeftFrom:(UIGestureRecognizer*)recognizer {
    //swipe left only work when player's y position is either at top or bottom
    //otherwise, that becomes weaving mode
    CGFloat player_x = [self player].position.x;
    CGFloat player_y = [self player].position.y;
    
    
    if ((player_y == bottom_corner_y+player_height) ||
        (player_y == top_corner_y-player_height) ){
        isWeaveMode = FALSE;
    }
    
    if (!isWeaveMode) {
        [[self player] removeAllActions];
        
        CGPoint toPoint = CGPointMake(left_corner_x+player_width, player_y);
        
        CGFloat distance = player_x - toPoint.x;
        CGFloat duration = distance/speed;
        
        SKAction *movePlayer = [SKAction moveTo:toPoint duration:duration];
        
        [[self player] runAction:movePlayer];
    }
    
}
- (void)handleSwipeRightFrom:(UIGestureRecognizer*)recognizer {
    CGFloat player_x = [self player].position.x;
    CGFloat player_y = [self player].position.y;
    
    if ((player_y == bottom_corner_y+player_height) ||
        (player_y == top_corner_y-player_height) ){
        isWeaveMode = FALSE;
    }
    
    if (!isWeaveMode) {
        [[self player] removeAllActions];
        
        CGPoint toPoint = CGPointMake(right_corner_x-player_width, player_y);
        
        CGFloat distance = toPoint.x-player_x ;
        CGFloat duration = distance/speed;
        
        SKAction *movePlayer = [SKAction moveTo:toPoint duration:duration];
        
        [[self player] runAction:movePlayer];
    }
    
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
