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
    
    float scale;
    
    BORDER player_current_border;
    
    bool isPlayerTransforming;
    
    float player_bottom_border_y, player_top_border_y, player_left_border_x, player_right_border_x;
}

@property (nonatomic) SKSpriteNode * player;
@property (nonatomic) SKSpriteNode * playerA;
@property (nonatomic) SKSpriteNode * playerB;
@property (nonatomic) SKSpriteNode * playerC;
@property (nonatomic) SKSpriteNode * playerD;

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
        top_left_corner_y = top_corner_y = [[UIScreen mainScreen] bounds].size.height - top_hud_height;
        
        top_right_corner_x = right_corner_x = [[UIScreen mainScreen] bounds].size.width - BORDER_SIDE_MARGIN;
        top_right_corner_y = [[UIScreen mainScreen] bounds].size.height - top_hud_height;
        
        
        bottom_left_corner_x = BORDER_SIDE_MARGIN;
        bottom_left_corner_y = bottom_corner_y = bottom_hud_height;
        
        bottom_right_corner_x = [[UIScreen mainScreen] bounds].size.width - BORDER_SIDE_MARGIN;
        bottom_right_corner_y = bottom_hud_height;
        
        self.backgroundColor = [SKColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        [self setupStageBorders];
        
//        self.player = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[self createPlayerImage:BORDER_BOTTOM]]];
        
        player_bottom_border_y = bottom_corner_y+pixel_widthheight+1;
        player_top_border_y = top_corner_y-pixel_widthheight*2*scale-3;
        player_left_border_x = left_corner_x+3;
        player_right_border_x = right_corner_x-11;
        
        CGSize player_size = CGSizeMake(0, 0);
        
        self.player = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:player_size];
        
        self.player.position = CGPointMake(([[UIScreen mainScreen] bounds].size.width-player_width)/2,
                                           //bottom_hud_height+pixel_widthheight);
                                           player_bottom_border_y);
        
        
        self.playerA = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[self createBlockImage]]];
        [self.player addChild:self.playerA];
        self.playerA.position = CGPointMake(pixel_widthheight*[UIScreen mainScreen].scale,pixel_widthheight*scale);
        
        self.playerB = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[self createBlockImage]]];
        [self.player addChild:self.playerB];
        self.playerB.position = CGPointMake(0,0);

        self.playerC = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[self createBlueBlockImage]]];
        [self.player addChild:self.playerC];
        self.playerC.position = CGPointMake(pixel_widthheight*scale,0);
        
        self.playerD = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[self createBlockImage]]];
        [self.player addChild:self.playerD];
        self.playerD.position = CGPointMake(pixel_widthheight*2*scale,0);
        
        
        [self addChild:self.player];
        
        player_current_border = BORDER_BOTTOM;
    }
    return self;
}

-(UIImage*)createBlockImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(pixel_widthheight, pixel_widthheight), NO,
                                           [UIScreen mainScreen].scale);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), PLAYER_COLOR.CGColor);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,0,pixel_widthheight,pixel_widthheight));
    UIImage *blockImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return blockImage;
}

