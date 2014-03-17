//
//  SLMyScene.h
//  Slide
//

//  Copyright (c) 2014 Steven Gallagher. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "HermitePath.h"

#define kMaxRoadKeyPoints 1000

@interface SLRaceScene : SKScene {
    CGPoint pathPoints[kMaxRoadKeyPoints];
}

@end
