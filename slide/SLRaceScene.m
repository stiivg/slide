//
//  SLRaceScene
//  slide
//
//  Created by Steven Gallagher on 3/9/14.
//  Copyright (c) 2014 Steven Gallagher. All rights reserved.
//

#import "SLRaceScene.h"
#import "SLGameManager.h"


@implementation SLRaceScene

const bool kDisplayControls = false;


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        [self initRace:size];
        
        //Create debug node
        self.debugOverlay = [SKNode node];
        
    }
    return self;
}

-(void)initRace:(CGSize)size {
    float centerHt = 240.0;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && IS_WIDESCREEN) {
        centerHt = 284.0;
    }
    
    self.backgroundColor = [SKColor colorWithRed:0.82 green:0.57 blue:0.3 alpha:1.0]; //Sand color
    
    SKSpriteNode *centerWall = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:0.72 green:0.47 blue:0.2 alpha:1.0]
                                              size:[SLConversion scaleSize:CGSizeMake(5, 160)]];
    centerWall.position = [SLConversion convertPoint:CGPointMake(160, centerHt)];
    centerWall.name = @"CenterWall";
    [self addChild:centerWall];
    
    SLPivotPoint *pivot1 = [[SLPivotPoint alloc] init];
    pivot1.centre = [SLConversion convertPoint:CGPointMake(160, centerHt+80)];
    pivot1.radius = [SLConversion scaleFloat:50];
    
    SLPivotPoint *pivot2 = [[SLPivotPoint alloc] init];
    pivot2.centre = [SLConversion convertPoint:CGPointMake(160, centerHt-80)];
    pivot2.radius = [SLConversion scaleFloat:50];
    
    pivotPoints = [NSArray arrayWithObjects:pivot1, pivot2, nil];
    
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
    
    slideButton = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:0.62 green:0.37 blue:0.2 alpha:1.0]
                                               size:[SLConversion scaleSize:CGSizeMake(50, 50)]];
    slideButton.position = [SLConversion convertPoint:CGPointMake(290, centerHt)];
    [self addChild:slideButton];
    
    //Create the player truck
    truck = [[SLTruckSprite alloc] initWithIndex:0];
    
    truck.position = [SLConversion convertPoint:CGPointMake(215, 240)];
    
    [self addChild:truck];
    
    //Create the 2nd truck
    truck2 = [[SLTruckSprite alloc] initWithIndex:1];
    
    truck2.position = [SLConversion convertPoint:CGPointMake(230, 240)];
    
    [self addChild:truck2];
    
    
    [self initPhysics];
    
}
-(void)createDebugControls {
    debugControls = [[SLDebugControls alloc] initWithScene:self];
    debugControls.truck = truck;
    debugControls.truck2 = truck2;
    //Force toggle to turn on debug with default values
    debugControls.isShown = NO;
    [debugControls toggleIsShown];
 
}
- (void)didMoveToView:(SKView *)view
{
    if (kDisplayControls) {
        [self createDebugControls];
    }
    
    swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [swipeRightGesture setDirection: UISwipeGestureRecognizerDirectionRight];
    
    [view addGestureRecognizer: swipeRightGesture ];
    
    swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    [swipeLeftGesture setDirection: UISwipeGestureRecognizerDirectionLeft];
    
    [view addGestureRecognizer: swipeLeftGesture ];
    
}

- ( void ) willMoveFromView: (SKView *) view {
    [view removeGestureRecognizer:swipeRightGesture];
    if (debugControls) {
        [debugControls removeSubViews];
    }
    
}

-(void) handleSwipeRight:(UISwipeGestureRecognizer *) recognizer {
    [[SLGameManager sharedGameManager] nextRaceScene:self.view];
    
}

-(void) handleSwipeLeft:(UISwipeGestureRecognizer *) recognizer {
    [[SLGameManager sharedGameManager] prevRaceScene:self.view];
    
}


-(void)initPhysics {
//    self.scaleMode = SKSceneScaleModeAspectFit;
    //Create edge loop around border
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    //Create center edge
    SKNode *centerWall = [self childNodeWithName:@"CenterWall"];
    centerWall.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:[SLConversion scalePoint:CGPointMake(0, -80)]
                                                          toPoint:[SLConversion scalePoint:CGPointMake(0, 80)]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if (location.x < [SLConversion scaleFloat:50] & location.y < [SLConversion scaleFloat:50]) {
            if (!debugControls) {
                [self createDebugControls];
            } else {
                [debugControls toggleIsShown];
            }
        } else if([slideButton containsPoint:location]){
            [truck startSlide];
        } else {
            truck.position = location;
            [truck start];
            [truck2 start];
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if([slideButton containsPoint:location]){
            [truck endSlide];
        }
    }
    
}

