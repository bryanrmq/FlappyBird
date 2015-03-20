//
//  GameViewController.h
//  FlappyBird
//

//  Copyright (c) 2015 Fliizweb.fr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface GameViewController : UIViewController

- (IBAction)buttonScore:(id)sender;
- (IBAction)buttonPlay:(id)sender;
- (IBAction)buttonPause:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewScore;
@property (weak, nonatomic) IBOutlet UIImageView *imageGameOver;
@property (weak, nonatomic) IBOutlet UILabel *highscoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentScore;

@end
