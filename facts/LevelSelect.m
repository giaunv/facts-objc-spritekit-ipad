//
//  LevelSelect.h
//  facts
//
//  Created by giaunv on 3/21/15.
//  Copyright (c) 2015 366. All rights reserved.
//

#import "LevelSelect.h"
#import "GameScene.h"
#import "FactsScene.h"

@implementation LevelSelect{
    long actualPlayerLevel;
    NSUserDefaults* defaults;
}

@synthesize tableView = _tableView;

-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:0.25 green:0.35 blue:0.15 alpha:1.0];
        defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

-(void) didMoveToView:(SKView *)view{
    
    actualPlayerLevel = [defaults integerForKey:@"actualPlayerLevel"];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _backButton.frame = CGRectMake(CGRectGetMidX(self.frame)-100, CGRectGetMaxY(self.frame)-100, 200, 70.0);
    _backButton.backgroundColor = [UIColor clearColor];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    UIImage *buttonExitImageNormal = [UIImage imageNamed:@"back.png"];
    UIImage *strechableButtonExitImageNormal = [buttonExitImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [_backButton setBackgroundImage:strechableButtonExitImageNormal forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(moveToHome) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
    
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    titleLabel.text = @"Level Select!!";
    titleLabel.fontSize = 60;
    titleLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+300);
    [self addChild:titleLabel];
    
    // TableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame)-300, CGRectGetMidY(self.frame)-250, 600, 400)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _levelsArray = [[NSArray alloc] initWithObjects:
                    @"Level 1.",
                    @"Level 2.",
                    @"Level 3.",
                    @"Level 4.",
                    @"Level 5.",
                    @"Level 6.",
                    @"Level 7.",
                    @"Level 8.",
                    @"Level 9.",
                    nil];
    
    _levelsDescriptionArray = [[NSArray alloc] initWithObjects:
                               @"The adventure begins.",
                               @"A new step.",
                               @"Achivements?!",
                               @"Level 4 description",
                               @"Level 5 description",
                               @"Level 6 description",
                               @"Level 7 description",
                               @"Level 8 description",
                               @"Level 9 description",
                               nil];
    
    
    [self.view addSubview:_tableView];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_levelsArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SKTransition* transition = [SKTransition doorsCloseHorizontalWithDuration:1];
    FactsScene* facts = [[FactsScene alloc] initWithSize:CGSizeMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame)) inLevel:indexPath.row withPlayerLives:3];
    [self removeUIViews];
    [self.scene.view presentScene:facts transition:transition];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *levels = [_levelsArray objectAtIndex:indexPath.row];
    NSString *descriptions = [_levelsDescriptionArray objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Identifier"];
    }
    
    if (indexPath.row >= actualPlayerLevel)
        [cell setUserInteractionEnabled:FALSE];
    
    [cell.textLabel setText:levels];
    cell.imageView.image = [UIImage imageNamed:@"appleLogo.png"];
    [cell.detailTextLabel setText:descriptions];
    return cell;
}

-(void) moveToHome{
    SKScene* myScene = [[GameScene alloc] initWithSize:CGSizeMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame))];
    [self removeUIViews];
    [self.scene.view presentScene:myScene];
}

-(void)removeUIViews{
    [_backButton removeFromSuperview];
    [_tableView removeFromSuperview];
}

@end