-(SLPivotPoint*)target:(CGPoint)position {
    //determine the target pivot point
    //simplistically right side 1, left side 2
    //Changed to delay moving to next pivot until past centre
    SLPivotPoint *targetPivot = pivotPoints[0];
    if (position.x < targetPivot.centre.x) {
        if (position.y < ((Circle *)pivotPoints[0]).centre.y) {
            targetPivot = pivotPoints[1];
        }
    } else if (position.y < ((Circle *)pivotPoints[1]).centre.y) {
        targetPivot = pivotPoints[1];
    }

    return targetPivot;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called at start of frame processing */
    //Temporarily remove debug nodes
    [self.debugOverlay removeFromParent];
    [self.debugOverlay removeAllChildren];
    
    //Calculate the target point
    SLPivotPoint *targetPivot = [self target:truck.position];
    steerHeading = [targetPivot heading:truck.position];
    
    //Send steerHeading to the truck
    [truck steerToTarget:steerHeading];


    //Calculate the 2nd truck target point
    SLPivotPoint *target2Pivot = [self target:truck2.position];
    CGFloat steer2Heading = [target2Pivot heading:truck2.position];
    
    //Send steerHeading to the truck
    [truck2 steerToTarget:steer2Heading];
}

-(void)debugDrawPivotPoints {
    
    for (Circle *debugPivot in pivotPoints) {
        CGRect pivotRect = CGRectMake(-debugPivot.radius, -debugPivot.radius, debugPivot.radius*2, debugPivot.radius*2);
        CGPathRef pivotPath = CGPathCreateWithEllipseInRect(pivotRect, &CGAffineTransformIdentity);
        SKShapeNode *pivotCircle = [[SKShapeNode alloc] init];
        pivotCircle.position = CGPointMake(debugPivot.centre.x, debugPivot.centre.y);
        pivotCircle.path = pivotPath;
        pivotCircle.strokeColor = [SKColor colorWithRed:1.0 green:0 blue:0 alpha:0.5];
        pivotCircle.lineWidth = 0.1;
        
        CGPathRelease(pivotPath);
        [self.debugOverlay addChild: pivotCircle];
    }
    
}

-(void)debugDrawDirectionVector:(CGFloat)direction length:(CGFloat)length position:(CGPoint)position{
    SKShapeNode *directionLine = [[SKShapeNode alloc] init];
    directionLine.position = position;
    CGFloat directionX = length *cosf(direction);
    CGFloat directionY = length *sinf(direction);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0.0, 0.0);
    CGPathAddLineToPoint(path, 0, directionX, directionY);
    CGPathCloseSubpath(path);
    directionLine.path = path;
    directionLine.strokeColor = [SKColor colorWithRed:0 green:1.0 blue:0 alpha:0.5];
    directionLine.lineWidth = 0.1;
    CGPathRelease(path);
    
    [self.debugOverlay addChild: directionLine];
    
}

-(void)debugDrawVector:(CGVector)vector position:(CGPoint)position{
    SKShapeNode *vectorLine = [[SKShapeNode alloc] init];
    vectorLine.position = position;
    CGFloat vectorScale = [SLConversion scaleFloat:0.5];
    CGFloat directionX = vectorScale*vector.dx;
    CGFloat directionY = vectorScale*vector.dy;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0.0, 0.0);
    CGPathAddLineToPoint(path, 0, directionX, directionY);
    CGPathCloseSubpath(path);
    vectorLine.path = path;
    vectorLine.strokeColor = [SKColor colorWithRed:1.0 green:0.0 blue:0.5 alpha:1.0];
    vectorLine.lineWidth = 0.1;
    CGPathRelease(path);
    
    [self.debugOverlay addChild: vectorLine];
    
}


-(void)debugDrawSteeringVector {
    CGFloat vectorScale = [SLConversion scaleFloat:250];
    [self debugDrawDirectionVector:steerHeading length:vectorScale position:truck.position];
}


-(void)didSimulatePhysics {
    /* Called before final frame rendered */
    // Update the car shadow position
    [truck prepareToDraw];
    [truck2 prepareToDraw];
    
    
    //Display debug nodes
    if (debugControls.showsVectors) {
        [self addChild:self.debugOverlay];
        
        // add code to create and add debugging images to the debug node.
        [self debugDrawPivotPoints];
        
        [self debugDrawSteeringVector];
        [self debugDrawVector:truck.physicsBody.velocity position:truck.position];
        
        [self debugDrawVector:truck.frontTireForce position:truck.frontForcePoint];
        
        [self debugDrawVector:truck.rearTireForce position:truck.rearForcePoint];
        
        CGFloat vectorScale = [SLConversion scaleFloat:25];
        [self debugDrawDirectionVector:truck.rearSlipAngle+truck.zRotation
                                length:vectorScale position:truck.rearForcePoint];
        [self debugDrawDirectionVector:truck.frontSlipAngle+truck.zRotation
                                length:vectorScale position:truck.frontForcePoint];
        self.view.showsPhysics = YES;
                
    } else {
        self.view.showsPhysics = NO;
    }
}












@end