//
//  LevelSelect.h
//  facts
//
//  Created by giaunv on 3/21/15.
//  Copyright (c) 2015 366. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface LevelSelect : SKScene <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UIButton* backButton;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *levelsArray;
@property (strong, nonatomic) NSArray *levelsDescriptionArray;

@end

