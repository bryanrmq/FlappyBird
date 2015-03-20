//
//  ScoresViewController.h
//  FlappyBird
//
//  Created by Jonathan on 19/03/2015.
//  Copyright (c) 2015 Fliizweb.fr. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GameViewController.h"
#import "ScoreDelegate.h"

@interface ScoresViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak) id<ScoreDelegate> scoreDelegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)backButton:(id)sender;
- (void) addScore:(NSUInteger)value;

@property (readonly) NSUInteger maxScore;


@end
