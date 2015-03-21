//
//  OptionsScene.m
//  facts
//
//  Created by giaunv on 3/21/15.
//  Copyright (c) 2015 366. All rights reserved.
//

#import "OptionsScene.h"
#import "GameScene.h"

@implementation OptionsScene{
    NSUserDefaults* defaults;
}

-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

-(void)didMoveToView:(SKView *)view{
    _backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _backButton.frame = CGRectMake(CGRectGetMidX(self.frame) - 100, CGRectGetMidY(self.frame) + 180, 200, 70);
    _backButton.backgroundColor = [UIColor clearColor];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage *buttonExitImageNormal = [UIImage imageNamed:@"ExitBtn.png"];
    UIImage *stretchableButtonExitImageNormal = [buttonExitImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [_backButton setBackgroundImage:stretchableButtonExitImageNormal forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(moveToHome) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
    
    _soundSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame) + 50, CGRectGetMidY(self.frame) - 26, 100, 100)];
    [_soundSwitch addTarget:self action:@selector(flipMusicAndSound:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_soundSwitch];
    
    _musicSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame) + 50, CGRectGetMidY(self.frame) + 50, 100, 100)];
    [_musicSwitch addTarget:self action:@selector(flipMusicAndSound:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_musicSwitch];
    
    _soundTitle = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    [_soundTitle setText:@"Sound"];
    [_soundTitle setFontSize:40];
    [_soundTitle setPosition:CGPointMake(CGRectGetMidX(self.frame) - 80, CGRectGetMidY(self.frame))];
    [self addChild:_soundTitle];
    
    _musicTitle = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    [_musicTitle setText:@"Music"];
    [_musicTitle setFontSize:40];
    [_musicTitle setPosition:CGPointMake(CGRectGetMidX(self.frame) - 80, CGRectGetMidY(self.frame) - 80)];
    [self addChild:_musicTitle];
    
    long soundDefaults = [defaults integerForKey:@"sound"];
    long musicDefaults = [defaults integerForKey:@"music"];
    
    if (soundDefaults == 1) {
        [_soundSwitch setOn:YES animated:YES];
    } else{
        [_soundSwitch setOn:NO animated:YES];
    }
    
    if (musicDefaults == 1) {
        [_musicSwitch setOn:YES animated:YES];
    } else {
        [_musicSwitch setOn:NO animated:YES];
    }
}

-(void)moveToHome{
    SKScene *gameScene = [[GameScene alloc] initWithSize:CGSizeMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame))];
    [_backButton removeFromSuperview];
    [_soundSwitch removeFromSuperview];
    [_musicSwitch removeFromSuperview];
    [self.scene.view presentScene:gameScene];
}

-(IBAction)flipMusicAndSound:(id)sender{
    if (_musicSwitch.on) {
        [defaults setInteger:1 forKey:@"music"];
    } else {
        [defaults setInteger:0 forKey:@"music"];
    }
    
    if (_soundSwitch.on) {
        [defaults setInteger:1 forKey:@"sound"];
    } else {
        [defaults setInteger:0 forKey:@"sound"];
    }
}
@end
