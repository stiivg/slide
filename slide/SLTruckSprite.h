//
//  SLTruckSprite.h
//  slide
//
//  Created by Steven Gallagher on 3/11/14.
//  Copyright (c) 2014 Steven Gallagher. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SLTruckSprite : SKSpriteNode {
    SKSpriteNode *truckShadow;
    SKSpriteNode *leftWheel;
    SKSpriteNode *rightWheel;
    CGFloat cgBalance; //0=rear, 1=front
    FILE *debugFile;
    
}
//+CCW relative to truck heading
@property CGFloat rearSlipAngle;
@property CGFloat frontSlipAngle;

@property CGVector rearTireForce;
@property CGVector frontTireForce;

@property CGPoint rearForcePoint;
@property CGPoint frontForcePoint;

@property CGVector lateralForce;
@property SKNode*  debugOverlay;

@property CGFloat tireStiffness;
@property CGFloat wheelBase;
@property CGFloat throttle;
@property CGFloat rearGrip;

-(void)steerToTarget:(CGFloat)steerHeading;
-(void)prepareToDraw;
-(void)initPhysics;
-(void)start;

@end

