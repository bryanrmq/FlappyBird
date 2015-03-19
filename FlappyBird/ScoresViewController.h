//
//  ScoresViewController.h
//  FlappyBird
//
//  Created by Jonathan on 19/03/2015.
//  Copyright (c) 2015 Fliizweb.fr. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface ScoresViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backButton:(id)sender;
- (void) addScore:(NSUInteger)value;
@end
