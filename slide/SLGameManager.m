//
//  SLGameManager.m
//  slide
//
//  Created by Steven Gallagher on 5/4/14.
//  Copyright (c) 2014 Steven Gallagher. All rights reserved.
//

#import "SLGameManager.h"
#import "SLRaceScene.h"
#import "SLRace2Scene.h"

@implementation SLGameManager
static SLGameManager* _sharedGameManager = nil;

@synthesize isGamePaused;
@synthesize isMusicON;
@synthesize isSoundEffectsON;
@synthesize isTutorialOn;

+(SLGameManager*)sharedGameManager {
    @synchronized([SLGameManager class])
    {
        if(!_sharedGameManager)
            [[self alloc] init];
        return _sharedGameManager;
    }
    return nil;
}

+(id)alloc
{
    @synchronized ([SLGameManager class])
    {
        NSAssert(_sharedGameManager == nil,
                 @"Attempted to allocate a second instance");
        _sharedGameManager = [super alloc];
        return _sharedGameManager;
    }
    return nil;
}

- (void)nextRaceScene:(SKView*)skView {
    
    // Create and configure the scene.
    SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionRight duration:0.5];
    SKScene * scene = [SLRace2Scene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene transition:reveal];
    
}

- (void)prevRaceScene:(SKView*)skView {
    
    // Create and configure the scene.
    SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionLeft duration:0.5];
    SKScene * scene = [SLRaceScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene transition:reveal];
    
}


@end