-(UIImage*)createBlueBlockImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(pixel_widthheight, pixel_widthheight), NO,
                                           [UIScreen mainScreen].scale);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor blueColor].CGColor);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,0,pixel_widthheight,pixel_widthheight));
    UIImage *blockImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return blockImage;
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
    if (isPlayerTransforming) return;
    
    CGFloat player_x = [self player].position.x;
    CGFloat player_y = [self player].position.y;
    
    isWeaveMode=FALSE;
    if (!(player_x == player_left_border_x) &&
        !(player_x == right_corner_x-player_width) ){
        isWeaveMode = TRUE;
    }
    
    if (!isWeaveMode) {
        [[self player] removeAllActions];
        
        CGPoint toPoint = CGPointMake(player_x, player_top_border_y);
        
        CGFloat distance = toPoint.y - player_y;
        CGFloat duration = distance/speed;
        
        SKAction *movePlayer = [SKAction moveTo:toPoint duration:duration];
        
        [[self player] runAction:movePlayer completion:^{
            if (player_x == player_left_border_x) {
                [self playerTransfromLeftToTop];
            }
            else {
                
            }
        }];
    }
    
}
- (void)handleSwipeDownFrom:(UIGestureRecognizer*)recognizer {
    if (isPlayerTransforming) return;
    
}
- (void)handleSwipeLeftFrom:(UIGestureRecognizer*)recognizer {
    if (isPlayerTransforming) return;
    
    //swipe left only work when player's y position is either at top or bottom
    //otherwise, that becomes weaving mode
    CGFloat player_x = [self player].position.x;
    CGFloat player_y = [self player].position.y;
    
    isWeaveMode=FALSE;
    if (!(player_y == player_bottom_border_y) &&
        !(player_y == player_top_border_y) ){
        isWeaveMode = TRUE;
    }
    
    if (!isWeaveMode) {
        [[self player] removeAllActions];
        
        CGPoint toPoint = CGPointMake(player_left_border_x, player_y);
        
        CGFloat distance = player_x - toPoint.x;
        CGFloat duration = distance/speed;
        
        SKAction *movePlayer = [SKAction moveTo:toPoint duration:duration];
        
        [[self player] runAction:movePlayer completion:^{
            
            if (player_y == player_bottom_border_y) { //bottom to left
                [self playerTransfromBottemToLeft];
            }
            else { //top to left
                
            }

            
        }];
    }
}


