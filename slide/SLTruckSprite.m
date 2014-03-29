//
//  SLTruckSprite.m
//  slide
//
//  Created by Steven Gallagher on 3/11/14.
//  Copyright (c) 2014 Steven Gallagher. All rights reserved.
//

#import "SLTruckSprite.h"

@implementation SLTruckSprite

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
    //self.physicsBody.velocity = CGVectorMake(0, 10);
    [self.physicsBody applyImpulse:CGVectorMake(0, 10)];
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
    
}

-(void)applyForces {
    
}


@end
