//
//  SPWGameObject.h
//  SpaceWeaver
//
//  Created by Ronald Lee on 6/6/14.
//  Copyright (c) 2014 noisysubmarine. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SPWGameObject <NSObject>

-(void)contactWith:(id<SPWGameObject>)gameObj;

@end
