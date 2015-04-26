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
#import "SLRace3Scene.h"

@implementation SLGameManager
static SLGameManager* _sharedGameManager = nil;

@synthesize isGamePaused;
@synthesize isMusicON;
@synthesize isSoundEffectsON;
@synthesize isTutorialOn;
@synthesize sceneID;

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
        NSAssert(_sharedGameManager == nil, @"Attempted to allocate a second instance");
        _sharedGameManager = [super alloc];
        _sharedGameManager.sceneID = 0;
        return _sharedGameManager;
    }
    return nil;
}


- (void)nextRaceScene:(SKView*)skView {
    
    SKScene *scene;
    // Create and configure the scene.
    SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionRight duration:0.5];
    sceneID+=1;
    if (sceneID > 2) {
        sceneID = 0;
    }
    switch (sceneID) {
        case 0:
            scene = [SLRaceScene sceneWithSize:skView.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            break;
            
        case 1:
            scene = [SLRace2Scene sceneWithSize:skView.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            break;
            
        case 2:
            scene = [SLRace3Scene sceneWithSize:skView.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            break;
            
        default:
            scene = [SLRaceScene sceneWithSize:skView.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            break;
            
            break;
    }
    
    // Present the scene.
    [skView presentScene:scene transition:reveal];
    
}

- (void)prevRaceScene:(SKView*)skView {
    
    SKScene *scene;
    // Create and configure the scene.
    SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionLeft duration:0.5];
    sceneID -= 1;
    if (sceneID < 0) {
        sceneID = 2;
    }
    switch (sceneID) {
        case 0:
            scene = [SLRaceScene sceneWithSize:skView.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            break;
            
        case 1:
            scene = [SLRace2Scene sceneWithSize:skView.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            break;
            
        case 2:
            scene = [SLRace3Scene sceneWithSize:skView.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            break;
            
        default:
            scene = [SLRaceScene sceneWithSize:skView.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            break;
    }
    
    // Present the scene.
    [skView presentScene:scene transition:reveal];
    
    
}


@end
