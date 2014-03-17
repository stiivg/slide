//
//  SLRaceScene
//  slide
//
//  Created by Steven Gallagher on 3/9/14.
//  Copyright (c) 2014 Steven Gallagher. All rights reserved.
//

#import "SLRaceScene.h"
#import "SLTruckSprite.h"

@implementation SLRaceScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.82 green:0.57 blue:0.3 alpha:1.0]; //Sand color
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Slide";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       self.frame.size.height - 100);
        
        [self addChild:myLabel];
        
        HermitePath *_path = [[HermitePath alloc] init];
        [_path createPath:pathPoints];
        //debug draw the path points
        for (int i=0; i<300; i++) {
            SKSpriteNode *dot = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(2, 2)];
            dot.position = pathPoints[i];
            [self addChild:dot];
        }

    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SLTruckSprite *truck = [[SLTruckSprite alloc] init];
       
        truck.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [truck runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:truck];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    //move shadow depending on the rotation angle
    NSArray *childrenArray = self.children;
    for (id childObj in childrenArray) {
        // do something with object
        if([childObj isKindOfClass:[SLTruckSprite class]]) {
            [((SLTruckSprite *)childObj) prepareToDraw ];
        }
    }
    
}

@end