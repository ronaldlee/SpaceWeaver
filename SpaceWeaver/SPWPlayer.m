//
//  SPWPlayer.m
//  SpaceWeaver
//
//  Created by Ronald Lee on 5/31/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import "SPWPlayer.h"
#import "SPWGraphic.h"

@interface SPWPlayer() {
    bool isWeaveMode;
    bool isPlayerTransforming;
    float bottom_border_y, top_border_y, left_border_x, right_border_x;
    BORDER player_current_border;
    float scale;
    CGRect bounds;
    float max_width, max_height;
    BOOL is_firing;
}
@end

@implementation SPWPlayer

@synthesize playerA;
@synthesize playerB;
@synthesize playerC;
@synthesize playerD;
//@synthesize effectNodeA;



- (id)initWithScale:(CGFloat)f_scale {
    self = [super init];
    if (self) {
        // Initialize self.
        self.userInteractionEnabled = YES;
        
        scale = f_scale;
        
        player_current_border = BORDER_BOTTOM;
        
        CGFloat scaled_width = PIXEL_WIDTHHEIGHT*scale;
        CGFloat scaled_height = PIXEL_WIDTHHEIGHT*scale;
        
//        self.playerA = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[SPWGraphic createBlockImage:scale]]];
        self.playerA = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_width,scaled_height)];
        [self addChild:self.playerA];
        self.playerA.position = CGPointMake(scaled_width,scaled_height);
        
        self.playerB = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_width,scaled_height)];
        [self addChild:self.playerB];
        self.playerB.position = CGPointMake(0,0);
        
        self.playerC = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_width,scaled_height)];
        [self addChild:self.playerC];
        self.playerC.position = CGPointMake(scaled_width,0);
        
        self.playerD = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(scaled_width,scaled_height)];
        [self addChild:self.playerD];
        self.playerD.position = CGPointMake(scaled_width*2,0);
        
        max_width = scaled_width*3;
        max_height = scaled_height*2;
        
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(max_width, max_height)];
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody.categoryBitMask = PLAYER_CATEGORY;
        self.physicsBody.contactTestBitMask = ENEMY_CATEGORY;
        self.physicsBody.collisionBitMask = 0;
        
//        effectNodeA = [[SKEffectNode alloc] init];
//        SPWGlowFilter *glowFilter = [[SPWGlowFilter alloc] init];
        
//        [glowFilter setInputCenter:[CIVector vectorWithX:(max_width)/2 Y:max_height/2]];
//        [glowFilter setGlowColor:[[UIColor whiteColor] colorWithAlphaComponent:1.0]];
//        [effectNodeA setShouldRasterize:YES];
//        [effectNodeA setFilter:glowFilter];
//        [self addChild:effectNodeA];
//        [effectNodeA addChild:self.playerA];
//        [effectNodeA addChild:self.playerB];
//        [effectNodeA addChild:self.playerC];
//        [effectNodeA addChild:self.playerD];
        
        
    }
    return self;
}

-(void)setBorderBounds:(CGRect)p_bounds {
    bounds = p_bounds;
    
    left_border_x = bounds.origin.x;
    right_border_x = left_border_x+bounds.size.width;
    bottom_border_y = bounds.origin.y;
    top_border_y = bottom_border_y+bounds.size.height;
}

-(void)moveUp {
    if (isPlayerTransforming) return;
    
    CGFloat player_x = (CGFloat)((int)self.position.x);
    CGFloat player_y = (CGFloat)((int)self.position.y);
    
    isWeaveMode=FALSE;
    if (!(player_x == left_border_x) &&
        !(player_x == right_border_x) ){
        isWeaveMode = TRUE;
    }
    
    if (player_current_border == BORDER_BOTTOM) {
        if (player_x == left_border_x) {
            [self playerTransfromBottomToLeft];
        }
        else if (player_x == right_border_x) {
            [self playerTransfromBottomToRight];
        }
    }
    
    if (!isWeaveMode) {
        [self removeAllActions];
        
        CGFloat distance = top_border_y - player_y;
        CGFloat duration = distance/SPEED;
        
        SKAction *movePlayer = [SKAction moveToY:top_border_y duration:duration];
        
        [self runAction:movePlayer completion:^{
            if (player_x == left_border_x) {
                [self playerTransfromLeftToTop];
            }
            else {
                [self playerTransfromRightToTop];
            }
        }];
    }

}

