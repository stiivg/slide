//
//  SLConversion.m
//  Slide
//
//  Created by Steven Gallagher on 4/5/14.
//  Copyright (c) 2014 Steven Gallagher. All rights reserved.
//

#import "SLConversion.h"

@implementation SLConversion

+ (CGPoint)convertPoint:(CGPoint)point
{
    //centre for portrait mode only
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return CGPointMake(64 + point.x*2, 32 + point.y*2);
    } else {
        return point;
    }
}

+ (CGPoint)scalePoint:(CGPoint)point
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return CGPointMake(point.x*2, point.y*2);
    } else {
        return point;
    }
}

+ (CGSize)scaleSize:(CGSize)size
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return CGSizeMake(size.width*2, size.height*2);
    } else {
        return size;
    }
}

+ (CGFloat)scaleFloat:(CGFloat)theFloat
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return theFloat*2;
    } else {
        return theFloat;
    }
}

+ (SKTextureAtlas *)textureAtlasNamed:(NSString *)fileName
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        if (IS_WIDESCREEN) {
            // iPhone Retina 4-inch
            fileName = [NSString stringWithFormat:@"%@-568", fileName];
        } else {
            // iPhone Retina 3.5-inch
            fileName = fileName;
        }
        
    } else {
        fileName = [NSString stringWithFormat:@"%@-ipad", fileName];
    }
    
    SKTextureAtlas *textureAtlas = [SKTextureAtlas atlasNamed:fileName];
    
    return textureAtlas;
}



@end
