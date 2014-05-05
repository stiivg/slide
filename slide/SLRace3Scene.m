//
//  SLRace3Scene.m
//  slide
//
//  Created by Steven Gallagher on 5/4/14.
//  Copyright (c) 2014 Steven Gallagher. All rights reserved.
//

#import "SLRace3Scene.h"

@implementation SLRace3Scene
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        
    }
    return self;
}

-(void)initRace:(CGSize)size {
    float centerHt = 240.0;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && IS_WIDESCREEN) {
        centerHt = 284.0;
    }
    
    self.backgroundColor = [SKColor colorWithRed:0.82 green:0.57 blue:0.3 alpha:1.0]; //Sand color
    
    SLPivotPoint *pivot1 = [[SLPivotPoint alloc] init];
    pivot1.centre = [SLConversion convertPoint:CGPointMake(220, centerHt-110)];
    pivot1.radius = [SLConversion scaleFloat:50];
    
    SLPivotPoint *pivot2 = [[SLPivotPoint alloc] init];
    pivot2.centre = [SLConversion convertPoint:CGPointMake(220, centerHt+110)];
    pivot2.radius = [SLConversion scaleFloat:50];
    
    SLPivotPoint *pivot3 = [[SLPivotPoint alloc] init];
    pivot3.centre = [SLConversion convertPoint:CGPointMake(100, centerHt+110)];
    pivot3.radius = [SLConversion scaleFloat:50];
    
    SLPivotPoint *pivot4 = [[SLPivotPoint alloc] init];
    pivot4.centre = [SLConversion convertPoint:CGPointMake(160, centerHt)];
    pivot4.radius = [SLConversion scaleFloat:50];
    
    SLPivotPoint *pivot5 = [[SLPivotPoint alloc] init];
    pivot5.centre = [SLConversion convertPoint:CGPointMake(100, centerHt-110)];
    pivot5.radius = [SLConversion scaleFloat:50];
    
    pivotPoints = [NSArray arrayWithObjects:pivot1, pivot2, pivot3, pivot4, pivot5, nil];
    
    
    pivot1.clearAngle = -M_PI_2;
    pivot1.transitionAngle = 0.0;
    pivot1.CW = false;
    
    pivot2.clearAngle = 0;
    pivot2.transitionAngle = M_PI_2;
    pivot2.CW = false;
    
    pivot3.clearAngle = M_PI_2;
    pivot3.transitionAngle = -M_PI_2;
    pivot3.CW = false;
    
    pivot4.clearAngle = 0.0;
    pivot4.transitionAngle = -M_PI_2;
    pivot4.CW = true;
    
    pivot5.clearAngle = M_PI;
    pivot5.transitionAngle = -M_PI_2;
    pivot5.CW = false;
    
    //oil drums at pivots
    SKTextureAtlas *spriteAtlas = [SLConversion textureAtlasNamed:@"sprites"];
    SKTexture *drumTexture = [spriteAtlas textureNamed:@"drum_top"];
    SKSpriteNode *drum1 = [SKSpriteNode spriteNodeWithTexture:drumTexture];
    drum1.name = @"Drum1";
    drum1.position = pivot1.centre;
    [self addChild:drum1];
    
    SKSpriteNode *drum2 = [SKSpriteNode spriteNodeWithTexture:drumTexture];
    drum2.name = @"Drum2";
    drum2.position = pivot2.centre;
    [self addChild:drum2];
    
    SKSpriteNode *drum3 = [SKSpriteNode spriteNodeWithTexture:drumTexture];
    drum3.name = @"Drum3";
    drum3.position = pivot3.centre;
    [self addChild:drum3];
    
    SKSpriteNode *drum4 = [SKSpriteNode spriteNodeWithTexture:drumTexture];
    drum4.name = @"Drum4";
    drum4.position = pivot4.centre;
    [self addChild:drum4];
    
    SKSpriteNode *drum5 = [SKSpriteNode spriteNodeWithTexture:drumTexture];
    drum5.name = @"Drum5";
    drum5.position = pivot5.centre;
    [self addChild:drum5];
    
    
    slideButton = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:0.62 green:0.37 blue:0.2 alpha:1.0]
                                               size:[SLConversion scaleSize:CGSizeMake(50, 50)]];
    slideButton.position = [SLConversion convertPoint:CGPointMake(290, centerHt)];
    [self addChild:slideButton];
    
    //Create the player truck
    truck = [[SLTruckSprite alloc] init];
    
    truck.position = [SLConversion convertPoint:CGPointMake(215, 240)];
    truck.targetPoint = pivot1;
    
    [self addChild:truck];
    
    [self initPhysics];
    
}

//Determine the current pivot target
-(SLPivotPoint*)target:(CGPoint)position {
    if (truck.hasTransitionedTarget) {
        //next target in array
        NSUInteger index = [pivotPoints indexOfObject:truck.targetPoint] + 1;
        //wrap array index
        if ([pivotPoints count] <= index) {
            index = 0;
        }
        truck.targetPoint = pivotPoints[index];
    }
    
    return truck.targetPoint;
}



-(void)initPhysics {
    //    self.scaleMode = SKSceneScaleModeAspectFit;
    //Create edge loop around border
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
}


@end