- (void)moveDown {
    NSLog(@"handleSwipeDownFrom: %d", isPlayerTransforming);
    if (isPlayerTransforming) return;
    
    CGFloat player_x = (CGFloat)((int)self.position.x);
    CGFloat player_y = (CGFloat)((int)self.position.y);
    
    isWeaveMode=FALSE;
    if (!(player_x == left_border_x) &&
        !(player_x == right_border_x) ){
        isWeaveMode = TRUE;
    }
    
    if (!isWeaveMode) {
        [self removeAllActions];
        
        if (player_current_border == BORDER_TOP) {
            if (player_x == right_border_x) {
                [self playerTransfromTopToRight];
            }
            else if (player_x == left_border_x) {
                [self playerTransfromTopToLeft];
            }
        }
        
        CGFloat distance = player_y-bottom_border_y;
        CGFloat duration = distance/SPEED;
        
        SKAction *movePlayer = [SKAction moveToY:bottom_border_y duration:duration];
        
        [self runAction:movePlayer completion:^{
            if (player_x == right_border_x) {
                [self playerTransfromRightToBottom];
            }
            else {
                [self playerTransfromLeftToBottom];
            }
        }];
    }
    
}

- (void)moveLeft {
    NSLog(@"handleSwipeLeftFrom: %d", isPlayerTransforming);
    if (isPlayerTransforming) return;
    
    //swipe left only work when player's y position is either at top or bottom
    //otherwise, that becomes weaving mode
    CGFloat player_x = (CGFloat)((int)self.position.x);
    CGFloat player_y = (CGFloat)((int)self.position.y);
    
    NSLog(@"player_y: %f",player_y);
    
    isWeaveMode=FALSE;
    if (!(player_y == bottom_border_y) &&
        !(player_y == top_border_y) ){
        isWeaveMode = TRUE;
    }
    
    NSLog(@"handleSwipeLeftFrom: isWeaveMode %d, player_y: %f", isWeaveMode, player_y);
    
    if (!isWeaveMode) {
        [self removeAllActions];
        
        if (player_current_border == BORDER_RIGHT) {
            if (player_y == bottom_border_y) {
                [self playerTransfromRightToBottom];
            }
            else if (player_y == top_border_y) {
                [self playerTransfromRightToTop];
            }
        }
        
        CGFloat distance = player_x - left_border_x;
        CGFloat duration = distance/SPEED;
        
        SKAction *movePlayer = [SKAction moveToX:left_border_x duration:duration];
        
        [self runAction:movePlayer completion:^{
            
            if (player_y == bottom_border_y) { //bottom to left
                [self playerTransfromBottomToLeft];
            }
            else { //top to left
                [self playerTransfromTopToLeft];
            }
            
        }];
    }
}


- (void)moveRight {
    NSLog(@"handleSwipeRightFrom: %d", isPlayerTransforming);
    if (isPlayerTransforming) return;
    
    CGFloat player_x = (CGFloat)((int)self.position.x);
    CGFloat player_y = (CGFloat)((int)self.position.y);
    
    isWeaveMode=FALSE;
    if (!(player_y == bottom_border_y) &&
        !(player_y == top_border_y) ){
        isWeaveMode = TRUE;
    }
    
    NSLog(@"handleSwipeRightFrom: isWeaveMode %d, player_y: %f", isWeaveMode, player_y);
    
    if (!isWeaveMode) {
        [self removeAllActions];
        
        if (player_current_border == BORDER_LEFT) {
            if (player_y == bottom_border_y) {
                [self playerTransfromLeftToBottom];
            }
            else if (player_y == top_border_y) {
                [self playerTransfromLeftToTop];
            }
        }
        
        CGFloat distance = right_border_x-player_x ;
        CGFloat duration = distance/SPEED;
        
        SKAction *movePlayer = [SKAction moveToX:right_border_x duration:duration];
        
        [self runAction:movePlayer completion:^{
            if (player_y == top_border_y) {
                [self playerTransfromTopToRight];
            }
            else {
                [self playerTransfromBottomToRight];
            }
        }];
    }
    
}

