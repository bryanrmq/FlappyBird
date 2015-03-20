//
//  GameScene.h
//  FlappyBird
//

//  Copyright (c) 2015 Fliizweb.fr. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
typedef NS_OPTIONS(uint32_t, FAPhysicsCategory) {
    towerCategory = 0x1 <<0,
    birdCategory = 0x1 <<1,
    groundCategory = 0x1 <<2
};

@interface GameScene : SKScene <SKPhysicsContactDelegate>
-(bool) collisionIsTrue;
@end
