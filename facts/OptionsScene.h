//
//  OptionsScene.h
//  facts
//
//  Created by lavalamp on 3/21/15.
//  Copyright (c) 2015 366. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface OptionsScene : SKScene

@property (nonatomic, retain) UIButton* backButton;
@property (nonatomic, retain) IBOutlet UISwitch* musicSwitch;
@property (nonatomic, retain) IBOutlet UISwitch* soundSwitch;
@property (nonatomic, retain) SKLabelNode* soundTitle;
@property (nonatomic, retain) SKLabelNode* musicTitle;
@end
