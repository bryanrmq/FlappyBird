//
//  ScoreDelegate.h
//  FlappyBird
//
//  Created by Jonathan on 20/03/2015.
//  Copyright (c) 2015 Fliizweb.fr. All rights reserved.
//


@protocol ScoreDelegate <NSObject>

- (void) scoreTopToShow:(NSUInteger)score;

@end