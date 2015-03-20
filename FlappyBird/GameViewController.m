//
//  GameViewController.m
//  FlappyBird
//
//  Created by Bryan Reymonenq on 18/03/2015.
//  Copyright (c) 2015 Fliizweb.fr. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "ScoresViewController.h"

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController{
    GameScene *scene;
    ScoresViewController* scoresView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    skView.showsPhysics = NO;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    scene = [GameScene unarchiveFromFile:@"GameScene"];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.gameDelegate = self;
    
    if([scene collisionIsTrue]){
        self.imageGameOver.hidden = NO;
        self.viewScore.hidden = NO;
    }
    scoresView = [[ScoresViewController alloc] init];
    [self scoreTopToShow:scoresView.maxScore];

    // Present the scene.
    [skView presentScene:scene];    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)buttonScore:(id)sender {
}

- (IBAction)buttonPlay:(id)sender {
    [scene restartScene];
}

- (IBAction)buttonPause:(id)sender {
}

- (void) gameSceneDetectedGameOver:(GameScene*)gameScene {
    [self showElements];
    _liveScore.hidden = YES;
    _currentScore.text = _liveScore.text;
}

- (void) gameSceneHideGameOver:(GameScene*)gameScene {
    [self hideElements];
    _liveScore.hidden = NO;
    _currentScore.text = 0;
}

- (void) gameSceneScoreUpdate:(int)score save:(bool)s {
    if(s && score > 0) {
        _liveScore.hidden = YES;
        [scoresView addScore:(NSInteger)score];
        [self scoreTopToShow:scoresView.maxScore];
    } else {
        _liveScore.text = [NSString stringWithFormat:@"%d", score];
    }
}


- (void) scoreTopToShow:(NSUInteger)score{
    _highscoreLabel.text = [NSString stringWithFormat:@"%lu", score];
}


- (void) showElements {
    _imageGameOver.hidden = NO;
    _viewScore.hidden = NO;
    _playButton.hidden = NO;
    _scoreButton.hidden = NO;
}

- (void) hideElements {
    _imageGameOver.hidden = YES;
    _viewScore.hidden = YES;
    _playButton.hidden = YES;
    _scoreButton.hidden = YES;
}


@end
