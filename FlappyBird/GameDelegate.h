//
//  GameDelegate.h
//  FlappyBird
//
//  Created by Jonathan on 20/03/2015.
//  Copyright (c) 2015 Fliizweb.fr. All rights reserved.
//

@class GameScene;

@protocol GameDelegate <NSObject>

- (void) gameSceneDetectedGameOver:(GameScene*)self;
- (void) gameSceneHideGameOver:(GameScene*)self;
- (void) gameSceneScoreUpdate:(int)score save:(bool)s;

@optional
- (void) restartScene;

@end