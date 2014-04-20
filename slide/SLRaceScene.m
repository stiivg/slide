//
//  SLRaceScene
//  slide
//
//  Created by Steven Gallagher on 3/9/14.
//  Copyright (c) 2014 Steven Gallagher. All rights reserved.
//

#import "SLRaceScene.h"
#import "SLConversion.h"

//Define object to hold pivot point info
@interface Circle : NSObject

@property CGPoint centre;
@property CGFloat radius;

@end

@implementation Circle

@synthesize centre;
@synthesize radius;

@end

@implementation SLRaceScene

const bool kDisplayControls = true;


-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        
        float centerHt = 240.0;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && IS_WIDESCREEN) {
            centerHt = 284.0;
        }
                
        self.backgroundColor = [SKColor colorWithRed:0.82 green:0.57 blue:0.3 alpha:1.0]; //Sand color
                
        centerWall = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:0.72 green:0.47 blue:0.2 alpha:1.0]
                                                  size:[SLConversion scaleSize:CGSizeMake(5, 160)]];
        centerWall.position = [SLConversion convertPoint:CGPointMake(160, centerHt)];
        [self addChild:centerWall];
        
        Circle *pivot1 = [[Circle alloc] init];
        pivot1.centre = [SLConversion convertPoint:CGPointMake(160, centerHt+80)];
        pivot1.radius = [SLConversion scaleFloat:50];
        
        Circle *pivot2 = [[Circle alloc] init];
        pivot2.centre = [SLConversion convertPoint:CGPointMake(160, centerHt-80)];
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
        
        //Create debug node
        self.debugOverlay = [SKNode node];
//       if (self.displayVectors) {
//            //Create debug nodes
//            self.debugOverlay = [SKNode node];
//            [self addChild:self.debugOverlay];
//        }
        
    }
    return self;
}

- (void) didMoveToView:(SKView *)view
{
    if (kDisplayControls) {
        debugControls = [[SLDebugControls alloc] initWithScene:self];
        debugControls.truck = truck;
        //Force toggle to turn on debug with default values
        debugControls.isShown = NO;
        [debugControls toggleIsShown];
    }
}

-(void)initPhysics {
//    self.scaleMode = SKSceneScaleModeAspectFit;
    //Create edge loop around border
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    //Create center edge
    centerWall.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:[SLConversion scalePoint:CGPointMake(0, -80)]
                                                          toPoint:[SLConversion scalePoint:CGPointMake(0, 80)]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if (location.x < [SLConversion scaleFloat:50] & location.y < [SLConversion scaleFloat:50]) {
            [debugControls toggleIsShown];
        } else if([slideButton containsPoint:location]){
            [truck startSlide];
        } else {
            truck.position = location;
            [truck start];
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

//From http://paulbourke.net/geometry/circlesphere/CircleCircleIntersection2.m

-(int) findIntersectionOfCircle: (Circle *)c1 circle:(Circle *)c2 sol1:(CGPoint *)sol1 sol2:(CGPoint *)sol2
{
	//Calculate distance between centres of circle
    CGPoint centresVector = CGPointMake(c1.centre.x - c2.centre.x, c1.centre.y - c2.centre.y);
    float d = ccpLength(centresVector);
	float c1r = [c1 radius];
	float c2r = [c2 radius];
	float m = c1r + c2r;
	float n = c1r - c2r;
	
	if (n < 0)
		n = n * -1;
	
	//No solns
	if ( d > m )
		return 0;
	
	//Circle are contained within each other
	if ( d < n )
		return 0;
	
	//Circles are the same
	if ( d == 0 && c1r == c2r )
		return -1;
	
	//Solve for a
	float a = ( c1r * c1r - c2r * c2r + d * d ) / (2 * d);
	
	//Solve for h
	float h = sqrt( c1r * c1r - a * a );
	
	//Calculate point p, where the line through the circle intersection points crosses the line between the circle centers.
	CGPoint p;
	
	p.x = c1.centre.x + ( a / d ) * ( c2.centre.x -c1.centre.x );
	p.y = c1.centre.y + ( a / d ) * ( c2.centre.y -c1.centre.y );
	
	//1 soln , circles are touching
	if ( d == c1r + c2r ) {
		*sol1 = p;
		return 1;
	}
	//2solns
	CGPoint p1;
	CGPoint p2;
	
	p1.x = p.x + ( h / d ) * ( c2.centre.y - c1.centre.y );
	p1.y = p.y - ( h / d ) * ( c2.centre.x - c1.centre.x );
	
	p2.x = p.x - ( h / d ) * ( c2.centre.y - c1.centre.y );
	p2.y = p.y + ( h / d ) * ( c2.centre.x - c1.centre.x );
	
	*sol1 = p1;
	*sol2 = p2;
	
	return 2;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called at start of frame processing */
    //Temporarily remove debug nodes
    [self.debugOverlay removeFromParent];
    [self.debugOverlay removeAllChildren];
    
    //Calculate the target point and set the steer heading
    CGPoint truckPosition = truck.position;
    //determine the target pivot point
    //simplistically right side 1, left side 2
    //Changed to delay moving to next pivot until past centre
    Circle *targetPivot = pivotPoints[0];
    if (truckPosition.x < targetPivot.centre.x) {
        if (truckPosition.y < ((Circle *)pivotPoints[0]).centre.y) {
            targetPivot = pivotPoints[1];
        }
    } else if (truckPosition.y < ((Circle *)pivotPoints[1]).centre.y) {
            targetPivot = pivotPoints[1];
        }

    
    //calc target point
    //vector from truck to pivot point
    CGPoint pivotVector = CGPointMake(targetPivot.centre.x - truckPosition.x, targetPivot.centre.y - truckPosition.y);
    float pivotDistance = ccpLength(pivotVector);
    steerHeading = M_PI_2; //Assume straight up
    if (pivotDistance <= targetPivot.radius) {
        //On radius; steer along tangent
        steerHeading = atan2f(pivotVector.y, pivotVector.x)-M_PI_2;
        if (steerHeading > M_PI) {
            steerHeading = M_2_PI - steerHeading;
        }
        //steerHeading = fmodf(steerHeading, M_2_PI);
    } else {
        //Outside radius; steer to tangent of radius
        // targets are the intersection of the pivot circle and carPivotCircle
        CGPoint target1 = CGPointMake(0, 0);
        CGPoint target2 = CGPointMake(0, 0);
        
        //Circle with diameter from car to pivot
        Circle *carPivotCircle = [[Circle alloc] init];
        carPivotCircle.centre = ccpAdd(truckPosition, ccpMult(pivotVector, 0.5));
        carPivotCircle.radius = pivotDistance/2;

        [self findIntersectionOfCircle:targetPivot circle:carPivotCircle sol1:&target1 sol2:&target2];
        //Assume target2 for now
        //Steer towards target2
        CGPoint targetVector = CGPointMake(target2.x - truckPosition.x, target2.y - truckPosition.y);
        steerHeading = atan2f(targetVector.y,targetVector.x);
    }
    //Send steerHeading to the truck
    [truck steerToTarget:steerHeading];
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