//
//  SLTruckSprite.h
//  slide
//
//  Created by Steven Gallagher on 3/11/14.
//  Copyright (c) 2014 Steven Gallagher. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#define kMaxSteerAngle 1.0f

@interface SLTruckSprite : SKSpriteNode {
    SKSpriteNode *truckShadow;
    SKSpriteNode *leftWheel;
    SKSpriteNode *rightWheel;
}

- (void)steerToTarget:(CGFloat)steerHeading;
- (void)prepareToDraw;
- (void)initPhysics;
- (void)start;

@end

