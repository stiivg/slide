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
#define kTireAngleMaxLinear 1.0 //Maximum angle with linear tire scrub force

#define kCGBalance 0.5
#define kDebugPrint NO


@implementation SLTruckSprite

@synthesize rearSlipAngle;
@synthesize frontSlipAngle;
@synthesize rearTireForce;
@synthesize frontTireForce;
@synthesize rearForcePoint;
@synthesize frontForcePoint;
@synthesize tireStiffness;
@synthesize wheelBase;
@synthesize throttle;
@synthesize rearGrip;
@synthesize sliding;
@synthesize targetPoint;
@synthesize targetAngle;
@synthesize targetIsCleared;

SKSpriteNode *truck;

- (id)init {
    self = [self initWithIndex:0];
    
    return self;
}

#pragma mark - Initialization
- (id)initWithIndex:(int )index {
    if ( self = [super init] ) {
        
        // Load sprites
        
        SKTextureAtlas *spriteAtlas = [SLConversion textureAtlasNamed:@"sprites"];
        if (index == 0) {
            SKTexture *truckTexture = [spriteAtlas textureNamed:@"red_truck"];
            truck = [SKSpriteNode spriteNodeWithTexture:truckTexture];
            truck.userData = [[NSMutableDictionary alloc] init]; //for possible future use
            truck.name = @"RedTruck";
        } else {
            SKTexture *truckTexture = [spriteAtlas textureNamed:@"blue_truck"];
            truck = [SKSpriteNode spriteNodeWithTexture:truckTexture];
            truck.userData = [[NSMutableDictionary alloc] init]; //for possible future use
            truck.name = @"BlueTruck";

        }
        
        SKTexture *shadowTexture = [spriteAtlas textureNamed:@"shadow"];
        truckShadow = [SKSpriteNode spriteNodeWithTexture:shadowTexture];
        SKTexture *wheelTexture = [spriteAtlas textureNamed:@"wheel"];
        leftWheel = [SKSpriteNode spriteNodeWithTexture:wheelTexture];
        rightWheel = [SKSpriteNode spriteNodeWithTexture:wheelTexture];

        truckShadow.position = [SLConversion scalePoint:CGPointMake(2, 2)];
        [self addChild:truckShadow];
        
        leftWheel.position = [SLConversion scalePoint:CGPointMake(8, 6)];
        rightWheel.position = [SLConversion scalePoint:CGPointMake(8, -6)];
        
        
        [self addChild:truck];
        [self addChild:leftWheel];
        [self addChild:rightWheel];
        
        
        [self initPhysics];
        self.zRotation = M_PI_2;
        
        throttle = 0.0;  //idling
        sliding = NO;
        
        //open debug file
        if (kDebugPrint) {
            NSString *filePath = @"/Users/stevengallagher/Documents/SlideGame/slide/debug.tsv";
            debugFile = fopen([filePath cStringUsingEncoding:NSUTF8StringEncoding], "w");
            fprintf(debugFile, "velX\tvelY\tvelAngle\tsideSlip\twSpeed\trearSlipAngle\tfrontSlipAngle\tFrontSteer\trearTireX\trearTireY\tfrontTireX\tfrontTireY\n");
            
        }

        
        return self;
    } else
        return nil;
}


- (SLPivotPoint*)targetPoint {
    return targetPoint;
}

//Save the new target angle when the target is set
- (void)setTargetPoint:(SLPivotPoint*)target {
    targetPoint = target;

    targetAngle = atan2f(self.position.y-target.centre.y, self.position.x - target.centre.x);
    targetIsCleared = false;
}

//test angle within PI CCW of prev, and within PI CW of next
-(BOOL)passedAngle:(CGFloat)test prevAngle:(CGFloat)prev nextAngle:(CGFloat)next clockwise:(BOOL)CW{
    CGFloat deltaPrev = [self limitToPI:test-prev];
    if (CW) {
        deltaPrev = -deltaPrev;
    }
    if (deltaPrev >= 0) {
        CGFloat deltaNext= [self limitToPI:test-next];
        if (CW) {
            deltaNext = -deltaNext;
        }
        if (deltaNext <= 0) {
            return true;
        }
    }
    return false;
}

