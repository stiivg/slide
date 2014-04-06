//
//  SLConversion.h
//  Slide
//
//  Created by Steven Gallagher on 4/5/14.
//  Copyright (c) 2014 Steven Gallagher. All rights reserved.
//

#import <Foundation/Foundation.h>

//http://stackoverflow.com/questions/12446990/how-to-detect-iphone-5-widescreen-devices
#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface SLConversion : NSObject


+ (CGPoint)convertPoint:(CGPoint)point;
+ (CGPoint)scalePoint:(CGPoint)point;
+ (CGSize)scaleSize:(CGSize)size;
+ (CGFloat)scaleFloat:(CGFloat)theFloat;

@end


