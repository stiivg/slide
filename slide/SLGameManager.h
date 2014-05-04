//
//  SLGameManager.h
//  slide
//
//  Created by Steven Gallagher on 5/4/14.
//  Copyright (c) 2014 Steven Gallagher. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SLGameManager : NSObject

+(SLGameManager*)sharedGameManager;

@property (readwrite) BOOL isGamePaused;
@property (readwrite) BOOL isMusicON;
@property (readwrite) BOOL isSoundEffectsON;
@property (readwrite) BOOL isTutorialOn;

- (void)nextRaceScene:(SKView*)skView;
- (void)prevRaceScene:(SKView*)skView;

@end
