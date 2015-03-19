//
//  Player.m
//  FlappyBird
//
//  Created by Jonathan on 18/03/2015.
//  Copyright (c) 2015 Fliizweb.fr. All rights reserved.
//

#import "Player.h"

@implementation Player


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void) addScore:(NSNumber*)currentScore{
    [self.scores addObject:currentScore];
}


- (NSNumber*) highScore{
    NSNumber* max;
    if(self.scores != nil){
        max = [self.scores objectAtIndex:0];
    }
    for (NSNumber* value in self.scores) {
        if(value > max){
            max = value;
        }
    }
    
    return max;
}


- (bool) isHighScore{
    if(self.currentScore == [self highScore]){
        return true;
    } else {
        return false;
    }
}


- (Player*) scoreAtIndex:(NSUInteger) index {
    return [self.scores objectAtIndex:index];
}


- (NSUInteger) count{
    return self.scores.count;
}


+ (Player*) sharedPlayer{
    static Player* manager = nil;
    
    if(manager == nil){
        manager = [[Player alloc] init];
    }
    
    return manager;
}

@end
