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

@implementation ScoresViewController{
    NSArray* paths;
    NSString* documentsDirectoryPath;
    NSString* filePath;
    NSMutableDictionary* newList;
    NSDictionary* newDiction;
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(id) init{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectoryPath = paths.firstObject;
    filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"scores.plist"];
    newList = [[NSMutableDictionary alloc] init];
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectoryPath = paths.firstObject;
    filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"scores.plist"];
    newList = [[NSMutableDictionary alloc] init];

    [self refreshTab];
}

- (void)refreshTab {
    
    /// On récupère toutes les données du fichier .plist
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSMutableDictionary* savedData = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
        if(savedData != nil){
            newList = [savedData objectForKey:@"scores"];
        } else {
            [newList setObject:@"" forKey:@""];
        }
        
        [self.tableView reloadData];
    } else {
        /// Si le fichier n'existe pas, on le créé
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return newList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default" forIndexPath:indexPath];
    
    NSDictionary* newDictionary = [newList objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row + 1]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [newDictionary objectForKey:@"score"]];
    
    return cell;
}


- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) addScore:(NSUInteger)value {
    [self refreshTab];
    
    NSDictionary* datas = @{
                            @"score":@(value)
                            };
    
    /// On ajoute les nouvelles données à la suite de la liste existante
    [newList setObject:datas forKey:[NSString stringWithFormat:@"%@", @(newList.count + 1)]];
    /// Récupération des données du fichier dans un dictionnaire
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    [dataDict setObject:newList forKey:@"scores"];
    
    /// Réécriture dans le fichier avec les nouveaux éléments
    [dataDict writeToFile:filePath atomically:YES];
    
    [self.tableView reloadData];
    
    NSLog(@"maxscore %lu", [self maxScore]);
}

- (NSUInteger) maxScore {
    int maxValue = 0;
    for (NSString *name in [newList allKeys]) {
        NSDictionary *info = newList[name];
        float value = [info[@"score"] floatValue];
        if (value > maxValue) {
            maxValue = value;
        }
    }
    return maxValue;
}

@end
