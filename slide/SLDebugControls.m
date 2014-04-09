//
//  SLDebugControls.m
//  Slide
//
//  Created by Steven Gallagher on 4/6/14.
//  Copyright (c) 2014 Steven Gallagher. All rights reserved.
//

#import "SLDebugControls.h"
#import "SLConversion.h"

@implementation SLDebugControls

@synthesize truck;
@synthesize isShown = _isShown;

-(id)initWithScene:(SKScene *)scene {
    if (self = [super init]) {
        debugScene = scene;
        [self addControls];
        self.isShown = YES;
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
    [debugScene.view addSubview:throttleSlider];
    
    [throttleSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    throttleLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-Light"];
    
    throttleLabel.text = @"Throttle";
    throttleLabel.fontSize = [SLConversion scaleFloat:10];
    
    throttleLabel.position = CGPointMake(sliderLocation.x,
                                         frameSize.height - sliderLocation.y);
    
    
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
    
    [debugScene.view addSubview:rearGripSlider];
    
    [rearGripSlider addTarget:self action:@selector(rearGripValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    rearGripLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-Light"];
    
    rearGripLabel.text = @"Rear Grip";
    rearGripLabel.fontSize = [SLConversion scaleFloat:10];
    
    rearGripLabel.position = CGPointMake(sliderLocation.x,
                                         frameSize.height - sliderLocation.y);
    
    
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
    [debugScene.view addSubview:tireStiffnessSlider];
    
    [tireStiffnessSlider addTarget:self action:@selector(stiffnessValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    tireStiffnessLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-Light"];
    
    tireStiffnessLabel.text = @"Stiffness";
    tireStiffnessLabel.fontSize = [SLConversion scaleFloat:10];
    
    tireStiffnessLabel.position = CGPointMake(sliderLocation.x,
                                         frameSize.height - sliderLocation.y);
    
    
    [debugNodes addChild:tireStiffnessLabel];
    
}

-(void)addControls {
    
    //Create debug nodes
    debugNodes = [SKNode node];
    debugNodes.name = @"DebugControls";
    [debugScene addChild:debugNodes];
    
    [self addThrottleControl];
    [self addRearGripControl];
    [self addTireStiffnessControl];
    
    [self toggleIsShown];
    
}


-(void)toggleIsShown {
    if (_isShown) {
        _isShown = NO;
        //Hide the Debug Nodes
        debugNodes.hidden = YES;
        throttleSlider.hidden = YES;
        rearGripSlider.hidden = YES;
        tireStiffnessSlider.hidden = YES;
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















@end
