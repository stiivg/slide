//
//  HermitePath.h
//  Slide
//
//  Created by Steven Gallagher on 11/13/11.
//  Copyright 2011 Steve Gallagher. All rights reserved.
//

#ifndef TinyDrift_Path_h
#define TinyDrift_Path_h

#import <SpriteKit/SpriteKit.h>
#import "VectorUtils.h"

/** @def CC_CONTENT_SCALE_FACTOR
 On Mac it returns 1;
 On iPhone it returns 2 if RetinaDisplay is On. Otherwise it returns 1
 */
#define CC_CONTENT_SCALE_FACTOR 1


#define MAX_ROAD_KEY_POINTS 1000
//normal race 16
#define SEGMENT_COUNT 8

@interface HermitePath : NSObject {
    CGPoint _roadControlPoints[MAX_ROAD_KEY_POINTS];
    int _numControlPoints;
    CGPoint _keyPoints[MAX_ROAD_KEY_POINTS];
    int _numKeyPoints;
    CGPoint * _pathPoints;
    int _numPathPoints;
}

- (id)createPath:(CGPoint *) pathPoints;

-(int)getNumPathPoints;
-(CGPoint) getStart;

@end


#endif
