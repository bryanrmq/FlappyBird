//
//  GameScene.h
//  FlappyBird
//

//  Copyright (c) 2015 Fliizweb.fr. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameDelegate.h"

typedef NS_OPTIONS(uint32_t, FAPhysicsCategory) {
    towerCategory = 0x1 << 0,
    birdCategory = 0x1  << 1,
    worldCategory = 0x1 << 2,
    scoreCategory = 0x1 << 3
};

@interface GameScene : SKScene <SKPhysicsContactDelegate>

-(bool) collisionIsTrue;
@property (weak) id<GameDelegate> gameDelegate;

@end
