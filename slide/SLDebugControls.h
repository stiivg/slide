//
//  SLDebugControls.h
//  Slide
//
//  Created by Steven Gallagher on 4/6/14.
//  Copyright (c) 2014 Steven Gallagher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "SLTruckSprite.h"

@interface SLDebugControls : NSObject {
    SKScene *debugScene;
    SKNode *debugNodes;
    SKLabelNode *throttleLabel;
    UISlider *throttleSlider;
    SKLabelNode *rearGripLabel;
    UISlider *rearGripSlider;
    SKLabelNode *tireStiffnessLabel;
    UISlider *tireStiffnessSlider;
}

-(id)initWithScene:(SKScene *)scene;
-(void)addControls;
-(void)toggleIsShown;
-(void)addThrottleControl;
-(void)addRearGripControl;

@property SLTruckSprite *truck;
@property BOOL isShown;

@end
