//
//  ScoresViewController.m
//  FlappyBird
//
//  Created by Jonathan on 19/03/2015.
//  Copyright (c) 2015 Fliizweb.fr. All rights reserved.
//

#import "ScoresViewController.h"

@interface ScoresViewController ()

@end

@implementation ScoresViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default" forIndexPath:indexPath];
    //cell.textLabel.text = book.title;
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", book.author.firstname, book.author.lastname];
    
    return cell;
}


- (IBAction)backButton:(id)sender {
}
@end
