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
@synthesize truck2;
@synthesize isShown = _isShown;
@synthesize showsVectors;
@synthesize physicsSpeed;

-(id)initWithScene:(SKScene *)scene {
    if (self = [super init]) {
        debugScene = scene;
        self.physicsSpeed = 1.0;
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
    CGPoint sliderLocation = CGPointMake(frameSize.width - sliderSize.width, frameSize.height - 5*sliderSize.height);
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
    
    rearGripLabel.text = @"Balance";
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
    CGPoint sliderLocation = CGPointMake(frameSize.width - sliderSize.width, frameSize.height - 7*sliderSize.height);
    tireStiffnessSlider = [[ UISlider alloc ] initWithFrame: CGRectMake(sliderLocation.x, sliderLocation.y,
                                                                        sliderSize.width, sliderSize.height) ];
    tireStiffnessSlider.backgroundColor = [UIColor clearColor];
    
    tireStiffnessSlider.maximumValue = 2000.0;
    tireStiffnessSlider.minimumValue = 0.0;
    tireStiffnessSlider.minimumTrackTintColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    tireStiffnessSlider.alpha =kControlAlpha;
    [debugScene.view addSubview:tireStiffnessSlider];
    
    [tireStiffnessSlider addTarget:self action:@selector(stiffnessValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    tireStiffnessLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-Light"];
    
    tireStiffnessLabel.text = @"Tire Grip";
    tireStiffnessLabel.fontSize = [SLConversion scaleFloat:10];
    
    tireStiffnessLabel.position = CGPointMake(sliderLocation.x,
                                              frameSize.height - sliderLocation.y);
    
    tireStiffnessLabel.alpha = kControlAlpha;
    [debugNodes addChild:tireStiffnessLabel];
    
}

-(void)addWheelbaseControl {
    
    CGSize frameSize = debugScene.frame.size;
    
    //Create control nodes
    CGSize sliderSize = [SLConversion scaleSize:CGSizeMake(150, 20)];
    CGPoint sliderLocation = CGPointMake(frameSize.width - sliderSize.width, frameSize.height - 9*sliderSize.height);
    wheelbaseSlider = [[ UISlider alloc ] initWithFrame: CGRectMake(sliderLocation.x, sliderLocation.y,
                                                                        sliderSize.width, sliderSize.height) ];
    wheelbaseSlider.backgroundColor = [UIColor clearColor];
    
    wheelbaseSlider.maximumValue = 0.5;
    wheelbaseSlider.minimumValue = 0.1;
    wheelbaseSlider.minimumTrackTintColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    wheelbaseSlider.alpha =kControlAlpha;
    [debugScene.view addSubview:wheelbaseSlider];
    
    [wheelbaseSlider addTarget:self action:@selector(wheelbaseValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    wheelbasLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-Light"];
    
    wheelbasLabel.text = @"Wheelbase";
    wheelbasLabel.fontSize = [SLConversion scaleFloat:10];
    
    wheelbasLabel.position = CGPointMake(sliderLocation.x,
                                              frameSize.height - sliderLocation.y);
    
    wheelbasLabel.alpha = kControlAlpha;
    [debugNodes addChild:wheelbasLabel];
    
}

-(void)addSloMoControl {
    
    CGSize frameSize = debugScene.frame.size;
    
    //Create control nodes
    CGSize sliderSize = [SLConversion scaleSize:CGSizeMake(150, 20)];
    CGPoint sliderLocation = CGPointMake(frameSize.width - sliderSize.width, sliderSize.height);
    sloMoSlider = [[ UISlider alloc ] initWithFrame: CGRectMake(sliderLocation.x, sliderLocation.y,
                                                                        sliderSize.width, sliderSize.height) ];
    sloMoSlider.backgroundColor = [UIColor clearColor];
    
    sloMoSlider.maximumValue = 2.0;
    sloMoSlider.minimumValue = 0.0;
    sloMoSlider.minimumTrackTintColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    sloMoSlider.alpha =kControlAlpha;
    [debugScene.view addSubview:sloMoSlider];
    
    [sloMoSlider addTarget:self action:@selector(sloMoValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    sloMoLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-Light"];
    
    sloMoLabel.text = @"SloMo";
    sloMoLabel.fontSize = [SLConversion scaleFloat:10];
    
    sloMoLabel.position = CGPointMake(sliderLocation.x,
                                              frameSize.height - sliderLocation.y);
    
    sloMoLabel.alpha = kControlAlpha;
    [debugNodes addChild:sloMoLabel];
    
}

-(void)addVectorSwitch {
    CGSize frameSize = debugScene.frame.size;
    CGPoint switchLocation = CGPointMake(frameSize.width - 60, [SLConversion scaleFloat:100]);
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

-(void)addPauseSwitch {
    CGSize frameSize = debugScene.frame.size;
    CGPoint switchLocation = CGPointMake(frameSize.width - 60, [SLConversion scaleFloat:50]);
    CGRect swFrame = {{switchLocation.x, switchLocation.y}, {100, 100}};
    pauseSwitch = [[UISwitch alloc] initWithFrame:swFrame];
    pauseSwitch.alpha = kControlAlpha;
    
    [debugScene.view addSubview:pauseSwitch];
    
    [pauseSwitch addTarget:self action:@selector(physicsPaused:) forControlEvents:UIControlEventValueChanged];
    
    SKLabelNode *pauseSwLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-Light"];
    
    pauseSwLabel.text = @"Pause";
    pauseSwLabel.fontSize = [SLConversion scaleFloat:10];
    
    pauseSwLabel.position = CGPointMake(switchLocation.x, frameSize.height - switchLocation.y);
    
    pauseSwLabel.alpha = kControlAlpha;
    [debugNodes addChild:pauseSwLabel];
    
    
}

-(void)addControls {
    
    //Create debug nodes
    debugNodes = [SKNode node];
    debugNodes.name = @"DebugControls";
    [debugScene addChild:debugNodes];
    
    [self addThrottleControl];
    [self addRearGripControl];
    [self addTireStiffnessControl];
    [self addWheelbaseControl];
    [self addVectorSwitch];
    [self addPauseSwitch];
    [self addSloMoControl];
}


-(void)toggleIsShown {
    if (_isShown) {
        _isShown = NO;
        //Hide the Debug Nodes
        debugNodes.hidden = YES;
        throttleSlider.hidden = YES;
        rearGripSlider.hidden = YES;
        tireStiffnessSlider.hidden = YES;
        wheelbaseSlider.hidden = YES;
        vectorsSwitch.hidden = YES;
        pauseSwitch.hidden = YES;
        sloMoSlider.hidden = YES;
    } else {
        _isShown = YES;

        rearGripSlider.value = truck.rearGrip;
        rearGripLabel.text = [NSString stringWithFormat:@"Balance %3.2f",truck.rearGrip];
        tireStiffnessSlider.value = truck.tireStiffness;
        tireStiffnessLabel.text = [NSString stringWithFormat:@"Tire Grip %3.0f",truck.tireStiffness];
        wheelbaseSlider.value = truck.wheelBase;
        wheelbasLabel.text = [NSString stringWithFormat:@"Wheelbase %2.2f",truck.wheelBase];
        sloMoSlider.value = self.physicsSpeed;
        sloMoLabel.text =[NSString stringWithFormat:@"SloMo %2.2f",self.physicsSpeed];

        debugNodes.hidden = NO;
        throttleSlider.hidden = NO;
        rearGripSlider.hidden = NO;
        tireStiffnessSlider.hidden = NO;
        wheelbaseSlider.hidden = NO;
        vectorsSwitch.hidden = NO;
        pauseSwitch.hidden = NO;
        sloMoSlider.hidden = NO;
    }
}


//apply throttle to both trucks
- (IBAction)sliderValueChanged:(UISlider *)sender {
    throttleLabel.text = [NSString stringWithFormat:@"Throttle %3.0f",sender.value];
    truck.throttle = [SLConversion scaleFloat:sender.value];
    truck2.throttle = [SLConversion scaleFloat:sender.value];
}



- (IBAction)rearGripValueChanged:(UISlider *)sender {
    rearGripLabel.text = [NSString stringWithFormat:@"Balance %3.2f",sender.value];
    truck.rearGrip = sender.value;
}

- (IBAction)stiffnessValueChanged:(UISlider *)sender {
    tireStiffnessLabel.text = [NSString stringWithFormat:@"Tire Grip %3.0f",sender.value];
    truck.tireStiffness = sender.value;
}

- (IBAction)wheelbaseValueChanged:(UISlider *)sender {
    wheelbasLabel.text = [NSString stringWithFormat:@"Wheelbase %2.2f",sender.value];
    truck.wheelBase = sender.value;
}

- (IBAction)sloMoValueChanged:(UISlider *)sender {
    sloMoLabel.text = [NSString stringWithFormat:@"SloMo %2.2f",sender.value];
    self.physicsSpeed = sender.value;
    debugScene.physicsWorld.speed = self.physicsSpeed;
}

- (IBAction)vectorsSwitched:(UISwitch *)sender {
    self.showsVectors = sender.isOn;
}

- (IBAction)physicsPaused:(UISwitch *)sender {
    if (sender.isOn) {
        debugScene.physicsWorld.speed = 0.0;
    } else {
        debugScene.physicsWorld.speed = self.physicsSpeed;
    }
}

-(void)removeSubViews {
    [throttleSlider removeFromSuperview];
    [rearGripSlider removeFromSuperview];
    [tireStiffnessSlider removeFromSuperview];
    [wheelbaseSlider removeFromSuperview];
    [vectorsSwitch removeFromSuperview];
    [pauseSwitch removeFromSuperview];
    [sloMoSlider removeFromSuperview];

}













@end
