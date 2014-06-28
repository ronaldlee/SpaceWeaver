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
#import "SPWBullet.h"
#import "SPWStage1Schedule.h"

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
@property (nonatomic) SPWStage1Schedule * stage1;

@end

@implementation SPWMyScene

@synthesize space_bg;
@synthesize stage1;
@synthesize fire_button;

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
        
        
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        
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
        
        CGRect bounds = CGRectMake(player_left_border_x, player_bottom_border_y,
                                   player_right_border_x-player_left_border_x,
                                   player_top_border_y-player_bottom_border_y);
        
        NSString* burstPath = [[NSBundle mainBundle] pathForResource:@"Space" ofType:@"sks"];
        space_bg = [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
        space_bg.userInteractionEnabled = YES;
        space_bg.position = CGPointMake(0,[[UIScreen mainScreen] bounds].size.height);
        
        [self addChild:space_bg];
        
        //===
        CGSize button_size = CGSizeMake(50,50);
        
        fire_button = [[SPWFireButton alloc] initWithSize:button_size Name:@"fire_button"];
//        fire_button.name = @"fire_button";
        fire_button.userInteractionEnabled = NO;
        fire_button.position = CGPointMake(left_corner_x, BOTTOM_HUD_HEIGHT - 10 - button_size.height);
        [self addChild:fire_button];
        
        //====
        
        self.player = [[SPWPlayer alloc] initWithScale:scale];
        self.player.position = CGPointMake(([[UIScreen mainScreen] bounds].size.width-PLAYER_WIDTH)/2,
                                           player_bottom_border_y);
        
        [self.player setBorderBounds:bounds];
        
        [self addChild:self.player];
        
        
        stage1 = [[SPWStage1Schedule alloc] initWithScale:scale Bounds:bounds Scene:self];
        
        [stage1 start];
        
    }
    return self;
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
//    SKPhysicsBody *playerBody, *enemyBody, *missileBody;
    
    NSLog(@"contact!!!");
    if ((contact.bodyA.categoryBitMask & PLAYER_CATEGORY)!=0) {
        
        SPWPlayer *player = (SPWPlayer*)contact.bodyA.node;
        
        if ((contact.bodyB.categoryBitMask & ENEMY_CATEGORY) != 0) {
            SPWMonsterA *monster = (SPWMonsterA*)contact.bodyB.node;
            
            NSLog(@"contact!: player and monster");
            [player contactWith:monster];
        }
    }
    else if ((contact.bodyA.categoryBitMask & ENEMY_CATEGORY) != 0) {
        SPWMonsterA* enemyBody = (SPWMonsterA*)contact.bodyA.node;
        
        if ((contact.bodyB.categoryBitMask & MISSLE_CATEGORY) != 0) {
            SPWBullet* missileBody = (SPWBullet*)contact.bodyB.node;
            
            NSLog(@"missle hit monster");
            [enemyBody explode];
        }
    }
    else if ((contact.bodyA.categoryBitMask & MISSLE_CATEGORY) != 0) {
        SPWBullet* missileBody = (SPWBullet*)contact.bodyA.node;
        
        if ((contact.bodyB.categoryBitMask & ENEMY_CATEGORY) != 0) {
            SPWMonsterA* enemyBody = (SPWMonsterA*)contact.bodyB.node;
            
            NSLog(@"missle hit monster");
            [enemyBody explode];
        }
    }
//    else if ((contact.bodyA.categoryBitMask & MISSLE_CATEGORY) != 0) {
//        missileBody = contact.bodyA;
//        
//        if ((contact.bodyB.categoryBitMask & ENEMY_CATEGORY) != 0) {
//            enemyBody = contact.bodyB;
//        }
//    }


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
//    NSLog(@"tap");
    [[self player] stop];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"touch");
    /* Called when a touch begins */
    
    for (UITouch* touch in touches) {
//        UITouch* touch = [touches anyObject];
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        
//        NSLog(@"touch class: %@, name: %@" , NSStringFromClass([node class]), node.name);
        
        if ([node.name isEqualToString:@"fire_button"]) {
//        if ([node isEqual:fire_button]) {
            NSLog(@"fire!!");
            [self.player toggleFiring];
            
            if ([self.player isFiring]) {
                SKAction* shootBulletAction = [SKAction runBlock:^{
                    BORDER cur_border = [self.player getCurrentBorder];
                    CGPoint location = [self.player position];
                    SPWBullet *bullet = [[SPWBullet alloc]initWithScale:1.0];
                    
                    bullet.position = CGPointMake(location.x,location.y+self.player.size.height/2);
                    //bullet.position = location;
                    bullet.zPosition = 1;
                    //                bullet.scale = 0.8;
                    
                    SKAction *action = Nil;
                    SKAction *remove = [SKAction removeFromParent];
                    float flight_distance = 2000;
                    CGFloat bullet_speed = 10;
                    if (cur_border == BORDER_TOP) {
                        action = [SKAction moveToY:-(flight_distance-self.frame.size.height) duration:bullet_speed];
                    }
                    else if (cur_border == BORDER_BOTTOM) {
                        action = [SKAction moveToY:flight_distance duration:bullet_speed];
                    }
                    else if (cur_border == BORDER_LEFT) {
                        action = [SKAction moveToX:flight_distance duration:bullet_speed];
                    }
                    else if (cur_border == BORDER_RIGHT) {
                        action = [SKAction moveToX:-(flight_distance-self.frame.size.width) duration:bullet_speed];
                    }
                    
                    [bullet runAction:[SKAction sequence:@[action,remove]]];
                    
                    [self addChild:bullet];
                }];// queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
                
                SKAction *wait = [SKAction waitForDuration:0.4];
                SKAction *sequence = [SKAction sequence:@[shootBulletAction, wait]];
                [self runAction:[SKAction repeatActionForever:sequence]];
            }
            else {
                [self removeAllActions];
            }
            
            return;
        }
    }
   
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}



@end
