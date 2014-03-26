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

#define kMaxRoadKeyPoints 1000

@interface SLRaceScene : SKScene {
    CGPoint pathPoints[kMaxRoadKeyPoints];
    SLTruckSprite *truck;
    SKSpriteNode *centerWall;
    NSArray *pivotPoints;
}
@property SKNode*  debugOverlay;

- (void)initPhysics;


@end
