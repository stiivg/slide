//
//  SLTruckSprite.m
//  slide
//
//  Created by Steven Gallagher on 3/11/14.
//  Copyright (c) 2014 Steven Gallagher. All rights reserved.
//

#import "SLTruckSprite.h"
#import "VectorUtils.h"

#define kMaxSteerAngle 1.0f
#define kTireStiffness 8
#define kTireAngleMaxLinear 0.5 //Maximum angle with linear tire scrub force


@implementation SLTruckSprite

@synthesize rearSlipAngle;
@synthesize frontSlipAngle;
@synthesize rearTireForce;
@synthesize frontTireForce;

#pragma mark - Initialization
- (id)init {
    if ( self = [super init] ) {
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"SlideImages"];
        SKTexture *truckTexture = [atlas textureNamed:@"red_truck"];
        SKSpriteNode *truck = [SKSpriteNode spriteNodeWithTexture:truckTexture];
        SKTexture *shadowTexture = [atlas textureNamed:@"shadow"];
        truckShadow = [SKSpriteNode spriteNodeWithTexture:shadowTexture];
        SKTexture *wheelTexture = [atlas textureNamed:@"wheel"];
        leftWheel = [SKSpriteNode spriteNodeWithTexture:wheelTexture];
        rightWheel = [SKSpriteNode spriteNodeWithTexture:wheelTexture];

        truckShadow.position = CGPointMake(4, 4);
        [self addChild:truckShadow];
        
        leftWheel.position = CGPointMake(30, 24);
        rightWheel.position = CGPointMake(30, -24);
        
        
        [self addChild:leftWheel];
        [self addChild:rightWheel];
        [self addChild:truck];
        
//        self.position = CGPointMake(494, 352);
        
        [self initPhysics];
        self.zRotation = M_PI_2;
        
        throttle = 0.0;  //idling
        cgBalance = 0.5; //center balanced
        
        //Create debug nodes
        self.debugOverlay = [SKNode node];
        [self addChild:self.debugOverlay];

        return self;
    } else
        return nil;
}

- (void)initPhysics {
//    CGSize size = self.size; // size is 0,0 !!
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(96, 58)];
    self.physicsBody.affectedByGravity = false;
    self.physicsBody.angularDamping = 0.4;
}

- (void)prepareToDraw {
    //Move shadow depending on rotation
    CGFloat rotation = self.zRotation + M_PI_2;
    truckShadow.position =  CGPointMake(8*cos(rotation), -8*sin(rotation));
}

-(void)start {
    throttle = 10.0;
}

-(void)steerToTarget:(CGFloat)steerHeading {
    //steerHeading is zero to east increasing counter clockwise in range +/- PI
    CGFloat steerAngle = steerHeading - self.zRotation;
    if (steerAngle > 0 & steerAngle > M_PI) {
        steerAngle = steerAngle - M_PI - M_PI; //large pos -> small neg
    } else if (steerAngle <0 & steerAngle < -M_PI) {
        steerAngle = steerAngle + M_PI + M_PI; //large neg -> small pos
    }
    
    if (steerAngle > 0) {
        steerAngle = fminf(steerAngle, kMaxSteerAngle);
    } else {
        steerAngle = fmaxf(steerAngle, -kMaxSteerAngle);
    }
    leftWheel.zRotation = steerAngle;
    rightWheel.zRotation = steerAngle;
    
    [self applyForces];
}