//True when car has cleared target and passed transition angle
-(BOOL)hasTransitionedTarget {
    CGFloat lastAngle = targetAngle;
    targetAngle = atan2f(self.position.y-targetPoint.centre.y, self.position.x - targetPoint.centre.x);

    if (targetIsCleared) {
        if ([self passedAngle:targetPoint.transitionAngle prevAngle:lastAngle nextAngle:targetAngle clockwise:targetPoint.CW]) {
            return true;
        }
    } else {
        if ([self passedAngle:targetPoint.clearAngle prevAngle:lastAngle nextAngle:targetAngle clockwise:targetPoint.CW]) {
            targetIsCleared = true;
            return false;
        }
        
    }
    return false;
}


/*
 Use the same mass for the car in all sizes.
 The tire scrub and engine forces are x2 for iPad
 */
- (void)initPhysics {
    wheelBase = 0.19;
    tireStiffness = 700;
    rearGrip = 0.25; //rear front balance

//    CGSize size = self.size; // size is 0,0 !!
    //Use Cener to move mass relative to node texture
//    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:[SLConversion scaleSize:CGSizeMake(24, 29)]
//                                                       center:CGPointMake(-10, 0)];
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:[SLConversion scaleSize:CGSizeMake(24, 15)]];
    self.physicsBody.affectedByGravity = false;
    self.physicsBody.angularDamping = 0.1;
    self.physicsBody.mass = 0.25; //Mass the same for all scaled sizes
//    CGFloat masstest =  self.physicsBody.mass; //was 0.247466668
}

- (void)prepareToDraw {
    //Move shadow depending on rotation
    CGFloat rotation = self.zRotation + M_PI_2;
    truckShadow.position =  [SLConversion scalePoint:CGPointMake(2*cos(rotation), -2*sin(rotation))];
}

-(void)start {
    self.physicsBody.angularVelocity = 0;
    self.physicsBody.velocity = CGVectorMake(0, 0);
    self.zRotation = M_PI_2;

}

-(void)startSlide {
    sliding = Initiating;
    self.throttle = self.throttle*2;
    //Start rotating and steer in direction of velocity
//    CGFloat impulseTorque = [SLConversion scaleFloat:0.2];
//    [self.physicsBody applyAngularImpulse:impulseTorque];
}

-(void)endSlide {
    sliding = NotSliding;
    self.throttle = self.throttle/2;
}

//Convert angles > pi to +/-pi range
-(CGFloat)limitToPI:(CGFloat)angle {
    if (angle > 0 & angle > M_PI) {
        angle = angle - M_PI - M_PI; //large pos -> small neg
    } else if (angle <0 & angle < -M_PI) {
        angle = angle + M_PI + M_PI; //large neg -> small pos
    }
    
    return angle;
}

-(void)applySteering:(CGFloat)steerAngle {
    //Limit the steering angle
    if (steerAngle > 0) {
        steerAngle = fminf(steerAngle, kMaxSteerAngle);
    } else {
        steerAngle = fmaxf(steerAngle, -kMaxSteerAngle);
    }
    leftWheel.zRotation = steerAngle;
    rightWheel.zRotation = steerAngle;
    
}