- (void)handleSwipeRightFrom:(UIGestureRecognizer*)recognizer {
    if (isPlayerTransforming) return;
    
    CGFloat player_x = [self player].position.x;
    CGFloat player_y = [self player].position.y;
    
    isWeaveMode=FALSE;
    if (!(player_y == player_bottom_border_y) &&
        !(player_y == player_top_border_y) ){
        isWeaveMode = TRUE;
    }
    
    if (!isWeaveMode) {
        [[self player] removeAllActions];
        
        CGPoint toPoint = CGPointMake(player_right_border_x, player_y);
        
        CGFloat distance = toPoint.x-player_x ;
        CGFloat duration = distance/speed;
        
        SKAction *movePlayer = [SKAction moveTo:toPoint duration:duration];
        
        [[self player] runAction:movePlayer completion:^{
            if (player_y == player_top_border_y) {
                [self playerTransfromTopToRight];
            }
        }];
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


-(void)playerTransfromBottemToLeft {
    isPlayerTransforming=TRUE;
    //B
    CGPoint b_toPoint = CGPointMake([self playerB].position.x, pixel_widthheight_x2*scale);
    
    CGFloat distance = b_toPoint.y-[self playerB].position.y ;
    CGFloat duration = distance/speed*transform_speed_factor;
    
    SKAction *movePlayerB = [SKAction moveTo:b_toPoint duration:duration];
    [[self playerB] runAction:movePlayerB];
    
    //D
    CGPoint d_toPoint = CGPointMake(0, [self playerD].position.y);
    
    distance = [self playerD].position.x-d_toPoint.x ;
    duration = distance/speed*transform_speed_factor;
    
    SKAction *movePlayerD = [SKAction moveTo:d_toPoint duration:duration];
    [[self playerD] runAction:movePlayerD];
    
    //C
    CGPoint c_toPoint = CGPointMake(0, [self playerC].position.y);
    
    distance = [self playerC].position.x-c_toPoint.x ;
    duration = distance/speed*transform_speed_factor;
    
    SKAction *movePlayerC = [SKAction moveTo:c_toPoint duration:duration];
    [[self playerC] runAction:movePlayerC completion:^ {
        CGPoint c_toPoint = CGPointMake([self playerC].position.x, pixel_widthheight*scale);
        
        CGFloat distance = c_toPoint.y-[self playerC].position.y ;
        CGFloat duration = distance/speed*transform_speed_factor;
        
        SKAction *movePlayerC2 = [SKAction moveTo:c_toPoint duration:duration];
        [[self playerC] runAction:movePlayerC2 completion:^ {
            //indicate the orientation now is left border
            player_current_border = BORDER_LEFT;
            isPlayerTransforming = FALSE;
        }];
    }];
}


-(void)playerTransfromLeftToTop {
    isPlayerTransforming=TRUE;
    //B
    CGPoint b_toPoint = CGPointMake(pixel_widthheight_x2*scale, [self playerB].position.y);
    
    CGFloat distance = b_toPoint.x-[self playerB].position.x ;
    CGFloat duration = distance/speed*transform_speed_factor;
    
    SKAction *movePlayerB = [SKAction moveTo:b_toPoint duration:duration];
    [[self playerB] runAction:movePlayerB];
    
    //D
    CGPoint d_toPoint = CGPointMake([self playerD].position.x, pixel_widthheight_x2*scale);
    
    distance = d_toPoint.y - [self playerD].position.y ;
    duration = distance/speed*transform_speed_factor;
    
    SKAction *movePlayerD = [SKAction moveTo:d_toPoint duration:duration];
    [[self playerD] runAction:movePlayerD];
    
    //C
    CGPoint c_toPoint = CGPointMake([self playerC].position.x,pixel_widthheight_x2*scale);
    
    distance = c_toPoint.y - [self playerC].position.y ;
    duration = distance/speed*transform_speed_factor;
    
    SKAction *movePlayerC = [SKAction moveTo:c_toPoint duration:duration];
    [[self playerC] runAction:movePlayerC completion:^ {
        CGPoint c_toPoint = CGPointMake(pixel_widthheight*scale,[self playerC].position.y);
        
        CGFloat distance = c_toPoint.x-[self playerC].position.x ;
        CGFloat duration = distance/speed*transform_speed_factor;
        
        SKAction *movePlayerC2 = [SKAction moveTo:c_toPoint duration:duration];
        [[self playerC] runAction:movePlayerC2 completion:^ {
            //indicate the orientation now is left border
            player_current_border = BORDER_TOP;
            isPlayerTransforming = FALSE;
        }];
    }];
    
    [[self playerC] runAction:movePlayerC];
}

-(void)playerTransfromTopToRight {
    isPlayerTransforming=TRUE;
    //B
    CGPoint b_toPoint = CGPointMake([self playerB].position.x, 0);
    
    CGFloat distance = [self playerB].position.y-b_toPoint.x ;
    CGFloat duration = distance/speed*transform_speed_factor;
    
    SKAction *movePlayerB = [SKAction moveTo:b_toPoint duration:duration];
    [[self playerB] runAction:movePlayerB];
    
    //D
    CGPoint d_toPoint = CGPointMake(pixel_widthheight_x2*scale, [self playerD].position.y);
    
    distance = d_toPoint.x - [self playerD].position.x ;
    duration = distance/speed*transform_speed_factor;
    
    SKAction *movePlayerD = [SKAction moveTo:d_toPoint duration:duration];
    [[self playerD] runAction:movePlayerD];
    
    //C
    CGPoint c_toPoint = CGPointMake(pixel_widthheight_x2*scale,[self playerC].position.y);
    
    distance = c_toPoint.x - [self playerC].position.x ;
    duration = distance/speed*transform_speed_factor;
    
    SKAction *movePlayerC = [SKAction moveTo:c_toPoint duration:duration];
    [[self playerC] runAction:movePlayerC completion:^ {
        CGPoint c_toPoint = CGPointMake([self playerC].position.x,pixel_widthheight*scale);
        
        CGFloat distance = [self playerC].position.y-c_toPoint.y ;
        CGFloat duration = distance/speed*transform_speed_factor;
        
        SKAction *movePlayerC2 = [SKAction moveTo:c_toPoint duration:duration];
        [[self playerC] runAction:movePlayerC2 completion:^ {
            //indicate the orientation now is left border
            player_current_border = BORDER_RIGHT;
            isPlayerTransforming = FALSE;
        }];
    }];
    
    [[self playerC] runAction:movePlayerC];
}




@end