//===========
-(void)playerTransfromBottomToLeft {
    isPlayerTransforming=TRUE;
    //B
    CGPoint b_toPoint = CGPointMake([self playerB].position.x, PIXEL_WIDTHHEIGHT_x2*scale);
    
    CGFloat distance = b_toPoint.y-[self playerB].position.y ;
    CGFloat duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
    
    SKAction *movePlayerB = [SKAction moveTo:b_toPoint duration:duration];
    [[self playerB] runAction:movePlayerB];
    
    //D
    CGPoint d_toPoint = CGPointMake(0, [self playerD].position.y);
    
    distance = [self playerD].position.x-d_toPoint.x ;
    duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
    
    SKAction *movePlayerD = [SKAction moveTo:d_toPoint duration:duration];
    [[self playerD] runAction:movePlayerD];
    
    //C
    CGPoint c_toPoint = CGPointMake(0, [self playerC].position.y);
    
    distance = [self playerC].position.x-c_toPoint.x ;
    duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
    
    SKAction *movePlayerC = [SKAction moveTo:c_toPoint duration:duration];
    
    [[self playerC] runAction:movePlayerC completion:^ {
        CGPoint c_toPoint = CGPointMake([self playerC].position.x, PIXEL_WIDTHHEIGHT*scale);
        
        CGFloat distance = c_toPoint.y-[self playerC].position.y ;
        CGFloat duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
        
        SKAction *movePlayerC2 = [SKAction moveTo:c_toPoint duration:duration];
        [[self playerC] runAction:movePlayerC2 completion:^ {
            
            player_current_border = BORDER_LEFT;
            isPlayerTransforming = FALSE;
            
            [self moveUp];
        }];
    }];
}


-(void)playerTransfromLeftToTop {
    isPlayerTransforming=TRUE;
    //B
    CGPoint b_toPoint = CGPointMake(PIXEL_WIDTHHEIGHT_x2*scale, [self playerB].position.y);
    
    CGFloat distance = b_toPoint.x-[self playerB].position.x ;
    CGFloat duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
    
    SKAction *movePlayerB = [SKAction moveTo:b_toPoint duration:duration];
    [[self playerB] runAction:movePlayerB];
    
    //D
    CGPoint d_toPoint = CGPointMake([self playerD].position.x, PIXEL_WIDTHHEIGHT_x2*scale);
    
    distance = d_toPoint.y - [self playerD].position.y ;
    duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
    
    SKAction *movePlayerD = [SKAction moveTo:d_toPoint duration:duration];
    [[self playerD] runAction:movePlayerD];
    
    //C
    CGPoint c_toPoint = CGPointMake([self playerC].position.x,PIXEL_WIDTHHEIGHT_x2*scale);
    
    distance = c_toPoint.y - [self playerC].position.y ;
    duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
    
    SKAction *movePlayerC = [SKAction moveTo:c_toPoint duration:duration];
    [[self playerC] runAction:movePlayerC completion:^ {
        CGPoint c_toPoint = CGPointMake(PIXEL_WIDTHHEIGHT*scale,[self playerC].position.y);
        
        CGFloat distance = c_toPoint.x-[self playerC].position.x ;
        CGFloat duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
        
        SKAction *movePlayerC2 = [SKAction moveTo:c_toPoint duration:duration];
        [[self playerC] runAction:movePlayerC2 completion:^ {
            player_current_border = BORDER_TOP;
            isPlayerTransforming = FALSE;
            
            [self moveRight];
        }];
    }];
    
    [[self playerC] runAction:movePlayerC];
}

-(void)playerTransfromTopToRight {
    isPlayerTransforming=TRUE;
    //B
    CGPoint b_toPoint = CGPointMake([self playerB].position.x, 0);
    
    CGFloat distance = [self playerB].position.y-b_toPoint.x ;
    CGFloat duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
    
    SKAction *movePlayerB = [SKAction moveTo:b_toPoint duration:duration];
    [[self playerB] runAction:movePlayerB];
    
    //D
    CGPoint d_toPoint = CGPointMake(PIXEL_WIDTHHEIGHT_x2*scale, [self playerD].position.y);
    
    distance = d_toPoint.x - [self playerD].position.x ;
    duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
    
    SKAction *movePlayerD = [SKAction moveTo:d_toPoint duration:duration];
    [[self playerD] runAction:movePlayerD];
    
    //C
    CGPoint c_toPoint = CGPointMake(PIXEL_WIDTHHEIGHT_x2*scale,[self playerC].position.y);
    
    distance = c_toPoint.x - [self playerC].position.x ;
    duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
    
    SKAction *movePlayerC = [SKAction moveTo:c_toPoint duration:duration];
    [[self playerC] runAction:movePlayerC completion:^ {
        CGPoint c_toPoint = CGPointMake([self playerC].position.x,PIXEL_WIDTHHEIGHT*scale);
        
        CGFloat distance = [self playerC].position.y-c_toPoint.y ;
        CGFloat duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
        
        SKAction *movePlayerC2 = [SKAction moveTo:c_toPoint duration:duration];
        [[self playerC] runAction:movePlayerC2 completion:^ {
            player_current_border = BORDER_RIGHT;
            isPlayerTransforming = FALSE;
            
            [self moveDown];
        }];
    }];
    
    [[self playerC] runAction:movePlayerC];
}

