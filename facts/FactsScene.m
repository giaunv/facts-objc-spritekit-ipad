//
//  FactsScene.m
//  facts
//
//  Created by giaunv on 3/21/15.
//  Copyright (c) 2015 366. All rights reserved.
//

#import "FactsScene.h"
#import "GameScene.h"

@implementation FactsScene{
    NSUserDefaults* defaults;
    NSString* musicPath;
    
    NSInteger playerLives;
    NSInteger playerLevel;
    int maximumTime;
}

-(id)initWithSize:(CGSize)size inLevel:(NSInteger)level withPlayerLives:(int)lives{
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:0.35 green:0.25 blue:0.5 alpha:1.0];
        defaults = [NSUserDefaults standardUserDefaults];
        
        playerLives = lives;
        playerLevel = level;
        
        maximumTime = 30;
    }
    
    return self;
}

-(void)didMoveToView:(SKView *)view{
    musicPath = [[NSBundle mainBundle] pathForResource:@"music" ofType:@"mp3"];
    _musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:musicPath] error:NULL];
    _musicPlayer.numberOfLoops = -1; // loop forever
    _musicPlayer.volume = 0.7;
    
    long musicFlag = [defaults integerForKey:@"music"];
    if (musicFlag == 1) {
        [_musicPlayer play];
    } else {
        [_musicPlayer stop];
    }
    
    SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:@"background.png"];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    background.size = CGSizeMake(768, 1024);
    [self addChild:background];
    
    SKSpriteNode* frontImage = [SKSpriteNode spriteNodeWithImageNamed:@"transparentCenterBorder.png"];
    frontImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    frontImage.size = CGSizeMake(600, 450);
    [self addChild:frontImage];
    
    heartArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < playerLives; i++) {
        SKSpriteNode* liveImage = [SKSpriteNode spriteNodeWithImageNamed:@"heart.png"];
        liveImage.scale = .6;
        liveImage.position = CGPointMake(CGRectGetMaxX(self.frame) - 40 - (i*50), CGRectGetMaxY(self.frame) - 40);
        [heartArray insertObject:liveImage atIndex:i];
        [self addChild:liveImage];
    }
    
    _trueButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _trueButton.frame = CGRectMake(CGRectGetMidX(self.frame) - 350, CGRectGetMidY(self.frame) + 300, 335, 106);
    _trueButton.backgroundColor = [UIColor clearColor];
    [_trueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage* buttonTrueImageNormal = [UIImage imageNamed:@"trueBtn.png"];
    UIImage* stretchableButtonTrueImageNormal = [buttonTrueImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [_trueButton setBackgroundImage:stretchableButtonTrueImageNormal forState:UIControlStateNormal];
    [_trueButton addTarget:self action:@selector(touchWillProdureASound) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_trueButton];
    
    _falseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _falseButton.frame = CGRectMake(CGRectGetMidX(self.frame) + 10, CGRectGetMidY(self.frame) + 300, 335, 106);
    _falseButton.backgroundColor = [UIColor whiteColor];
    [_falseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage* buttonFalseImageNormal = [UIImage imageNamed:@"falseBtn.png"];
    UIImage* stretchableButtonFalseImageNormal = [buttonFalseImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [_falseButton setBackgroundImage:stretchableButtonFalseImageNormal forState:UIControlStateNormal];
    [_falseButton addTarget:self action:@selector(touchWillProdureASound) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_falseButton];
    
    _timerLevel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _timerLevel.text = @"30";
    _timerLevel.fontSize = 70;
    _timerLevel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 350);
    [self addChild:_timerLevel];
    
    SKAction* wait = [SKAction waitForDuration:1];
    SKAction* updateTimer = [SKAction runBlock:^{
        [self updateTimer];
    }];
    
    SKAction* updateTimerS = [SKAction sequence:@[wait, updateTimer]];
    [self runAction:[SKAction repeatActionForever:updateTimerS]];
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"LevelDescription" ofType:@"plist"];
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    if ([dictionary objectForKey:@"Questions"] != nil) {
        NSMutableArray* array = [dictionary objectForKey:@"Questions"];
        
        for (int i = 0; i < [array count]; i++) {
            NSMutableDictionary* questions = [array objectAtIndex:i];
            NSLog(@"ID %@", [questions objectForKey:@"id"]);
            NSLog(@"%@", [questions objectForKey:@"statement"]);
            NSLog(@"%@", [questions objectForKey:@"isCorrect"]);
            NSLog(@"%@", [questions objectForKey:@"additionalInfo"]);
        }
    }
}

-(void)updateTimer{
    maximumTime--;
    if (maximumTime == 0) {
        long soundFlag = [defaults integerForKey:@"sound"];
        if (soundFlag == 1) {
            SKAction* sound;
            sound = [SKAction playSoundFileNamed:@"beep.mp3" waitForCompletion:YES];
            [self runAction:sound];
        }
        if (playerLives < 1) {
            SKTransition* transition = [SKTransition fadeWithDuration:2];
            SKScene* gameScene = [[GameScene alloc] initWithSize:CGSizeMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame))];
            [self removeUIViews];
            [self.scene.view presentScene:gameScene transition:transition];
        } else {
            // other
        }
    }
    
    [_timerLevel setText:[[NSNumber numberWithInt:maximumTime] stringValue]];
}

-(void)removeUIViews{
    [_trueButton removeFromSuperview];
    [_falseButton removeFromSuperview];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch* touch in touches) {
        [self touchWillProdureASound];
    }
}

-(void)touchWillProdureASound{
    long soundFlag = [defaults integerForKey:@"sound"];
    NSString* answer = @"False";
    
    if (soundFlag == 1) {
        SKAction* sound;
        if ([answer isEqualToString:@"False"]) {
            sound = [SKAction playSoundFileNamed:@"wrong.mp3" waitForCompletion:YES];
            NSLog(@"inside");
        }
        
        [self runAction:sound];
    }
}
@end
