//
//  SLTruckSprite.m
//  slide
//
//  Created by Steven Gallagher on 3/11/14.
//  Copyright (c) 2014 Steven Gallagher. All rights reserved.
//

#import "SLTruckSprite.h"
#import "VectorUtils.h"
#import "SLConversion.h"

#define kMaxSteerAngle 1.0f
#define kTireAngleMaxLinear 0.9 //Maximum angle with linear tire scrub force

#define kCGBalance 0.5


@implementation SLTruckSprite

@synthesize rearSlipAngle;
@synthesize frontSlipAngle;
@synthesize rearTireForce;
@synthesize frontTireForce;
@synthesize lateralForce;
@synthesize rearForcePoint;
@synthesize frontForcePoint;
@synthesize tireStiffness;
@synthesize wheelBase;
@synthesize throttle;
@synthesize rearGrip;

#pragma mark - Initialization
- (id)init {
    if ( self = [super init] ) {
        
        // Load sprites
        
        SKTextureAtlas *spriteAtlas = [SLConversion textureAtlasNamed:@"sprites"];
        SKTexture *truckTexture = [spriteAtlas textureNamed:@"red_truck"];
        SKSpriteNode *truck = [SKSpriteNode spriteNodeWithTexture:truckTexture];
        truck.userData = [[NSMutableDictionary alloc] init]; //for possible future use
        truck.name = @"RedTruck";
        
        SKTexture *shadowTexture = [spriteAtlas textureNamed:@"shadow"];
        truckShadow = [SKSpriteNode spriteNodeWithTexture:shadowTexture];
        SKTexture *wheelTexture = [spriteAtlas textureNamed:@"wheel"];
        leftWheel = [SKSpriteNode spriteNodeWithTexture:wheelTexture];
        rightWheel = [SKSpriteNode spriteNodeWithTexture:wheelTexture];

        truckShadow.position = [SLConversion scalePoint:CGPointMake(4, 4)];
        [self addChild:truckShadow];
        
        leftWheel.position = [SLConversion scalePoint:CGPointMake(15, 12)];
        rightWheel.position = [SLConversion scalePoint:CGPointMake(15, -12)];
        
        
        [self addChild:leftWheel];
        [self addChild:rightWheel];
        [self addChild:truck];
        
        
        [self initPhysics];
        self.zRotation = M_PI_2;
        
        throttle = 0.0;  //idling
        
        return self;
    } else
        return nil;
}


/*
 Use the same mass for the car in all sizes.
 The tire scrub and engine forces are x2 for iPad
 */
- (void)initPhysics {
    wheelBase = 0.14;
    tireStiffness = 400;
    rearGrip = 0.5; //rear front balance

//    CGSize size = self.size; // size is 0,0 !!
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:[SLConversion scaleSize:CGSizeMake(48, 29)]];
    self.physicsBody.affectedByGravity = false;
    self.physicsBody.angularDamping = 0.0;
    self.physicsBody.mass = 0.25; //Mass the same for all scaled sizes
    CGFloat masstest =  self.physicsBody.mass; //was 0.247466668
}

- (void)prepareToDraw {
    //Move shadow depending on rotation
    CGFloat rotation = self.zRotation + M_PI_2;
    truckShadow.position =  [SLConversion scalePoint:CGPointMake(4*cos(rotation), -4*sin(rotation))];
}

-(void)start {
    
//    self.throttle = [SLConversion scaleFloat:60];
    self.physicsBody.angularVelocity = 0;
    self.physicsBody.velocity = CGVectorMake(0, 0);
    self.zRotation = M_PI_2;

}

//Convert angles > pi to +/-pi range
-(CGFloat)convertAngle:(CGFloat)angle {
    if (angle > 0 & angle > M_PI) {
        angle = angle - M_PI - M_PI; //large pos -> small neg
    } else if (angle <0 & angle < -M_PI) {
        angle = angle + M_PI + M_PI; //large neg -> small pos
    }
    
    return angle;
}