-(void)playerTransfromRightToBottom {
    isPlayerTransforming=TRUE;
    //B
    CGPoint b_toPoint = CGPointMake(0,[self playerB].position.y);
    
    CGFloat distance = [self playerB].position.x-b_toPoint.x ;
    CGFloat duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
    
    SKAction *movePlayerB = [SKAction moveTo:b_toPoint duration:duration];
    [[self playerB] runAction:movePlayerB];
    
    //D
    CGPoint d_toPoint = CGPointMake([self playerD].position.x, 0);
    
    distance = [self playerD].position.y - d_toPoint.y;
    duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
    
    SKAction *movePlayerD = [SKAction moveTo:d_toPoint duration:duration];
    [[self playerD] runAction:movePlayerD];
    
    //C
    CGPoint c_toPoint = CGPointMake([self playerC].position.x, 0);
    
    distance = [self playerC].position.y-c_toPoint.y ;
    duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
    
    SKAction *movePlayerC = [SKAction moveTo:c_toPoint duration:duration];
    [[self playerC] runAction:movePlayerC completion:^ {
        CGPoint c_toPoint = CGPointMake(PIXEL_WIDTHHEIGHT*scale,[self playerC].position.y);
        
        CGFloat distance = [self playerC].position.x-c_toPoint.x ;
        CGFloat duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
        
        SKAction *movePlayerC2 = [SKAction moveTo:c_toPoint duration:duration];
        [[self playerC] runAction:movePlayerC2 completion:^ {
            player_current_border = BORDER_BOTTOM;
            isPlayerTransforming = FALSE;
            
            [self moveLeft];
        }];
    }];
    
    [[self playerC] runAction:movePlayerC];
}

//counter clockwise
-(void)playerTransfromBottomToRight {
    isPlayerTransforming=TRUE;
    //B
    CGPoint b_toPoint = CGPointMake(PIXEL_WIDTHHEIGHT_x2*scale, [self playerB].position.y);
    
    CGFloat distance = b_toPoint.x-[self playerB].position.x ;
    CGFloat duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
    
    SKAction *movePlayerB = [SKAction moveTo:b_toPoint duration:duration];
    [[self playerB] runAction:movePlayerB];
    
    //D
    CGPoint d_toPoint = CGPointMake([self playerD].position.x,PIXEL_WIDTHHEIGHT_x2*scale);
    
    distance = d_toPoint.y- [self playerD].position.y;
    duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
    
    SKAction *movePlayerD = [SKAction moveTo:d_toPoint duration:duration];
    [[self playerD] runAction:movePlayerD];
    
    //C
    CGPoint c_toPoint = CGPointMake(PIXEL_WIDTHHEIGHT_x2*scale,[self playerC].position.y );
    
    distance = c_toPoint.x-[self playerC].position.x;
    duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
    
    SKAction *movePlayerC = [SKAction moveTo:c_toPoint duration:duration];
    [[self playerC] runAction:movePlayerC completion:^ {
        CGPoint c_toPoint = CGPointMake([self playerC].position.x, PIXEL_WIDTHHEIGHT*scale);
        
        CGFloat distance = c_toPoint.y-[self playerC].position.y ;
        CGFloat duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
        
        SKAction *movePlayerC2 = [SKAction moveTo:c_toPoint duration:duration];
        [[self playerC] runAction:movePlayerC2 completion:^ {
            player_current_border = BORDER_RIGHT;
            isPlayerTransforming = FALSE;
            
            [self moveUp];
        }];
    }];
}

-(void)playerTransfromRightToTop {
    isPlayerTransforming=TRUE;
    //B
    CGPoint b_toPoint = CGPointMake([self playerB].position.x,PIXEL_WIDTHHEIGHT_x2*scale);
    
    CGFloat distance = b_toPoint.y-[self playerB].position.y ;
    CGFloat duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
    
    SKAction *movePlayerB = [SKAction moveTo:b_toPoint duration:duration];
    [[self playerB] runAction:movePlayerB];
    
    //D
    CGPoint d_toPoint = CGPointMake(0,[self playerD].position.y);
    
    distance = [self playerD].position.x-d_toPoint.x;
    duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
    
    SKAction *movePlayerD = [SKAction moveTo:d_toPoint duration:duration];
    [[self playerD] runAction:movePlayerD];
    
    //C
    CGPoint c_toPoint = CGPointMake([self playerC].position.x, PIXEL_WIDTHHEIGHT_x2*scale);
    
    distance = c_toPoint.y-[self playerC].position.y;
    duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
    
    SKAction *movePlayerC = [SKAction moveTo:c_toPoint duration:duration];
    [[self playerC] runAction:movePlayerC completion:^ {
        CGPoint c_toPoint = CGPointMake(PIXEL_WIDTHHEIGHT*scale,[self playerC].position.y );
        
        CGFloat distance = [self playerC].position.x-c_toPoint.x;
        CGFloat duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
        
        SKAction *movePlayerC2 = [SKAction moveTo:c_toPoint duration:duration];
        [[self playerC] runAction:movePlayerC2 completion:^ {
            player_current_border = BORDER_TOP;
            isPlayerTransforming = FALSE;
            
            [self moveLeft];
        }];
    }];
}

