//
//  SLRace2Scene.m
//  slide
//
//  Created by Steven Gallagher on 4/30/14.
//  Copyright (c) 2014 Steven Gallagher. All rights reserved.
//

#import "SLRace2Scene.h"

@implementation SLRace2Scene

SKSpriteNode *centerWall;
SKSpriteNode *drum1;
SKSpriteNode *drum2;



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
    
    centerWall = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:0.72 green:0.47 blue:0.2 alpha:1.0]
                                              size:[SLConversion scaleSize:CGSizeMake(5, 100)]];
    centerWall.position = [SLConversion convertPoint:CGPointMake(100, centerHt)];
    [self addChild:centerWall];
    
    Circle *pivot1 = [[Circle alloc] init];
    pivot1.centre = [SLConversion convertPoint:CGPointMake(100, centerHt+100)];
    pivot1.radius = [SLConversion scaleFloat:50];
    
    Circle *pivot2 = [[Circle alloc] init];
    pivot2.centre = [SLConversion convertPoint:CGPointMake(100, centerHt-100)];
    pivot2.radius = [SLConversion scaleFloat:50];
    
    pivotPoints = [NSArray arrayWithObjects:pivot1, pivot2, nil];
    
    //oil drums at pivots
    SKTextureAtlas *spriteAtlas = [SLConversion textureAtlasNamed:@"sprites"];
    SKTexture *drumTexture = [spriteAtlas textureNamed:@"drum_top"];
    drum1 = [SKSpriteNode spriteNodeWithTexture:drumTexture];
    drum1.name = @"Drum1";
    drum1.position = pivot1.centre;
    [self addChild:drum1];
    
    drum2 = [SKSpriteNode spriteNodeWithTexture:drumTexture];
    drum2.name = @"Drum2";
    drum2.position = pivot2.centre;
    [self addChild:drum2];
    
    slideButton = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:0.62 green:0.37 blue:0.2 alpha:1.0]
                                               size:[SLConversion scaleSize:CGSizeMake(50, 50)]];
    slideButton.position = [SLConversion convertPoint:CGPointMake(290, centerHt)];
    [self addChild:slideButton];
    
    //Create the player truck
    truck = [[SLTruckSprite alloc] init];
    
    truck.position = [SLConversion convertPoint:CGPointMake(215, 240)];
    
    [self addChild:truck];
    
    [self initPhysics];

}

-(void)initPhysics {
    //    self.scaleMode = SKSceneScaleModeAspectFit;
    //Create edge loop around border
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    //Create center edge
    centerWall.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:[SLConversion scalePoint:CGPointMake(0, -80)]
                                                          toPoint:[SLConversion scalePoint:CGPointMake(0, 80)]];
}



@end
