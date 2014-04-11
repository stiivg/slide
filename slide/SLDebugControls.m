//
//  SLDebugControls.m
//  Slide
//
//  Created by Steven Gallagher on 4/6/14.
//  Copyright (c) 2014 Steven Gallagher. All rights reserved.
//

#import "SLDebugControls.h"
#import "SLConversion.h"

#define kControlAlpha 0.4

@implementation SLDebugControls

@synthesize truck;
@synthesize isShown = _isShown;
@synthesize showsVectors;

-(id)initWithScene:(SKScene *)scene {
    if (self = [super init]) {
        debugScene = scene;
        [self addControls];
    }
    return self;
}

-(void)addThrottleControl {
    
    CGSize frameSize = debugScene.frame.size;
    
    //Create control nodes
    CGSize sliderSize = [SLConversion scaleSize:CGSizeMake(150, 20)];
    CGPoint sliderLocation = CGPointMake(frameSize.width - sliderSize.width, frameSize.height - 3*sliderSize.height);
    throttleSlider = [[ UISlider alloc ] initWithFrame: CGRectMake(sliderLocation.x, sliderLocation.y,
                                                                   sliderSize.width, sliderSize.height) ];
    throttleSlider.backgroundColor = [UIColor clearColor];
    
    throttleSlider.maximumValue = 200.0;
    throttleSlider.minimumValue = 0.0;
    throttleSlider.minimumTrackTintColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    throttleSlider.alpha =kControlAlpha;
    [debugScene.view addSubview:throttleSlider];
    
    [throttleSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    throttleLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-Light"];
    
    throttleLabel.text = @"Throttle";
    throttleLabel.fontSize = [SLConversion scaleFloat:10];
    
    throttleLabel.position = CGPointMake(sliderLocation.x,
                                         frameSize.height - sliderLocation.y);
    
    throttleLabel.alpha = kControlAlpha;
    
    [debugNodes addChild:throttleLabel];
    
}

-(void)addRearGripControl {
    
    CGSize frameSize = debugScene.frame.size;
    
    //Create control nodes
    CGSize sliderSize = [SLConversion scaleSize:CGSizeMake(150, 20)];
    CGPoint sliderLocation = CGPointMake(frameSize.width - sliderSize.width, frameSize.height - 6*sliderSize.height);
    rearGripSlider = [[ UISlider alloc ] initWithFrame: CGRectMake(sliderLocation.x, sliderLocation.y,
                                                                   sliderSize.width, sliderSize.height) ];
    rearGripSlider.backgroundColor = [UIColor clearColor];
    
    rearGripSlider.maximumValue = 1.0;
    rearGripSlider.minimumValue = 0.0;
    rearGripSlider.minimumTrackTintColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    rearGripSlider.alpha =kControlAlpha;
    
    [debugScene.view addSubview:rearGripSlider];
    
    [rearGripSlider addTarget:self action:@selector(rearGripValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    rearGripLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-Light"];
    
    rearGripLabel.text = @"Rear Grip";
    rearGripLabel.fontSize = [SLConversion scaleFloat:10];
    
    rearGripLabel.position = CGPointMake(sliderLocation.x,
                                         frameSize.height - sliderLocation.y);
    
    rearGripLabel.alpha = kControlAlpha;
    
    [debugNodes addChild:rearGripLabel];
    
}

-(void)addTireStiffnessControl {
    
    CGSize frameSize = debugScene.frame.size;
    
    //Create control nodes
    CGSize sliderSize = [SLConversion scaleSize:CGSizeMake(150, 20)];
    CGPoint sliderLocation = CGPointMake(frameSize.width - sliderSize.width, frameSize.height - 9*sliderSize.height);
    tireStiffnessSlider = [[ UISlider alloc ] initWithFrame: CGRectMake(sliderLocation.x, sliderLocation.y,
                                                                   sliderSize.width, sliderSize.height) ];
    tireStiffnessSlider.backgroundColor = [UIColor clearColor];
    
    tireStiffnessSlider.maximumValue = 1200.0;
    tireStiffnessSlider.minimumValue = 0.0;
    tireStiffnessSlider.minimumTrackTintColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    tireStiffnessSlider.alpha =kControlAlpha;
    [debugScene.view addSubview:tireStiffnessSlider];
    
    [tireStiffnessSlider addTarget:self action:@selector(stiffnessValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    tireStiffnessLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-Light"];
    
    tireStiffnessLabel.text = @"Stiffness";
    tireStiffnessLabel.fontSize = [SLConversion scaleFloat:10];
    
    tireStiffnessLabel.position = CGPointMake(sliderLocation.x,
                                         frameSize.height - sliderLocation.y);
    
    tireStiffnessLabel.alpha = kControlAlpha;
    [debugNodes addChild:tireStiffnessLabel];
    
}

-(void)addVectorSwitch {
    CGSize frameSize = debugScene.frame.size;
    CGPoint switchLocation = CGPointMake(frameSize.width - 60, 50);
    CGRect swFrame = {{switchLocation.x, switchLocation.y}, {100, 100}};
    vectorsSwitch = [[UISwitch alloc] initWithFrame:swFrame];
    vectorsSwitch.alpha = kControlAlpha;

    [debugScene.view addSubview:vectorsSwitch];
    
    [vectorsSwitch addTarget:self action:@selector(vectorsSwitched:) forControlEvents:UIControlEventValueChanged];
    
    SKLabelNode *vectorSwLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-Light"];
    
    vectorSwLabel.text = @"Vectors";
    vectorSwLabel.fontSize = [SLConversion scaleFloat:10];
    
    vectorSwLabel.position = CGPointMake(switchLocation.x, frameSize.height - switchLocation.y);
    
    vectorSwLabel.alpha = kControlAlpha;
    [debugNodes addChild:vectorSwLabel];
    

}

-(void)addControls {
    
    //Create debug nodes
    debugNodes = [SKNode node];
    debugNodes.name = @"DebugControls";
    [debugScene addChild:debugNodes];
    
    [self addThrottleControl];
    [self addRearGripControl];
    [self addTireStiffnessControl];
    [self addVectorSwitch];
}


-(void)toggleIsShown {
    if (_isShown) {
        _isShown = NO;
        //Hide the Debug Nodes
        debugNodes.hidden = YES;
        throttleSlider.hidden = YES;
        rearGripSlider.hidden = YES;
        tireStiffnessSlider.hidden = YES;
        vectorsSwitch.hidden = YES;
    } else {
        _isShown = YES;

        rearGripSlider.value = truck.rearGrip;
        rearGripLabel.text = [NSString stringWithFormat:@"Rear Grip %3.1f",truck.rearGrip];
        tireStiffnessSlider.value = truck.tireStiffness;
        tireStiffnessLabel.text = [NSString stringWithFormat:@"Stiffness %3.0f",truck.tireStiffness];

        debugNodes.hidden = NO;
        throttleSlider.hidden = NO;
        rearGripSlider.hidden = NO;
        tireStiffnessSlider.hidden = NO;
        vectorsSwitch.hidden = NO;
    }
}



- (IBAction)sliderValueChanged:(UISlider *)sender {
    throttleLabel.text = [NSString stringWithFormat:@"Throttle %3.0f",sender.value];
    truck.throttle = [SLConversion scaleFloat:sender.value];
}



- (IBAction)rearGripValueChanged:(UISlider *)sender {
    rearGripLabel.text = [NSString stringWithFormat:@"Rear Grip %3.1f",sender.value];
    truck.rearGrip = sender.value;
}

- (IBAction)stiffnessValueChanged:(UISlider *)sender {
    tireStiffnessLabel.text = [NSString stringWithFormat:@"Stiffness %3.0f",sender.value];
    truck.tireStiffness = sender.value;
}

- (IBAction)vectorsSwitched:(UISwitch *)sender {
    self.showsVectors = sender.isOn;
}















@end