-(void)playerTransfromTopToLeft {
    isPlayerTransforming=TRUE;
    //B
    CGPoint b_toPoint = CGPointMake(0,[self playerB].position.y);
    
    CGFloat distance = [self playerB].position.x-b_toPoint.x ;
    CGFloat duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
    
    SKAction *movePlayerB = [SKAction moveTo:b_toPoint duration:duration];
    [[self playerB] runAction:movePlayerB];
    
    //D
    CGPoint d_toPoint = CGPointMake([self playerD].position.x,0);
    
    distance = [self playerD].position.y-d_toPoint.y;
    duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
    
    SKAction *movePlayerD = [SKAction moveTo:d_toPoint duration:duration];
    [[self playerD] runAction:movePlayerD];
    
    //C
    CGPoint c_toPoint = CGPointMake(0,[self playerC].position.y);
    
    distance = [self playerC].position.x-c_toPoint.x;
    duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
    
    SKAction *movePlayerC = [SKAction moveTo:c_toPoint duration:duration];
    [[self playerC] runAction:movePlayerC completion:^ {
        CGPoint c_toPoint = CGPointMake([self playerC].position.x,PIXEL_WIDTHHEIGHT*scale);
        
        CGFloat distance = [self playerC].position.x-c_toPoint.x;
        CGFloat duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
        
        SKAction *movePlayerC2 = [SKAction moveTo:c_toPoint duration:duration];
        [[self playerC] runAction:movePlayerC2 completion:^ {
            player_current_border = BORDER_LEFT;
            isPlayerTransforming = FALSE;
            
            [self moveDown];
        }];
    }];
}

-(void)playerTransfromLeftToBottom {
    isPlayerTransforming=TRUE;
    //B
    CGPoint b_toPoint = CGPointMake([self playerB].position.x,0);
    
    CGFloat distance = [self playerB].position.y-b_toPoint.y ;
    CGFloat duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
    
    SKAction *movePlayerB = [SKAction moveTo:b_toPoint duration:duration];
    [[self playerB] runAction:movePlayerB];
    
    //D
    CGPoint d_toPoint = CGPointMake(PIXEL_WIDTHHEIGHT_x2*scale,[self playerD].position.y);
    
    distance = [self playerD].position.y-d_toPoint.y;
    duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
    
    SKAction *movePlayerD = [SKAction moveTo:d_toPoint duration:duration];
    [[self playerD] runAction:movePlayerD];
    
    //C
    CGPoint c_toPoint = CGPointMake([self playerB].position.x,0);
    
    distance = [self playerC].position.y-c_toPoint.y;
    duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
    
    SKAction *movePlayerC = [SKAction moveTo:c_toPoint duration:duration];
    [[self playerC] runAction:movePlayerC completion:^ {
        CGPoint c_toPoint = CGPointMake(PIXEL_WIDTHHEIGHT*scale,[self playerC].position.y);
        
        CGFloat distance = c_toPoint.x-[self playerC].position.x;
        CGFloat duration = distance/SPEED*TRANSFORM_SPEED_FACTOR;
        
        SKAction *movePlayerC2 = [SKAction moveTo:c_toPoint duration:duration];
        [[self playerC] runAction:movePlayerC2 completion:^ {
            player_current_border = BORDER_BOTTOM;
            isPlayerTransforming = FALSE;
            
            [self moveRight];
        }];
    }];
}


-(void)contactWith:(id<SPWGameObject>)gameObj {
    //player can only contact with monster
    
    //drop eneryg
    
    SPWMonsterA* monster = (SPWMonsterA*)gameObj;
    
    //monster explode
    [monster explode];
    
    
}

-(void)toggleFiring {
    is_firing = !is_firing;
}

-(BOOL)isFiring {
    return is_firing;
}

-(void)stop {
    
    if (!is_firing) {
        [self removeAllActions];
    }
}

-(BORDER)getCurrentBorder {
    return player_current_border;
}

@end
