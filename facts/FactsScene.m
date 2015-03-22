//
//  FactsScene.m
//  facts
//
//  Created by giaunv on 3/21/15.
//  Copyright (c) 2015 366. All rights reserved.
//

#import "FactsScene.h"
#import "GameScene.h"
#import "factObject.h"
#import "LevelSelect.h"

@implementation FactsScene{
    NSUserDefaults* defaults;
    NSString* musicPath;
    
    NSInteger playerLives;
    NSInteger playerLevel;
    int maximumTime;
    
    NSMutableArray* statements;
    int randomQuestion;
    int questionNumber;
    int totalRightQuestions; // need 7 out of 10 to pass to the next level
}

-(id)initWithSize:(CGSize)size inLevel:(NSInteger)level withPlayerLives:(int)lives{
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:0.35 green:0.25 blue:0.5 alpha:1.0];
        defaults = [NSUserDefaults standardUserDefaults];
        
        playerLives = lives;
        playerLevel = level;
        
        maximumTime = 30;
        
        questionNumber = 1;
        totalRightQuestions = 0;
        
        statements = [[NSMutableArray alloc] init];
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"LevelDescription" ofType:@"plist"];
        NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        
        if ([dictionary objectForKey:@"Questions"] != nil) {
            NSMutableArray* array = [dictionary objectForKey:@"Questions"];
            
            for (int i = 0; i < [array count]; i++) {
                NSMutableDictionary* questions = [array objectAtIndex:i];
                factObject* stat = [factObject new];
                stat.factID = [[questions objectForKey:@"id"] intValue];
                stat.statement = [questions objectForKey:@"statement"];
                stat.isCorrect = [[questions objectForKey:@"isCorrect"] integerValue];
                stat.additionalInfo = [questions objectForKey:@"additionalInfo"];
                [statements addObject:stat];
            }
        }
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
        SKSpriteNode* liveImage = [SKSpriteNode spriteNodeWithImageNamed:@"hearth.png"];
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
    [_trueButton addTarget:self action:@selector(presentCorrectWrongMenu:) forControlEvents:UIControlEventTouchUpInside];
    [_trueButton setTag:1];
    [self.view addSubview:_trueButton];
    
    _falseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _falseButton.frame = CGRectMake(CGRectGetMidX(self.frame) + 10, CGRectGetMidY(self.frame) + 300, 335, 106);
    _falseButton.backgroundColor = [UIColor whiteColor];
    [_falseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage* buttonFalseImageNormal = [UIImage imageNamed:@"falseBtn.png"];
    UIImage* stretchableButtonFalseImageNormal = [buttonFalseImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [_falseButton setBackgroundImage:stretchableButtonFalseImageNormal forState:UIControlStateNormal];
    [_falseButton addTarget:self action:@selector(presentCorrectWrongMenu:) forControlEvents:UIControlEventTouchUpInside];
    [_falseButton setTag:0];
    [self.view addSubview:_falseButton];
    
    _currentLevelLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _currentLevelLabel.text = [[NSString alloc] initWithFormat:@"Level: %ld of 10", (long)questionNumber];
    _currentLevelLabel.fontSize = 15;
    _currentLevelLabel.position = CGPointMake(CGRectGetMinX(self.frame)+90, CGRectGetMaxY(self.frame)-50);
    // TODO: Bug: terminating with uncaught exception of type NSException
    // [self addChild:_currentLevelLabel];
    
    _timerLevel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _timerLevel.text = @"60";
    _timerLevel.fontSize = 70;
    _timerLevel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 350);
    // TODO: Bug: terminating with uncaught exception of type NSException
    // [self addChild:_timerLevel];
    
    SKAction* wait = [SKAction waitForDuration:1];
    SKAction* updateTimer = [SKAction runBlock:^{
        [self updateTimer];
    }];
    
    SKAction* updateTimerS = [SKAction sequence:@[wait, updateTimer]];
    [self runAction:[SKAction repeatActionForever:updateTimerS]];
    
    
    CGRect labelFrame = CGRectMake(120, 300, 530, 100);
    _questionLabel = [[UILabel alloc] initWithFrame:labelFrame];
    
    randomQuestion = [self getRandomNumberBetween:0 to:([statements count] - 1)];
    
    NSString* labelText = [[statements objectAtIndex:randomQuestion] statement];
    [_questionLabel setText:labelText];
    [_questionLabel setTextColor:[UIColor whiteColor]];
    [_questionLabel setFont:[UIFont fontWithName:NULL size:23]];
    [_questionLabel setTextAlignment:NSTextAlignmentCenter];
    // The label will use an unlimited number of lines
    [_questionLabel setNumberOfLines:0];
    [self.view addSubview:_questionLabel];
}

-(int)getRandomNumberBetween:(int)from to:(int)to{
    return (int)from + arc4random()%(to-from+1);
}