-(void)steerToTarget:(CGFloat)steerHeading {
    
    if (sliding == NotSliding) {
        //if not sliding steer to target
        //steerHeading is zero to east increasing counter clockwise in range +/- PI
        CGFloat steerAngle = steerHeading - self.zRotation;
        steerAngle = [self limitToPI:steerAngle];
        
        [self applySteering:steerAngle];
        
    } else if (sliding == Initiating) {
        //Steer in direction of velocity
        CGVector velocity = self.physicsBody.velocity;
        CGFloat velocityAngle =  atan2f(velocity.dy, velocity.dx);
        CGFloat sideSlipAngle = velocityAngle - self.zRotation; //angle of truck to direction of travel
        sideSlipAngle = [self limitToPI:sideSlipAngle];
        [self applySteering:sideSlipAngle];
        
        //Keep rotating until at max steer slide
        if (fabsf(sideSlipAngle) < kMaxSteerAngle) {
            CGFloat torque = [SLConversion scaleFloat:0.2];
            torque = [SLConversion scaleFloat:torque]; // Torque is 4x for iPad
            [self.physicsBody applyTorque:torque];
        }
        
    }
    [self applyEngineForce];
    
    CGVector velocity = self.physicsBody.velocity;
    CGFloat velLength = sqrtf(velocity.dx * velocity.dx + velocity.dy * velocity.dy);
    
    if (velLength > 0.0) {
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

-(CGFloat)calcSlipAngle:(CGFloat)sideSlipAngle cgDistance:(CGFloat)distance {
    CGFloat angVel = self.physicsBody.angularVelocity;
    CGFloat wSpeed = angVel * distance;
    CGFloat slipAngle = atan2f(sinf(sideSlipAngle) + wSpeed, cosf(sideSlipAngle));
    return slipAngle;
}

/* 
 Convert the angle the tire is scrubbing over the ground to a scrub force
 magnitude. The scrub force is applied perpendicular to the rolling direction.
 Grip is used to proportion the front and rear scrub force.
 */
-(CGFloat)calcScrubForce:(CGFloat)slipAngle tireGrip:(CGFloat)grip {
    CGFloat scrubForce = tireStiffness;
    CGFloat smallSlipAngle = slipAngle;
    if(smallSlipAngle < 0 ) {
        scrubForce = -tireStiffness;
        if (smallSlipAngle < -M_PI_2) {
            smallSlipAngle = -M_PI - smallSlipAngle;
        }
    } else {
        if (smallSlipAngle > M_PI_2) {
            smallSlipAngle = M_PI - smallSlipAngle;
        }
    }
    
    if(fabsf(smallSlipAngle) < kTireAngleMaxLinear) {
        scrubForce = (smallSlipAngle / kTireAngleMaxLinear) * tireStiffness;
    }

    scrubForce = grip*[SLConversion scaleFloat:scrubForce]; //apply grip
    
    return scrubForce;
}

//All physics forces are in scene coordinates for force vector and position
//Use truck position and rotation to apply force in the correct position on the truck
-(CGPoint)applyTireForce:(CGVector)tireForce cgDistance:(CGFloat)cgDistance{
    cgDistance = [SLConversion scaleFloat:cgDistance];
    CGPoint forcePoint = CGPointMake(self.position.x+cgDistance*cosf(self.zRotation),
                                 self.position.y+cgDistance*sinf(self.zRotation));
    [self.physicsBody applyForce:tireForce atPoint:forcePoint];
    return forcePoint;
}


-(void)applyForces {
    //calc the truck side slip angle - angle of truck heading to velocity direction
    //truck heading +CCW from velocity heading
    CGVector velocity = self.physicsBody.velocity;
    CGFloat velocityAngle =  atan2f(velocity.dy, velocity.dx);
    CGFloat sideSlipAngle = velocityAngle - self.zRotation; //angle of truck to direction of travel
    sideSlipAngle = [self limitToPI:sideSlipAngle];
    
    
    rearSlipAngle = [self calcSlipAngle:sideSlipAngle cgDistance:(kCGBalance-1)*wheelBase];
    frontSlipAngle = [self calcSlipAngle:sideSlipAngle cgDistance:kCGBalance*wheelBase];
    
    //apply steering to front slip angle
    CGFloat frontSlipSteerAngle = frontSlipAngle - leftWheel.zRotation;
    
    CGFloat rearScrubForce = [self calcScrubForce:rearSlipAngle tireGrip:self.rearGrip];
    
    //truck y direction
    CGFloat torqueForceDirection = self.zRotation - M_PI_2;
    
    //apply the rear torque force in truck y direction only
    rearTireForce = CGVectorMake(rearScrubForce*cosf(torqueForceDirection),
                                         rearScrubForce*sinf(torqueForceDirection));

    CGFloat cgDistance = [SLConversion scaleFloat:-12];
    rearForcePoint = CGPointMake(self.position.x+cgDistance*cosf(self.zRotation),
                                     self.position.y+cgDistance*sinf(self.zRotation));
    
    //calc the front scrub force
    CGFloat frontScrubForce = [self calcScrubForce:frontSlipSteerAngle tireGrip:1 - self.rearGrip];
    
    //Add the steering angle to the torque force direction
    CGFloat frontForceDirection = leftWheel.zRotation + torqueForceDirection;
    
    //apply front scrub force perpendicular to the wheel
    frontTireForce = CGVectorMake(frontScrubForce*cosf(frontForceDirection),
                                  frontScrubForce*sinf(frontForceDirection));
    
    cgDistance = [SLConversion scaleFloat:12];
    frontForcePoint = CGPointMake(self.position.x+cgDistance*cosf(self.zRotation),
                                 self.position.y+cgDistance*sinf(self.zRotation));

    //Smaller number damps forces more
    CGFloat limit = -8; //16 just starts to oscillate on rotations.
    
    //scale the forces to prevent zero crossing of velocity
    //Test for max force to apply here F = -mdv/dt = -dv 0.25 / 1/60 = -dv*15
    //Add rotation speed to trans vel and scale front and rear forces separately
    CGFloat velLength = sqrtf(velocity.dx * velocity.dx + velocity.dy * velocity.dy);
    CGFloat transVel = velLength*sinf(sideSlipAngle); //velocity sideways to truck
    CGFloat wSpeed = self.physicsBody.angularVelocity*wheelBase/2;
    CGFloat maxTransForce = (transVel - wSpeed) * limit;
    CGFloat rearTireForceLength = vectorLength(rearTireForce);
    //tire force positive if rear slip angle negative
    if (rearSlipAngle > 0) {
        rearTireForceLength *= -1;
    }
    
    CGFloat forceScale = maxTransForce / rearTireForceLength;
    //both same sign and force > max allowed
    if (0 < forceScale & forceScale <=1) {
        rearTireForce.dx = rearTireForce.dx * forceScale;
        rearTireForce.dy = rearTireForce.dy * forceScale;
    }
    
    //Test velocity in direction of tire force
    transVel = velLength*sinf(sideSlipAngle - leftWheel.zRotation); //velocity sideways to front tire
    maxTransForce = (transVel + wSpeed*cosf(leftWheel.zRotation)) * limit;
    CGFloat frontTireForceLength = vectorLength(frontTireForce);
    
    if (frontSlipSteerAngle > 0) {
        frontTireForceLength *= -1;
    }
    forceScale = maxTransForce / frontTireForceLength;
    
    if (0 < forceScale & forceScale <=1) {
        frontTireForce.dx = frontTireForce.dx * forceScale;
        frontTireForce.dy = frontTireForce.dy * forceScale;
    }
    
    

    [self.physicsBody applyForce:rearTireForce atPoint:rearForcePoint];
    [self.physicsBody applyForce:frontTireForce atPoint:frontForcePoint];

    if (kDebugPrint) {
        CGFloat angVel = self.physicsBody.angularVelocity;
        
        fprintf(debugFile, "%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n", velocity.dx,velocity.dy, velocityAngle, sideSlipAngle, angVel, rearSlipAngle, frontSlipAngle,frontSlipSteerAngle,
                rearTireForce.dx,rearTireForce.dy,frontTireForce.dx,frontTireForce.dy);
    }
}
















@end