-(void)steerToTarget:(CGFloat)steerHeading {
    //steerHeading is zero to east increasing counter clockwise in range +/- PI
    CGFloat steerAngle = steerHeading - self.zRotation;
    steerAngle = [self convertAngle:steerAngle];
    
    //Limit the steering angle
    if (steerAngle > 0) {
        steerAngle = fminf(steerAngle, kMaxSteerAngle);
    } else {
        steerAngle = fmaxf(steerAngle, -kMaxSteerAngle);
    }
    
    leftWheel.zRotation = steerAngle;
    rightWheel.zRotation = steerAngle;
    
    [self applyEngineForce];
    
    CGVector velocity = self.physicsBody.velocity;
    CGFloat velLength = sqrtf(velocity.dx * velocity.dx + velocity.dy * velocity.dy);
    
    if (velLength > 1.0) {
        [self applyForces];
    }
}

-(void)applyEngineForce {
    //engine force in direction truck faces
    CGFloat truckDirection = self.zRotation;
    CGVector engineVector = CGVectorMake(throttle*cosf(truckDirection),
                                         throttle*sinf(truckDirection));
    [self.physicsBody applyForce:engineVector];
}


-(void)applyForces {
    //calc the truck side slip angle
    CGVector velocity = self.physicsBody.velocity;
    CGFloat velocityAngle =  atan2f(velocity.dy, velocity.dx);
    CGFloat sideSlipAngle = self.zRotation - velocityAngle; //angle of truck to direction of travel
    sideSlipAngle = [self convertAngle:sideSlipAngle];
    
    //calc the rear rotational slip angle
    CGFloat angVel = self.physicsBody.angularVelocity;
    CGFloat wc = angVel * (1-kCGBalance)*wheelBase;
    rearSlipAngle = (sinf(sideSlipAngle) + wc) / fabsf(cosf(sideSlipAngle));
    
    CGFloat wb = angVel * kCGBalance * wheelBase;
    frontSlipAngle = (sinf(sideSlipAngle) - wb) / fabsf(cosf(sideSlipAngle)) + leftWheel.zRotation;
    
    
    //calc the rear scrub force
    CGFloat rearScrubForce = tireStiffness*rearSlipAngle;
    if (rearSlipAngle > kTireAngleMaxLinear) {
        rearScrubForce = tireStiffness*kTireAngleMaxLinear;
    } else if (rearSlipAngle < -kTireAngleMaxLinear) {
        rearScrubForce = -tireStiffness*kTireAngleMaxLinear;
    }
    rearScrubForce = self.rearGrip*[SLConversion scaleFloat:rearScrubForce]; //apply rear grip
    
    //truck y direction
    CGFloat torqueForceDirection = self.zRotation + M_PI_2;
    
    //apply the rear torque force in truck y direction only
    rearTireForce = CGVectorMake(rearScrubForce*cosf(torqueForceDirection),
                                         rearScrubForce*sinf(torqueForceDirection));

    CGFloat rearDistance = [SLConversion scaleFloat:24];
    rearForcePoint = CGPointMake(self.position.x-rearDistance*cosf(self.zRotation),
                                 self.position.y-rearDistance*sinf(self.zRotation));
    [self.physicsBody applyForce:rearTireForce atPoint:rearForcePoint];
    
    //calc the front scrub force
    CGFloat frontScrubForce = tireStiffness*frontSlipAngle;
    if (frontSlipAngle > kTireAngleMaxLinear) {
        frontScrubForce = tireStiffness*kTireAngleMaxLinear;
    } else if (frontSlipAngle < -kTireAngleMaxLinear) {
        frontScrubForce = -tireStiffness*kTireAngleMaxLinear;
    }
    frontScrubForce = (1 - self.rearGrip)*[SLConversion scaleFloat:frontScrubForce];
    //Add the steering angle to the torque force direction
    CGFloat frontForceDirection = leftWheel.zRotation + torqueForceDirection;
    
    //apply front scrub force perpendicular to the wheel
    frontTireForce = CGVectorMake(frontScrubForce*cosf(frontForceDirection),
                                  frontScrubForce*sinf(frontForceDirection));
    
    //All physics forces are in scene coordinates for force vector and position
    //Use truck position and rotation to apply force in the correct position on the truck
    CGFloat frontDistance = [SLConversion scaleFloat:24];
    frontForcePoint = CGPointMake(self.position.x+frontDistance*cosf(self.zRotation),
                                  self.position.y+frontDistance*sinf(self.zRotation));
    [self.physicsBody applyForce:frontTireForce atPoint:frontForcePoint];
    
}


















@end
