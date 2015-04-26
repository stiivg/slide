//
//  SLTruckSprite.h
//  slide
//
//  Created by Steven Gallagher on 3/11/14.
//  Copyright (c) 2014 Steven Gallagher. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SLPivotPoint.h"

@interface SLTruckSprite : SKSpriteNode {
    SKSpriteNode *truckShadow;
    SKSpriteNode *leftWheel;
    SKSpriteNode *rightWheel;
    CGFloat cgBalance; //0=rear, 1=front
    FILE *debugFile;
    CGVector lastVelocity;
    CGFloat lastAngularVelocity;    
}

typedef NS_ENUM(NSUInteger, SlideState) {
    NotSliding,
    Initiating,
    Maintaining,
    Recovering
    
};

//+CCW relative to truck heading
@property CGFloat rearSlipAngle;
@property CGFloat frontSlipAngle;

@property CGVector rearTireForce;
@property CGVector frontTireForce;

@property CGPoint rearForcePoint;
@property CGPoint frontForcePoint;

@property SKNode*  debugOverlay;

@property CGFloat tireStiffness;
@property CGFloat wheelBase;
@property CGFloat throttle;
@property CGFloat rearGrip;
@property SlideState sliding;
@property SLPivotPoint* targetPoint;

//angle from the pivot point to the car
@property CGFloat targetAngle;

@property BOOL targetIsCleared;

-(id)initWithIndex:(int)index;
-(void)startSlide;
-(void)endSlide;
-(void)steerToTarget:(CGFloat)steerHeading;
-(void)prepareToDraw;
-(void)initPhysics;
-(void)start;
-(BOOL)hasTransitionedTarget;

@end

