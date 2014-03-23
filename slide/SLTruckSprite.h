//
//  SLTruckSprite.h
//  slide
//
//  Created by Steven Gallagher on 3/11/14.
//  Copyright (c) 2014 Steven Gallagher. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


@interface SLTruckSprite : SKSpriteNode {
   SKSpriteNode *truckShadow;
}

- (void)prepareToDraw;
- (void)initPhysics;
- (void)start;


@end

