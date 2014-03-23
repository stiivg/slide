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
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"red truck"];
        truckShadow = [SKSpriteNode spriteNodeWithImageNamed:@"shadow"];
        SKSpriteNode *leftWheel = [SKSpriteNode spriteNodeWithImageNamed:@"wheel"];
        SKSpriteNode *rightWheel = [SKSpriteNode spriteNodeWithImageNamed:@"wheel"];

        truckShadow.position = CGPointMake(4, 4);
        [self addChild:truckShadow];
        
        leftWheel.position = CGPointMake(-24, 30);
        rightWheel.position = CGPointMake(24, 30);
        
        
        [self addChild:leftWheel];
        [self addChild:rightWheel];
        [self addChild:sprite];
        
//        self.position = CGPointMake(494, 352);
        
        [self initPhysics];

        return self;
    } else
        return nil;
}

- (void)initPhysics {
//    CGSize size = self.size; // size is 0,0 !!
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(58, 96)];
    self.physicsBody.affectedByGravity = false;
}

- (void)prepareToDraw {
    CGFloat rotation = self.zRotation + M_PI_2;
    truckShadow.position =  CGPointMake(8*cos(rotation), -8*sin(rotation));
}

-(void)start {
    //self.physicsBody.velocity = CGVectorMake(0, 10);
    [self.physicsBody applyImpulse:CGVectorMake(0, 1)];
}

@end
