//
//  VectorUtils.h
//  Slide
//
//  Created by Steven Gallagher on 3/23/14.
//  Copyright (c) 2014 Steven Gallagher. All rights reserved.
//

#ifndef Slide_VectorUtils_h
#define Slide_VectorUtils_h

//Vector math from Raw Wenderlich http://www.raywenderlich.com/42699/spritekit-tutorial-for-beginners
static inline CGPoint ccpAdd(CGPoint a, CGPoint b) {
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint ccpSub(CGPoint a, CGPoint b) {
    return CGPointMake(a.x - b.x, a.y - b.y);
}

static inline CGPoint ccpMult(CGPoint a, float b) {
    return CGPointMake(a.x * b, a.y * b);
}

static inline float ccpLength(CGPoint a) {
    return sqrtf(a.x * a.x + a.y * a.y);
}

static inline float vectorLength(CGVector a) {
    return sqrtf(a.dx * a.dx + a.dy * a.dy);
}

// Makes a vector have a length of 1
static inline CGPoint ccpNormalize(CGPoint a) {
    float length = ccpLength(a);
    return CGPointMake(a.x / length, a.y / length);
}



#endif
