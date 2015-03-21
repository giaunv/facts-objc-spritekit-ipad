//
//  OptionsScene.m
//  facts
//
//  Created by lavalamp on 3/21/15.
//  Copyright (c) 2015 366. All rights reserved.
//

#import "OptionsScene.h"
#import "GameScene.h"

@implementation OptionsScene
-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        
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
}

-(void)moveToHome{
    SKScene *gameScene = [[GameScene alloc] initWithSize:CGSizeMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame))];
    [_backButton removeFromSuperview];
    [self.scene.view presentScene:gameScene];
}
@end
