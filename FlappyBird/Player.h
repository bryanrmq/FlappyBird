//
//  Player.h
//  FlappyBird
//
//  Created by Jonathan on 18/03/2015.
//  Copyright (c) 2015 Fliizweb.fr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject

@property (strong) NSMutableArray* scores;
@property (assign) NSNumber* currentScore;

+ (Player*) sharedPlayer;
- (void) addScore:(NSNumber*)currentScore;
- (bool) isHighScore;
- (NSNumber*) highScore;
- (NSUInteger) count;


@end
