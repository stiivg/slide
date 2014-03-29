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
#define kTireStiffness 200


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
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:truckTexture];
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
        [self addChild:sprite];
        
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
    
    //calc the lateral velocity angle for torque force direction
    CGFloat latVelAngle = velocityAngle+M_PI_2;
    
    //calc the rear scrub force
    CGFloat scrubForce = kTireStiffness*fabsf(rearSlipAngle);
    if (fabsf(rearSlipAngle) > 0.05) {
        scrubForce = kTireStiffness*0.05;
    }
    
    //apply the rear torque force
    rearTireForce = CGVectorMake(scrubForce*cosf(latVelAngle), scrubForce*sinf(latVelAngle));
//    [self.physicsBody applyForce:rearTireForce atPoint:CGPointMake(0, 29)];
    
    //calc the front scrub force
    scrubForce = kTireStiffness*fabsf(frontSlipAngle);
    if (fabsf(frontSlipAngle) > 0.05) {
        scrubForce = kTireStiffness*0.05;
    }
    
    //apply front scrub torque force
    frontTireForce = CGVectorMake(-scrubForce*cosf(latVelAngle), -scrubForce*sinf(latVelAngle));
//    [self.physicsBody applyForce:frontTireForce atPoint:CGPointMake(96, 29)];
}

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
    directionLine.strokeColor = [SKColor colorWithRed:1.0 green:1.0 blue:0 alpha:0.5];
    directionLine.lineWidth = 0.1;
    CGPathRelease(path);
    
    [self.debugOverlay addChild: directionLine];
    
}

-(void)removeDebugNodes {
    //Temporarily remove debug nodes
    [self.debugOverlay removeFromParent];
    [self.debugOverlay removeAllChildren];
    
}

-(void)debugDrawForceVectors {
    [self debugDrawDirectionVector:frontSlipAngle length:50 position:CGPointMake(48, 0)];
    [self debugDrawDirectionVector:rearSlipAngle length:50 position:CGPointMake(-48, 0)];
    
//    [self debugDrawDirectionVector:truck.frontTireForce length:50];
//    [self debugDrawDirectionVector:truck.rearTireForce length:50];
//    
}

-(void)displayDebug {
    //Display debug nodes
    [self addChild:self.debugOverlay];
    [self debugDrawForceVectors];
}

















@end
