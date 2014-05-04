//
//  SLPivotPoint.m
//  slide
//
//  Created by Steven Gallagher on 5/3/14.
//  Copyright (c) 2014 Steven Gallagher. All rights reserved.
//

#import "SLPivotPoint.h"
#import "VectorUtils.h"

@implementation Circle

@synthesize centre;
@synthesize radius;

@end


@implementation SLPivotPoint

@synthesize clearAngle;
@synthesize transitionAngle;
@synthesize CCW;


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

//Heading angle for the truck position
-(CGFloat)heading:(CGPoint) truckPosition {
    //vector from truck to pivot point
    CGPoint pivotVector = CGPointMake(self.centre.x - truckPosition.x, self.centre.y - truckPosition.y);
    float pivotDistance = ccpLength(pivotVector);
    CGFloat steerHeading = M_PI_2; //Assume straight up
    if (pivotDistance <= self.radius) {
        //On radius; steer along tangent
        steerHeading = atan2f(pivotVector.y, pivotVector.x)-M_PI_2;
        if (steerHeading > M_PI) {
            steerHeading = M_2_PI - steerHeading;
        }
    } else {
        //Outside radius; steer to tangent of radius
        // targets are the intersection of the pivot circle and carPivotCircle
        CGPoint target1 = CGPointMake(0, 0);
        CGPoint target2 = CGPointMake(0, 0);
        
        //Circle with diameter from car to pivot
        Circle *carPivotCircle = [[Circle alloc] init];
        carPivotCircle.centre = ccpAdd(truckPosition, ccpMult(pivotVector, 0.5));
        carPivotCircle.radius = pivotDistance/2;
        
        [self findIntersectionOfCircle:self circle:carPivotCircle sol1:&target1 sol2:&target2];
        //Assume target2 for now
        //Steer towards target2
        CGPoint targetVector = CGPointMake(target2.x - truckPosition.x, target2.y - truckPosition.y);
        steerHeading = atan2f(targetVector.y,targetVector.x);
    }
    return steerHeading;
}











@end