-(void)presentCorrectWrongMenu:(UIButton*) sender {
    int userData = sender.tag;
    
    //background
    _backgroundStatement = [SKSpriteNode spriteNodeWithImageNamed:@"background.png"];
    _backgroundStatement.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    _backgroundStatement.size = CGSizeMake(768, 1024);
    _backgroundStatement.zPosition = 10;
    _backgroundStatement.alpha = 0.0;
    [self addChild:_backgroundStatement];
    
    _nextQuestion = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _nextQuestion.frame = CGRectMake(CGRectGetMidX(self.frame) - 100, CGRectGetMidY(self.frame) + 90, 200, 70);
    _nextQuestion.backgroundColor = [UIColor clearColor];
    [_nextQuestion setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_nextQuestion setTitle:@"Tap here to continue" forState:UIControlStateNormal];
    [_nextQuestion addTarget:self action:@selector(nextQuestion) forControlEvents:UIControlEventTouchUpInside];
    _nextQuestion.alpha = 1.0;
    [self.view addSubview:_nextQuestion];
    
    [_backgroundStatement runAction:[SKAction fadeAlphaTo:1.0 duration:0.2f]];
    _trueButton.alpha = 0.0;
    _falseButton.alpha = 0.0;
    
    if (([[statements objectAtIndex:randomQuestion] isCorrect] == 0 && userData == 0) || ([[statements objectAtIndex:randomQuestion] isCorrect] == 1 && userData == 1)) {
        if ([[statements objectAtIndex:randomQuestion] isCorrect] == 0){
            _questionLabel.text = [[statements objectAtIndex:randomQuestion] additionalInfo];
        }
        
        _correct = [SKSpriteNode spriteNodeWithImageNamed:@"correct.png"];
        _correct.scale = .6;
        _correct.zPosition = 10;
        _correct.position = CGPointMake(CGRectGetMidX(self.frame), 800);
        _correct.alpha = 1.0;
        
        totalRightQuestions++;
        
        [self touchWillProdureASound:@"True"];
        [self addChild:_correct];
    }
    else{
        if ([[statements objectAtIndex:randomQuestion] isCorrect] == 0) {
            _questionLabel.text = [[statements objectAtIndex:randomQuestion] additionalInfo];
        }
        
        _wrong = [SKSpriteNode spriteNodeWithImageNamed:@"wrong.png"];
        _wrong.scale = .6;
        _wrong.zPosition = 10;
        _wrong.position = CGPointMake(CGRectGetMidX(self.frame), 800);
        _wrong.alpha = 1.0;
        
        [self removePlayerLife];
        
        [self touchWillProdureASound:@"False"];
        [self addChild:_wrong];
    }
}

-(void)nextQuestion{
    [self resetTimer];
    
    questionNumber++;
    _currentLevelLabel.text = [[NSString alloc] initWithFormat:@"Level: %ld of 10", (long)questionNumber];
    
    _wrong.alpha = 0.0;
    _correct.alpha = 0.0;
    _backgroundStatement.alpha = 0.0;
    _nextQuestion.alpha = 0.0;
    
    [statements removeObject:[statements objectAtIndex:randomQuestion]];
    
    // random question
    randomQuestion = [self getRandomNumberBetween:0 to:([statements count] - 1)];
    [_questionLabel setText:[[statements objectAtIndex:randomQuestion] statement]];
    
    _trueButton.alpha = 1.0;
    _falseButton.alpha = 1.0;
    
    if (questionNumber == 10 && totalRightQuestions > 7) {
        int nextLevel = playerLevel + 2;
        [defaults setInteger:nextLevel forKey:@"actualPlayerLevel"];
        [self removeUIViews];
        SKTransition* transition = [SKTransition doorwayWithDuration:2];
        LevelSelect* levelSelect = [[LevelSelect alloc] initWithSize:CGSizeMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame))];
        [self.scene.view presentScene:levelSelect transition:transition];
    }
}

-(void)removePlayerLife{
    if (playerLives > 1) {
        for (NSInteger i = 0; i < playerLives; i++) {
            SKSpriteNode* node = [heartArray objectAtIndex:i];
            if (i == (playerLives - 1)) {
                node.alpha = .1;
            }
        }
        
        playerLives--;
    } else {
        [self moveToHome];
    }
}

-(void)resetTimer{
    maximumTime = 60;
    [_timerLevel setText:@"60"];
}

-(void)updateTimer{
    maximumTime--;
    if (maximumTime == 0) {
        
        if (playerLives < 1) {
            [self touchWillProdureASound:@"False"];
            [self moveToHome];
        } else {
            [self presentCorrectWrongMenu:_trueButton];
            [self touchWillProdureASound:@"False"];
            [self removePlayerLife];
        }
    }
    
    [_timerLevel setText:[[NSNumber numberWithInt:maximumTime] stringValue]];
}

-(void)moveToHome{
    SKTransition* transition = [SKTransition fadeWithDuration:2];
    SKScene* gameScene = [[GameScene alloc] initWithSize:CGSizeMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame))];
    [self.scene.view presentScene:gameScene transition:transition];
}

-(void)removeUIViews{
    [_trueButton removeFromSuperview];
    [_falseButton removeFromSuperview];
    [_questionLabel removeFromSuperview];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch* touch in touches) {
        [self touchWillProdureASound:@"False"];
    }
}

-(void)touchWillProdureASound:(NSString*) answer{
    long soundFlag = [defaults integerForKey:@"sound"];
    // NSString* answer = @"False";
    
    if (soundFlag == 1) {
        SKAction* sound;
        if ([answer isEqualToString:@"False"]) {
            sound = [SKAction playSoundFileNamed:@"wrong.mp3" waitForCompletion:YES];
            //NSLog(@"inside");
        } else {
            sound = [SKAction playSoundFileNamed:@"right.mp3" waitForCompletion:YES];
        }
        
        [self runAction:sound];
    }
}
@end
