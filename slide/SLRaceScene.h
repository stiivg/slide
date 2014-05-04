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
#import "SLConversion.h"
#import "SLPivotPoint.h"



@interface SLRaceScene : SKScene <UIGestureRecognizerDelegate> {
    SLTruckSprite *truck;
    NSArray *pivotPoints;
    SKSpriteNode *slideButton;
    CGFloat steerHeading;
    SLDebugControls *debugControls;
    
    UISwipeGestureRecognizer* swipeRightGesture;

}
@property SKNode*  debugOverlay;

- (void)initPhysics;


@end