-(void)applyForces {
    //engine force in direction truck faces
    CGFloat truckDirection = self.zRotation;
    CGVector engineVector = CGVectorMake(throttle*cosf(truckDirection),
                                         throttle*sinf(truckDirection));
    [self.physicsBody applyForce:engineVector];
    
    //calc the truck slip angle
    CGVector velocity = self.physicsBody.velocity;
    CGFloat velocityAngle =  atan2f(velocity.dy, velocity.dx);
    CGFloat truckSlipAngle = truckDirection - velocityAngle; //angle of truck to direction of travel
    
    //calc the rear rotational slip angle
    CGFloat angVel = self.physicsBody.angularVelocity;
    rearSlipAngle = angVel * (1-cgBalance);
    
    //rear slip angle from velocity and rotation
    rearSlipAngle = rearSlipAngle + truckSlipAngle;
    
    
    //calc the front rotational slip angle
    frontSlipAngle = -angVel * cgBalance;
    
    //front slip angle from velocity, rotation and steering angle
    frontSlipAngle = frontSlipAngle + truckSlipAngle + leftWheel.zRotation;
    
    //calc the rear scrub force
    CGFloat scrubForce = kTireStiffness*rearSlipAngle;
    if (rearSlipAngle > kTireAngleMaxLinear) {
        scrubForce = kTireStiffness*kTireAngleMaxLinear;
    } else if (rearSlipAngle < -kTireAngleMaxLinear) {
        scrubForce = -kTireStiffness*kTireAngleMaxLinear;
    }
    
    //truck y direction
    CGFloat torqueForceDirection = truckDirection + M_PI_2;
    
    //apply the rear torque force in truck y direction only
    rearTireForce = CGVectorMake(scrubForce*cosf(torqueForceDirection),
                                         scrubForce*sinf(torqueForceDirection));
    
    [self.physicsBody applyForce:rearTireForce atPoint:CGPointMake(0, 29)];
    
    //calc the front scrub force
    scrubForce = kTireStiffness*frontSlipAngle;
    if (frontSlipAngle > kTireAngleMaxLinear) {
        scrubForce = kTireStiffness*kTireAngleMaxLinear;
    } else if (frontSlipAngle < -kTireAngleMaxLinear) {
        scrubForce = -kTireStiffness*kTireAngleMaxLinear;
    }
    
    //apply front scrub torque force in truck y direction only
    frontTireForce = CGVectorMake(scrubForce*cosf(torqueForceDirection),
                                 scrubForce*sinf(torqueForceDirection));
    [self.physicsBody applyForce:frontTireForce atPoint:CGPointMake(96, 29)];
}

#pragma mark debug drawing

-(void)debugDrawDirectionVector:(CGFloat)direction length:(CGFloat)length position:(CGPoint)position{
    SKShapeNode *directionLine = [[SKShapeNode alloc] init];
    directionLine.position = position;
    CGFloat directionX = length *cosf(direction);
    CGFloat directionY = length *sinf(direction);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0.0, 0.0);
    CGPathAddLineToPoint(path, 0, directionX, directionY);
    CGPathCloseSubpath(path);
    directionLine.path = path;
    directionLine.strokeColor = [SKColor colorWithRed:1.0 green:1.0 blue:0 alpha:0.5]; //Yellow
    directionLine.lineWidth = 0.1;
    CGPathRelease(path);
    
    [self.debugOverlay addChild: directionLine];
    
}

-(void)debugDrawVector:(CGVector)vector length:(CGFloat)length position:(CGPoint)position{
    SKShapeNode *vectorLine = [[SKShapeNode alloc] init];
    vectorLine.position = position;
    CGFloat directionX = 10*vector.dx;
    CGFloat directionY = 10*vector.dy;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0.0, 0.0);
    CGPathAddLineToPoint(path, 0, directionX, directionY);
    CGPathCloseSubpath(path);
    vectorLine.path = path;
    vectorLine.strokeColor = [SKColor colorWithRed:1.0 green:0.0 blue:0.5 alpha:1.0];
    vectorLine.lineWidth = 0.1;
    CGPathRelease(path);
    
    [self.debugOverlay addChild: vectorLine];
    
}

-(void)removeDebugNodes {
    //Temporarily remove debug nodes
    [self.debugOverlay removeFromParent];
    [self.debugOverlay removeAllChildren];
    
}

-(void)debugDrawForceVectors {
    [self debugDrawDirectionVector:frontSlipAngle length:50 position:CGPointMake(48, 0)];
    [self debugDrawDirectionVector:rearSlipAngle length:50 position:CGPointMake(-48, 0)];
    
}

-(void)displayDebug {
    //Display debug nodes
    [self addChild:self.debugOverlay];
    [self debugDrawForceVectors];
}

















@end
