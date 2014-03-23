//
//  SLMyScene.h
//  Slide
//

//  Copyright (c) 2014 Steven Gallagher. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "HermitePath.h"
#import "SLTruckSprite.h"


#define kMaxRoadKeyPoints 1000

@interface SLRaceScene : SKScene {
    CGPoint pathPoints[kMaxRoadKeyPoints];
    SLTruckSprite *truck;
    SKSpriteNode *centerWall;
}

- (void)initPhysics;

@end
