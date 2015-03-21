//
//  FactsScene.m
//  facts
//
//  Created by giaunv on 3/21/15.
//  Copyright (c) 2015 366. All rights reserved.
//

#import "FactsScene.h"

@implementation FactsScene{
    NSUserDefaults* defaults;
    NSString* musicPath;
}

-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        
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
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch* touch in touches) {
        [self touchWillProdureASound:@"False"];
    }
}

-(void)touchWillProdureASound:(NSString*) answer{
    long soundFlag = [defaults integerForKey:@"sound"];
    
    if (soundFlag == 1) {
        SKAction* sound;
        if ([answer isEqualToString:@"False"]) {
            sound = [SKAction playSoundFileNamed:@"beep.mp3" waitForCompletion:YES];
        }
        
        [self runAction:sound];
    }
}
@end
