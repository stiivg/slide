//
//  SLRaceScene.h
//  Slide
//

//  Copyright (c) 2014 Steven Gallagher. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "HermitePath.h"
#import "SLTruckSprite.h"
#import "VectorUtils.h"
#import "SLDebugControls.h"

#define kMaxRoadKeyPoints 1000

@interface SLRaceScene : SKScene {
    CGPoint pathPoints[kMaxRoadKeyPoints];
    SLTruckSprite *truck;
    SKSpriteNode *centerWall;
    SKSpriteNode *drum1;
    SKSpriteNode *drum2;
    NSArray *pivotPoints;
    CGFloat steerHeading;
    SLDebugControls *debugControls;
}
@property SKNode*  debugOverlay;
@property SLDebugControls*  controlOverlay;

- (void)initPhysics;


@end
