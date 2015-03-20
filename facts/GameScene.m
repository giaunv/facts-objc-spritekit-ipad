//
//  GameScene.m
//  facts
//
//  Created by giaunv on 3/20/15.
//  Copyright (c) 2015 366. All rights reserved.
//

#import "GameScene.h"
#import "FactsScene.h"
#import "OptionsScene.h"

@implementation GameScene{
    UIButton *startButton;
    UIButton *optionsButton;
    UIButton *exitButton;
}

-(id)initWithSize:(CGSize)size{
    /* Setup your scene here */
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:10.0/255.0 green:10.0/255.0 blue:10.0/255/0 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        myLabel.text = @"Facts!";
        myLabel.fontSize = 65;
        myLabel.position = CGPointMake(size.width/2, size.height/2 + myLabel.frame.size.height);
        
        [self addChild:myLabel];
    }
    
    return self;
}

-(void)didMoveToView:(SKView *)view {
    startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    startButton.frame = CGRectMake(CGRectGetMidX(self.frame) - 100, CGRectGetMidY(self.frame), 200, 70);
    startButton.backgroundColor = [UIColor clearColor];
    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage *buttonImageNormal = [UIImage imageNamed:@"StartBtn.png"];
    UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [startButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(moveToGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];
    
    optionsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    optionsButton.frame = CGRectMake(CGRectGetMidX(self.frame) - 100, CGRectGetMidY(self.frame) + 90, 200, 70);
    optionsButton.backgroundColor = [SKColor clearColor];
    [optionsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage *buttonOptionsImageNormal = [UIImage imageNamed:@"OptionsBtn.png"];
    UIImage *stretchableButtonOptionsImageNormal = [buttonOptionsImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [optionsButton setBackgroundImage:stretchableButtonOptionsImageNormal forState:UIControlStateNormal];
    [optionsButton addTarget:self action:@selector(moveToOptions) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:optionsButton];
    
    exitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    exitButton.frame = CGRectMake(CGRectGetMidX(self.frame) - 100, CGRectGetMidY(self.frame) + 180, 200, 70);
    exitButton.backgroundColor = [UIColor clearColor];
    [exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage *buttonExitImageNormal = [UIImage imageNamed:@"ExitBtn.png"];
    UIImage *stretchableButtonExitImageNormal = [buttonExitImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [exitButton setBackgroundImage:stretchableButtonExitImageNormal forState:UIControlStateNormal];
    [exitButton addTarget:self action:@selector(endApplication) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitButton];
}

-(void)moveToGame{
    FactsScene *factsScence = [[FactsScene alloc] initWithSize:CGSizeMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame))];
    SKTransition *transition = [SKTransition revealWithDirection:SKTransitionDirectionUp duration:1];
    [startButton removeFromSuperview];
    [optionsButton removeFromSuperview];
    [exitButton removeFromSuperview];
    
    [self.scene.view presentScene:factsScence transition:transition];
}

-(void)moveToOptions{
    OptionsScene *optionsScene = [[OptionsScene alloc] initWithSize:CGSizeMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame))];
    SKTransition *transition = [SKTransition revealWithDirection:SKTransitionDirectionUp duration:1];
    [startButton removeFromSuperview];
    [optionsButton removeFromSuperview];
    [exitButton removeFromSuperview];
}

-(void)endApplication{
    [startButton removeFromSuperview];
    [optionsButton removeFromSuperview];
    [exitButton removeFromSuperview];
}

/*
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.xScale = 0.5;
        sprite.yScale = 0.5;
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
}
*/

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
