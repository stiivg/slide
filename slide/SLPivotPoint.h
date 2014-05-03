//
//  SLPivotPoint.h
//  slide
//
//  Created by Steven Gallagher on 5/3/14.
//  Copyright (c) 2014 Steven Gallagher. All rights reserved.
//

#import <Foundation/Foundation.h>
//Define object to hold circle info
@interface Circle : NSObject

@property CGPoint centre;
@property CGFloat radius;

@end


@interface SLPivotPoint : Circle

@property CGFloat clearAngle;
@property CGFloat transitionAngle;
@property BOOL CCW;

-(CGFloat)heading:(CGPoint) truckPosition;

@end
