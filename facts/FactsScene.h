//
//  FactsScene.h
//  facts
//
//  Created by giaunv on 3/21/15.
//  Copyright (c) 2015 366. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

@interface FactsScene : SKScene{
    NSMutableArray* heartArray;
}

@property (nonatomic, strong) AVAudioPlayer* musicPlayer;
@property (nonatomic, weak) SKLabelNode* currentLevelLabel;
@property (nonatomic, weak) SKLabelNode* timerLevel;
@property (nonatomic, retain) UIButton* trueButton;
@property (nonatomic, retain) UIButton* falseButton;

-(id) initWithSize:(CGSize)size inLevel:(NSInteger)level withPlayerLives:(int)lives;
@end
